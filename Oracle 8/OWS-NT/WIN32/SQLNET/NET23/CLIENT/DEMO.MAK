#=================================================
# Windows NT tftp sample makefile
#
#=================================================
DEBUG = YES
#DEBUG = PROFILE

# You have to change this to be the Oracle home directory (\orant)
ORACLE_HOME	= d:\orant

TNSINCLUDE	= $(ORACLE_HOME)\network\include

CDEBIG		=
LDEBUG		=
!if "$(DEBUG)" == "YES"
CDEBUG		= -Z7 -Od
LDEBUG		= -debug:full -debugtype:cv -pdb:none
!endif
!if "$(DEBUG)" == "PROFILE"
CDEBUG		= -Gh -Zd
LDEBUG		= -debug:partial -debugtype:coff
!endif

CCOMMON	= -c -W0 -DCRTAPI1=_cdecl -DCRTAPI2=_cdecl -nologo -D_X86_=1
CFLAGS		= $(CCOMMON) -DWIN32 -D_WIN32 -I$(TNSINCLUDE) $(CDEBUG)
CLIENT		= $(CFLAGS) /DCLIENT
SERVER		= $(CFLAGS) /DSERVER
CC		= cl

LCOMMON		= /INCREMENTAL:NO /RELEASE /NOLOGO /NODEFAULTLIB
DLLENTRY	= @12
EXEFLAGS	= -subsystem:console -entry:mainCRTStartup
LFLAGS		= $(LCOMMON) -align:0x1000 $(EXEFLAGS) $(LDEBUG)

LIBTNSAPI	= $(ORACLE_HOME)\network\lib\tnsapi.lib
BASELIBS	= libc.lib oldnames.lib kernel32.lib advapi32.lib cap.lib
LINK		= link

TFTP_COMMON_OBJS = initvars.obj \
	filep.obj \
	util.obj

TFTP_OBJS = maincli.obj \
	cmd.obj \
	cmdgetpu.obj \
	cmdsubs.obj  \
	fsm.obj \
	nettns.obj \
	sendrecv.obj

TFTPD_OBJS = mainserv.obj \
	fsmserv.obj \
	nettnssrv.obj \
	sendrecvsvr.obj

FINGER_OBJS = tnsapifc.obj tnsapifd.obj

OBJS = $(FINGER_OBJS) $(TFTP_OBJS) $(TFTPD_OBJS) $(TFTP_COMMON_OBJS) 


all: $(OBJS) tftp tftpd sfinger sfingerd

tnsapifc.obj:	tnsapifc.c
	$(CC) $(CFLAGS) tnsapifc.c

tnsapifd.obj:	tnsapifd.c
	$(CC) $(CFLAGS) tnsapifd.c

maincli.obj : maincli.c tftpdef.h
	$(CC) $(CFLAGS) maincli.c

mainserv.obj : mainserv.c tftpdef.h
	$(CC) $(CFLAGS) mainserv.c

cmd.obj : 	cmd.c cmd.h
	$(CC) $(CFLAGS) cmd.c

cmdgetpu.obj :	cmdgetpu.c tftpdef.h
	$(CC) $(CFLAGS) cmdgetpu.c

cmdsubs.obj :	cmdsubs.c cmd.h
	$(CC) $(CFLAGS)  cmdsubs.c

filep.obj :	filep.c tftpdef.h
	$(CC) $(CFLAGS)  filep.c

fsm.obj :	fsm.c tftpdef.h
	$(CC) $(CLIENT) fsm.c

fsmserv.obj :	fsm.c tftpdef.h
	$(CC) $(SERVER) -Fofsmserv.obj   fsm.c

nettns.obj :	nettns.c tftpdef.h
	$(CC) $(CLIENT)  nettns.c

nettnssrv.obj :	nettns.c tftpdef.h
	$(CC) $(SERVER) -Fonettnssrv.obj   nettns.c

sendrecv.obj :	sendrecv.c tftpdef.h
	$(CC) $(CLIENT)  sendrecv.c

sendrecvsvr.obj :	sendrecv.c tftpdef.h
	$(CC) $(SERVER) -Fosendrecvsvr.obj -FAs  sendrecv.c

util.obj :	util.c	
	$(CC) $(CFLAGS)  util.c

initvars.obj :	initvars.c tftpdef.h
	$(CC) $(CFLAGS)  initvars.c

tftp:	$(TFTP_OBJS) $(TFTP_COMMON_OBJS)
	$(LINK) $(LFLAGS) \
	-out:tftp.exe -map:tftp.map \
	$(TFTP_OBJS) \
	$(TFTP_COMMON_OBJS) \
	$(LIBTNSAPI) \
	$(BASELIBS)

tftpd:	$(TFTPD_OBJS) $(TFTP_COMMON_OBJS)
	$(LINK) $(LFLAGS) \
	-out:tftpd.exe -map:tftpd.map \
	$(TFTPD_OBJS) \
	$(TFTP_COMMON_OBJS) \
	$(LIBTNSAPI) \
	$(BASELIBS)

sfinger: tnsapifc.obj  
	$(LINK) $(LFLAGS) \
	-out:sfinger.exe -map:sfinger.map \
	tnsapifc.obj \
	$(LIBTNSAPI) \
	$(BASELIBS)

sfingerd: tnsapifd.obj
	$(LINK) $(LFLAGS) \
	-out:sfingerd.exe -map:sfingerd.map \
	tnsapifd.obj \
	$(LIBTNSAPI) \
	$(BASELIBS)

clean : $(OBJS) 
	-!del $**



