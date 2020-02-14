`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:34:20 02/11/2020 
// Design Name: 
// Module Name:    Analyzer 
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
module Analyzer(
	input [7:0]data,
	input clk,
	input init,
	output reg [14:0]addr,
	output reg done,
	output reg [2:0]res
    );

reg init_old;
reg start;
reg [14:0]count;
reg [17:0]sumaR;
reg [17:0]sumaG;
reg [17:0]sumaB;

wire [2:0]dataR;
wire [2:0]dataG;
wire [2:0]dataB;

initial begin
	init_old <= 0;
	addr <= 15'h7fff;
	done <= 0;
	count <= 0;
	sumaR <= 0;
	sumaG <= 0;
	sumaB <= 0;
end

assign dataR = data[7:5];
assign dataG = data[4:2];
assign dataB = {data[2:0],1'b0};

always @(posedge clk)begin
		if(init && !init_old)begin
			start <= 1;
			done <= 0;
			sumaR <= 0;
			sumaG <= 0;
			sumaB <= 0;
		end
	if(start)begin
		if(count >= 19200)begin
			start <= 0;
			count <= 0;
			addr <= 15'h7fff;
			done <= 1;
			if((sumaR > sumaG) && (sumaR > sumaB))begin
				res = 3'b100;
			end else begin
				if((sumaG > sumaR) && (sumaG > sumaB))begin
				res = 3'b010;
				end else begin
					if((sumaB > sumaR) && (sumaB > sumaG))begin
						res = 3'b001;
					end else begin
						res =3'b111; //No hay ninguno mayor
					end
				end
			end
		end else begin
			addr <= addr+1;
			count <= count+1;
			sumaR <= #1 sumaR+dataR;
			sumaG <= #1 sumaG+dataG;
			sumaB <= #1 sumaB+dataB;
			done <= 0;
		end
	end 
	init_old = init;
end
endmodule
