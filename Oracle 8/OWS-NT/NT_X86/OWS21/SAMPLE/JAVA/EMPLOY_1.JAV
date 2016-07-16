/*
**  Copyright (c) 1996 by Oracle Corporation. All rights reserved. 
**    NAME
**      EmployeeReport.java
**    DESCRIPTION
**      
**    RETURNS
** 
**    NOTES
**      
**    MODIFIED   (MM/DD/YY)
**     mfreedma      09/11/96 -  Added Banner
*/

import oracle.rdbms.*; // import Oracle classes which deal with database session
import oracle.plsql.*; // import Oracle classes which deal with PL/SQL
		       // data types
import oracle.html.*;  // import Oracle HTML classes which deal with HTML

public class EmployeeReport {

  public static void main (String args[]) throws HtmlException {

    HtmlHead hd = new HtmlHead("Employee Listing");
    HtmlBody bd = new HtmlBody();
    HtmlPage hp = new HtmlPage(hd, bd);
    hp.printHeader();

    // define Oracle session properties link ORACLE_HOME
    Session.setProperty("ORACLE_HOME", System.getProperty("oracleHome"));
    Session.setProperty("TNS_ADMIN",
                        System.getProperty("oracleHome")
                        + "/network/admin");

    Session session;

    // create a database session and logon
    try {
      session = new Session("scott", "tiger", "HR_DB");
    } catch (ServerException e) {
      bd.addItem(new SimpleItem("Logon fails: " + e.getSqlerrm()));
      hp.print();
      return;
    }

    // create a new instance of Employee package
    Employee employee = new Employee(session);

    // find the department name from the input parameter
    String deptName = null;
    if ((args.length < 1) || !args[0].startsWith("DEPT=")) {
      bd.addItem(new SimpleItem("No department name given"));
      hp.print();
      return;
    } else {
      deptName = args[0].substring(5);
    }

    // create objects to encapsulate PL/SQL values that are
    // used as parameters
    PStringBuffer pDeptName = new PStringBuffer(30, deptName);
    PStringBuffer pEmployeeName[];
    PDouble       pEmployeeNumber[];
    PDouble	  pEmployeeCount;

    // print report header
    bd.addItem("Department " + pDeptName + ":")
      .addItem(SimpleItem.Paragraph);

    // call Employee package to count the number of employees in
    // the department
    try {
      pEmployeeCount = employee.count_employees(pDeptName);
    } catch (ServerException e) {
      bd.addItem("Fail to retrieve employee information for department " +
 		 deptName + ": " + e.getSqlerrm());
      hp.print();
      return;
    }
    int employeeCount = (int)pEmployeeCount.doubleValue();
    if (employeeCount == 0) {
      bd.addItem("No employee found under department " + deptName);
      hp.print();
      return;
    }

    // allocate the arrays for employee names and numbers
    pEmployeeName     = new PStringBuffer[employeeCount];
    pEmployeeNumber   = new PDouble[employeeCount];

    // allocate the buffers to retrieve employee information
    for(int i = 0; i < employeeCount; i++) {
      // max length of employee name is 30 (characters)
      pEmployeeName[i]   = new PStringBuffer(30);
      pEmployeeNumber[i] = new PDouble();
    }

    // call Employee package to look up employees in the dept
    try {
      employee.list_employees(pDeptName, pEmployeeName, pEmployeeNumber);
    } catch (ServerException e) {
      bd.addItem("Fail to retrieve employee information for department " +
 		 deptName + ": " + e.getSqlerrm());
      hp.print();
      return;
    }

    // generate report
    DynamicTable tab = new DynamicTable(2);
    TableRow row = new TableRow();
    row.addCell(new TableHeaderCell("Employee Name"))
       .addCell(new TableHeaderCell("Employee Number"));
    tab.addRow(row);

    for (int i = 0; i < employeeCount; i++) {
      row = new TableRow();
      if (pEmployeeNumber[i].isNull())
 	row.addCell(new TableDataCell(pEmployeeName[i].toString()))
 	   .addCell(new TableDataCell("new employee"));
      else
 	row.addCell(new TableDataCell(pEmployeeName[i].toString()))
	   .addCell(new TableDataCell(pEmployeeNumber[i].toString()));
      tab.addRow(row);
    }
    hp.addItem(tab);
    hp.print();

    // logoff from database
    try {
      session.logoff();
    } catch (ServerException e) {}
    
  }
}
