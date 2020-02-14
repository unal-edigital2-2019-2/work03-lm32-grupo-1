#!/usr/bin/python3

from migen import *
from migen.build.generic_platform import *
from migen.build.xilinx import XilinxPlatform
from litex.soc.interconnect.csr import *


class Cam_Mem_Master(Module,AutoCSR):
	def __init__(self, pads, clk=ClockSignal()):

		self.rst = Signal()
		self.clk =clk
		self.init = CSRStorage(8)
		self.done = CSRStatus(8)
		self.error = CSRStatus(8)
		self.res= CSRStatus(8)
		


    ##Instancia
		self.specials +=[Instance("test_cam",
            i_clk = self.clk,
            i_rst = self.rst,
            i_init = self.init.storage,
	    o_error =self.error.status,
            o_done = self.done.status,
            i_CAM_href = pads.href,
	    i_CAM_pclk = pads.pclk,
	    o_CAM_xclk = pads.xclk,
	    i_CAM_vsync = pads.vsync,
	    i_CAM_px_data_0 = pads.data_in_0,
	    i_CAM_px_data_1 = pads.data_in_1,
	    i_CAM_px_data_2 = pads.data_in_2,
	    i_CAM_px_data_3 = pads.data_in_3,
	    i_CAM_px_data_4 = pads.data_in_4,
	    i_CAM_px_data_5 = pads.data_in_5,
	    i_CAM_px_data_6 = pads.data_in_6,
	    i_CAM_px_data_7 = pads.data_in_7,

	    o_res= self.res.status
        )]



