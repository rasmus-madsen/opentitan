// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// smoke test vseq: accessing a major datapath within the pwm
class pwm_smoke_vseq extends pwm_base_vseq;
  `uvm_object_utils(pwm_smoke_vseq)
  `uvm_object_new


    // variables

    virtual task pre_start();
      super.pre_start();
    endtask // pre_start


  virtual task body();
    //make sure write to regs are enabled
    set_reg_en(Enable);

    // disable channel 0
    set_ch_enables(32'h0);
    //setup general config
    cfg.pwm_cfg.DcResn       = 12; //12;
    cfg.pwm_cfg.ClkDiv       = 'h1;
    cfg.pwm_cfg.CntrEn       = 1;

    set_cfg_reg(cfg.pwm_cfg);

    for (int i = 0; i < 1; i++) begin
      cfg.duty_cycle[i].A      = 6500;
      cfg.duty_cycle[i].B      = 0;
      cfg.blink[i].A           = 0;
      cfg.blink[i].B           = 0;
      cfg.pwm_param[i].BlinkEn = 0;
    
      set_duty_cycle(i, cfg.duty_cycle[i]);
      set_blink(i, cfg.blink[i]);
      set_param(i, cfg.pwm_param[i]);
   end
                


    // enable channel 0
    set_ch_enables(32'h1);

    // add some run time so we get some pulses
    cfg.clk_rst_vif.wait_clks(1000000);
    shutdown_dut();
  endtask

endclass : pwm_smoke_vseq
