################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

CG_TOOL_ROOT := C:/ti/ccs901/ccs/tools/compiler/ti-cgt-c2000_18.12.3.LTS

GEN_OPTS__FLAG := 
GEN_CMDS__FLAG := 

ORDERED_OBJS += \
"./main.obj" \
"./sources/F2837xD_Adc.obj" \
"./sources/F2837xD_CodeStartBranch.obj" \
"./sources/F2837xD_CpuTimers.obj" \
"./sources/F2837xD_DBGIER.obj" \
"./sources/F2837xD_DefaultISR.obj" \
"./sources/F2837xD_Dma.obj" \
"./sources/F2837xD_ECap.obj" \
"./sources/F2837xD_EPwm.obj" \
"./sources/F2837xD_EQep.obj" \
"./sources/F2837xD_Emif.obj" \
"./sources/F2837xD_GlobalVariableDefs.obj" \
"./sources/F2837xD_Gpio.obj" \
"./sources/F2837xD_I2C.obj" \
"./sources/F2837xD_Ipc.obj" \
"./sources/F2837xD_Ipc_Driver.obj" \
"./sources/F2837xD_Ipc_Driver_Lite.obj" \
"./sources/F2837xD_Ipc_Driver_Util.obj" \
"./sources/F2837xD_Mcbsp.obj" \
"./sources/F2837xD_PieCtrl.obj" \
"./sources/F2837xD_PieVect.obj" \
"./sources/F2837xD_Sci.obj" \
"./sources/F2837xD_Spi.obj" \
"./sources/F2837xD_SysCtrl.obj" \
"./sources/F2837xD_TempSensorConv.obj" \
"./sources/F2837xD_Upp.obj" \
"./sources/F2837xD_can.obj" \
"./sources/F2837xD_sci_io.obj" \
"./sources/F2837xD_sdfm_drivers.obj" \
"./sources/F2837xD_struct.obj" \
"./sources/F2837xD_usDelay.obj" \
"../2837xD_RAM_lnk_cpu1.cmd" \
"../F2837xD_Headers_nonBIOS_cpu1.cmd" \
$(GEN_CMDS__FLAG) \
-llibc.a \
-l"C:/Users/admin/Documents/GitHub/fault_tolerant_drives/Software/MultipleDataPlot/MultipleFloatDataSender/Debug/MultipleFloatDataSender.lib" \

-include ../makefile.init

RM := DEL /F
RMDIR := RMDIR /S/Q

