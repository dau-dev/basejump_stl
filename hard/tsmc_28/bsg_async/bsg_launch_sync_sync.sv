// MBT 7/24/2014
//
// This is a launch/synchronization complex.
// The launch flop prevents combinational glitching.
// The two sync flops reduce probability of metastability.
// See MBT's note on async design and CDC.
//
// The three flops should be don't touched in synopsys
// and abutted in physical design to reduce chances of metastability.
//
// Use of reset is optional; it can be used to hold a known value during reset
// if for instance, the value is coming off chip.
//

// the code is structured this way because synopsys's
// support for hierarchical placement groups appears
// not to work for parameterized modules.
// so we must have a non-parameterized module
// in order to abut the three registers, which
// have two different clocks.
//
// DWP 02/09/2022
//   Ported from hard/gf_14/bsg_async/bsg_sync_sync.sv

// ASYNC RESET: iclk cannot toggle at deassertion of reset
`include "bsg_defines.sv"

`define bsg_launch_sync_sync_unit(EDGE,bits)                            \
                                                                        \
module bsg_launch_sync_sync_``EDGE``_``bits``_unit                      \
  (input iclk_i                                                         \
   , input iclk_reset_i                                                 \
   , input oclk_i                                                       \
   , input  [bits-1:0] iclk_data_i                                      \
   , output [bits-1:0] iclk_data_o                                      \
   , output [bits-1:0] oclk_data_o                                      \
   );                                                                   \
                                                                        \
   genvar i;                                                            \
                                                                        \
   logic [bits-1:0] bsg_SYNC_LNCH_r;                                    \
   assign iclk_data_o = bsg_SYNC_LNCH_r;                                \
                                                                        \
   always_ff @(EDGE iclk_i)                                             \
     begin                                                              \
        if (iclk_reset_i)                                               \
          bsg_SYNC_LNCH_r <= {bits{1'b0}};                              \
        else                                                            \
          bsg_SYNC_LNCH_r <= iclk_data_i;                               \
     end                                                                \
                                                                        \
   for (i = 0; i < bits; i = i + 1)                                  \
     begin : bss_unit                                                   \
       bsg_sync_sync_unit bss1                                          \
        (.oclk_i(oclk_i)                                                \
         ,.iclk_data_i(bsg_SYNC_LNCH_r[i])                                  \
         ,.oclk_data_o(oclk_data_o[i])                                  \
         );                                                             \
     end                                                                \
endmodule

`define bsg_launch_sync_sync_async_reset_unit(EDGE,bits)                \
                                                                        \
module bsg_launch_sync_sync_async_reset_``EDGE``_``bits``_unit          \
  (input iclk_i                                                         \
   , input iclk_reset_i                                                 \
   , input oclk_i                                                       \
   , input  [bits-1:0] iclk_data_i                                      \
   , output [bits-1:0] iclk_data_o                                      \
   , output [bits-1:0] oclk_data_o                                      \
   );                                                                   \
                                                                        \
   genvar i;                                                            \
                                                                        \
   logic [bits-1:0] bsg_SYNC_LNCH_r;                                    \
   assign iclk_data_o = bsg_SYNC_LNCH_r;                                \
                                                                        \
   always_ff @(EDGE iclk_i or posedge iclk_reset_i)                     \
     begin : BSG_NO_CLOCK_GATE_1                                        \
        if (iclk_reset_i)                                               \
          bsg_SYNC_LNCH_r <= {bits{1'b0}};                              \
        else                                                            \
          bsg_SYNC_LNCH_r <= iclk_data_i;                               \
     end                                                                \
                                                                        \
   for (i = 0; i < bits; i++)                                           \
     begin : BSG_NO_CLOCK_GATE_2                                        \
       bsg_sync_sync_async_reset_unit bss1                              \
        (.oclk_i(oclk_i)                                                \
         ,.iclk_reset_i(iclk_reset_i)                                   \
         ,.iclk_data_i(bsg_SYNC_LNCH_r[i])                              \
         ,.oclk_data_o(oclk_data_o[i])                                  \
         );                                                             \
     end                                                                \
endmodule

// bsg_launch_sync_sync_posedge_1_unit
`bsg_launch_sync_sync_unit(posedge,1)
`bsg_launch_sync_sync_unit(posedge,2)
`bsg_launch_sync_sync_unit(posedge,3)
`bsg_launch_sync_sync_unit(posedge,4)
`bsg_launch_sync_sync_unit(posedge,5)
`bsg_launch_sync_sync_unit(posedge,6)
`bsg_launch_sync_sync_unit(posedge,7)
`bsg_launch_sync_sync_unit(posedge,8)

// bsg_launch_sync_sync_negedge_1_unit
`bsg_launch_sync_sync_unit(negedge,1)
`bsg_launch_sync_sync_unit(negedge,2)
`bsg_launch_sync_sync_unit(negedge,3)
`bsg_launch_sync_sync_unit(negedge,4)
`bsg_launch_sync_sync_unit(negedge,5)
`bsg_launch_sync_sync_unit(negedge,6)
`bsg_launch_sync_sync_unit(negedge,7)
`bsg_launch_sync_sync_unit(negedge,8)

// bsg_launch_sync_sync_async_reset_posedge_1_unit
`bsg_launch_sync_sync_async_reset_unit(posedge,1)
`bsg_launch_sync_sync_async_reset_unit(posedge,2)
`bsg_launch_sync_sync_async_reset_unit(posedge,3)
`bsg_launch_sync_sync_async_reset_unit(posedge,4)
`bsg_launch_sync_sync_async_reset_unit(posedge,5)
`bsg_launch_sync_sync_async_reset_unit(posedge,6)
`bsg_launch_sync_sync_async_reset_unit(posedge,7)
`bsg_launch_sync_sync_async_reset_unit(posedge,8)

// bsg_launch_sync_sync_async_reset_negedge_1_unit
`bsg_launch_sync_sync_async_reset_unit(negedge,1)
`bsg_launch_sync_sync_async_reset_unit(negedge,2)
`bsg_launch_sync_sync_async_reset_unit(negedge,3)
`bsg_launch_sync_sync_async_reset_unit(negedge,4)
`bsg_launch_sync_sync_async_reset_unit(negedge,5)
`bsg_launch_sync_sync_async_reset_unit(negedge,6)
`bsg_launch_sync_sync_async_reset_unit(negedge,7)
`bsg_launch_sync_sync_async_reset_unit(negedge,8)

// warning: if you make this != 8, you need
// to modify other parts of this code

`define blss_max_block 8

// handle trailer bits
`define blss_if_clause(EDGE,num) if ((width_p % `blss_max_block) == num) begin: z            \
                                     bsg_launch_sync_sync_``EDGE``_``num``_unit blss \
                                        (.iclk_i                                     \
                                         ,.iclk_reset_i                              \
                                         ,.oclk_i                                    \
                                         ,.iclk_data_i(iclk_data_i[width_p-1-:num])  \
                                         ,.iclk_data_o(iclk_data_o[width_p-1-:num])  \
                                         ,.oclk_data_o(oclk_data_o[width_p-1-:num])  \
                                         ); end
										 
