A patched binary to launch the rtsp service even if the camera is not able to connect to Tuya cloud.

The model I used is this one, but it may work with other Tuya-based cameras :
https://fr.aliexpress.com/item/1005006881775972.html?spm=a2g0o.order_list.order_list_main.5.99815e5bLxcscS&gatewayAdapt=glo2fra

The bash script allows to flash the camera without modifying the firmware permanently. I have not tried to do so, so feel free to open a pull request if you do.

How to :
- Configure the camera with the Tuya app so that it connects to your Wi-Fi
- Firewall the camera completely so that it cannot establish any connection
- Use the rtsp.sh script to use the custom binary (you will have to modify the TELNET_IP variable in the file)
- Access the stream through rtsp://<CAMERA_IP>:554/jkstream

Good luck :-)
