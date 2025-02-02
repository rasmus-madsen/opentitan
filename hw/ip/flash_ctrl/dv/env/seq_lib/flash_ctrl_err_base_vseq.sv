// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Base sequence for fault tests
class flash_ctrl_err_base_vseq extends flash_ctrl_rw_vseq;
  `uvm_object_utils(flash_ctrl_err_base_vseq)
  `uvm_object_new

  task body();
    fork
      begin
        run_main_event();
      end
      begin
        run_error_event();
      end
    join
    clean_up();

  endtask

  virtual task run_main_event();
    super.body();
  endtask
  virtual task run_error_event(); endtask

  task check_fault(input uvm_object ptr,
                   input uvm_reg_data_t exp_data = 1);
    `uvm_info(`gfn, "err assert is done", UVM_MEDIUM)
    csr_spinwait(.ptr(ptr), .exp_data(exp_data));
    `uvm_info(`gfn, "csr wait is done is done", UVM_MEDIUM)
  endtask

  // After fatal error event, we need to reset dut
  // for clean finish.
  // This task assert reset and wait for buffer enable comes back.
  virtual task clean_up();
    cfg.seq_cfg.disable_flash_init = 1;
    cfg.seq_cfg.en_init_keys_seeds = 0;
    apply_reset();
    init_controller();
  endtask // clean_up
endclass
