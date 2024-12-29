/*
 * MultipleFloatDataSender.h
 *
 *  Created on: 23 Tem 2020
 *      Author: hakansrc
 */

#ifndef MULTIPLEFLOATDATASENDER_H_
#define MULTIPLEFLOATDATASENDER_H_


int SciaUartSend_NoInterrupt(char *BuffWriteArray, unsigned int lengthOfData);
int SciSendMultipleFloatWithTheTag(float *FloatArrayToBeSent, uint16_t ui16NumberOfFloats);
void SciaBackgroundTask(void);
void InitializeSciaRegisters(float fSciBaudRate);
#endif /* MULTIPLEFLOATDATASENDER_H_ */
