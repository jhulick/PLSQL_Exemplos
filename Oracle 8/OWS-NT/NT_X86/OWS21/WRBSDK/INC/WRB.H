/* Copyright (c) 1996 by Oracle Corp.  All Rights Reserved */
 
/*
  NAME
    WRB - Web Request Broker interface functions
  PURPOSE
    The Web Request Broker allows developers to plug applications
    into the Oracle Web Server for improved performance and flexibility
    over CGI.

    This header file contains all of the interface functions for
    developers to obtain transaction information from the WRB.
  NOTES
    User must include "oratypes.h" (or equivalent) before this file.
 
  HISTORY
    sadunuth   05/21/96 - fixed olint errors
    rpang      04/22/96 - Added WRB_Authorize, WRBGetUserID, WRBGetPassword
                          WRBGetClientIP, WRBSetAuthorization and "authorize"
			  callback			  
    sadunuth   04/22/96 - Added WRBGetMimeType & WRBGetReqMimeType
    mbookman   03/15/96 - Add "version" and "version free" callbacks
    mbookman   03/12/96 - Add "reload" callback
    mbookman   02/15/96 - Add get ORACLE_HOME and APP_CONF calls
    manand     02/07/96 - Updating for Cartridge configuration information
    mbookman   02/07/96 - Fixing up for Alpha release
    tchou      02/06/96 - Created
*/

#ifndef WRB_ORACLE
#define WRB_ORACLE

#ifdef WIN_NT
#ifndef _SSIZE_T
#define _SSIZE_T
typedef int ssize_t;
#endif
#endif

/*
 * The WRB return codes expected to come back from the WRB client
 */
typedef sb4 WRBReturnCode;
typedef sb4 WRBErrorCode;

#define WRB_DONE  0
#define WRB_ERROR 1
#define WRB_ABORT 2

/*
 * The WRB authorization scheme
 */
typedef sb4 WRBAuthScheme;

#define WRB_AUTH_BASIC_EXIST	1  /* existing basic authentication scheme  */
#define WRB_AUTH_BASIC_NEW	2  /* new basic authentication scheme       */
#define WRB_AUTH_DIGEST_EXIST	3  /* existing digest authentication scheme */
#define WRB_AUTH_DIGEST_NEW	4  /* new digest authentication scheme      */
#define WRB_AUTH_DOMAIN		5  /* existing IP restriction scheme        */
#define WRB_AUTH_IP		6  /* existing domain restriction scheme    */

/****************************************************************************/
/* WRB Configuration File specification                                     */
/****************************************************************************/
/* All new cartridges will need to register themselves in the WRB config    */
/* file which is read by the server at startup.  A environment variable     */
/* OWS_APPFILE needs to be defined specifying the full path for the WRB     */
/* config file. eg setenv OWS_APPFILE /private1/release2/ows21/admin/sv.app  */
/*                                                                          */
/* In the WRB config file the following 2 sections will need to be filled.  */
/* In the [Apps]  section                                                   */
/* APPS  - This tag will define your cartridge type                         */
/* Object Path - this tag will define the full path from where the shared   */
/*               resides.                                                   */
/* Entry Point - This entry point function should fill in the WRBCallbacks  */
/*               table that it is passed, such that the WRB can call the    */
/*               init, exec, and shut routines respectively (explained      */
/*               below).                                                    */
/* Min         - This entry indicates the minimum number of processes that  */
/*               need to be started up for each cartridge/application       */
/* Max         - This entry indicates the maximum number of processes that  */
/*               will be allocated for each cartridge/application use.      */
/* In the [AppsDirs] section                                                */
/* Virtual Path  - this entry specifies the virtual path that all URL's     */
/*                 will be refernced by                                     */
/* APP           - Same as above APP entry                                  */
/* N/R           - Recursive/Non-recursive traversal for each cartridge     */
/*                 in their specified paths.                                */
/* Physical Path - The actual physical path that the applications will read */
/*                 all their data files from.                               */
/****************************************************************************/


