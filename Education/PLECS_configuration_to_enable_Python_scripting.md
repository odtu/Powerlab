# PLECS configuration to enable Python scripting

## <div align="right"> <sup><div dir="rtl"> METU PowerLab 2024</div></sup> </div>

PLECS configuration that is necessary to connect Python to PLECS which enables usage of custom Python scripts to control any simulation.

This guide assumes PLECS is downloaded and ready to use. Download link is provided below, but there is a need for a valid license. Also this guide is provided for PLECS 4.7.7, there may be minor differences between versions; some known version differences will be stated in this document.

PLECS download link:
https://www.plexim.com/download

#
Jupyter Notebook is particularly useful for this task, as it allows partial execution of the code snippets (similar to MATLAB's Run Section command). Download link is given below, one can also find it via search in Visual Studio Code. This guide will be using Jupyter scripts (.ipynb) rather than Python ones (.py), though the syntax is identical.

Jupyter Notebook download link:
https://jupyter.org
#
## Step #1

Open PLECS, from Library Browser screen go to File -> PLECS Preferences

![image](https://github.com/user-attachments/assets/ad8cca4f-7b5b-48e8-9c09-519a0a67ec47)

## Step #2

Select "Enable" next to "RPC Interface:", "port:" value default is 1080; if this is not the case enter 1080.
![image](https://github.com/user-attachments/assets/011d5213-63e4-42b0-906d-e07120012510)

## Step #3

The way the PLECS enables scripting is actually through a local server hosting. Therefore, there may be a requirement to allow a permission of the app through the network firewall. 

Go to Windows search and search for "Firewall & network protection" (Both Windows 10 & 11)

![image](https://github.com/user-attachments/assets/6aa8b427-2dfb-4e66-bdad-16217f021bab)

## Step #4

Click on "Allow an app through firewall"

![image](https://github.com/user-attachments/assets/218d8997-25c8-47b6-b93b-5c93c18543ef)

## Step #5

Click on "Change Settings" and then "Allow another app..."

![image](https://github.com/user-attachments/assets/5359c644-07b2-4773-864c-98a874dbedcb)

## Step #6

Click on "Browse..."

Go to PLECS installation directory (can be found from Windows Search -> PLECS -> right click -> Open File Location (again if shortcut is found)), then select "PLECS_server.exe", finally select "Open".

After the pop-up screen closes, click on "Add".

![image](https://github.com/user-attachments/assets/56b885ed-74cc-490d-a2fb-27206940ab56)

![image](https://github.com/user-attachments/assets/cd7b0039-fbe0-47f6-aa25-c099d209e659)

## Step #7

"PLECS_server.exe" will be added to the exception list. Check all the boxes to give firewall permissions.

![image](https://github.com/user-attachments/assets/8039af73-fb56-4ef6-a90b-52a728bb3a07)

## Step #8

Open a new Jupyter Notebook file (.ipynb) and enter the following lines of code in a new cell.

import xmlrpc.client as xml

import os

os.chdir('**Enter your simulation file directory**')

plecs = xml.ServerProxy("http://localhost:1080").plecs

![image](https://github.com/user-attachments/assets/75dcce81-97e8-4337-b09c-3919da5594ae)

Check mark indicates successful connection.

### Version difference

In different versions the line "plecs = xml.ServerProxy("http://localhost:1080").plecs" may differ. If there is an error, check PLECS Documentation which can be found inside PLECS.

PLECS -> Window -> Demo Models -> PLECS 4.x Documentation -> RPC Interface in PLECS Standalone

Check whether the lines of code is different in your version and edit your code accordingly.

![image](https://github.com/user-attachments/assets/fe07c56f-5598-4cfd-9a64-33337a7beaf0)

## Step #9

In PLECS Documentation,

PLECS -> Window -> Demo Models -> PLECS 4.x Documentation -> RPC Interface in PLECS Standalone

The commands that are available to control simulation and/or simulation parameters can be found. Refer to that document for scripting help; PLECS provides little to no access to the simulation file itself, though. There are only a handful of functions provided by the company to alter the simulation or the component parameters. Interestingly, .plecs files are not encrypted and can be opened as .txt files. Further simulation changes apart from the provided commands can be done by text editing, such as changing components.

Good luck.
