
#ifndef ORATYPES_ORACLE
# include <oratypes.h>
#endif

#ifndef WRB_ORACLE
# include <wrb.h>
#endif

#undef boolean
#include <windows.h>

WRBReturnCode test_init();
WRBReturnCode test_auth();
WRBReturnCode test_exec();
WRBReturnCode test_shut();

_declspec (dllexport)
WRBReturnCode testentry (WRBCalls)
WRBCallbacks *WRBCalls;
{
  WRBCalls->init_WRBCallback      = test_init;
  WRBCalls->authorize_WRBCallback = test_auth;
  WRBCalls->exec_WRBCallback      = test_exec;
  WRBCalls->shut_WRBCallback      = test_shut;
  
  return (WRB_DONE);
}


WRBReturnCode test_init( WRBCtx, clientcxp )
void   *WRBCtx;
void  **clientcxp;
{
  return (WRB_DONE);
}


WRBReturnCode test_auth( WRBCtx, clientcxp, bAuthorized )
void     *WRBCtx;
void     *clientcxp;
boolean  *bAuthorized;
{
  char *userID, *password;
  HANDLE phToken;

  WRBSetAuthorization(WRBCtx, WRB_AUTH_BASIC_NEW, "Hello World", FALSE);
    
  userID   = WRBGetUserID(WRBCtx);
  password = WRBGetPassword(WRBCtx);

  *bAuthorized = LogonUser(userID,NULL,password,LOGON32_LOGON_INTERACTIVE,LOGON32_PROVIDER_DEFAULT,&phToken);
  CloseHandle(phToken);

  return (WRB_DONE);
}

WRBReturnCode test_exec( WRBCtx, clientcxp )
void   *WRBCtx;
void   *clientcxp;
{
  WRBClientWrite(WRBCtx, "Content-type: text/html\n\n<TITLE>Hello World</TITLE><IMG SRC=\"/ows-img/ows.gif\" ALT=\"Oracle WebServer\"><HR>\nHello World\n<HR><ADDRESS>(c)1996 Oracle Corporation</ADDRESS>", 172);
  return (WRB_DONE);
}

WRBReturnCode test_shut( WRBCtx, clientcxp )
void   *WRBCtx;
void   *clientcxp;
{
  return (WRB_DONE);
}

