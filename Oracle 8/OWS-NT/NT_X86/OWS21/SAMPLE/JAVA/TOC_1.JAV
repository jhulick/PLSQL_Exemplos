/*
**  Copyright (c) 1996 by Oracle Corporation. All rights reserved. 
**    NAME
**      toc.java
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
// This is the toc (table of contents) page for package demo.
// It demostrates simple table handling capability of this package.
//
public
class toc {

  // main: the entry point of this program
public static void main(String args[]) 
  
{
  // Creates an HtmlHead Object titled "Table Demo"
  HtmlHead hd = new HtmlHead("Demos for Oracle.HTML Package");
  hd.setBaseTarget("content");
  hd.addMetaInfo(new MetaInfo("Expires", "Sunday, 27 Jan 1996"));

  // Create an HtmlBody Object
  HtmlBody bd = new HtmlBody();
  bd.setBackgroundColor("#fffff2");
  bd.setUnfollowedLinkColor("#cc0000");
  bd.setActivatedLinkColor("#ff3300");
  bd.setFollowedLinkColor("#000055");

  // Creates an HtmlPage object using hd and bd
  HtmlPage hp = new HtmlPage(hd, bd);

  // Creates the table of contents
  DynamicTable tab = new DynamicTable(1);
  tab.setCellSpacing(2);
  tab.setCellPadding(5);
  tab.setBorder(0);

  TableRow rows[] = new TableRow[4];
  for (int i=0; i< 4; i++) {
    rows[i] = new TableRow();
    tab.addRow(rows[i]);
  }

  rows[0]
    .addCell(new TableDataCell(new Link("table",
					new SimpleItem("TABLE handling demo"),
					"content")));
  rows[1]
    .addCell(new TableDataCell(new Link("form",
					new SimpleItem("FORM handling demo"),
					"content")));
  rows[2]
    .addCell(new TableDataCell(new Link("list",
					new SimpleItem("Various LIST handling demo"),
					"content")));
  
  rows[3]
    .addCell(new TableDataCell(new Link("file",
					new SimpleItem("Legacy HTML File handling demo"), 
					"content")));
	
  // add table to HtmlBody
  bd
    .addItem(SimpleItem.HorizontalRule)
    .addItem(SimpleItem.Paragraph)
    .addItem(new SimpleItem("Oracle.HTML Demos").setBold())
    .addItem(SimpleItem.Paragraph)
    .addItem(SimpleItem.HorizontalRule)
    .addItem(tab)
    .addItem(SimpleItem.HorizontalRule)
    .addItem(SimpleItem.Paragraph)
    .addItem(new Link("srcview?filename=toc.java", 
		      new SimpleItem("Click here to view the source code"),
		      "content"))
    .addItem(SimpleItem.Paragraph)
    .addItem(SimpleItem.HorizontalRule);
	     
  // print out header info
  hp.printHeader();
  // print out content
  hp.print();
}

}

