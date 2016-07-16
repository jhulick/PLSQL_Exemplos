/* outstr.c
 * Version 1.0, last updated 8/12/97
 * This file contains the C implementations for all the versions of
 * OutputString, as described in Chapter 20 of _Oracle8 PL/SQL Programming_
 * by Scott Urman.
 */

#include <stdio.h>
#include <oci.h>

/* Outputs the string contained in message to a file specified by path.
   The file will be created if it doesn't exist. */
void OutputString(path, message)
char *path;
char *message;  {

  FILE *file_handle;

  /* Open the file for writing. */
  file_handle = fopen(path, "w");

  /* Output the string followed by a newline. */
  fprintf(file_handle, "%s\n", message);

  /* Close the file. */
  fclose(file_handle);
}


/* Outputs the string contained in message to a file specified by path.
   The message is repeated num_times times.  The file will be created if it
   doesn't exist. */
void OutputString2(path, message, num_times)
char *path;
char *message;
int   num_times;  {

  FILE *file_handle;
  int counter;

  /* Open the file for writing. */
  file_handle = fopen(path, "w");

  for (counter = 0; counter < num_times; counter++)
    /* Output the string followed by a newline. */
    fprintf(file_handle, "%s\n", message);

  /* Close the file. */
  fclose(file_handle);
}


/* Outputs the string contained in message to a file specified by path.
   The message is repeated num_times times.  The file will be created if it
   doesn't exist.  The number of lines actually written is returned in
   num_lines_written.  */
void OutputString3(path, message, num_times, num_lines_written)
char *path;
char *message;
int  num_times;
ub2 *num_lines_written;  {

  FILE *file_handle;
  int counter;

  /* Open the file for writing. */
  file_handle = fopen(path, "w");

  for (counter = 0; counter < num_times; counter++)  {
    /* Output the string followed by a newline. */
    fprintf(file_handle, "%s\n", message);
    (*num_lines_written)++;
  }

  /* Close the file. */
  fclose(file_handle);
}

/* Outputs the string contained in message to a file specified by path.
   The message is repeated num_times times.  The file will be created if it
   doesn't exist.  The number of lines actually written is returned in
   num_lines_written.  The NULL-ness of each parameter is checked.  */
void OutputString4(path, path_ind,
                   message, message_ind,
                   num_times, num_times_ind,
                   num_lines_written)
char *path;
short path_ind;
char *message;
short message_ind;
int   num_times;
short num_times_ind;
ub2  *num_lines_written;  {

  FILE *file_handle;
  int counter;

  /* If any of the input parameters are NULL, return zero and
     don't output anything. */
  if (path_ind == OCI_IND_NULL || message_ind == OCI_IND_NULL ||
      num_times_ind == OCI_IND_NULL) {
    *num_lines_written = 0;
    return;
  }

  /* Open the file for writing. */
  file_handle = fopen(path, "w");

  for (counter = 0; counter < num_times; counter++)  {
    /* Output the string followed by a newline. */
    fprintf(file_handle, "%s\n", message);
    (*num_lines_written)++;
  }

  /* Close the file. */
  fclose(file_handle);
}

/* Outputs the string contained in message to a file specified by path.
   The message is repeated num_times times.  The file will be created if it
   doesn't exist.  The number of lines actually written is returned.
   The NULL-ness of each parameter is checked.  */
ub2 OutputString5(path, path_ind,
                   message, message_ind,
                   num_times, num_times_ind,
                   retval_ind)
char  *path;
short  path_ind;
char  *message;
short  message_ind;
int    num_times;
short  num_times_ind;
short  *retval_ind;  {

  FILE *file_handle;
  ub2 counter;

  /* If any of the input parameters are NULL, return NULL and
     don't output anything. */
  if (path_ind == OCI_IND_NULL || message_ind == OCI_IND_NULL ||
      num_times_ind == OCI_IND_NULL) {
    *retval_ind = OCI_IND_NULL;
    return 0;
  }

  /* Open the file for writing. */
  file_handle = fopen(path, "w");

  for (counter = 0; counter < num_times; counter++)  {
    /* Output the string followed by a newline. */
    fprintf(file_handle, "%s\n", message);
  }

  /* Close the file. */
  fclose(file_handle);

  /* Set up return values. */
  *retval_ind = OCI_IND_NOTNULL;
  return counter;
}

/* Outputs the string contained in message to a file specified by path.
   The message is repeated num_times times.  The file will be created if it
   doesn't exist.  The number of lines actually written is returned.
   The NULL-ness of each parameter is checked, and ORA-6502 is raised if
   and input parameter is NULL.  */
ub2 OutputString6(context, path, path_ind,
                   message, message_ind,
                   num_times, num_times_ind,
                   retval_ind)
OCIExtProcContext *context;
char              *path;
short              path_ind;
char              *message;
short              message_ind;
int                num_times;
short              num_times_ind;
short              *retval_ind;  {

  FILE *file_handle;
  ub2 counter;

  /* If any of the input parameters are NULL, raise ORA-6502 and return
     immediately. */
  if (path_ind == OCI_IND_NULL || message_ind == OCI_IND_NULL ||
      num_times_ind == OCI_IND_NULL) {
    OCIExtProcRaiseExcp(context, 6502);
    return 0;
  }

  /* Open the file for writing. */
  file_handle = fopen(path, "w");

  for (counter = 0; counter < num_times; counter++)  {
    /* Output the string followed by a newline. */
    fprintf(file_handle, "%s\n", message);
  }

  /* Close the file. */
  fclose(file_handle);

  /* Set up return values. */
  *retval_ind = OCI_IND_NOTNULL;
  return counter;
}

/* Outputs the string contained in message to a file specified by path.
   The message is repeated num_times times.  The file will be created if it
   doesn't exist.  The number of lines actually written is returned.
   The NULL-ness of each parameter is checked, and ORA-6502 is raised if
   and input parameter is NULL.  If the file cannot be opened, a user-defined
   error is returned. */
ub2 OutputString7(context, path, path_ind,
                   message, message_ind,
                   num_times, num_times_ind,
                   retval_ind)
OCIExtProcContext *context;
char              *path;
short              path_ind;
char              *message;
short              message_ind;
int                num_times;
short              num_times_ind;
short              *retval_ind;  {

  FILE *file_handle;
  ub2 counter;

  /* If any of the input parameters are NULL, raise ORA-6502 and return
     immediately. */
  if (path_ind == OCI_IND_NULL || message_ind == OCI_IND_NULL ||
      num_times_ind == OCI_IND_NULL) {
    OCIExtProcRaiseExcp(context, 6502);
    return 0;
  }

  /* Open the file for writing. */
  file_handle = fopen(path, "w");

  /* Check for success.  If not, raise an error. */
  if (!file_handle) {
    text *initial_msg = (text *)"Cannot open file ";
    text *error_msg;

    /* Allocate space for the error message text, and set it up.
       We do not have to free this memory - PL/SQL will do that automatically. */
    error_msg = OCIExtProcAllocCallMemory(context,
                  strlen(path) + strlen(initial_msg) + 1);
    strcpy((char *)error_msg, (char *)initial_msg);
    strcat((char *)error_msg, path);

    OCIExtProcRaiseExcpWithMsg(context, 20001, error_msg, 0);
    return 0;
  }
  for (counter = 0; counter < num_times; counter++)  {
    /* Output the string followed by a newline. */
    fprintf(file_handle, "%s\n", message);
  }

  /* Close the file. */
  fclose(file_handle);

  /* Set up return values. */
  *retval_ind = OCI_IND_NOTNULL;
  return counter;
}
