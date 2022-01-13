// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class pwm_env_cfg extends cip_base_env_cfg #(.RAL_T(pwm_reg_block));
  `uvm_object_utils_begin(pwm_env_cfg)
  `uvm_object_utils_end
  `uvm_object_new

  // knobs //
  int                   clk_div_min;
  int                   clk_div_max;
  int                   resn_min;
  int                   resn_max;
  int                   dc_min;
  int                   dc_max;
  int                   blink_min;
  int                   blink_max;
  int                   blink_pct;
  int                   htbt_pct;
  int                   phase_delay_min;
  int                   phase_delay_max;

  // configs
  pwm_monitor_cfg       m_pwm_monitor_cfg[PWM_NUM_CHANNELS];

  // virtual ifs
  virtual clk_rst_if    clk_rst_core_vif;
  int                   core_clk_freq_mhz;

  // variables
  rand cfg_reg_t        pwm_cfg;
  rand dc_blink_t       duty_cycle[PWM_NUM_CHANNELS];
  rand dc_blink_t       blink[PWM_NUM_CHANNELS];
  rand param_reg_t      pwm_param[PWM_NUM_CHANNELS];
  // ratio between bus_clk and core_clk (must be >= 1)
  rand int clk_ratio;
  constraint clk_ratio_c { clk_ratio inside {[1: 4]}; }


  constraint pwm_cfg_c {
      pwm_cfg.ClkDiv inside { [clk_div_min:clk_div_max] };
      pwm_cfg.DcResn inside { [resn_min:resn_max] };
      // force the counter enable to 0
      // this should always be manually enabled
      pwm_cfg.CntrEn == 0;
  }

  constraint dutycycle_c {
        foreach (duty_cycle[ii]) {
           duty_cycle[ii].A inside { [dc_min:dc_max] };
           duty_cycle[ii].B inside { [dc_min:dc_max] };
        }
  }

  constraint blink_c {
        foreach (blink[ii]) {
           blink[ii].A inside { [blink_min:blink_max] };
           blink[ii].B inside { [blink_min:blink_max] };
        }
  }

  constraint ch_param_c {
        foreach (pwm_param[ii]) {
          pwm_param[ii].BlinkEn dist { 1 :/ blink_pct,
                                       0 :/ 100-blink_pct
                                     };
          pwm_param[ii].HtbtEn  dist { 1 :/ htbt_pct,
                                       0 :/ 100 - htbt_pct
                                     };
          pwm_param[ii].PhaseDelay inside { [phase_delay_min:phase_delay_max] };
        }
  }
  

  virtual function void initialize(bit [31:0] csr_base_addr = '1);
    list_of_alerts = pwm_env_pkg::LIST_OF_ALERTS;
    super.initialize(csr_base_addr);

    // create pwm_agent_cfg
    foreach(m_pwm_monitor_cfg[i]) begin
      m_pwm_monitor_cfg[i] = pwm_monitor_cfg::type_id::
              create($sformatf("m_pwm_monitor_%0d_cfg", i));
      m_pwm_monitor_cfg[i].if_mode = Device;
    end
  endfunction

  // clk_core_freq_mhz is assigned by
  // - a slower frequency in range [bus_clock*scale : bus_clock] if en_random is set (scale <= 1)
  // - bus_clock frequency otherwise
  virtual function int get_clk_core_freq(uint en_random = 1);
    int clk_core_min, clk_core_max, clk_core_mhz;

    if (en_random) begin
//      `DV_CHECK_MEMBER_RANDOMIZE_FATAL(clk_ratio)
//      `DV_CHECK_GE(clk_ratio, 1)
      clk_core_max = clk_rst_vif.clk_freq_mhz;
      clk_core_min = int'(clk_rst_vif.clk_freq_mhz / clk_ratio);
      clk_core_mhz = $urandom_range(clk_core_min, clk_core_max);
    end else begin
      clk_core_mhz = clk_rst_vif.clk_freq_mhz;
    end
    return clk_core_mhz;
  endfunction : get_clk_core_freq
endclass : pwm_env_cfg