/*****************************************************************************/
/* Client-provided callback functions                                        */
/*****************************************************************************/
/* The following function defintions should be provided by the WRB client */
/* such that the WRB can invoke the users application.  The WRB client    */
/* must have a single entry point, which gets specified in the [Apps]     */
/* section of the WRB configuration file.                                 */
/*                                                                        */
/* This entry point function should fill in the WRBCallbacks table that   */
/* it is passed, such that the WRB can call the init, exec, and shut      */
/* routines respectively (explained below).                               */
/*                                                                        */
/* A simple example of a valid entry function would be:                   */
/* WRBReturnCode mydyn_init(WRBCallbacks *WRBcalls)                       */
/* {                                                                      */
/*    WRBcalls->init_WRBCallback = my_init;                               */
/*    WRBcalls->authorize_WRBCallback = my_authorize;                     */
/*    WRBcalls->exec_WRBCallback = my_exec;                               */
/*    WRBcalls->shut_WRBCallback = my_shut;                               */
/*    WRBcalls->reload_WRBCallback = my_reload;                           */
/*    WRBcalls->version_WRBCallback = my_version;                         */
/*    WRBcalls->version_free_WRBCallback = my_version_free;               */
/*                                                                        */
/*    return WRB_DONE                                                     */
/* }                                                                      */

/*******************************/
/* WRB Function table datatype */
/*******************************/
struct WRBCallbacks
{
   WRBReturnCode (*init_WRBCallback)();
   WRBReturnCode (*exec_WRBCallback)();
   WRBReturnCode (*shut_WRBCallback)();

   WRBReturnCode (*reload_WRBCallback)();

   char         *(*version_WRBCallback)();
   void          (*version_free_WRBCallback)();
   sb4           (*authorize_WRBCallback)();
};
typedef struct WRBCallbacks WRBCallbacks;

/*
 * The Init Callback
 *
 * This callback is invoked by WRB Application Engine on its initialization.
 * The WRB cartridge initializes its context in this routine which is then
 * made available to the cartridge on subsequent call backs.
 */
WRBReturnCode WRB_Init( void *WRBCtx, void **clientCtx );

/*
 * The Authorization Callback
 *
 * If defined, this callback is invoked by WRB Application Engine upon
 * receiving a HTTP Request. The WRB cartridge is responsible for
 * setting authorization information, and optionally checking the client
 * authentication information and deciding whether the HTTP request should
 * be authorized or not.
 */
WRBReturnCode WRB_Authorize( void *WRBCtx, void *clientCtx,
			     boolean *bAuthorized );

/*
 * The Exec Callback
 *
 * This callback is invoked by WRB Application Engine upon receiving a HTTP
 * Request, and checking authorization if the authorize callback is
 * defined. The WRB cartridge is responsible for creating the response that
 * is written back to the Listener in this callback .
*/
WRBReturnCode WRB_Exec( void *WRBCtx, void *clientCtx );

/*
 * The Shutdown Callback
 *
 * The WRB Application Engine invokes this call back to provide an graceful
 * exit for the WRB Client. Any memory allocated in the client context
 * during the init callback should be deallocated here.
*/
WRBReturnCode WRB_Shutdown( void *WRBCtx, void *clientCtx);

/*
 * The Reload Callback
 *
 * This callback is not required, but is recommended.
 * The WRB Application Engine invokes this call back whenever the Web Listener
 * has been signalled to reload its own configuration files.
 * The Web Listener halts all new incoming connections, allows existing
 * transactions to complete, and then signals each running WRB cartridge to
 * execute its reload callback (if one exists).
 * If your application uses configuration information from the OWS_APPFILE
 * then you should call WRBGetAppConfig again, as these values may have.
 */
WRBReturnCode WRB_Reload( void *WRBCtx, void *clientCtx);

/*
 * The Version Callback 
 *
 * The version callback enables the cartridge to return a character
 * string with information about the version of that cartridge.
 *
 * This callback is made by the "wlctl21" utility.
 */
char *WRB_Version( void );

/*
 * The Version Free Callback 
 *
 * The version free callback enables the cartridge to free the memory
 * allocated by the version callback.
 *
 * This callback is made by the "wlctl21" utility after a successful
 * call to the version callback.
 */
