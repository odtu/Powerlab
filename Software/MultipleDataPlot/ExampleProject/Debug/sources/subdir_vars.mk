################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

# Add inputs and outputs from these tool invocations to the build variables 
ASM_SRCS += \
../sources/F2837xD_CodeStartBranch.asm \
../sources/F2837xD_DBGIER.asm \
../sources/F2837xD_usDelay.asm 

C_SRCS += \
../sources/F2837xD_Adc.c \
../sources/F2837xD_CpuTimers.c \
../sources/F2837xD_DefaultISR.c \
../sources/F2837xD_Dma.c \
../sources/F2837xD_ECap.c \
../sources/F2837xD_EPwm.c \
../sources/F2837xD_EQep.c \
../sources/F2837xD_Emif.c \
../sources/F2837xD_GlobalVariableDefs.c \
../sources/F2837xD_Gpio.c \
../sources/F2837xD_I2C.c \
../sources/F2837xD_Ipc.c \
../sources/F2837xD_Ipc_Driver.c \
../sources/F2837xD_Ipc_Driver_Lite.c \
../sources/F2837xD_Ipc_Driver_Util.c \
../sources/F2837xD_Mcbsp.c \
../sources/F2837xD_PieCtrl.c \
../sources/F2837xD_PieVect.c \
../sources/F2837xD_Sci.c \
../sources/F2837xD_Spi.c \
../sources/F2837xD_SysCtrl.c \
../sources/F2837xD_TempSensorConv.c \
../sources/F2837xD_Upp.c \
../sources/F2837xD_can.c \
../sources/F2837xD_sci_io.c \
../sources/F2837xD_sdfm_drivers.c \
../sources/F2837xD_struct.c 

C_DEPS += \
./sources/F2837xD_Adc.d \
./sources/F2837xD_CpuTimers.d \
./sources/F2837xD_DefaultISR.d \
./sources/F2837xD_Dma.d \
./sources/F2837xD_ECap.d \
./sources/F2837xD_EPwm.d \
./sources/F2837xD_EQep.d \
./sources/F2837xD_Emif.d \
./sources/F2837xD_GlobalVariableDefs.d \
./sources/F2837xD_Gpio.d \
./sources/F2837xD_I2C.d \
./sources/F2837xD_Ipc.d \
./sources/F2837xD_Ipc_Driver.d \
./sources/F2837xD_Ipc_Driver_Lite.d \
./sources/F2837xD_Ipc_Driver_Util.d \
./sources/F2837xD_Mcbsp.d \
./sources/F2837xD_PieCtrl.d \
./sources/F2837xD_PieVect.d \
./sources/F2837xD_Sci.d \
./sources/F2837xD_Spi.d \
./sources/F2837xD_SysCtrl.d \
./sources/F2837xD_TempSensorConv.d \
./sources/F2837xD_Upp.d \
./sources/F2837xD_can.d \
./sources/F2837xD_sci_io.d \
./sources/F2837xD_sdfm_drivers.d \
./sources/F2837xD_struct.d 

OBJS += \
./sources/F2837xD_Adc.obj \
./sources/F2837xD_CodeStartBranch.obj \
./sources/F2837xD_CpuTimers.obj \
./sources/F2837xD_DBGIER.obj \
./sources/F2837xD_DefaultISR.obj \
./sources/F2837xD_Dma.obj \
./sources/F2837xD_ECap.obj \
./sources/F2837xD_EPwm.obj \
./sources/F2837xD_EQep.obj \
./sources/F2837xD_Emif.obj \
./sources/F2837xD_GlobalVariableDefs.obj \
./sources/F2837xD_Gpio.obj \
./sources/F2837xD_I2C.obj \
./sources/F2837xD_Ipc.obj \
./sources/F2837xD_Ipc_Driver.obj \
./sources/F2837xD_Ipc_Driver_Lite.obj \
./sources/F2837xD_Ipc_Driver_Util.obj \
./sources/F2837xD_Mcbsp.obj \
./sources/F2837xD_PieCtrl.obj \
./sources/F2837xD_PieVect.obj \
./sources/F2837xD_Sci.obj \
./sources/F2837xD_Spi.obj \
./sources/F2837xD_SysCtrl.obj \
./sources/F2837xD_TempSensorConv.obj \
./sources/F2837xD_Upp.obj \
./sources/F2837xD_can.obj \
./sources/F2837xD_sci_io.obj \
./sources/F2837xD_sdfm_drivers.obj \
./sources/F2837xD_struct.obj \
./sources/F2837xD_usDelay.obj 

ASM_DEPS += \
./sources/F2837xD_CodeStartBranch.d \
./sources/F2837xD_DBGIER.d \
./sources/F2837xD_usDelay.d 

