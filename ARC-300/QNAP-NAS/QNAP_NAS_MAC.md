# Qnap Mac Adress Change to 00:00:00:00:05:09 
This is random error. sometimes happens after FW update. 

If you found MAC address of NAS is changed to 00:00:00:00:05:09 (sometime NAS reports External Lan Card Changed), please use the following commands to repair the MAC address (replace the MAC address with the one written on the sticker behind your NAS).

You can fix it with this steps:

1 - [Connect to your NAS via SSH](https://www.qnap.com/en/how-to/faq/article/how-do-i-access-my-qnap-nas-using-ssh) (QNAP_NAS_SSH.md)
2 - Run the following commands:

> **Note:**  You can find the correct MAC address from the label on back of NAS.

#### For HAL NAS: (for Qnap 4.1.x and Up Firmware)  

    # hal_app –se_sys_set_mac obj_index=0,value=00:08:9B:12:34:56

> **Note:** obj_index is the LAN interface number, 0=LAN1, 1=LAN2, etc…

#### For Legacy NAS with single LAN interface: (For Qnap 4.0.x and lower versions)

    # set_mac 00:08:9b:12:34:56

#### For Legacy NAS with dual LAN interface:

    # iface_set_mac eth0 00:08:9b:12:34:56

    # iface_set_mac eth1 00:08:9b:12:34:57






source:
http://qnapsupport.net/qnap-mac-adress-lost-and-turn-to-00-00-00-00-05-09/




