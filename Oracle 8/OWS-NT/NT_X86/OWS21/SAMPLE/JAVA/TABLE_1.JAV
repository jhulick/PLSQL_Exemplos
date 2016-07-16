/*
**  Copyright (c) 1996 by Oracle Corporation. All rights reserved.
**    NAME
**      table.java
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
import java.util.*;
import java.io.*;
import java.lang.*;

//
// This simple sample demonstrates the table handling capability
// of package oracle.html. 
// 
public
class table {

  // main: the entry point of this program
public static void main(String args[]) 
  
{
  // Creates an HtmlHead Object titled "Table Sample"
  HtmlHead hd = new HtmlHead("Table Sample");
  // Adds Expiration Date
  hd.addMetaInfo(new MetaInfo("Expires", "Sunday, 27 June 1996"));

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
  bd.addItem(new banner("Table Handling in Oracle.html"));

  // Creates the table 
  DynamicTable tab = new DynamicTable(3);
  tab.setCaption("Table Sample");

  TableRow[] rows = new TableRow[2];
  
  for (int i=0; i< 2; i++)
    rows[i] = new TableRow();

  rows[0]
    .addCell(new TableDataCell(new SimpleItem("first cell").setBold().setItal()))
    .addCell(new TableDataCell(new SimpleItem("second cell").setItal()))
    .addCell(new TableDataCell(new SimpleItem("third cell").setBold()));

  rows[1]
    .addCell
    (new TableDataCell
     (new Link("list", 
             new SimpleItem("Go to LIST Samples"))))
    .addCell
    (new TableDataCell
     (new Link("form",
	       new SimpleItem("Go to FORM Samples"))))
    .addCell
    (new TableDataCell
     (new OrderedList()
      .addItem(new SimpleItem("1st item"))
      .addItem(new SimpleItem("2nd item"))));


  for (int i=0; i<2; i++)
    tab.addRow(rows[i]);

  // add the table to HtmlBody
  bd.addItem(tab);

  // add the string representation of table to HtmlBody
  bd.addItem(SimpleItem.Paragraph)
    .addItem(SimpleItem.HorizontalRule)
    .addItem(SimpleItem.Paragraph)
    .addItem("Although it's getting rare, there are still browsers which cannot handle tables. In such cases, this package will automatically generate a <b>string</b> equivalent of the table and send it to the browser.")
    .addItem(SimpleItem.LineBreak)
    .addItem("For this particular table, the following would be the result:")
    .addItem(SimpleItem.Paragraph)
    .addItem(new Preformat().addItem(new SimpleItem(tab.toString())));

  // add trailer to HtmlBody
  bd.addItem(new trailer("table.java"));

  // print out the header information
  hp.printHeader();
  // print out the content of this page
  hp.print();
}

}