OBJS__QUOTED += \
"sources\F2837xD_Adc.obj" \
"sources\F2837xD_CodeStartBranch.obj" \
"sources\F2837xD_CpuTimers.obj" \
"sources\F2837xD_DBGIER.obj" \
"sources\F2837xD_DefaultISR.obj" \
"sources\F2837xD_Dma.obj" \
"sources\F2837xD_ECap.obj" \
"sources\F2837xD_EPwm.obj" \
"sources\F2837xD_EQep.obj" \
"sources\F2837xD_Emif.obj" \
"sources\F2837xD_GlobalVariableDefs.obj" \
"sources\F2837xD_Gpio.obj" \
"sources\F2837xD_I2C.obj" \
"sources\F2837xD_Ipc.obj" \
"sources\F2837xD_Ipc_Driver.obj" \
"sources\F2837xD_Ipc_Driver_Lite.obj" \
"sources\F2837xD_Ipc_Driver_Util.obj" \
"sources\F2837xD_Mcbsp.obj" \
"sources\F2837xD_PieCtrl.obj" \
"sources\F2837xD_PieVect.obj" \
"sources\F2837xD_Sci.obj" \
"sources\F2837xD_Spi.obj" \
"sources\F2837xD_SysCtrl.obj" \
"sources\F2837xD_TempSensorConv.obj" \
"sources\F2837xD_Upp.obj" \
"sources\F2837xD_can.obj" \
"sources\F2837xD_sci_io.obj" \
"sources\F2837xD_sdfm_drivers.obj" \
"sources\F2837xD_struct.obj" \
"sources\F2837xD_usDelay.obj" 

C_DEPS__QUOTED += \
"sources\F2837xD_Adc.d" \
"sources\F2837xD_CpuTimers.d" \
"sources\F2837xD_DefaultISR.d" \
"sources\F2837xD_Dma.d" \
"sources\F2837xD_ECap.d" \
"sources\F2837xD_EPwm.d" \
"sources\F2837xD_EQep.d" \
"sources\F2837xD_Emif.d" \
"sources\F2837xD_GlobalVariableDefs.d" \
"sources\F2837xD_Gpio.d" \
"sources\F2837xD_I2C.d" \
"sources\F2837xD_Ipc.d" \
"sources\F2837xD_Ipc_Driver.d" \
"sources\F2837xD_Ipc_Driver_Lite.d" \
"sources\F2837xD_Ipc_Driver_Util.d" \
"sources\F2837xD_Mcbsp.d" \
"sources\F2837xD_PieCtrl.d" \
"sources\F2837xD_PieVect.d" \
"sources\F2837xD_Sci.d" \
"sources\F2837xD_Spi.d" \
"sources\F2837xD_SysCtrl.d" \
"sources\F2837xD_TempSensorConv.d" \
"sources\F2837xD_Upp.d" \
"sources\F2837xD_can.d" \
"sources\F2837xD_sci_io.d" \
"sources\F2837xD_sdfm_drivers.d" \
"sources\F2837xD_struct.d" 

ASM_DEPS__QUOTED += \
"sources\F2837xD_CodeStartBranch.d" \
"sources\F2837xD_DBGIER.d" \
"sources\F2837xD_usDelay.d" 

C_SRCS__QUOTED += \
"../sources/F2837xD_Adc.c" \
"../sources/F2837xD_CpuTimers.c" \
"../sources/F2837xD_DefaultISR.c" \
"../sources/F2837xD_Dma.c" \
"../sources/F2837xD_ECap.c" \
"../sources/F2837xD_EPwm.c" \
"../sources/F2837xD_EQep.c" \
"../sources/F2837xD_Emif.c" \
"../sources/F2837xD_GlobalVariableDefs.c" \
"../sources/F2837xD_Gpio.c" \
"../sources/F2837xD_I2C.c" \
"../sources/F2837xD_Ipc.c" \
"../sources/F2837xD_Ipc_Driver.c" \
"../sources/F2837xD_Ipc_Driver_Lite.c" \
"../sources/F2837xD_Ipc_Driver_Util.c" \
"../sources/F2837xD_Mcbsp.c" \
"../sources/F2837xD_PieCtrl.c" \
"../sources/F2837xD_PieVect.c" \
"../sources/F2837xD_Sci.c" \
"../sources/F2837xD_Spi.c" \
"../sources/F2837xD_SysCtrl.c" \
"../sources/F2837xD_TempSensorConv.c" \
"../sources/F2837xD_Upp.c" \
"../sources/F2837xD_can.c" \
"../sources/F2837xD_sci_io.c" \
"../sources/F2837xD_sdfm_drivers.c" \
"../sources/F2837xD_struct.c" 

ASM_SRCS__QUOTED += \
"../sources/F2837xD_CodeStartBranch.asm" \
"../sources/F2837xD_DBGIER.asm" \
"../sources/F2837xD_usDelay.asm" 


