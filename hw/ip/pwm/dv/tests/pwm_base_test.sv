// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class pwm_base_test extends cip_base_test #(
  .CFG_T(pwm_env_cfg),
  .ENV_T(pwm_env)
);

  `uvm_component_utils(pwm_base_test)
  `uvm_component_new

  // the base class dv_base_test creates the following instances:
  // pwm_env_cfg: cfg
  // pwm_env:     env

  // the base class also looks up UVM_TEST_SEQ plusarg to create and run that seq in
  // the run_phase; as such, nothing more needs to be done
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    configure_env();
  endfunction : build_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    if (uvm_top.get_report_verbosity_level() > UVM_LOW) begin
      uvm_top.print_topology();
    end
  endfunction // end_of_elaboration

  function configure_env();
    // set resolution min/max
    cfg.resn_min      =    0;
    cfg.resn_max      =    15;
    // set clockdiv constraints
    cfg.clk_div_min   =    1;
    cfg.clk_div_max   =    8;
    // dutycycle constraints
    cfg.dc_min        =    1;
    cfg.dc_max        =    65535;
    // num of pulse for each DC
    cfg.blink_min     =    1;
    cfg.blink_max     =    256;
    // channel param knobs
    cfg.blink_pct         =    75;
    cfg.htbt_pct          =    50;
    cfg.phase_delay_min   =    0;
    cfg.phase_delay_max   =    255;
    
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask

endclass : pwm_base_test
