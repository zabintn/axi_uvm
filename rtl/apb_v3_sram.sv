module axi_slave_stub #(parameter B_LIFO = 0) (axi_if vif);

  // always ready, always OKAY
  assign vif.awready = 1'b1;
  assign vif.wready  = 1'b1;
  assign vif.arready = 1'b1;
  assign vif.bresp   = 2'b00;
  assign vif.rresp   = 2'b00;

  // ---------- write: B after (AW accepted AND last W beat seen) ----------
  logic [3:0] aw_ids[$];
  int         w_done;

  always @(posedge vif.clk) begin
    if (!vif.aresetn) begin
      aw_ids.delete();
      w_done      = 0;
      vif.bvalid <= 0;
    end else begin
      if (vif.awvalid)                aw_ids.push_back(vif.awid);   // awready is always 1
      if (vif.wvalid && vif.wlast)    w_done++;                     // wready is always 1
      if (vif.bvalid && vif.bready)   vif.bvalid <= 0;

      if ((!vif.bvalid || vif.bready) && aw_ids.size() > 0 && w_done > 0) begin
        vif.bid    <= B_LIFO ? aw_ids.pop_back() : aw_ids.pop_front();
        vif.bvalid <= 1;
        w_done--;
      end
    end
  end

  // ---------- read: one R burst at a time ----------
  logic [3:0]  ar_ids[$];
  logic [7:0]  ar_lens[$];
  logic [3:0]  cur_id;
  logic [7:0]  cur_len, beat;
  bit          active;

  always @(posedge vif.clk) begin
    if (!vif.aresetn) begin
      ar_ids.delete(); ar_lens.delete();
      active      = 0;
      vif.rvalid <= 0;
      vif.rlast  <= 0;
    end else begin
      if (vif.arvalid) begin
        ar_ids.push_back(vif.arid);
        ar_lens.push_back(vif.arlen);
      end
      if (vif.rvalid && vif.rready) begin
        vif.rvalid <= 0;
        vif.rlast  <= 0;
      end
      if (!vif.rvalid || vif.rready) begin
        if (!active && ar_ids.size() > 0) begin
          cur_id  = ar_ids.pop_front();
          cur_len = ar_lens.pop_front();
          beat    = 0;
          active  = 1;
        end
        if (active) begin
          vif.rvalid <= 1;
          vif.rid    <= cur_id;
          vif.rdata  <= beat;                 // dummy data: just the beat number
          vif.rlast  <= (beat == cur_len);
          if (beat == cur_len) active = 0; else beat++;
        end
      end
    end
  end
endmodule
