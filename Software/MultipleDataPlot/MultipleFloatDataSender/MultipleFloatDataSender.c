
#include <stdint.h>
#include "MultipleFloatDataSender.h"
#include <F2837xD_Device.h>
#include <F2837xD_Examples.h>
#include <math.h>


#define MFDS_LIB_CPU_FREQ   200e6
#define MFDS_THETAG              "hsrc"
#define MFDS_THETAGBYTESIZE      4
#define MFDS_SCILIBBUFFERLENGTH      256
#define MFDS_SCIARXBUFFERSIZE        64
#define MFDS_MULTIPLEFLOATARRAYSIZE (24+MFDS_THETAGBYTESIZE)

unsigned char ucSciaRxBuffer[MFDS_SCIARXBUFFERSIZE];
unsigned int uiSciaRxBufferIndex = 0;
char cSciaLibDataBuffer[MFDS_SCILIBBUFFERLENGTH];
unsigned int uiSciaLibReadFromBufferIndex = 0;
unsigned int uiSciaLibWriteToBufferIndex=0;
unsigned char ucSciaRxBuffer[MFDS_SCIARXBUFFERSIZE];
unsigned int uiSciaLibBufferNumberOfMessages=0;



#define MFDS_MULTIPLEFLOATARRAYSIZE (24+MFDS_THETAGBYTESIZE)
char cSendMultipleFloatArray[MFDS_MULTIPLEFLOATARRAYSIZE];
char cSendMultipleFloatArray[MFDS_MULTIPLEFLOATARRAYSIZE];


int SciSendMultipleFloatWithTheTag(float *FloatArrayToBeSent, uint16_t ui16NumberOfFloats)
{
    int16_t theIndex=0;

    for(theIndex=MFDS_THETAGBYTESIZE;theIndex<((ui16NumberOfFloats)*4+MFDS_THETAGBYTESIZE);theIndex++)
    {
        cSendMultipleFloatArray[theIndex] = __byte((int *) FloatArrayToBeSent,theIndex-MFDS_THETAGBYTESIZE);
    }
    memcpy(cSendMultipleFloatArray, MFDS_THETAG, MFDS_THETAGBYTESIZE);
    return SciaUartSend_NoInterrupt(cSendMultipleFloatArray, ((ui16NumberOfFloats)*4+MFDS_THETAGBYTESIZE));
}


int SciaUartSend_NoInterrupt(char *BuffWriteArray, unsigned int lengthOfData)
{
    if ((uiSciaLibBufferNumberOfMessages + lengthOfData) > MFDS_SCILIBBUFFERLENGTH)
    {
        /*because the buffer is full, try again later*/
        return -1;
    }
    if ((uiSciaLibWriteToBufferIndex + lengthOfData) < MFDS_SCILIBBUFFERLENGTH)
    {
        /*if rollover won't happen, just copy inside the buffer*/
        memcpy(&cSciaLibDataBuffer[uiSciaLibWriteToBufferIndex], BuffWriteArray,
               lengthOfData);
        uiSciaLibWriteToBufferIndex += lengthOfData;
        uiSciaLibBufferNumberOfMessages += lengthOfData;
    }
    else
    {
        /*if rollover happens, deal with it nicely*/
        /*first copy the first part*/
        memcpy(&cSciaLibDataBuffer[uiSciaLibWriteToBufferIndex], BuffWriteArray,
               (MFDS_SCILIBBUFFERLENGTH - uiSciaLibWriteToBufferIndex));
        /*then copy the second part*/
        memcpy(&cSciaLibDataBuffer[0],
               BuffWriteArray
                       + (MFDS_SCILIBBUFFERLENGTH - uiSciaLibWriteToBufferIndex),
               lengthOfData
                       - (MFDS_SCILIBBUFFERLENGTH - uiSciaLibWriteToBufferIndex));
        uiSciaLibBufferNumberOfMessages += lengthOfData;
        uiSciaLibWriteToBufferIndex = lengthOfData
                - (MFDS_SCILIBBUFFERLENGTH - uiSciaLibWriteToBufferIndex);
    }
    return lengthOfData;
}

void InitializeSciaRegisters(float fSciBaudRate)
{
    float lspclkdivider = 0;
    float lspclkfreq = 0;



#define SCI_FREQ        fSciBaudRate
#define SCI_PRD         (((float)lspclkdivider)/(SCI_FREQ*8))-1

    switch(ClkCfgRegs.LOSPCP.bit.LSPCLKDIV)
    {
        case 0:
            lspclkdivider = 1;
        case 1:
            lspclkdivider = 2;
        case 2:
            lspclkdivider = 4;
        case 3:
            lspclkdivider = 6;
        case 4:
            lspclkdivider = 8;
        case 5:
            lspclkdivider = 10;
        case 6:
            lspclkdivider = 12;
        case 7:
            lspclkdivider = 14;
        default:
            lspclkdivider = 4;
    }
    lspclkfreq = ((float)MFDS_LIB_CPU_FREQ)/lspclkdivider;

   SciaRegs.SCICCR.all = 0x0007;      // 1 stop bit,  No loopback
                                      // No parity,8 char bits,
                                      // async mode, idle-line protocol
   SciaRegs.SCICTL1.all = 0x0003;     // enable TX, RX, internal SCICLK,
                                      // Disable RX ERR, SLEEP, TXWAKE
   SciaRegs.SCICTL2.bit.TXINTENA = 0;
   SciaRegs.SCICTL2.bit.RXBKINTENA = 0;
   SciaRegs.SCIHBAUD.all = 0x0000;
   SciaRegs.SCILBAUD.all = round((((float)lspclkfreq)/(fSciBaudRate*8.0))-1);
   SciaRegs.SCICCR.bit.LOOPBKENA = 0; // Enable loop back
   SciaRegs.SCIFFTX.all = 0xC022;
   SciaRegs.SCIFFRX.all = 0x0022;
   SciaRegs.SCIFFCT.all = 0x00;

   SciaRegs.SCICTL1.all = 0x0023;     // Relinquish SCI from Reset
   SciaRegs.SCIFFTX.bit.TXFIFORESET = 1;
   SciaRegs.SCIFFRX.bit.RXFIFORESET = 1;
}
void SciaBackgroundTask(void)
{
    while ((uiSciaLibBufferNumberOfMessages > 0))
    {
        while(SciaRegs.SCIFFTX.bit.TXFFST != 16)
        {
            SciaRegs.SCITXBUF.all =
                    cSciaLibDataBuffer[uiSciaLibReadFromBufferIndex];
            uiSciaLibReadFromBufferIndex++;
            if (uiSciaLibReadFromBufferIndex == MFDS_SCILIBBUFFERLENGTH)
            {
                uiSciaLibReadFromBufferIndex = 0;
            }
            uiSciaLibBufferNumberOfMessages--;
            if(uiSciaLibBufferNumberOfMessages==0)
            {
                break;
            }
        }

    }
}
