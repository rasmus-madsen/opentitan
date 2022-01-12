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
    end
    
  //     cfg.duty_cycle[1].A      = 'h8;
   // cfg.duty_cycle[2].A      = 'h80;
   // cfg.duty_cycle[3].A      = 'h800;
   // cfg.duty_cycle[4].A      = 'h8000;    
   //
   // 
   //
      set_duty_cycle(0, cfg.duty_cycle[0]);
     cfg.clk_rst_vif.wait_clks(10);
   //     set_duty_cycle(0, cfg.duty_cycle[1]);
   // set_duty_cycle(0, cfg.duty_cycle[2]);
   // set_duty_cycle(0, cfg.duty_cycle[3]);
   // set_duty_cycle(0, cfg.duty_cycle[4]);    
      set_blink(0, cfg.blink[0]);
      set_param(0, cfg.pwm_param[0]);

    // enable channel 0
    set_ch_enables(32'h1);

    // add some run time so we get some pulses
    cfg.clk_rst_vif.wait_clks(1000000);
    shutdown_dut();
  endtask

endclass : pwm_smoke_vseq
