/*
**  Copyright (c) 1996 by Oracle Corporation. All rights reserved. 
**    NAME
**      file.java
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
import java.io.*;


//
// This simple demo demonstrates the legacy HTML file handling capability
// of package oracle.html. 
// 
class file {

public static void main (String args[]) {
  DynamicTable tab = new DynamicTable(2);
  TableRow[] rows = new TableRow[2];
  rows[0] = new TableRow();
  rows[1] = new TableRow();
  tab.addRow(rows[0]).addRow(rows[1]);
  rows[0]
    .addCell(new TableDataCell("cell11"))
    .addCell(new TableDataCell("cell12"));
  rows[1]
    .addCell(new TableDataCell("cell21"))
    .addCell(new TableDataCell("cell22"));
  
  File file = new File(System.getProperty("ORACLE_HOME") + "\\ows21\\sample\\java\\sample.html");
  HtmlPage fp = new HtmlPage(file);
  fp.setItemAt("table1", tab);
  fp.printHeader();
  fp.print();
}
}
