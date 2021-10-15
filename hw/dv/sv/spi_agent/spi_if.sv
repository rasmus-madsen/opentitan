// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

import spi_agent_pkg::*;

interface spi_if (
  input rst_n
);

  // standard spi interface pins
  logic       sck;
  logic [3:0] csb;
  logic [3:0] sio;

  // debug signals
  logic [7:0] host_byte;
  int         host_bit;
  logic [7:0] device_byte;
  int         device_bit;
  int         sck_pulses;
  bit         sck_polarity;
  bit         sck_phase;

  //---------------------------------
  // common tasks
  //---------------------------------
  task automatic wait_for_dly(int dly);
    repeat (dly) @(posedge sck);
  endtask : wait_for_dly

  task automatic get_data_from_sio(ref spi_mode_e mode, output bit sio_bits[]);
    unique case (mode)
      Standard: sio_bits = {>> 1 {sio[0]}};
      Dual:     sio_bits = {>> 1 {sio[1:0]}};
      Quad:     sio_bits = {>> 1 {sio[3:0]}};
    endcase
  endtask : get_data_from_sio

endinterface : spi_if
