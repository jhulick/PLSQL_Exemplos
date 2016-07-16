Welcome to Adobe Acrobat Reader 2.1 for Windows 

Adobe(tm) Acrobat(tm) software gives you instant access to documents in 
their original form, independent of computer platform. With the Acrobat 
Reader, you can view, navigate, print and present any Portable Document 
Format (PDF) file.

This Read Me file contains installation instructions and product 
information for the Acrobat Reader program. The On-line Guide 
(help_r.pdf) also provides essential information to help you begin 
using Acrobat Reader 2.1.

If you are redistributing Acrobat Reader, place this Read Me file 
standalone in the directory with the acroread.exe file to assist the end 
user with installation of the program.

This file contains the following topics:
        New features in Acrobat Reader 2.1
        Installing Acrobat Reader
        System requirements
        Using the Weblink tool with Acrobat Reader
        Known Problems
        Creating your own PDF documents
        Technical support
        Electronic End User License Agreement

NEW FEATURES IN ACROBAT READER 2.1
==================================
Acrobat Reader 2.1 now runs under Windows NT 3.5 (or later), Windows 3.1, 
and Windows 95, as well as OS/2 2.11 or later in Windows compatibility 
mode. Adobe’s ATM technology for rendering Type 1 fonts has been built 
into Acrobat Reader 2.1 for Windows so it is no longer necessary to install 
ATM on Windows systems. For Windows 3.1 and Windows 95, installing ATM is 
an option (not included with the Reader) that may improve performance of 
printing documents with Type 1 fonts to non-PostScript printers.

Acrobat Reader 2.1 now accepts some specially enabled plug-ins, such as 
Weblink and Movie. This allows Acrobat Reader users to take advantage of 
new capabilities in PDF files created with Acrobat Exchange, for example 
following World Wide Web (URL) links or viewing QuickTime and AVI 
(Windows only) movies within a PDF document.

Printing quality has been improved to non-PostScript printers.

Limitations in printing to some non-Postscript printers with non-square 
pixels (some fax modems and dot-matrix printers) have been removed.

Acrobat Reader 2.1 generates DSC-compliant PostScript when used with the 
AdobePS 3.0 (or later) driver.

INSTALLING ACROBAT READER
=========================
- To install Acrobat Reader 2.1 on your hard drive, from the Windows 
Program Manager, choose Run from the File menu; type 
  [drive]:\setup.exe 
- Follow the instructions on your screen.
- Installation requires approximately 3 MB of free hard disk space. 

SYSTEM REQUIREMENTS
===================
- 386- or 486-based personal computer (486 recommended)
- Microsoft Windows 3.1 or greater
- 4 MB application RAM
- 4 MB hard disk space
- 1.44 MB 3.5" floppy disk drive