`define blssar_if_clause(EDGE,num) if ((width_p % `blss_max_block) == num) begin: z          \
                         bsg_launch_sync_sync_async_reset_``EDGE``_``num``_unit blss \
                                        (.iclk_i                                     \
                                         ,.iclk_reset_i                              \
                                         ,.oclk_i                                    \
                                         ,.iclk_data_i(iclk_data_i[width_p-1-:num])  \
                                         ,.iclk_data_o(iclk_data_o[width_p-1-:num])  \
                                         ,.oclk_data_o(oclk_data_o[width_p-1-:num])  \
                                         ); end

module bsg_launch_sync_sync #(parameter `BSG_INV_PARAM(width_p)
                              , parameter use_negedge_for_launch_p = 0
                              , parameter use_async_reset_p = 0)
   (input iclk_i
    , input iclk_reset_i
    , input oclk_i
    , input  [width_p-1:0] iclk_data_i
    , output [width_p-1:0] iclk_data_o // after launch flop
    , output [width_p-1:0] oclk_data_o // after sync flops
    );

`ifndef BSG_HIDE_FROM_SYNTHESIS

/*   initial
     begin
        $display("%m: instantiating blss of size %d",width_p);
     end
 */
   initial assert (iclk_reset_i !== 'z)
     else
       begin
          $error("%m iclk_reset should be connected");
          $finish();
       end

`endif

   genvar i;

   if (use_async_reset_p == 0) begin: sync

   if (use_negedge_for_launch_p)
     begin: n
        for (i = 0; i < (width_p/`blss_max_block); i = i + 1)
          begin : maxb
             bsg_launch_sync_sync_negedge_8_unit blss
                 (.iclk_i
                  ,.iclk_reset_i
                  ,.oclk_i
                  ,.iclk_data_i(iclk_data_i[i*`blss_max_block+:`blss_max_block])
                  ,.iclk_data_o(iclk_data_o[i*`blss_max_block+:`blss_max_block])
                  ,.oclk_data_o(oclk_data_o[i*`blss_max_block+:`blss_max_block])
                  );
          end

        `blss_if_clause(negedge,1) else
          `blss_if_clause(negedge,2) else
            `blss_if_clause(negedge,3) else
              `blss_if_clause(negedge,4) else
                `blss_if_clause(negedge,5) else
                  `blss_if_clause(negedge,6) else
                    `blss_if_clause(negedge,7)
     end
   else
     begin: p
        for (i = 0; i < (width_p/`blss_max_block); i = i + 1)
          begin : maxb
             bsg_launch_sync_sync_posedge_8_unit blss
                 (.iclk_i
                  ,.iclk_reset_i
                  ,.oclk_i
                  ,.iclk_data_i(iclk_data_i[i*`blss_max_block+:`blss_max_block])
                  ,.iclk_data_o(iclk_data_o[i*`blss_max_block+:`blss_max_block])
                  ,.oclk_data_o(oclk_data_o[i*`blss_max_block+:`blss_max_block])
                  );
          end

        `blss_if_clause(posedge,1) else
          `blss_if_clause(posedge,2) else
            `blss_if_clause(posedge,3) else
              `blss_if_clause(posedge,4) else
                `blss_if_clause(posedge,5) else
                  `blss_if_clause(posedge,6) else
                    `blss_if_clause(posedge,7)
     end

   end 
   else begin: async

   if (use_negedge_for_launch_p)
     begin: n
        for (i = 0; i < (width_p/`blss_max_block); i = i + 1)
          begin : maxb
             bsg_launch_sync_sync_async_reset_negedge_8_unit blss
                 (.iclk_i
                  ,.iclk_reset_i
                  ,.oclk_i
                  ,.iclk_data_i(iclk_data_i[i*`blss_max_block+:`blss_max_block])
                  ,.iclk_data_o(iclk_data_o[i*`blss_max_block+:`blss_max_block])
                  ,.oclk_data_o(oclk_data_o[i*`blss_max_block+:`blss_max_block])
                  );
          end

        `blssar_if_clause(negedge,1) else
          `blssar_if_clause(negedge,2) else
            `blssar_if_clause(negedge,3) else
              `blssar_if_clause(negedge,4) else
                `blssar_if_clause(negedge,5) else
                  `blssar_if_clause(negedge,6) else
                    `blssar_if_clause(negedge,7)
     end
   else
     begin: p
        for (i = 0; i < (width_p/`blss_max_block); i = i + 1)
          begin : maxb
             bsg_launch_sync_sync_async_reset_posedge_8_unit blss
                 (.iclk_i
                  ,.iclk_reset_i
                  ,.oclk_i
                  ,.iclk_data_i(iclk_data_i[i*`blss_max_block+:`blss_max_block])
                  ,.iclk_data_o(iclk_data_o[i*`blss_max_block+:`blss_max_block])
                  ,.oclk_data_o(oclk_data_o[i*`blss_max_block+:`blss_max_block])
                  );
          end

        `blssar_if_clause(posedge,1) else
          `blssar_if_clause(posedge,2) else
            `blssar_if_clause(posedge,3) else
              `blssar_if_clause(posedge,4) else
                `blssar_if_clause(posedge,5) else
                  `blssar_if_clause(posedge,6) else
                    `blssar_if_clause(posedge,7)
     end

   end

endmodule

`BSG_ABSTRACT_MODULE(bsg_launch_sync_sync)

