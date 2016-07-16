/* oci.c
 * Version 1.0, last updated 6/11/97
 * This is a complete OCI program which demonstrates how to call a stored
 * procedure, as described in Chapter 13 of _Oracle8 PL/SQL Programming_
 * by Scott Urman.
 */


/* Include the standard header files, plus the OCI headers. */
#include <stdio.h>
#include <oratypes.h>
#include <ocidfn.h>
#include <ociapr.h>

/* Declare an LDA, HDA and CDA for use in later statements. */
Lda_Def lda;
ub1 HDA[512];
Cda_Def cda;

/* Declare the variables which will be used for input. */
char v_Department[4] = "ECN";
int v_Course = 101;
int v_StudentID = 10006;

/* String which contains the block calling Register.
   Note that the return characters are escaped with a
   backslash to keep this all in one C string.  The trailing
   semicolon is included in the string, since it is a
   syntactic part of the block. */
char *plsqlBlock =
  "BEGIN \
       Register(:v_StudentID, :v_Department, :v_Course); \
   END;";

/* User name and password to connect the database. */
char *username = "example";
char *password = "example";


/* Error reporting function.  Uses oerhms to get the full
   error, and prints it to the screen. */
void print_error(Lda_Def *lda, Cda_Def *cda) {
  int v_ReturnChars;
  char v_Buffer[1000];

  v_ReturnChars = oerhms(lda, cda->rc, (text *) v_Buffer,
                         (sword) sizeof(v_Buffer));
  printf("Oracle error occurred!\n");
  printf("%s\n", v_Buffer);
}


main() {
  /* Connect to the database. */
  if (orlon(&lda, HDA, (text *) username, -1,
            (text *) password, -1, 0)) {
    print_error(&lda, &lda);
    exit(-1);
  }
  printf("Connected to Oracle\n");

  /* Open a cursor for later use. */
  if (oopen(&cda, &lda, (text *) 0, -1, -1,
            (text *) 0, -1)) {
    print_error(&lda, &cda);
    exit(-1);
  }

  /* Parse the PL/SQL block. */
  if (oparse(&cda, (text *) plsqlBlock,
             (sb4) -1, 1, (ub4) 2)) {
    print_error(&lda, &cda);
    exit(-1);
  }

  /* Bind the department using type 5, STRING. */
  if (obndrv(&cda, (text *) ":v_Department", -1,
             (ub1 *) v_Department, sizeof(v_Department),
             5, -1, (sb2 *) 0, 0, -1, -1)) {
    print_error(&lda, &cda);
    exit(-1);
  }

  /* Bind the course using type 3, INTEGER. */
  if (obndrv(&cda, (text *) ":v_Course", -1,
            (ub1 *) &v_Course, sizeof(v_Course),
            3, -1, (sb2 *) 0, 0, -1, -1)) {
    print_error(&lda, &cda);
    exit(-1);
  }

  /* Bind the student ID using type 3, INTEGER. */
  if (obndrv(&cda, (text *) ":v_StudentID", -1,
             (ub1 *) &v_StudentID, sizeof(v_StudentID),
             3, -1, (sb2 *) 0, 0, -1, -1)) {
    print_error(&lda, &cda);
    exit(-1);
  }

  /* Execute the statement. */
  if (oexec(&cda)) {
    print_error(&lda, &cda);
    exit(-1);
  }

  /* Commit our work. */
  if (ocom(&lda)) {
    print_error(&lda, &cda);
    exit(-1);
  }

  /* Close the cursor. */
  if (oclose(&cda)) {
    print_error(&lda, &cda);
    exit(-1);
  }

  /* Log off from the database. */
  if (ologof(&lda)) {
    print_error(&lda, &cda);
    exit(-1);
  }
}
