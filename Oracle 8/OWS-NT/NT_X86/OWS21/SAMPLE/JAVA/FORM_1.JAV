/*
**  Copyright (c) 1996 by Oracle Corporation. All rights reserved. 
**    NAME
**      form.java
**    DESCRIPTION
**      
**    RETURNS
** 
**    NOTES
**      
**    MODIFIED   (MM/DD/YY)
**     mfreedma      09/11/96 -  Added Banner
*/

import oracle.html.*;

//
// This simple sample demonstrates the form handling capability
// of package oracle.html. 
// 
public
class form {

 // main: the entry point of this program
public static void main(String args[]) 
  
{
  // Creates an HtmlHead Object titled "Form Sample"
  HtmlHead hd = new HtmlHead("Form Sample");

  // Create an HtmlBody Object
  HtmlBody bd = new HtmlBody();
  // Sets various attributes of HtmlBody
  bd.setBackgroundColor("#fffff2");
  bd.setUnfollowedLinkColor("#cc0000");
  bd.setActivatedLinkColor("#ff3300");
  bd.setFollowedLinkColor("#000055");

  // Creates an HtmlPage object using hd and bd
  HtmlPage hp = new HtmlPage(hd, bd);

  // Creates the banner
  bd
    .addItem(new banner("Form Handling in Oracle.html"))
    .addItem(SimpleItem.Paragraph)
    .addItem(new SimpleItem("Note: this form will not do any processing with the data you submit, but merely take you to the TABLE handling sample page").setItal())
    .addItem(SimpleItem.Paragraph);

  // Creates the main form
  Form frm = new Form("GET", "table");
  frm
    .addItem(new SimpleItem("Please let us know more about yourself").setBold())
    .addItem(SimpleItem.Paragraph)
    .addItem(new SimpleItem("Name: ").setBold().setItal())
    .addItem(new TextField("name", 32, 16, ""))
    .addItem(SimpleItem.LineBreak)
    .addItem(new SimpleItem("Age:  ").setCode().setEmphasis())
    .addItem(new PasswordField("age", 32, 16, ""))
    .addItem(SimpleItem.Paragraph);

  frm
    .addItem(new SimpleItem("What do you think of this package?").setBold())
    .addItem(SimpleItem.LineBreak)
    .addItem(new SimpleItem("It's great!"))
    .addItem(new Radio("taste", "It's great!"))
    .addItem(new SimpleItem("It's lousy!"))
    .addItem(new Radio("taste", "It's lousy!"))
    .addItem(SimpleItem.Paragraph);
  
  frm
    .addItem(new SimpleItem("A Little Survey: Which Browser do you use?").setBold())
    .addItem(SimpleItem.Paragraph)
    .addItem(new SimpleItem("Netscape Mozilla"))
    .addItem(new CheckBox("browser", "mozilla", true))
    .addItem(new SimpleItem("Oracle Power Browser"))
    .addItem(new CheckBox("browser", "orapb"))
    .addItem(SimpleItem.Paragraph);
  
  frm
    .addItem(new SimpleItem("Which HTTP server do you use?").setBold())
    .addItem(new Select("server")
	     .addOption(new Option("Oracle WebServer"))
	     .addOption(new Option("Netscape"))
	     .addOption(new Option("Apache"))
	     .addOption(new Option("NCSA"))
	     .addOption(new Option("CERN")))
    .addItem(SimpleItem.Paragraph);
  
  frm
    .addItem(new SimpleItem("Please enter your comments:").setBold())
    .addItem(SimpleItem.LineBreak)
    .addItem(new TextArea("comments", 40, 10))
    .addItem(SimpleItem.HorizontalRule);

  frm
    .addItem(new Submit("submit", "Submit!"))
    .addItem(new Reset("Reset"));	      

  // Adds form to HtmlBody
  bd.addItem(frm);
  
  // Adds trailer
  bd.addItem(new trailer("form.java"));

  // Print header info
  hp.printHeader();
  // Print body
  hp.print();
}

}