void WRB_Version_Free( void );

/*
 * WRB Listener Information Functions
 *
 * The following Listener Information functions provide cartridge developers
 * with information, if required, from the client as well as the underlying
 * HTTP Server. All functions return pointers to WRB Application Engine
 * memory which the WRB client should not modify.
 */

/*
 * WRB Get ORACLE_HOME
 *
 * Returns the ORACLE_HOME which was set when the Web Listener
 * was started.
 */
char *WRBGetORACLE_HOME( void *WRBCtx );

/*
 * WRB Get Application Configuration
 *
 * Returns the configuration information for the current application.
 * The structure of the return value is a pointer to an array of
 * pointers to character strings.  These character strings are of the
 * form "name=val".
 * The information is retrieved from the OWS_APPFILE at the time the
 * Web Listener starts up.
 *
 * An example might be:
 *
 * [MyCartidge]
 * myparam1 = val1
 * myparam2 = val2
 *
 */
char **WRBGetAppConfig( void *WRBCtx );

/*
 * WRB Get named Application Configuration Value
 *
 * Returns a named item for the application's configuration.
 * The information is retrieved from the OWS_APPFILE at the time the
 * Web Listener starts up.
 */
char *WRBGetConfigVal( void *WRBCtx, char *name );

/*
 * WRB Get URI 
 *
 * Returns the URI received from the HTTP Server. The cartridge developers
 * may extract additional information from the URI if required.
 */
char *WRBGetURI( void *WRBCtx );

/*
 * WRB Get URL 
 *
 * Returns the URL received from the HTTP Server. The cartridge developers
 * may extract additional information from the URL if required.
 */
char *WRBGetURL( void *WRBCtx );


/*
 * WRB Get Environment Variable
 *
 * Returns the value of an environment variable.  This provides a way for the
 * WRB client to access CGI Environment variables.  Or environment variables
 * set at the time of Listener startup.  Returns NULL if szEnvVar
 * points to a non-existent environment variable.
*/
char *WRBGetEnvironmentVariable( void *WRBCtx, char *szEnvVar );


/*
 * WRB Get Environment
 *
 * Returns the HTTP Server environment as an array of null terminated
 * strings with the syntax varname=varvalue.  The last entry in the array
 * is a NULL pointer.  Returns NULL in case of an error.
*/
char **WRBGetEnvironment( void *WRBCtx );


/*
 * WRB Get Content
 *
 * Returns either the Query String or the POST data content depending on the
 * type of the request method.  Returns NULL if there was no content sent from
 * the browser.
*/
char *WRBGetContent( void *WRBCtx );


/*
 * WRB Get Language
 *
 * Returns the WRB Application Engine Language preferences. Returns NULL in
 * case of an error.
 *
 * On success, returns a comma delimited list of the "Accept" languages.
 *
 */
char *WRBGetLanguage( void *WRBCtx );


/*
 * WRB Get Character Encoding
 *
 * Returns the WRB Application Engine Character Encoding preferences.
 * Returns NULL in case of an error.
 *
 * On success, returns a comma delimited list of the "Accept" encodings.
 *
 */
char *WRBGetCharacterEncoding( void *WRBCtx );


/*
 * WRB Get Parsed Query String
 *
 * Returns an array of name-value pairs after parsing the query string.
 * Return value codes are explained in the previous section
 */

struct WRBEntry
{
	char 		*name; 
	char 		*value;
};
typedef struct WRBEntry WRBEntry;

WRBReturnCode WRBGetParsedContent( void      *WRBCtx,
                                   WRBEntry **WRBEntries,
                                   int       *numEntries );


/*
 * WRB Get Named Entry
 *
 * Returns the requested name/value pair from a list of entries
 * generated by by a call to WRBGetParsedContent
 *
 * Returns a NULL pointer if the entry is not found.
 */
char *WRBGetNamedEntry( char     *entryName,
                        WRBEntry *WRBEntries,
                        int       numEntries );

/*
 * WRB Get MIME Type
 * returns the mime-type string based on an extension 
 * if none matches text/html is returned 
 */

