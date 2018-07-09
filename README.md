# 3Ddashboard
3D dashboard for STM32 IOT node board

# Gateway
## Processing Setting
1. Install Processing.  
  https://processing.org/download/
2. Install L3D lib  
  https://github.com/enjrolas/L3D-Library
3. Install UDP lib by Procesing "Import library"
4. nano ~/.bash_profile

   add:     export PATH="${PATH}:~/Desktop/processing-3.3.7"

## Node and Firebase Setting
1. sudo apt-get install -y nodejs  
2. sudo apt install npm   
3. npm install --save firebase  


# Sensor Board Setting  
1. Hw    
   https://www.st.com/en/evaluation-tools/b-l475e-iot01a.html   
2. Sw:  B-L475E-IOT01.bin    
   It is based on X-CUBE-AWS. Instead of sending sensor JSON data by MQTT, it sends sensor data by UDP multicast (Port: 3333, "224.0.0.1").    
   The user push-button (blue) is used to configure the WiFi credentials. This can be done from the time that the board starts up and up to 3 seconds after that.    
   https://www.st.com/en/embedded-software/x-cube-aws.html    
   
3. Install cutecom for sensor board setting.

   sudo apt-get update  
   sudo apt-get install cutecom  

   if "Serial port errors 'Permission denied' ", solution:   
   id -Gn  
   sudo adduser user dialout  
4.  The serial port is to be configured with: COM port number, 115200 baud rate, 8-bit data,
parity none, 1 stop bit and no flow control.  The virtual terminal new-line transmit configuration must be set to LineFeed (\n or LF) in order to allow the copy-paste from the UNIX type text files. The “Local echo” option makes copy-paste visible on the console   

5.  Ref  
   https://www.st.com/content/ccc/resource/technical/document/user_manual/group0/9b/f5/d4/e1/17/3f/4d/fa/DM00367435/files/DM00367435.pdf/jcr:content/translations/en.DM00367435.pdf
  
# 3D Cube Setting
1. Photon-datasheet  
   https://docs.particle.io/datasheets/photon-(wifi)/photon-datasheet/ 
2. Getting started  
   https://docs.particle.io/guide/getting-started/intro/photon/ 
3. Stream app  
   https://github.com/enjrolas/L3D-Software/blob/master/Streaming/Listener/Listener.ino 
  
4. Reference   
   https://www.kickstarter.com/projects/lookingglass/l3d-cube-the-3d-led-cube-from-the-future   
   Cube firmware:  https://github.com/enjrolas/L3D-Software   
   Cube hardware:  https://github.com/enjrolas/L3D-Hardware   
   Processing library:  https://github.com/enjrolas/L3D-library   

# Voice User Interface  
1. Hw  
   https://www.st.com/content/st_com/en/products/evaluation-tools/product-evaluation-tools/mcu-eval-tools/stm32-mcu-eval-tools/stm32-mcu-discovery-kits/32f769idiscovery.html   
2. Sw   
   https://www.st.com/en/embedded-software/x-cube-vs4a.html  
   
