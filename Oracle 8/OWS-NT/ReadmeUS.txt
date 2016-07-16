Oracle WebServer for Windows NT Release Notes

Release 2.1.0.3.1 Production
January 1997

Oracle WebServer Release 2.1 supports Oracle databases Version 7.2 and later, 
and it is certified for use with Windows NT Version 3.51 and 4.0.

The following topics are discussed in this document:

o  New in this Release
o  Bug Fixes
o  Known Problems, Restrictions, and Workarounds
o  Your Comments Are Welcome

New in this Release

Supported Third-Party HTTP Servers

Oracle WebServer Version 2.1 supports third-party web servers. Users can upgrade these
servers to use the Oracle Web Request Broker (WRB) for improved reliability and scalability.
Oracle WebServer 2.1 supports these HTTP servers:

o  Netscape FastTrack Version 2.0 and 2.1
o  Netscape Enterprise Server Version 2.0
o  Microsoft Internet Information Server Version 2.0 (for Windows NT Version 4.0 only)

Future releases of Oracle WebServer will support integration with other popular HTTP 
servers.

Upgrading Netscape FastTrack

Original Netscape FastTrack web server settings are automatically backed-up during the upgrade
process by Oracle WebServer. The new filename is OBJ.CONF.SAV, and it is saved to the same
directory as the original OBJ.SAV file.

Security Enhancement Utility

This release contains a security enhancement utility for use with previous releases of the Oracle
WebServer (prior to release 2.1.0.3.1). This security utility, distributed as a patch, automates
adjustments to WebServer necessary to develop secure PL/SQL applications for the web.

To access and install this utility:

Open the file from any web browser:

file: //<cd-rom drive>:/owspatch/security.htm

Follow the instructions in this HTML file.

Bug Fixes

o  Administration of the WRB in conjunction with the Netscape FastTrack web server is only
possible with an Oracle administrative server.

o  The WRB and Web Listener are synchronized.

o  Remote users do not lose connections when using the utility OWA_UTIL.REDIRECT_URL.

o  Users are unable to bypass Basic authentication with WRB security.

o  A cleanup process for network errors is in place.

o  When /SAMPLE/SSI is selected, SAMPLE/SSI/INDEX.HTML appears by default.

o  A new parameter that allows web administrators to control direct access from any client’s web
browser to the Oracle Web Agent (OWA) packages provided by Oracle is included in this release
of Oracle WebServer for Windows NT. The parameter PROTECT_OWA_PKG is located in the
SV<LISTENER>.APP file. Any URL (Uniform Resource Locator) of the form
//hostname:port//DCD/owa/<OWA_PACKAGE>.<OWA.PROCEDURE> will be rejected if the
parameter is set to any value except FALSE. An entry with the offending package will be logged in
the server’s log file.

For example, the URL http://www.a-site.com/owa_default/owa/owa_util.print_cgi_env will be
rejected and the standard error page (“Request Failed”) appears to the client. Because many
applications depend on this type of direct access, setting the parameter explicitly to FALSE will
allow Oracle Web Server to accept this type of request.

Known Problems, Restrictions, and Workarounds

o  This release of Oracle WebServer works with the 7.2.2, 7.2.3, and 7.3.2 versions of the
Oracle7 Server. This release does not include the “Blob” sample referenced on the Samples
page.

o  Identical directory maps cannot exist in the listener configuration file and OWS_APPFILE.
The security information for the protection used in the OWS_APPFILE must exist in the
corresponding server configuration file.

o  Domain authentication for Microsoft Internet Information Server (IIS) is not supported.

PL/SQL Agent Administration

The CGITimeout parameter of the administration listener may cause the creation or modification
of a Data Connector Descriptors to timeout if the PL/SQL package is being installed. If this
happens, the server returns “The server had an internal error and could not process the request”.
Increase the CGITimeout parameter appropriately to ensure completion of the execution within
that time.

Boot

During the creation of the OWA_DEFAULT_SERVICE and OWA_DBA DCDs, the
PL/SQL package and the train demo are automatically installed. The ORACLE database may run
out of shared memory during this operation if the shared pool size parameter for the database is
too small. Increase the SHARED_POOL_SIZE initialization parameter (edit the file
ORANT\DATABASE\INITORCL.ORA, then restart the database) for the changes to take effect.

Train Demo

o  If the query for a train ticket between a pair of dates cannot find available train times, the
subsequent page displays an empty select list. This action causes an incorrect number of
arguments to be passed to tr.purchase, the next procedure call. The error page is displayed.

o  Add to Step 2 of installation instructions for Oracle Travel Demo
(\ows-adoc\demos.html).

o  If you are running Oracle Web Agents through CGI, add the following entry to the Directory
Mappings section of the Advanced Listener Configuration:

ORANT\OWS21\BIN  CR  /demo/

o  Assuming you already have a database demo and if you are running Oracle Web Agents as a
cartridge, add the following entry to the Applications and Directories section of the WRB
Configuration:

 /DEMO/OWA  OWA  ORANT\OWS21\BIN

Dispatcher

The minimum and maximum number of cartridge instances as specified in the [Apps] section of
the WRB configuration file (SV<listener>.APP) means the minimum and maximum number of
cartridge instances per listener process. This distinction is significant in the case of the Netscape
FastTrack Server where there can be multiple listener processes. The Oracle Web Listener
supports one listener process, and so the previous definition is irrelevant.
The minimum number of instances of each cartridge are started up by each listener process at
the end of the first transaction handled by that listener process, as opposed to being started up at
the time of server initialization.

Your Comments Are Welcome

Contact Oracle WebServer Feedback at owshelp@us.oracle.com. Please provide:

o  RDBMS version
o  WebServer version
o  a description of the problem, including test cases, and log/error files

For comments on documentation, contact ntdoc@us.oracle.com. Please provide the title of the
documentation, the platform of the product, the version number of the product, and the part
number of the documentation if possible.