char *WRBGetMimeType( void *WRBCtx, 
		      char *extension );

/* 
 * The mime-type for the request based on the 
 * extension is returned. Default is text/html
 */

char *WRBGetReqMimeType( void *WRBCtx );

/*
 * WRB Get User ID
 *
 * Returns the user ID supplied by the client in an HTTP request in response
 * to a challenge from the cartridge.
 *
 * Returns a NULL pointer if the user ID is not found.
 */
char *WRBGetUserID( void *WRBCtx );

/*
 * WRB Get Password
 *
 * Returns the password supplied by the client in an HTTP request in response
 * to a challenge from the cartridge.
 *
 * Returns a NULL pointer if the password is not found.
 */
char *WRBGetPassword( void *WRBCtx );

/*
 * WRB Get Client IP
 *
 * Returns the client's IP address.
 *
 */
ub4 WRBGetClientIP( void *WRBCtx );

/*
 * WRB Intervention Functions
 *
 * These functions are invoked by the WRB cartridge to respond to an
 * incoming client request.
 */

/*
 * WRB Set Authorization
 *
 * Invoked by the WRB client when it would like to specify an authorization
 * scheme (in init or authorize callback).
 *
 */
WRBReturnCode WRBSetAuthorization( void *WRBCtx, WRBAuthScheme nScheme,
				   char *szRealm, boolean bAndorflag );

/*
 *
 * WRB Client Read
 *
 * The WRB Client invokes this function to read the POST data of a HTTP
 * request from the WRB Application Engine.
 *
 * In the current implementation, if a client is going to read POST data,
 * it must do so before sending any data (through WRBClientWrite) back to
 * the Web Listener.
 * The return value is the number of bytes read.
 */
ssize_t WRBClientRead( void *WRBCtx, char *szData, int nBytes );


/*
 * WRB Client Write
 *
 * The WRB cartridge invokes this function to send data to the client.
 * The return value is the number of bytes written.
 */
ssize_t WRBClientWrite( void *WRBCtx, char *szData, int nBytes );


/*
 * WRB Return HTTP Error
 *
 * Invoked by the WRB client when it would like a standard HTTP error
 * sent back to the browser.
 * 
 * This call must come before any other calls to WRBClientWrite, as it
 * is just a wrapper which sends : Status: <nErrorCode> <szErrorMesg>
 *
 * The "close" flag set to FALSE indicates that you wish to send 
 * addition HTTP header information and that you will close the HTTP
 * header explicitly with a call to WRBCloseHTTPHeader.
 */
ssize_t WRBReturnHTTPError( void *WRBCtx,      WRBErrorCode nErrorCode,
                            char *szErrorMesg, boolean close );

/*
 * WRB Return HTTP Redirect
 *
 * Invoked by the WRB client when it would like an HTTP redirect,
 * indicating that a different URI should be retrieved to complete this
 * request.
 * 
 * This call must come before any other calls to WRBClientWrite, as it
 * is just a wrapper which sends : Location: <szURI>
 *
 * The "close" flag set to FALSE indicates that you wish to send 
 * addition HTTP header information and that you will close the HTTP
 * header explicitly with a call to WRBCloseHTTPHeader.
 */
ssize_t WRBReturnHTTPRedirect( void *WRBCtx, char *szURI, boolean close );

/*
 * WRB Close HTTP Header
 *
 * Invoked by the WRB client when it would like to close an HTTP header.
 * Generally used after calls to WRBReturnHTTPError or WRBReturnHTTPRedirect
 * with the "close" flag set to FALSE.
 *
 */
ssize_t WRBCloseHTTPHeader( void *WRBCtx );

/*
 * WRB Log Message
 *
 * Simple logging function for WRB clients to log messages.
 * Currently this will write to a file in ?/ows/log called
 * wrb_<process_id>.log.  In future versions, it the file
 * name will be wrb_<cartridge>_<process_id>.log
 */
void WRBLogMessage( void *WRBCtx, char *message, int nSeverity );

#endif /* WRB_ORACLE */
