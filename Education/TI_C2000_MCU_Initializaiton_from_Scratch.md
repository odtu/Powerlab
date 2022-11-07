<h1>
<div align="left">TI C2000 Launchpad Initialization<div align="right">
<sup><div dir="rtl"> METU PowerLab 2022</div></sup>
</div>

</h1>

TI C2000 MCU Initializaiton from Scratch

This document is prepeared to standartize our way of creating a new project on C2000 family microcontrollers. In acts as a guide to prepare for a new project on a TMS320F29379D Launchpad boards with a fresh install on windows. The software developement kit is specified as C2000Ware and its expansions such as MotorControl pack and DigitalPower pack with offline installation.

<!---<h2>
<sub><div dir="ttl">  </div></sub>
</h2>
-->


##  **Installing Code Composer Studio (CCS)**

https://www.ti.com/tool/CCSTUDIO

installation directory should be under = `C:\ti\`

(ie. C:\ti\ccs1210 for CCS version 12.1.0)

We recommend you to choose "full installation" to achieve full families.

https://www.ti.com/design-resources/embedded-development/c2000-real-time-mcus.html

## Installing C2000Ware SDK

https://www.ti.com/tool/C2000WARE#downloads

the main SDK

installation directory should be under =  `C:\ti\c2000`
```
C2000WARE-SDK
C2000WARE-MOTORCONTROL-SDK
C2000WARE-DIGITALPOWER-SDK
```
##

## Debug probe XDS100v2 FTDI
Connect your MCU using proprierty USB cable, open device manager.
Check if below is presented.
![DeviceManager](https://user-images.githubusercontent.com/38794995/198623917-52fd40d6-e136-4571-861e-2ab56c847a0f.png)

If it is not located under debug probes section, install [XDS100v2](https://software-dl.ti.com/ccs/esd/documents/xdsdebugprobes/emu_xds100.html) drivers.

## Creating Project
Start CCS IDE, starting with a workspace launcher window, locate your base folder.
![image](https://user-images.githubusercontent.com/38794995/198630203-72287d36-1abf-4177-8478-089147fe71af.png)

* Create new project (File>New>CCS Project)
* Select target according to your device.
![image](https://user-images.githubusercontent.com/38794995/198638663-a6ffc6f7-f406-49db-91c8-50c33e062e11.png)
* Verify connection as "Texas Instruments XDS100v2 USB Debug Probe".
  * working connection results in:
  ```
    -----[Perform the Integrity scan-test on the JTAG DR]------------------------

    This test will use blocks of 64 32-bit words.
    This test will be applied just once.

    Do a test using 0xFFFFFFFF.
    Scan tests: 1, skipped: 0, failed: 0
    Do a test using 0x00000000.
    Scan tests: 2, skipped: 0, failed: 0
    Do a test using 0xFE03E0E2.
    Scan tests: 3, skipped: 0, failed: 0
    Do a test using 0x01FC1F1D.
    Scan tests: 4, skipped: 0, failed: 0
    Do a test using 0x5533CCAA.
    Scan tests: 5, skipped: 0, failed: 0
    Do a test using 0xAACC3355.
    Scan tests: 6, skipped: 0, failed: 0
    All of the values were scanned correctly.

    The JTAG DR Integrity scan-test has succeeded.

    [End]
    ```
 * Click finish


## Including Source and Header Files
Now we need to import device specific files for the functions already written on the SDK.

* Move to `C:\ti\c2000\C2000Ware_4_02_00_00\device_support\f2837xd\common`
* "**Copy**" source folder into the project.
![image](https://user-images.githubusercontent.com/38794995/198679869-f7dfda16-52b8-4aeb-84e6-e1e4d1d8ba36.png)

* Move to `C:\ti\c2000\C2000Ware_4_02_00_00\device_support\f2837xd\headers\source`
*  "**Copy**" content into the same source folder.
![image](https://user-images.githubusercontent.com/38794995/198681000-e3e171fa-8b8f-411e-9a15-10dc578f29ba.png)

* Create a new directory in the project folder named "header_files"
* Move to `C:\ti\c2000\C2000Ware_4_02_00_00\device_support\f2837xd\common\include`
* "**Copy**" all content into "header_files"
![image](https://user-images.githubusercontent.com/38794995/198682829-69c235dc-ccc4-4dd7-96aa-5b18f9fd4632.png)

* Create a new directory in the project folder named "header_inc_files"
* Move to `C:\ti\c2000\C2000Ware_4_02_00_00\device_support\f2837xd\headers\include`
* "**Copy**" all content into "header_inc_files"
![image](https://user-images.githubusercontent.com/38794995/198683438-3e0941f2-e086-48ba-a454-62b6194096a9.png)

* Move to `C:\ti\c2000\C2000Ware_4_02_00_00\driverlib\f2837xd\driverlib`
* "**Copy**" all content into "header_files"
![image](https://user-images.githubusercontent.com/38794995/198713067-67310e97-d003-4c44-90bc-aeb3cae15f9e.png)


* Now we should include these header files for the compiler.
* in CCS, Project>Properties
* Include Options > Add... > Workspace and select the "header_files"
![image](https://user-images.githubusercontent.com/38794995/198685503-b64078d1-d99b-4216-b214-83972dfe5c7d.png)

* Include Options > Add... > Workspace and this time select the "header_inc_files"
* Should be as shown below
   ```
   ${PROJECT_ROOT}
   ${workspace_loc:/${ProjName}/header_files}
   ${workspace_loc:/${ProjName}/header_inc_files}
   ${CG_TOOL_ROOT}/include
   ```
* Apply and Close

## Include Flash Linker

* Move to `C:\ti\c2000\C2000Ware_4_02_00_00\device_support\f2837xd\common\cmd`
* "**Copy**" '2837xD_FLASH_lnk_cpu1.cmd'  into the project directory.

![image](https://user-images.githubusercontent.com/38794995/198693365-8b610b9c-c353-44d7-af46-695d2e578dc2.png)

A cmd file named '2837x_FLASH_lnk_cpu1.cmd' is also coming with project files. You should ensure that only one cmd file is included.
You can follow the instructions below:
* Select this '2837x_FLASH_lnk_cpu1.cmd'
* Right click and choose 'exclude from build'.

![image](https://user-images.githubusercontent.com/38794995/198694722-285d1069-2dfc-4f03-a53e-94069c1aebf9.png)

After that, you should add Bios adjustments.
* Move to `C:\ti\c2000\C2000Ware_4_02_00_00\device_support\f2837xd\headers\cmd`
* "**Copy**" 'F2837xD_Headers_nonBIOS_cpu1.cmd'  into the project directory.

![image](https://user-images.githubusercontent.com/38794995/198708417-1d2518cb-a348-439d-9239-e8f1c280a876.png)

## Pre-defined Symbols
Defined symbols are used in project to identify various settings and can be used with #ifdef, #endif.

* in CCS, Project>Properties
* in Predefined Symbols you can add various macros such as,
   ```
   CPU1
   CPU2
   _FLASH
   _LAUNCHXL_F28379D
   ```

![image](https://user-images.githubusercontent.com/38794995/198710203-0255e04e-16a3-4461-aed4-a38392208415.png)

## Extra Settings
Good to have
* Project>Properties>Build>C2000 Compiler> Optimization> Floating Point mode (--fp_mode) : relaxed
