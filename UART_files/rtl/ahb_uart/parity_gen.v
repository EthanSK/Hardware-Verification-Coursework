


module PARITY_GEN
#(parameter DATA_IN_WIDTH=8)
(
    input wire is_even_parity, //1 for even 0 for odd
    input wire [DATA_IN_WIDTH-1:0] data_in,

    output wire [DATA_IN_WIDTH:0] data_out
);

assign data_out = { 
    is_even_parity 
    ?
    ^data_in[DATA_IN_WIDTH-1:0]
    :
    ~(^data_in[DATA_IN_WIDTH-1:0]), 
    data_in[DATA_IN_WIDTH-1:0]
    };

endmodule

// module paritygentest();

// wire [8:0] data_out;

// PARITY_GEN
//     #(.DATA_IN_WIDTH(8))
// uPARITY_GEN
// (
//     .is_even_parity(1'b0),
//     .data_in(8'b10101010),
//     .data_out(data_out[8:0])
// );    

// initial begin
//     #100
//     $display("%b", data_out[8]);
// end

// endmodule