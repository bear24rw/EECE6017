###################################################################
# Project Configuration: 
# 
# Specify the name of the design (project) and the Quartus II
# Settings File (.qsf)
###################################################################

PROJECT = top
ASSIGNMENT_FILES = top.qpf top.qsf

SRC = \
	../rtl/top.v \
	../rtl/timp_input.v \
	../rtl/state_2_bcd.v \
	../rtl/seven_seg.v \
	../rtl/pulse_led.v \
	../rtl/monitor.v \
	../rtl/clk_div.v \
	../rtl/bin_2_bcd.v \
	../rtl/bin_sub.v

###################################################################
# Main Targets
#
# all: build everything
# clean: remove output files and database
# program: program your device with the compiled design
###################################################################

all: smart.log $(PROJECT).asm.rpt $(PROJECT).sta.rpt 

clean:
	rm -rf *.rpt *.chg smart.log *.htm *.eqn *.pin *.sof *.pof *.done *.jdi db incremental_db

map: smart.log $(PROJECT).map.rpt
fit: smart.log $(PROJECT).fit.rpt
asm: smart.log $(PROJECT).asm.rpt
sta: smart.log $(PROJECT).sta.rpt
smart: smart.log

###################################################################
# Executable Configuration
###################################################################

MAP_ARGS = --family="Cyclone II"
FIT_ARGS = --part=EP2C20F484C7
ASM_ARGS =
STA_ARGS =

###################################################################
# Target implementations
###################################################################

STAMP = echo done >

$(PROJECT).map.rpt: map.chg $(SOURCE_FILES) 
	quartus_map $(MAP_ARGS) $(PROJECT)
	$(STAMP) fit.chg

$(PROJECT).fit.rpt: fit.chg $(PROJECT).map.rpt
	quartus_fit $(FIT_ARGS) $(PROJECT)
	$(STAMP) asm.chg
	$(STAMP) sta.chg

$(PROJECT).asm.rpt: asm.chg $(PROJECT).fit.rpt
	quartus_asm $(ASM_ARGS) $(PROJECT)

$(PROJECT).sta.rpt: sta.chg $(PROJECT).fit.rpt
	quartus_sta $(STA_ARGS) $(PROJECT) 

smart.log: $(ASSIGNMENT_FILES)
	quartus_sh --determine_smart_action $(PROJECT) > smart.log

###################################################################
# Project initialization
###################################################################

$(ASSIGNMENT_FILES):
	quartus_sh --prepare $(PROJECT)
	
map.chg:
	$(STAMP) map.chg
fit.chg:
	$(STAMP) fit.chg
sta.chg:
	$(STAMP) sta.chg
asm.chg:
	$(STAMP) asm.chg

###################################################################
# Programming the device
###################################################################

program: $(PROJECT).sof
	quartus_pgm --no_banner --mode=jtag -o "P;$(PROJECT).sof"
