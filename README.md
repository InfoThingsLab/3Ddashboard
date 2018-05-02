# 3Ddashboard
3D dashboard for STM32 IOT node board


1. Install Processing.  
  https://processing.org/download/
2. Install L3D lib 
  https://github.com/enjrolas/L3D-Library
3. Install UDP lib by Procesing "Import library"
4. Install cutecom for sensor board setting.
  sudo apt-get update
  sudo apt-get install cutecom
  
  Serial port errors 'Permission denied'
  user@ubuntu:~$ id -Gn
  user adm cdrom sudo dip plugdev lpadmin sambashare
  user@ubuntu:~$ sudo adduser user dialout
  [sudo] password for user:
  Adding user `user' to group `dialout' ...
  Adding user user to group dialout
  Done. 
  
