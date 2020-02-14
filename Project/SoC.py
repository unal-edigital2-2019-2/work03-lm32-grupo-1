from migen import *

from migen.genlib.io import CRG

from litex.build.generic_platform import *
from litex.build.xilinx import XilinxPlatform

import litex.soc.integration.soc_core as SC
from litex.soc.integration.builder import *

from CamMEM import Cam_Mem_Master


#
# platform
#

_io = [


    ("clk100", 0, Pins("E3"), IOStandard("LVCMOS33")),

    ("cpu_reset", 0, Pins("C12"), IOStandard("LVCMOS33")),

    ("serial", 0,
        Subsignal("tx", Pins("D4")),#pines UART Nexys
        Subsignal("rx", Pins("C4")),
        IOStandard("LVCMOS33"),
    ),


    ("camMemory", 0,
    	Subsignal("href", Pins("F16")),
        Subsignal("pclk", Pins("E16")),
        Subsignal("xclk", Pins("D14")),
        Subsignal("vsync", Pins("F13")),
        Subsignal("data_in_0", Pins("C17")),
        Subsignal("data_in_1", Pins("D17")),
        Subsignal("data_in_2", Pins("D18")),
        Subsignal("data_in_3", Pins("E17")),
        Subsignal("data_in_4", Pins("E18")),
        Subsignal("data_in_5", Pins("F18")),
        Subsignal("data_in_6", Pins("G17")),
        Subsignal("data_in_7", Pins("G18")),

	#Subsignal("data_in_0", Pins("J15")),
        #Subsignal("data_in_1", Pins("L16")),
        #Subsignal("data_in_2", Pins("M13")),
        #Subsignal("data_in_3", Pins("R15")),
        #Subsignal("data_in_4", Pins("R17")),
        #Subsignal("data_in_5", Pins("T18")),
        #Subsignal("data_in_6", Pins("U18")),
        #Subsignal("data_in_7", Pins("R13")),
        IOStandard("LVCMOS33")
    ),
]




class Platform(XilinxPlatform):
    default_clk_name = "clk100"
    default_clk_period = 10

    def __init__(self):
       XilinxPlatform.__init__(self, "xc7a100t-CSG324-1", _io, toolchain="ise")

    def do_finalize(self, fragment):
        XilinxPlatform.do_finalize(self, fragment, ngdbuild_opt="ngdbuild -p")


#
# design
#

# create our platform (fpga interface)
platform = Platform()
platform.add_source("src/test_cam.v")
platform.add_source("src/Analyzer.v")
platform.add_source("src/cam_read.v")
platform.add_source("src/clk24_25_nexys4.v")
platform.add_source("src/buffer_ram_dp.v")
platform.add_platform_command("NET  \"camMemory_pclk\" CLOCK_DEDICATED_ROUTE = FALSE;")

class BaseSoC(SC.SoCCore):
    # Peripherals CSR declaration
    csr_peripherals = {
      "Cam": 4
    }
    SC.SoCCore.csr_map= csr_peripherals

    def __init__(self, platform):
        sys_clk_freq = int(100e6)
        # SoC with CPU
        SC.SoCCore.__init__(self, platform,
            cpu_type="lm32",
            clk_freq=100e6,
            ident="CPU Test SoC", ident_version=True,
            integrated_rom_size=0x8000,
            csr_data_width=32,
            integrated_main_ram_size=16*1024)

     
        # Clock Reset Generation
        self.submodules.crg = CRG(platform.request("clk100"), ~platform.request("cpu_reset"))

	# Cámara
        self.submodules.Cam = Cam_Mem_Master(platform.request("camMemory"))

soc = BaseSoC(platform)


#
# build
#
builder = Builder(soc, output_dir="build", csr_csv="csr.csv")

builder.build()

# create our soc (fpga description)