USING THE WEBLINK TOOL WITH ACROBAT READER
==========================================
To use the Weblink plug-in to follow links, you must set up your browser to
recognize Acrobat Reader. See the Adobe Home Page (http://www.adobe.com)
for information on configuring your browser to recognize PDF documents.

To install the Weblink plug-in:
        1. Copy the Weblink plug-in to the Adobe Acrobat Plug-ins directory.
        If you just installed Acrobat Reader, the Weblink plug-in may
        already exist in the Plug-ins directory.
        2. Restart Acrobat Reader.

To select your Web browser:
        1. Choose Edit>Preferences>Weblink.
        2. Click Browse, then select your Web browse from the dialog box.
        3. Choose a Connection Type. Standard is the connection type for
        the supported browsers Netscape 1.1 and Spyglass Mosaic 2.0.

To open your web browser from Acrobat Reader click the Web browser button
in the toolbar. This feature fails intermittantly in Windows 95.

KNOWN PROBLEMS
================
Errors During Acrobat Reader Installation
When launched, the Acrobat Reader installer (SETUP.EXE) makes a copy 
of the SETUP.EXE file in the temp directory specified in the 
AUTOEXEC.BAT file. When the drive and directory listed in the "Set temp=" 
line in the AUTOEXEC.BAT file are invalid or you don't have write access 
to that drive and directory,or enough space on the drive, the Acrobat Reader 
installation fails, and returns the errors "Cannot load the language 
library", "Cannot load the license agreement", or "Not enough free disk 
space to continue installation".

Do one or more of the following: 
A. Ensure there is at least 4-8MB free disk space available on the hard 
drive onto which Acrobat Reader is being installed.
B. Ensure the "Set temp=" line in the AUTOEXEC.BAT is valid: 
 1. Open the AUTOEXEC.BAT file in a text editor that saves as text-only 
 (e.g., Windows Write, Notepad). 
 2. Locate the line that reads "Set temp=" and verify the drive and 
 directory following the equal sign are valid. When the "Set temp=" 
 line points to an invalid drive or directory, edit the line to point 
 to a valid drive and directory, then save the file as text-only. 
 3. Reboot the computer.
C. Ensure you have write access to the drive where the TEMP directory 
is located.

Windows95
Installation From the Network -- If you set up a network server with 
the Acrobat Reader installation disk images (this problem does not occur 
with the single-file Reader Installer) so users can install Acrobat Reader 
over the network, the user installing the software must run the 
installation from a network drive that is mapped, not directly from the 
Network Neighborhood. The easist way to assign (map) a drive letter to a 
network computer or folder is as follows:

1. On the Windows 95 desktop, right mouse click My Computer, and then 
click Map Network Drive. The Map Network Drive dialog appears.
2. Select a Drive letter.
3. Select a Path to the network server you want. 
For example:
\\computername\foldername
If a password is required, Windows prompts you. 

After the drive has been mapped, double click on My Computer to open the 
My Computer window. The drive name and letter you just mapped will be 
listed and can be used to navigate to the Acrobat Reader install disks.

Weblink Plug-in
- Spyglass Mosaic under Win32s crashes intermittantly when a download is
cancelled from Weblink.
- An invalid gopher URL (e.g. gopher://example.com/pub/test.pdf) will
download an error message as a text file with the PDF file name. Acrobat 
Reader will return the message "There was an error opening this document. 
File does not begin with %PDF-".
- If the web browser is busy contacting the host for over one minute,
Weblink will return the message "The web browser has not responded to
your request for over 1 minute: terminating request". The browser may
not respond to Weblink's attempt to cancel; use the web browser button
in the toolbar to activate the browser and manually cancel the request. 

PCL Printing 
The printer drivers shipped with Microsoft Windows 3.1 for the HP LaserJet 
III, IIID, IIIP, and IIISi printers may not work well with Acrobat Reader 
(and other applications for that matter). Adobe recommends you use a PCL 
printer driver based on the Universal Printer Driver V.3.1.2. Here are four 
ways to get this driver:

COMPUSERVE. Type “GO MSL” to get to the Microsoft Software Library forum. 
Download the file named HPPCL5.EXE. Place this file on an empty, formatted 
DOS diskette then from DOS run the file to extract the driver and 
installation instructions which are in the file named printer.txt.

MICROSOFT'S BULLETIN BOARD. Microsoft's bulletin-board download service 
can be reached at 206-936-6735. It supports up to 9600 baud and you should 
set up your modem to use 8-bit, 1 stop bit, and no parity. Once connected, 
there is a menu-driven bulletin board. Download the file named "HPPCL5.EXE" 
and follow the same directions as above.

MICROSOFT. If you don't have a modem, you may call Microsoft directly at 
206-637-7098 or 800-426-9400 and obtain the LaserJet III printer drivers 
on a diskette.

HEWLETT PACKARD. Again, if you don't have a modem, you may call Hewlett 
Packard directly at 303-353-7650 and obtain the LaserJet III printer 
drivers on a diskette. You may also use this number to obtain the latest 
printer drivers for the HP LaserJet 4, DeskJet, and PaintJet families of 
printers.

If you experience problems printing to HP LaserJet printers in the 600-dpi 
mode try switching back to 300-dpi mode or if it is equipped with a 
PostScript option, use the PostScript mode for 600-dpi printing. This 
600-dpi PCL5 printing problem does not seem specific to Acrobat.

If outline-style text is printing incorrectly to a PCL printer (outlines 
printing on top of black characters) make the following change in the ATM 
Conrol Panel: check the option to "Print ATM Fonts as Graphics." 

To properly print certain special text effects (such as shadow, zoomed 
text, or outlined text) to non-PostScript printers it may be required to 
select the Print ATM Fonts as Graphics option in the ATM Control Panel. 
Certain printer drivers including the LaserJet PCL4 (Series II and higher), 
PCL5 (LaserJet III and LaserJet 4 families) and the Lexmark PPDS (4029 & 
4029) always print black soft fonts on top of images and non-black text 
strings. 

Documents with various graphic images may not print correctly to the 
LaserJet 4 in PCL mode at 600 dpi unless the Graphics option in the Windows 
printer driver setup is set to Raster mode. 

To increase printer performance of documents formatted entirely in 
landscape orientation to non- PostScript printers the printer driver 
must be set in landscape orientation in the Windows printer setup. 

Postscript Printing
AdobePS 3.01 Driver  For best results when printing to PostScript printers, 
Adobe recommends you use the AdobePS 3.01 (or later) driver. The driver  
and installation instructions are included on the Acrobat Sampler CD.

AdobePS 2.1.1 Driver  You may experience problems when printing from 
Acrobat Reader 2.1 when using the AdobePS 2.1.1 printer driver. The 
problems occur in printing certain documents that use TrueType fonts 
or extended characters, such as typographic quote marks. A PSPrinter 
2.1.2 update that fixes both of these problems is available. The AdobePS 
2.1.2 update upgrades an installed version of AdobePS 2.1.1 to 2.1.2 
is available from the following sources:

COMPUSERVE.   Type GO ADOBE to get to the Adobe forum.

FTP.  Adobe’s ftp Server is at ftp.adobe.com. The path to the updater is 
ftp.adobe.com/pub/adobe/Applications/Drivers/Windows/adobeps.exe

WORLD WIDE WEB. Adobe’s World Wide Web server is at http://www.adobe.com.

PHONE.  Call 800-521-1976 to have the AdobePS 2.1.2 update disk sent to 
you directly. Shipping and handling charges may apply.

Note: The update is not the complete, standalone AdobePS 2.1.2 driver. 
It will only update a previously installed version of AdobePS 2.1.1.

Memory Issues. If you encounter problems, such as as VMerror, printing 
to PostScript Level 1 or 2 printers it may be because the printer has 
little available memory (for example, a non-upgraded LaserWriter, LaserWriter 
Plus, LaserWriter II NT or NTX). There are two potential solutions to this 
problem: 
1/In the General Preferences dialog (select from the Edit/Preferences 
menu) you may choose to use Serif only or Sans only for font substituion. 
This frees up additional memory in the printer and chances are your 
document will print successfully. 
2/The other option is to purchase more memory for your printer.

Apple Personal LaserWriter NT   If you are using an Apple Personal 
LaserWriter NT printer that has not been upgraded to a Personal 
LaserWriter NTR, Acrobat Reader won't be able to print substitute fonts. 
Contact your Apple dealer for information on upgrading your printer.

Miscellaneous Issues
CANON BJC 800 PRINTER In order to properly print text, graphics, and images 
to this printer be sure to check the Use Print Manager option in the Printers 
control panel. 
CANON LBP-8IV  Use the printers “bitmap mode” for best results.
COMPAQ MGA8.DRV VIDEO DRIVER  Using this video driver (installed on Compaq 
DeskproXL 586 (1024x768, 640x480, 256 colors) with Compaq Qvision 2000 board 
may cause Acrobat Reader to crash. Solution: Turn off Page Caching in the 
Edit > Preferences > General dialog.
HP DESKJET 500C  This printer has an unprintable area near the top of the 
page. Be sure to use the Shrink to Fit option in Acrobat Reader’s Print 
dialog.
FONT NOT FOUND  A font not found error may indicate that ATM did not have 
enough memory to create a substitute font. See the Improving Performance 
section of this file for information on how to increase the memory available 
to ATM (if installed).
INSTALL  Due to problems with some Desktop Managers, during installation 
the Adobe Acrobat  program group and the Acrobat Reader program item may 
not be created. By default, the program is installed in the directory 
c:\acroread and the executable is c:\acroread\acroread.exe.
LOTUS NOTES  When you open an embedded PDF file from a Notes database, 
the Acrobat Reader window seems to flicker slightly. This is because Lotus 
Notes is giving Acrobat Reader OLE instructions to Show, Hide, then Show 
the PDF document.
MACH 32 VIDEO CARD FROM ATI  If you are using the MACH 32 ATI card, be 
sure to use the 256-color mode with the Color Pallette ON. In other words, 
do not use the 256-color mode with the color pallette off. For Acrobat, 
make sure the Pallette is ON. 
NEC ULTRALITE VERSA LINEAR DRIVER  Rotated images may display with artifacts 
when using the UltraLite Versa Linear 640x480 256 color video driver. 
Solution: Use the UltraLite Versa 640x480 256 color driver.
NUMBER 9 VIDEO DRIVER  When Acrobat Reader’s page caching is enabled, if 
you experience horizontal lines running across the page try turning off the 
turbo mode in the #9GXE video driver. This can be done via the Turbo menu 
in the program “#9GXE Status” available in the “#9 Hawkeye Control 
Panel.
OLE  When viewing a PDF file which is an embedded OLE object, you can 
only perform an incremental save, not a full save. Operations which 
require a full size are things like inserting another PDF file. As a 
result, you cannot perform this operation on an embedded OLE object.
OS/2  Acrobat Reader should run in the Windows 3.1 compatibility mode 
of OS/2 2.1 and OS/2 2.1.1.
PAGE CACHING — Page caching is disabled for 16-bit and 24-bit displays 
and the option is grayed out in the General Preferences dialog.
PATTERNS  Files produced by the Acrobat Distiller containing patterns 
may display slowly and cause memory shortages. This can often be the case 
when applications represent patterns as thousands of small Type 3 font 
characters. If you experience this problem, it is recommended to use 
color rather than pattern fills.
PC TOOLS FOR WINDOWS 1.0  No Adobe Acrobat group is created and no 
program items/icons are created. See INSTALL problem above for description 
of workaround. 
PHONENET  PhoneNet does not properly map Macintosh file names containing 
upper-ASCII characters. As a result, you will not be able to open any such 
files in Acrobat Reader. Solution: Don’t use special characters in file 
names to be accessed by both Macintosh and Windows users over a 
PhoneNet network.
PRINTING FROM FILE MANAGER  Only one PDF file at a time can be selected 
and printed from the File Manager.
ROTATING PAGES  Rotating pages results in the loss of thumbnail images 
for those pages. You can regenerate the thumbnails by choosing 
Edit/Thumbnails/Create All. 
ROTATED/TRANSFORMED TRUETYPE FONTS  You may encounter some problems with 
displaying or printing rotated or otherwise transformed TrueType fonts. 
This is a limitation of TrueType and Windows. For best results, we recommend 
you use Adobe PostScript Type 1 fonts in your documents. 
STANDARD MODE  Acrobat Reader 2.1 does not work in standard mode; you 
must be running Windows 3.1 in enhanced mode.
SYSHOOK  Syshook is an application that patches the system menus of 
applications; it does not work well with Acrobat Reader. 
TRUE TYPE  TrueType fonts cannot be reencoded. Because of this limitation, 
documents that were created using some special characters in a Type 1 font 
may not display correctly if a TrueType version of the font with the same 
name is installed on your system. When this happens, the error message 
“Some text in the font and character 'FONTNAME ###' could not be displayed 
or printed correctly. The font could not be reencoded.” is displayed. Since 
the Acrobat installers do not replace TrueType versions of Times, Helvetica, 
and Courier you may get this message with these fonts. Solution: Use the 
Custom Install option to install a Type 1 version of these fonts.
WINDOWS FOR WORKGROUPS  The Windows for Workgroups Netware extensions 
(\windows\netx.com) have been known to cause problems with Acrobat Reader's 
Open dialog, as well as other application’s Open dialog. 
Solution: Contact Microsoft.
WRONG COLORS  If the colors on your monitor seem completely wrong, 
try the following. In the Acrobat Reader's ini file (c:\windows\acroread.ini) 
try changing the line 'IS8514=4' to 'IS8514=105'.


TO CREATE YOUR OWN PDF DOCUMENTS
================================
To take full advantage of the benefits of electronic documents, you can 
purchase Acrobat Exchange, Acrobat Pro, or Acrobat for Workgroups with the 
coupon contained in the Acrobat Reader On-line Guide (available on the 
Acrobat CD Sampler) or by calling 800-87-ADOBE (800-872-3623). With the full 
Acrobat products, you can:

- Create your own electronic documents as easily as printing from your 
  existing applications with PDF Writer.
- Protect your files with passwords; control access, printing, changing 
  the document, adding and changing notes, copying text and graphics.
- Find exactly what you need across multiple PDF files by searching on 
  keywords, author, title, subject synonyms, etc.
- Reuse information easily by extracting, copying, reordering and replacing 
  pages among PDF files -- with bookmarks, links and notespreserved.
- Create your own custom views into information.
- Add value, set priorities and maintain a dynamic information network 
  with links, bookmarks, notes and connections to external applications 
  and documents.
- Take advantage of third-party plug-ins to add new features to  Acrobat.
- Integrate Acrobat with your desktop applications with Acrobat's support 
  for OLE automation, Notes F/X, AppleEvents, and more.

TECHNICAL SUPPORT
=================
For primary technical information and answers, you're free to take advantage 
of Adobe's Basic Support Services at any time. You're responsible only for 
telephone charges. These services include:
- Adobe US Automated Technical Suport -- a full-time, computer-driven 
  diagnostic system with answers to the most commonly asked questions. 
  Call 1-206-628-2757 24 hours a day, 7 days a week.
- Adobe US Fax Request Line -- an easy way to request free technical notes 
  by fax. Dial 1-206-628-5737 24 hours a day, 7 days a week.
- CompuServe Questions and Answers -- an Adobe bulletin board for CompuServe 
  subscribers. Directory: GO ADOBE
- Adobe US Electronic Bulletin Board -- A 24 hours a day bank of information. 
  Dial 1-206-623-6984.

US only -- for users of Adobe Acrobat products in the US and Canada, 
pay for support options include:
- 900-555-2276 -- this business-to-business 900 service is a way for 
  infrequent users to get help from an Adobe Technical Support Representative. 
  Each minute is $2.00 plus toll, if any, and charges will appear on your 
  monthly phone bill.

ELECTRONIC END USER LICENSE AGREEMENT
=====================================
Adobe Systems Incorporated
Electronic End User License Agreement

NOTICE TO USER:
THIS IS A CONTRACT.  BY INDICATING YOUR ACCEPTANCE BELOW, YOU ACCEPT ALL THE 
TERMS AND CONDITIONS OF THIS AGREEMENT.
This Adobe Systems Incorporated ("Adobe") End User License Agreement 
accompanies an Adobe software product and related explanatory written 
materials ("Software"). 
The term "Software" shall also include any upgrades, modified versions or 
updates of the Software licensed to you by Adobe.  This copy of the Software 
is licensed to you as the end user.  You must read this Agreement carefully 
before indicating acceptance at the end of the text of this Agreement. 
If you do not agree with the terms and conditions of this Agreement, decline 
where instructed during installation, and you will not be able to use the 
Software. Adobe grants to you a nonexclusive license to use the Software, 
provided that you agree to the following: 

1. Use of the Software. You may install the Software in a single location on 
   a hard disk or other storage device; install and use the Software on a 
   file server for use on a network for the purpose of permanent installation 
   onto hard disks or other storage devices or use of the Software over such 
   network; and make backup copies of the Software. You may make unlimited 
   copies of the Software and give copies to other persons or entities as 
   long as the copies contain this Agreement and the same copyright and other 
   proprietary notices that appear on or in the Software.

2. Copyright. The Software is owned by Adobe and its suppliers, and its 
   structure, organization and code are the valuable trade secrets of Adobe 
   and its suppliers.  The Software is also protected by United States 
   Copyright Law and International Treaty provisions.  You agree not to 
   modify, adapt, translate, reverse engineer, decompile, disassemble or 
   otherwise attempt to discover the source code of 
   the Software.  You may use trademarks only to identify printed output 
   produced by the Software, in accordance with accepted trademark practice, 
   including identification of trademark owner's name.  Such use of any 
   trademark does not give you any rights of ownership in that trademark. 
   Except as stated above, this Agreement does not grant you any 
   intellectual property rights in the Software.

3. Transfer. You may not rent, lease, or sublicense the Software. You may, 
   however, transfer all your rights to use the Software to another person 
   or entity, provided that you transfer this Agreement with the Software.

4. No Warranty. The Software is being delivered to you AS IS and Adobe makes 
   no warranty as to its use or performance. ADOBE AND ITS SUPPLIERS DO NOT 
   AND CANNOT WARRANT THE PERFORMANCE OR RESULTS YOU MAY OBTAIN BY USING 
   THE SOFTWARE OR DOCUMENTATION. ADOBE AND ITS SUPPLIERS MAKE NO WARRANTIEs, 
   EXPRESS OR IMPLIED, AS TO NONINFRINGEMENT OF THIRD PARTY RIGHTS, 
   MERCHANTABILITY, OR FITNESS FOR ANY PARTICULAR PURPOSE.  IN NO EVENT WILL 
   ADOBE OR ITS SUPPLIERS BE LIABLE TO YOU FOR ANY CONSEQUENTIAL, INCIDENTAL 
   OR SPECIAL DAMAGES, INCLUDING ANY LOST PROFITS OR LOST SAVINGS, EVEN IF 
   AN ADOBE REPRESENTATIVE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH 
   DAMAGES, OR FOR ANY CLAIM BY ANY THIRD PARTY.  
   Some states or jurisdictions do not allow the exclusion or limitation of 
   incidental, consequential or special damages, or the exclusion of implied 
   warranties or limitations on how long an implied warranty may last, so the 
   above limitations may not apply to you.
 
5. Governing Law and General Provisions. This Agreement will be governed by 
   the laws of the State of California U.S.A., excluding the application 
   of its conflicts of law rules.  This Agreement will not be governed by 
   the United Nations Convention on Contracts for the International Sale 
   of Goods, the application of which is expressly excluded.  If any part 
   of this Agreement is found void and unenforceable, it will not affect 
   the validity of the balance of the Agreement, which shall remain valid 
   and enforceable according to its terms.  You agree that the Software 
   will not be shipped, transferred or exported into any country or used 
   in any manner prohibited by the United States Export Administration 
   Act or any other export laws, restrictions or regulations.  This 
   Agreement shall automatically terminate upon failure by you to comply 
   with its terms.  This Agreement may only be 
   modified in writing signed by an authorized officer of Adobe.

6. Notice to Government End Users. If this product is acquired under the terms 
   of a:  GSA contract- Use, reproduction or disclosure is subject to the 
   restrictions set forth in the applicable ADP Schedule contract; 
   DoD contract- Use, duplication or disclosure by the Government is subject 
   to restrictions as set forth in subparagraph (c) (1) (ii) of 252.227-7013;
   Civilian agency contract- Use, reproduction, or disclosure is subject 
   to 52.227-19 (a) through (d) and restrictions set forth in the accompanying 
   end user agreement.  Unpublished-rights reserved under the copyright laws 
   of the United States.  Adobe Systems Incorporated, 1585 Charleston Road, 
   P.O. Box 7900, Mountain View, CA 94039-7900.Adobe is a trademark of 
   Adobe Systems Incorporated which may be registered in certain jurisdictions.
 
Please indicate your acceptance or decline of the foregoing Agreement by 
clicking on the appropriate box during installation.

Adobe, Acrobat, and Adobe Type Manager are trademarks of Adobe Systems, 
Incorporated and may be registered in certain jusridictions. 
(c) 1983-1995 Adobe Systems Incorporated. All rights reserved.
