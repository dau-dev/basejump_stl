

module bsg_mul_comp42
   ( input [3:0] i  // 0-2: early; 3: middle
     , input cr_i   // middle
     , output cl_o  // middle
     , output c_o   // late
     , output s_o   // late
     );

   wire           tmp;

   bsg_mul_csa csa_1 (.x_i(i[0]), .y_i(i[1]), .z_i(i[2]), .c_o(cl_o), .s_o(tmp));
   bsg_mul_csa csa_2 (.x_i(i[3]), .y_i(tmp ), .z_i(cr_i), .c_o(c_o ), .s_o(s_o));

endmodule


module bsg_mul_comp42_rep #(parameter blocks_p=1, harden_p=0)
   // we do this so that it is easy to combine vectors of results from blocks
   (input [3:0][blocks_p-1:0] i
    ,input cr_i
    ,output cl_o
    ,output [blocks_p-1:0] c_o
    ,output [blocks_p-1:0] s_o
    );

   genvar j;
   wire [blocks_p:0] ci_local;

   assign ci_local[0] = cr_i;
   assign cl_o        = ci_local[blocks_p];

   for (j = 0; j < blocks_p; j=j+1)
     begin: rof
        wire [3:0] tmp = { i[3][j], i[2][j], i[1][j], i[0][j] };

        bsg_mul_comp42 c (.i(tmp), .cr_i(ci_local[j]), .cl_o(ci_local[j+1]), .c_o(c_o[j]) ,.s_o(s_o[j]));
     end
endmodule
