#include <F2837xD_Device.h>
#include <F2837xD_Examples.h>
#include <string.h>
#include <math.h>
#include "MultipleFloatDataSender.h"

__interrupt void cpu_timer0_isr(void);  /*prototype of the ISR functions*/
__interrupt void cpu_timer1_isr(void);  /*prototype of the ISR functions*/
__interrupt void cpu_timer2_isr(void);  /*prototype of the ISR functions*/





/**
 * main.c
 */

float fSynchronousData = 5.0;
unsigned char SendData = 0;
float fFloatToBeSent[6] = {2,2,2,2,2,2};
#define SENDFREQ 2500
#define PI 3.14159

int main(void)
{

    InitSysCtrl();  /*initialize the peripheral clocks*/

    EALLOW;
    ClkCfgRegs.PERCLKDIVSEL.bit.EPWMCLKDIV = 0; // EPWM Clock Divide Select: /1 of PLLSYSCLK
    EDIS;

    InitPieCtrl();  /*initialize the PIE table (interrupt related)*/
    IER = 0x0000;   /*clear the Interrupt Enable Register   (IER)*/
    IFR = 0x0000;   /*clear the Interrupt Flag Register     (IFR)*/
    InitPieVectTable();

    EALLOW;
    CpuSysRegs.PCLKCR0.bit.TBCLKSYNC = 0;   /*stop the TimeBase clock for later synchronization*/
    CpuSysRegs.PCLKCR0.bit.GTBCLKSYNC = 0;  /*stop the global TimeBase clock for later synchronization*/
    EDIS;

    /*Initialize cpu timers*/
    InitCpuTimers();
    ConfigCpuTimer(&CpuTimer0, 200, 28*1000000/512); //1 seconds
    ConfigCpuTimer(&CpuTimer1, 200, 1000000/SENDFREQ); //2.5khz
    ConfigCpuTimer(&CpuTimer2, 200, 1000000); //1 seconds
    CpuTimer0Regs.TCR.all = 0x4000; // enable cpu timer interrupt
    CpuTimer1Regs.TCR.all = 0x4000; // enable cpu timer interrupt
    CpuTimer2Regs.TCR.all = 0x4000; // enable cpu timer interrupt



    EALLOW;
    PieVectTable.TIMER0_INT = &cpu_timer0_isr;  /*specify the interrupt service routine (ISR) address to the PIE table*/
    PieVectTable.TIMER1_INT = &cpu_timer1_isr;  /*specify the interrupt service routine (ISR) address to the PIE table*/
    PieVectTable.TIMER2_INT = &cpu_timer2_isr;  /*specify the interrupt service routine (ISR) address to the PIE table*/
    EDIS;
    IER |= M_INT1;  /*Enable the PIE group of Cpu timer 0 interrupt*/
    IER |= M_INT13; /*Enable the PIE group of Cpu timer 1 interrupt*/
    IER |= M_INT14; /*Enable the PIE group of Cpu timer 2 interrupt*/
    PieCtrlRegs.PIECTRL.bit.ENPIE = 1;  // Enable the PIE block
    PieCtrlRegs.PIEIER1.bit.INTx7 = 1;  /*Enable the 7th interrupt of the Group 1, which is for timer 0 interrupt*/

    EALLOW;
    CpuSysRegs.PCLKCR0.bit.TBCLKSYNC = 1;   /*start the TimeBase clock */
    CpuSysRegs.PCLKCR0.bit.GTBCLKSYNC = 1;  /*start the global TimeBase clock */
    EDIS;

    EINT;  // Enable Global interrupt INTM
    ERTM;  // Enable Global realtime interrupt DBGM


    EALLOW;
    GpioCtrlRegs.GPBGMUX1.bit.GPIO42 = 3;
    GpioCtrlRegs.GPBMUX1.bit.GPIO42 = 3;
    GpioCtrlRegs.GPBGMUX1.bit.GPIO43 = 3;
    GpioCtrlRegs.GPBMUX1.bit.GPIO43 = 3;
    EDIS;
    InitializeSciaRegisters(921600.0);
    while(1)
    {
        DELAY_US(1000);
        SciaBackgroundTask();

    }
    return 0;
}
__interrupt void cpu_timer0_isr(void)
{
    CpuTimer0.InterruptCount++;
    PieCtrlRegs.PIEACK.all = PIEACK_GROUP1;

}

__interrupt void cpu_timer1_isr(void)
{
    CpuTimer1.InterruptCount++;
#if 1
    fFloatToBeSent[0] = cos(2.0*PI*50.0*((float )CpuTimer1.InterruptCount)/2500.0);
    fFloatToBeSent[1] = cos(2.0*PI*60.0*((float )CpuTimer1.InterruptCount)/2500.0);
    fFloatToBeSent[2] = cos(2.0*PI*70.0*((float )CpuTimer1.InterruptCount)/2500.0);
    fFloatToBeSent[3] = cos(2.0*PI*80.0*((float )CpuTimer1.InterruptCount)/2500.0);
    fFloatToBeSent[4] = cos(2.0*PI*90.0*((float )CpuTimer1.InterruptCount)/2500.0);
    fFloatToBeSent[5] = cos(2.0*PI*100.0*((float )CpuTimer1.InterruptCount)/2500.0);
#endif
    SciSendMultipleFloatWithTheTag(fFloatToBeSent,6);
    if(CpuTimer1.InterruptCount == 2500)
    {
        CpuTimer1.InterruptCount = 0;
    }
    PieCtrlRegs.PIEACK.all = PIEACK_GROUP1;
}

__interrupt void cpu_timer2_isr(void)
{

    CpuTimer2.InterruptCount++;

}


