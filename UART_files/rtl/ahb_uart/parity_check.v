module PARITY_CHECK
#(parameter ORIG_DATA_IN_WIDTH=8) //data size without parity
(
    input wire is_even_parity, //1 for even 0 for odd
    input wire [ORIG_DATA_IN_WIDTH:0] data_in_parity, //data with parity
    input wire parity_fault_injection,

    output wire PARITYERR
);

 assign PARITYERR = parity_fault_injection ^ ((^data_in_parity[ORIG_DATA_IN_WIDTH:0]) ^ is_even_parity);

endmodule


// wire [ORIG_DATA_IN_WIDTH:0] d_in_parity_with_fault_inj; //data_in_parity with fault injection

// assign d_in_parity_with_fault_inj = 
//     parity_fault_injection
//     ?
//     {~data_in_parity[ORIG_DATA_IN_WIDTH], data_in_parity[ORIG_DATA_IN_WIDTH-1:0]} //flip the parity bit
//     :
//     data_in_parity[ORIG_DATA_IN_WIDTH:0]
//     ;
 
 
// assign PARITYERR =
//     (
//     is_even_parity
//     ? 
//     ^d_in_parity_with_fault_inj[ORIG_DATA_IN_WIDTH-1:0]
//     :
//     ~(^d_in_parity_with_fault_inj[ORIG_DATA_IN_WIDTH-1:0])
//     )
//     != 
//     d_in_parity_with_fault_inj[ORIG_DATA_IN_WIDTH]
//     ;

// endmodule

// module paritychecktest();

// wire parity_err;

// PARITY_CHECK
//     #(.ORIG_DATA_IN_WIDTH(8))
// uPARITY_CHECK
// (
//     .is_even_parity(1'b1),
//     .data_in_parity(9'b010101010),
//     .PARITYERR(parity_err)
// );    

// initial begin
//     #100
//     $display("%b", parity_err);
// end

// endmodule