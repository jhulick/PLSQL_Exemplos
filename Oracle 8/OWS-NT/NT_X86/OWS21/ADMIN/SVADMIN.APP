[Apps]
#
# APP   Object Path                                Entry Point  Min     Max
# ===   ===========                                ===========  ===     ===
OWA     %OWS21%\bin\owa.dll                         ndwoadinit  0       100
SSI     %OWS21%\bin\ssi.dll                         ndwussinit  0       100
JAVA    %OWS21%\bin\wrbjava.dll                       ojsdinit  0       100
HELLO   %OWS21%\sample\wrbsdk\helloworld.dll         testentry  0       100
MYAPP   %OWS21%\sample\wrbsdk\mywrbapp\mywrbapp.dll MyWRBApp_Entry 0 100

[AppDirs]
#
# Virtual Path          APP     Physical Path
# ============          ===     =============
/ssi                    SSI     %OWS21%\sample\ssi
/hr/owa                 OWA     %OWS21%\bin
/tr/owa                 OWA     %OWS21%\bin
/owa_dba/owa            OWA     %OWS21%\bin
/java                   JAVA    %OWS21%\java
/sample/wrbsdk/hello    HELLO   %OWS21%
/sample/ssi             SSI     %OWS21%\sample\ssi
/sample/java/run        JAVA    %OWS21%\sample\java
/mywrbapp/bin           MYAPP   %OWS21%

[AppProtection]
/owa_dba/owa/*            Basic (Admin Server)
/hr/owa/*              Basic (Admin Server)
/tr/owa/*              Basic (Admin Server)
/ssi/*				  Basic (Admin Server)
/java/*				  Basic (Admin Server)
/sample/wrbsdk/hello/*		 Basic (Admin Server)
/sample/ssi/*		 Basic (Admin Server)
/sample/java/run/*	 Basic (Admin Server)
/mywrbapp/bin/*		 Basic (Admin Server)

[OWA]
Protect_OWA_Pkg = TRUE
[SSI]
EnableLiveHTML     = TRUE
ParseHTMLExtn      = FALSE
EnableExecTag      = TRUE
ExtensionList      = html shtml lhtml

[JAVA]
CLASSPATH          = %OWS21%\java\classes.zip;%OWS21%\java\oracle.zip;%OWS21%\sample\java
LD_LIBRARY_PATH    = %OWS21%\bin;%OWS21%\lib

[MYAPP]
state              = CA
tax                = 8.25

