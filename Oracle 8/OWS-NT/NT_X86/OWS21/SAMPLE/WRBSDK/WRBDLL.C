/* Copyright (c) 1995 by Oracle Corporation */

/*
   NAME
     sndwdll.c	- NDWOADM DLL Main function

   DESCRIPTION
     This file holds the dll main function

   PUBLIC FUNCTION(S)
     None.

   PRIVATE FUNCTION(S)
     None.

   RETURNS
     N/A

   NOTES
        

   MODIFIED   (MM/DD/YY)
    eesselin   29/MAR/96 -  Created

*/

/* 
 * Include header files for other packages that you depend on here.     *
 */

#ifndef _DLL
#error This file is for DLL's only !
#endif

#include <windows.h>

/****************************************************************************
   FUNCTION: DllMain(HANDLE, DWORD, LPVOID)

   PURPOSE:  DllMain is called by Windows when
             the DLL is initialized, Thread Attached, and other times.
             Refer to SDK documentation, as to the different ways this
             may be called.
             
             The DllMain function should perform additional initialization
             tasks required by the DLL.  In this example, no initialization
             tasks are required.  DllMain should return a value of 1 if
             the initialization is successful.
           
*******************************************************************************/
BOOL APIENTRY DllMain(HANDLE hInst, DWORD ul_reason_being_called, LPVOID lpReserved)
{
    return 1;
        UNREFERENCED_PARAMETER(hInst);
        UNREFERENCED_PARAMETER(ul_reason_being_called);
        UNREFERENCED_PARAMETER(lpReserved);
}

