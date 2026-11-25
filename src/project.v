`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, good to declare
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    localparam [1:0] VERDE    = 2'd0,
                     AMARILLO = 2'd1,
                     ROJO     = 2'd2;

    reg [1:0] estado;
    reg [2:0] luces; // [0]=Verde, [1]=Amarillo, [2]=Rojo

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            estado <= VERDE;
        end else begin
            case (estado)
                VERDE:    estado <= AMARILLO;
                AMARILLO: estado <= ROJO;
                ROJO:     estado <= VERDE;
                default:  estado <= VERDE;
            endcase
        end
    end

    always @(*) begin
        case (estado)
            VERDE:    luces = 3'b001;
            AMARILLO: luces = 3'b010;
            ROJO:     luces = 3'b100;
            default:  luces = 3'b001;
        endcase
    end

    // Asigna todas las salidas para evitar latches o pines flotantes
    assign uo_out  = {5'b00000, luces}; // uo_out[0]=Verde, uo_out[1]=Amarillo, uo_out[2]=Rojo
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

    // Evita advertencias por señales no usadas
    wire _unused = &{ena, ui_in, uio_in, 1'b0};

endmodule
