[Apps]
#
# APP   Object Path                                Entry Point  Min     Max
# ===   ===========                                ===========  ===     ===
OWA     %OWS21%\bin\owa.dll                         ndwoadinit  0       100
SSI     %OWS21%\bin\ssi.dll                         ndwussinit  0       100
JAVA    %OWS21%\bin\wrbjava.dll                       ojsdinit  0       100
HELLO   %OWS21%\sample\wrbsdk\helloworld.dll         testentry  0       100
MYAPP   %OWS21%\sample\wrbsdk\mywrbapp\mywrbapp.dll MyWRBApp_Entry 0    100

[AppDirs]
#
# Virtual Path          APP     Physical Path
# ============          ===     =============
/ssi                    SSI     %OWS21%\sample\ssi
/hr/owa                 OWA     %OWS21%\bin
/tr/owa                 OWA     %OWS21%\bin
/java                   JAVA    %OWS21%\java
/sample/wrbsdk/hello    HELLO   %OWS21%
/sample/ssi             SSI     %OWS21%\sample\ssi
/sample/java/run        JAVA    %OWS21%\sample\java
/mywrbapp/bin           MYAPP   %OWS21%\ows21

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
MaxRequests        = 1000

[MYAPP]
state              = CA
tax                = 8.25