# All of the sources participating in the build are defined here
-include sources.mk
-include subdir_vars.mk
-include sources/subdir_vars.mk
-include subdir_rules.mk
-include sources/subdir_rules.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C55_DEPS)),)
-include $(C55_DEPS)
endif
ifneq ($(strip $(C_UPPER_DEPS)),)
-include $(C_UPPER_DEPS)
endif
ifneq ($(strip $(S67_DEPS)),)
-include $(S67_DEPS)
endif
ifneq ($(strip $(S62_DEPS)),)
-include $(S62_DEPS)
endif
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(OPT_DEPS)),)
-include $(OPT_DEPS)
endif
ifneq ($(strip $(C??_DEPS)),)
-include $(C??_DEPS)
endif
ifneq ($(strip $(ASM_UPPER_DEPS)),)
-include $(ASM_UPPER_DEPS)
endif
ifneq ($(strip $(S??_DEPS)),)
-include $(S??_DEPS)
endif
ifneq ($(strip $(C64_DEPS)),)
-include $(C64_DEPS)
endif
ifneq ($(strip $(CXX_DEPS)),)
-include $(CXX_DEPS)
endif
ifneq ($(strip $(S64_DEPS)),)
-include $(S64_DEPS)
endif
ifneq ($(strip $(INO_DEPS)),)
-include $(INO_DEPS)
endif
ifneq ($(strip $(CLA_DEPS)),)
-include $(CLA_DEPS)
endif
ifneq ($(strip $(S55_DEPS)),)
-include $(S55_DEPS)
endif
ifneq ($(strip $(SV7A_DEPS)),)
-include $(SV7A_DEPS)
endif
ifneq ($(strip $(C62_DEPS)),)
-include $(C62_DEPS)
endif
ifneq ($(strip $(C67_DEPS)),)
-include $(C67_DEPS)
endif
ifneq ($(strip $(PDE_DEPS)),)
-include $(PDE_DEPS)
endif
ifneq ($(strip $(K_DEPS)),)
-include $(K_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(CC_DEPS)),)
-include $(CC_DEPS)
endif
ifneq ($(strip $(C++_DEPS)),)
-include $(C++_DEPS)
endif
ifneq ($(strip $(C43_DEPS)),)
-include $(C43_DEPS)
endif
ifneq ($(strip $(S43_DEPS)),)
-include $(S43_DEPS)
endif
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(CPP_DEPS)),)
-include $(CPP_DEPS)
endif
ifneq ($(strip $(SA_DEPS)),)
-include $(SA_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
EXE_OUTPUTS += \
ExampleProject.out \

EXE_OUTPUTS__QUOTED += \
"ExampleProject.out" \

BIN_OUTPUTS += \
ExampleProject.hex \

BIN_OUTPUTS__QUOTED += \
"ExampleProject.hex" \


# All Target
all: $(OBJS) $(CMD_SRCS) $(GEN_CMDS)
	@$(MAKE) --no-print-directory -Onone "ExampleProject.out"

# Tool invocations
ExampleProject.out: $(OBJS) $(CMD_SRCS) $(GEN_CMDS)
	@echo 'Building target: "$@"'
	@echo 'Invoking: C2000 Linker'
	"C:/ti/ccs901/ccs/tools/compiler/ti-cgt-c2000_18.12.3.LTS/bin/cl2000" -v28 -ml -mt --cla_support=cla1 --float_support=fpu32 --tmu_support=tmu0 --vcu_support=vcu2 --fp_mode=relaxed --define=CPU1 --define=_LAUNCHXL_F28379D -g --diag_warning=225 --diag_wrap=off --display_error_number --abi=coffabi -z -m"ExampleProject.map" --stack_size=0x200 --warn_sections -i"C:/ti/ccs901/ccs/tools/compiler/ti-cgt-c2000_18.12.3.LTS/lib" -i"C:/ti/ccs901/ccs/tools/compiler/ti-cgt-c2000_18.12.3.LTS/include" --reread_libs --diag_wrap=off --display_error_number --xml_link_info="ExampleProject_linkInfo.xml" --rom_model -o "ExampleProject.out" $(ORDERED_OBJS)
	@echo 'Finished building target: "$@"'
	@echo ' '

ExampleProject.hex: $(EXE_OUTPUTS)
	@echo 'Building files: $(strip $(EXE_OUTPUTS__QUOTED))'
	@echo 'Invoking: C2000 Hex Utility'
	"C:/ti/ccs901/ccs/tools/compiler/ti-cgt-c2000_18.12.3.LTS/bin/hex2000"  -o "ExampleProject.hex" $(EXE_OUTPUTS__QUOTED)
	@echo 'Finished building: $(strip $(EXE_OUTPUTS__QUOTED))'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(BIN_OUTPUTS__QUOTED)$(EXE_OUTPUTS__QUOTED)
	-$(RM) "main.obj" "sources\F2837xD_Adc.obj" "sources\F2837xD_CodeStartBranch.obj" "sources\F2837xD_CpuTimers.obj" "sources\F2837xD_DBGIER.obj" "sources\F2837xD_DefaultISR.obj" "sources\F2837xD_Dma.obj" "sources\F2837xD_ECap.obj" "sources\F2837xD_EPwm.obj" "sources\F2837xD_EQep.obj" "sources\F2837xD_Emif.obj" "sources\F2837xD_GlobalVariableDefs.obj" "sources\F2837xD_Gpio.obj" "sources\F2837xD_I2C.obj" "sources\F2837xD_Ipc.obj" "sources\F2837xD_Ipc_Driver.obj" "sources\F2837xD_Ipc_Driver_Lite.obj" "sources\F2837xD_Ipc_Driver_Util.obj" "sources\F2837xD_Mcbsp.obj" "sources\F2837xD_PieCtrl.obj" "sources\F2837xD_PieVect.obj" "sources\F2837xD_Sci.obj" "sources\F2837xD_Spi.obj" "sources\F2837xD_SysCtrl.obj" "sources\F2837xD_TempSensorConv.obj" "sources\F2837xD_Upp.obj" "sources\F2837xD_can.obj" "sources\F2837xD_sci_io.obj" "sources\F2837xD_sdfm_drivers.obj" "sources\F2837xD_struct.obj" "sources\F2837xD_usDelay.obj" 
	-$(RM) "main.d" "sources\F2837xD_Adc.d" "sources\F2837xD_CpuTimers.d" "sources\F2837xD_DefaultISR.d" "sources\F2837xD_Dma.d" "sources\F2837xD_ECap.d" "sources\F2837xD_EPwm.d" "sources\F2837xD_EQep.d" "sources\F2837xD_Emif.d" "sources\F2837xD_GlobalVariableDefs.d" "sources\F2837xD_Gpio.d" "sources\F2837xD_I2C.d" "sources\F2837xD_Ipc.d" "sources\F2837xD_Ipc_Driver.d" "sources\F2837xD_Ipc_Driver_Lite.d" "sources\F2837xD_Ipc_Driver_Util.d" "sources\F2837xD_Mcbsp.d" "sources\F2837xD_PieCtrl.d" "sources\F2837xD_PieVect.d" "sources\F2837xD_Sci.d" "sources\F2837xD_Spi.d" "sources\F2837xD_SysCtrl.d" "sources\F2837xD_TempSensorConv.d" "sources\F2837xD_Upp.d" "sources\F2837xD_can.d" "sources\F2837xD_sci_io.d" "sources\F2837xD_sdfm_drivers.d" "sources\F2837xD_struct.d" 
	-$(RM) "sources\F2837xD_CodeStartBranch.d" "sources\F2837xD_DBGIER.d" "sources\F2837xD_usDelay.d" 
	-@echo 'Finished clean'
	-@echo ' '

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets

