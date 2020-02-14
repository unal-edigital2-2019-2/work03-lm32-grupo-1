`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:14:22 12/02/2019 
// Design Name: 
// Module Name:    cam_read 
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
module cam_read #(
		parameter AW = 15 // Cantidad de bits  de la direccion 
		)(
		input pclk,
		input rst,
		input vsync,
		input href,
		input [7:0] px_data,
		
		input init,
		output reg done,
		output reg error,

		output reg [AW-1:0] mem_px_addr,
		output reg [7:0]  mem_px_data,
		output reg px_wr
   );

reg countData;
reg [1:0]start;
reg init_old;
reg vsync_old;
reg [14:0]count;

initial begin
	countData <= 0;
	mem_px_addr <= 15'h7fff;
	start <= 0;
	done <= 0;
	error <= 0;
	count <= 0;
end

always @(posedge pclk)begin
	if (!rst)begin
		if(init && !init_old)begin
			start <= 1;
			done <= 0;
		end
		if(start>0 && (!vsync && vsync_old))begin
			start <=2;
		end
		if(start == 2 && (vsync && !vsync_old))begin
			mem_px_addr <= 15'h7fff;
			px_wr <= 0;
			start <= 0;
			if(count >= 19200)begin
				done <= 1;
				error <= 0;
			end else begin
				error <= 1;
				done <= 0;
			end
		end
			if(start==2)begin
				if(href)begin
					if(countData == 0)begin
						mem_px_data[7:2] <= {px_data[7:5],px_data[2:0]} ;
						countData <= 1;
						px_wr <= 0;
					end
					if(countData == 1)begin
						mem_px_data[1:0] <= {px_data[4:3]} ;
						mem_px_addr <= mem_px_addr + 1;
						px_wr <= #1 1;
						countData <= 0;
						count <= count+1;
					end
				end else begin
					px_wr <= 0;
				end
			end 
	end
	init_old = init;
	vsync_old = vsync;
end

endmodule
