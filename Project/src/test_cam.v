`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:46:19 11/04/2019 
// Design Name: 
// Module Name:    test_cam 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module test_cam(
    input wire clk,           // board clock: 32 MHz quacho 100 MHz nexys4 
    input wire rst,         	// reset button

	
	
	//CAMARA input/output
	
	output wire CAM_xclk,		// System  clock input
	
	// colocar aqui las entras  y salidas de la camara  que hace falta

	input wire CAM_pclk,
	input wire CAM_vsync,
	input wire CAM_href,
	input wire CAM_px_data_0,
	input wire CAM_px_data_1,
	input wire CAM_px_data_2,
	input wire CAM_px_data_3,
	input wire CAM_px_data_4,
	input wire CAM_px_data_5,
	input wire CAM_px_data_6,
	input wire CAM_px_data_7,
	
	input init,
	output error,
	output done,
	output [2:0]res
	
	);

wire [7:0]CAM_px_data;
assign CAM_px_data[7:0] ={CAM_px_data_7,CAM_px_data_6,CAM_px_data_5,CAM_px_data_4,CAM_px_data_3,CAM_px_data_2,CAM_px_data_1,CAM_px_data_0};

// TAMAÑO DE ADQUISICIÓN DE LA CAMARA 
parameter CAM_SCREEN_X = 160;
parameter CAM_SCREEN_Y = 120;

localparam AW = 15; // LOG2(CAM_SCREEN_X*CAM_SCREEN_Y)
localparam DW = 8;


// Clk 
wire clk32M;
wire clk25M;
wire clk24M;

// Conexión dual por ram

wire  [AW-1: 0] DP_RAM_addr_in;  
wire  [DW-1: 0] DP_RAM_data_in;
wire DP_RAM_regW;
wire  [AW-1: 0] DP_RAM_addr_out;
wire  [DW-1: 0] DP_RAM_data_out; 	

/* ****************************************************************************
Asignacin de las seales de control xclk pwdn y reset de la camara 
**************************************************************************** */

assign CAM_xclk=  clk24M;
assign CAM_pwdn=  0;			// power down mode 
assign CAM_reset=  0;



/* ****************************************************************************
  Este bloque se debe modificar segn sea le caso. El ejemplo esta dado para
  fpga Spartan6 lx9 a 32MHz.
  usar "tools -> Core Generator ..."  y general el ip con Clocking Wizard
  el bloque genera un reloj de 25Mhz usado para el VGA  y un relo de 24 MHz
  utilizado para la camara , a partir de una frecuencia de 32 Mhz
**************************************************************************** */
//assign clk32M =clk;
clk24_25_nexys4
  clk24_25_nexys4(
  .CLK_IN1(clk),
  .CLK_OUT1(clk25M),
  .CLK_OUT2(clk24M),
  .RESET(rst)
 );


/* ****************************************************************************
buffer_ram_dp buffer memoria dual port y reloj de lectura y escritura separados
Se debe configurar AW  segn los calculos realizados en el Wp01
se recomiendia dejar DW a 8, con el fin de optimizar recursos  y hacer RGB 332
**************************************************************************** */
buffer_ram_dp #( AW,DW)
	buffer_ram_dp(  
	.clk_w(CAM_pclk), 
	.addr_in(DP_RAM_addr_in), 
	.data_in(DP_RAM_data_in),
	.regwrite(DP_RAM_regW),
	.clk_r(clk25M), 
	.addr_out(DP_RAM_addr_out),
	.data_out(DP_RAM_data_out)
	);
	

/*****************************************************************************
Módulo de captura de datos
**************************************************************************** */
wire done_read;

 cam_read #(AW)cam_read(
		.pclk(CAM_pclk),
		.rst(rst),
		.vsync(CAM_vsync),
		.href(CAM_href),
		.px_data(CAM_px_data),
		.init(init),
		.done(done_read),
		.error(error),
		.mem_px_addr(DP_RAM_addr_in),
		.mem_px_data(DP_RAM_data_in),
		.px_wr(DP_RAM_regW)
   );
	
/*****************************************************************************
Módulo Analizador
**************************************************************************** */
Analyzer Analyzer(
	.data(DP_RAM_data_out),
	.clk(clk25M),
	.init(done_read),
	.addr(DP_RAM_addr_out),
	.done(done),
	.res(res)
    );
	
endmodule
