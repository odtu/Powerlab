# METU POWER LAB

# Programming & Debugging Custom C2000 MCU Device Using On-board Debugger of a Texas Launchpad (Launchxl-F280049C)

## Prepared By:
### Kaan DEMİRKOPARAN - Undergraduate Researcher at METU POWERLAB

---

## Table Of Contents

1. Preparation of Hardware
2. Preparation of Software

---

## 1) PREPARATION OF HARDWARE: 

- You should remove the 4 jumpers from the launchpad (indicated by a blue rectangle in the original file).
- Ensure that the 3 jumpers at the USB side remain (indicated by a green rectangle in the original file).
<img width="268" height="343" alt="image" src="https://github.com/user-attachments/assets/5f361576-1f20-4dda-a07a-a56058a494ef" />

- Connections for TMS, TCK, and GND must be made between the launchpad and the custom board.
<img width="567" height="268" alt="image" src="https://github.com/user-attachments/assets/501d25a3-ae88-4aad-8827-d0d7b60d663d" />
<img width="219" height="325" alt="image" src="https://github.com/user-attachments/assets/7cf5712c-2fec-4bab-97ce-a96d449efeaf" />

- Supply power to your custom board.
- Connect the USB connection of the launchpad to your PC.

---

## 2) PREPARATION OF SOFTWARE:

### Installation and Setup

- Download the Code Composer Studio (CCS) IDE from `https://www.ti.com/tool/CCSTUDIO`.
- Run the `ccs_setup.exe` file and install the application by following the standard setup procedure.
<img width="80%" alt="image" src="https://github.com/user-attachments/assets/e3c88cec-adbd-4360-bcf6-3d8569172c4f" />

- When you reach the "Select Components" window, check only the "C2000 real-time microcontrollers" option and continue the installation.
<img width="80%" alt="image" src="https://github.com/user-attachments/assets/9ff9a700-b58a-4149-9f5e-c73227a677e6" />

### Importing and Configuring the Project

- Run the CCS IDE.

<img width="80%" alt="image" src="https://github.com/user-attachments/assets/0c4091b9-a56b-44bf-987a-5fe6cc49a040" />

- Import a new project by clicking the "Import Project" button.

<img width="80%" alt="image" src="https://github.com/user-attachments/assets/8e4fff2b-71ac-4f56-8e56-144401dd0df4" />

- Click the "Browse" button and navigate to the `C:\ti\c2000\C2000Ware_5_04_00_00\training\device\f28004x\getting_started` directory.
- Select the `syscfg_lp_f28004x` project. Note: This specific path is for the TMS320F280049 device; if your custom board uses a different device, select your corresponding device folder.

<img width="80%" alt="image" src="https://github.com/user-attachments/assets/2f55a931-814b-4a57-b47e-47388174aaf5" />

<img width="80%" alt="image" src="https://github.com/user-attachments/assets/70babc2f-ccd3-4e0c-8afd-a05678f30ff0" />

- After the project imports, double-click the `lab_blinkyled_launchpad.syscfg` file, then select your specific device from the popup menu.

<img width="80%" alt="image" src="https://github.com/user-attachments/assets/38d5c4a3-d791-400a-8aa5-5d8c69be5f0e" />

### Testing the Connection

- To test the JTAG communication, double-click the `TMS320F280049C_LaunchPad.ccxml` file.

<img width="80%" alt="image" src="https://github.com/user-attachments/assets/149b6059-9f28-4bc9-ac18-7b3e8380f1bb" />

- Click the "Advanced" button, followed by the "Test Connection" button.

<img width="80%" alt="image" src="https://github.com/user-attachments/assets/7ade2d21-fd40-4e83-8f72-c9f1288dd688" />

- After the test has been completed, it should be seen as follows:

<img width="80%" alt="image" src="https://github.com/user-attachments/assets/c9626900-2d04-4dbf-9854-8dbfe729b367" />

### Uploading the Test Code (LED Blink)

- Once you've verified the connection, you can proceed to upload the first test code, which is an LED blink code.
- Double-click the `lab_blinkyled_launchpad.syscfg` file.
- From the GPIO menu under PinMux, select the appropriate GPIO pin that your LED is connected to on your custom board.
- If a suitable GPIO isn't in the default list, add a new one and name it `myBoardLEDO_GPIO` or `myBoardLED1_GPIO`.
- Assign your specific pin number to that GPIO under the PinMux settings.
<img width="80%" alt="image" src="https://github.com/user-attachments/assets/ead35271-a09b-452f-aa7e-2156a15f0f7a" />

- Save the sysconfig file and close it.
- In the file explorer, right-click your imported project and click "Debug" as shown below:
<img width="80%" alt="image" src="https://github.com/user-attachments/assets/ed9657ed-2425-4637-9b34-bdd4f6bd1cd5" />

- After the debug session launches, click the "Continue" button as shown below:
<img width="80%" alt="image" src="https://github.com/user-attachments/assets/25ab65d8-c5b5-482f-ae38-fffdda973021" />

- Your first code is now successfully uploaded, and your LED should start blinking!

---
