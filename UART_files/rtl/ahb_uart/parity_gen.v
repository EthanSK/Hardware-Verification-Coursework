


module PARITY_GEN
#(parameter DATA_IN_WIDTH=8)
(
    input wire is_even_parity, //1 for even 0 for odd
    input wire [DATA_IN_WIDTH-1:0] data_in,
    input wire parity_fault_injection,

    output wire [DATA_IN_WIDTH:0] data_out
);
 
// assign data_out = {^data_in[DATA_IN_WIDTH-1:0] ~^ is_even_parity ^ parity_fault_injection, data_in};

assign parity_bit = 
    is_even_parity 
    ?
    ^data_in[DATA_IN_WIDTH-1:0]
    :
    ~(^data_in[DATA_IN_WIDTH-1:0]);

assign data_out = { 
    parity_fault_injection ? ~parity_bit : parity_bit
    ,
    data_in[DATA_IN_WIDTH-1:0]
    };

 

endmodule

// module paritygentest();

// wire [8:0] data_out;

// PARITY_GEN
//     #(.DATA_IN_WIDTH(8))
// uPARITY_GEN
// (
//     .is_even_parity(1'b1),
//     .data_in(8'b01000001),
//     .data_out(data_out[8:0]),
//     .parity_fault_injection(1'b0)
// );    

// initial begin
//     #100
//     $display("Parity bit: %b", data_out[8]);
// end

// endmodule