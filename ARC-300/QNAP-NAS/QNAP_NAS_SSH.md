# Accessing QNAP NAS Using SSH
This guide provides steps to access your QNAP NAS via SSH.

## Introduction
This document provides a step-by-step guide to accessing your QNAP NAS using SSH.

## Steps

### 1. Enable SSH on Your NAS

#### Using QTS Web Interface:
1. Log in to your NAS with an administrator account. For details, see [What is the default system administrator password for my NAS?](https://www.qnap.com/en/how-to/faq/article/what-is-the-default-system-administrator-password-for-my-nas)
2. Open the `Control Panel.`
3. Go to `Network & File Services` > `Telnet / SSH`.
4. Select `Allow SSH connection`.
5. Click `Apply`.


#### Using Qfinder Pro:
1. Download and install Qfinder Pro on your PC.
2. Open [Qfinder Pro](https://www.qnap.com/en/software/qfinder-pro), which automatically searches and displays all QNAP devices on the same network.
> Tip: Make sure that your NAS is on the same network as your computer.
3. Locate your NAS on the list, click on it, and go to `Settings` > `Connect via SSH`.
4. Log in with an administrator account. For details, see [What is the default system administrator password for my NAS?](https://www.qnap.com/en/how-to/faq/article/what-is-the-default-system-administrator-password-for-my-nas)
5. Enable `Allow SSH connections` and click `Apply`.

### 2. Access Your NAS via SSH
Access your NAS depending on your computer's operating system:

#### For Windows:
1. Download and install [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html).
2. Open `PuTTY` and configure an SSH connection:
   - **Host Name (or IP address):** Your NAS IP address.
   - **Connection type:** SSH.
3. Click `Open` and log in with your NAS user credentials.

#### For macOS/Linux:
1. Open Terminal.
2. Enter the command:
   ```sh
   ssh username@YOUR_NAS_IP_ADDRESS