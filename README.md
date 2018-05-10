# 3Ddashboard
3D dashboard for STM32 IOT node board

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


## Sensor Board Setting
1. Install cutecom for sensor board setting.

   sudo apt-get update  
   sudo apt-get install cutecom  

   if "Serial port errors 'Permission denied' ", solution:   
   id -Gn  
   sudo adduser user dialout  

  
