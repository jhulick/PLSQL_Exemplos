Patch release Oracle WebServer 2.1.0.3.2 on NT
--------------------------------------------------
Installation
------------
1. Stop all Oracle Web Listeners and all other listeners connected to the Oracle WRB.
2. Run the patch.exe program found in this directory.
   This will have the following effect - 
   i. create an original directory under ORACLE_HOME\OWS21\bin and ORACLE_HOME\OWS21\admin
   ii. Copy the original files over to the original directories.
   iii. Replace the existing executables/config files in the respective directories.

Configuration file changes
--------------------------
Please make the following changes to your sv<listener>.APP files (Bug#474557) - 

In the APP section change the name of the JAVA cartridge (wrbjava.dll) to javai.dll.
Your APP section will now look like this ...

[Apps]
#
# APP   Object Path                                Entry Point  Min     Max
# ===   ===========                                ===========  ===     ===
OWA     C:\ORANT\OWS21\bin\owa.dll                         ndwoadinit  0       100
SSI     C:\ORANT\OWS21\bin\ssi.dll                         ndwussinit  0       100
JAVA    C:\ORANT\OWS21\bin\javai.dll                         ojsdinit  0       100
HELLO   C:\ORANT\OWS21\sample\wrbsdk\helloworld.dll         testentry  0       100
MYAPP   C:\ORANT\OWS21\sample\wrbsdk\mywrbapp\mywrbapp.dll MyWRBApp_Entry 0 100

Bugs fixed
----------
The following bugs have been fixed in this post release patch.
464113 - T model with Netscape/IIS listeners fixed.
465466 - Network Errors cleanup WRB processes when using a Spylass listener.
465470 - Network Errors cleanup WRB processes when using Netscape listeners.
465501 - Network Errors cleanup WRB processes when using IIS listener.
464777 - Memory leak in ISAPI adapter fixed.
460067 - Dispatcher is no longer case sensitive.
474557 - Java native dll's (including net.dll) added.
