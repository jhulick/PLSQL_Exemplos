/*
**  Copyright (c) 1996 by Oracle Corporation. All rights reserved.
**    NAME
**      mywrbapp.c
**    DESCRIPTION
**      
**    RETURNS
** 
**    NOTES
**      
**    MODIFIED   (MM/DD/YY)
**     mfreedma      09/11/96 -  Added Banner 
*/

#include "mywrbapp.h"

#ifdef DEBUG
static char debug[1024];
#endif

/*
 * forward declarations
 */
WRBReturnCode newUser(myappctx *ctx, void *WRBCtx);

WRBReturnCode getUserData(myappctx *ctx, void *WRBCtx);

WRBReturnCode editUserData(myappctx *ctx, void *WRBCtx);

WRBReturnCode getCatalog(myappctx *ctx, void *WRBCtx);

WRBReturnCode placeOrder(myappctx *ctx, void *WRBCtx);

WRBReturnCode confirmOrder(myappctx *ctx, void *WRBCtx);

WRBReturnCode addUser(const datablock* newdata, myappctx* ctx,
  void *WRBCtx);

WRBReturnCode rehash(const char *oldname, const datablock* newdata,
  myappctx* ctx, void *WRBCtx);

WRBReturnCode formatUserData(const datablock *data, myappctx *ctx,
  void *WRBCtx);

void userDataError(const char *message, const char *URL, myappctx *ctx,
  void *WRBCtx);

WRBReturnCode storeInfo(const char* user, myappctx *ctx, void *WRBCtx);

datablock *getDataBlock(const char *user, myappctx *ctx, void *WRBCtx);

WRBReturnCode formatOrder(const boolean invoice, myappctx *ctx,
  void *WRBCtx);

boolean taxable(char *user, myappctx *ctx, void *WRBCtx);

int itemcmp(const void* item1, const void* item2);

myappctx *mapdata(const int fd, myappctx *ctx, void *WRBCtx);

WRBReturnCode remapdata(myappctx *ctx, void *WRBCtx);

WRBReturnCode growdata(myappctx *ctx, void *WRBCtx);

/*
 * MyWRBApp_Entry--sets up WRBCallbacks dispatch table so the WRB 
 * application engine can call this app's cartridge functions
 */
WRBReturnCode
MyWRBApp_Entry(WRBCallbacks *WRBCalls)
{
	WRBCalls->init_WRBCallback = MyWRBApp_Init;
	WRBCalls->authorize_WRBCallback = MyWRBApp_Authorize;
	WRBCalls->exec_WRBCallback = MyWRBApp_Exec;
	WRBCalls->shut_WRBCallback = MyWRBApp_Shutdown;
	WRBCalls->reload_WRBCallback = MyWRBApp_Reload;
	/* Version and Version_Free currently not implemented */

	return (WRB_DONE);
}

/*
 * MyWRBApp_Init--sets up this application in preparation for
 * handling client requests. Opens (or creates) the datafile
 * and maps it into memory.
 */
WRBReturnCode
MyWRBApp_Init(void *WRBCtx, void **appCtx)
{
	int fd;
	myappctx *ctx;
	char datafile[256];
	char *ohome;
	
	ohome = WRBGetORACLE_HOME(WRBCtx);
	sprintf(datafile, "%s/ows21/sample/wrbsdk/mywrbapp/datafile", ohome);
	fd = open(datafile, O_CREAT | O_RDWR, 0664);
	if (fd == -1) {
		/* bad news--can't get to datafile--shut down app */
#ifdef DEBUG
		sprintf(debug, "MyWRBApp_Init: failed to open datafile: %s",
		  strerror(errno));
		WRBLogMessage(WRBCtx, debug, 1);
#endif
		return (WRB_ABORT);
	}

	/* map datafile into memory */
	if (!(ctx = mapdata(fd, NULL, WRBCtx))) {
		return (WRB_ABORT);
	}

	/* allocate order items array */
	ctx->items = (orderitem *)malloc((MAXITEMS + 1) * sizeof(orderitem));
	ctx->numitems = 0;

	/* load configuration parameters */
	MyWRBApp_Reload(WRBCtx, ctx);

#ifdef DEBUG
	sprintf(debug, "MyWRBApp_Init: context structure fields are:");
	WRBLogMessage(WRBCtx, debug, 1);
	sprintf(debug, "table: %X\nfirstfree: %X\ndatacount: %X\ndatablocks: %X",
	  ctx->table, ctx->firstfree, ctx->datacount, ctx->datablocks);
	WRBLogMessage(WRBCtx, debug, 1);
	sprintf(debug, "datafd: %d\nend: %u\nitems: %X\nnumitems: %d",
	  ctx->datafd, ctx->end, ctx->items, ctx->numitems);
	WRBLogMessage(WRBCtx, debug, 1);
#endif

	/* pass back context pointer to WRB application engine */
	*appCtx = ctx;

	return (WRB_DONE);
}

/*
 * MyWRBApp_Shutdown--frees resources in preparation for termination.
 * Unmaps and closes the datafile
 */
WRBReturnCode
MyWRBApp_Shutdown(void *WRBCtx, void *appCtx)
{
	myappctx *ctx = (myappctx *)appCtx;

	WRLOCK(FILE_START, FILE_SIZE, ctx)
	
	/* sync data file */
	msync((char *)ctx->table, ctx->end, MS_SYNC | MS_INVALIDATE);

	UNLOCK(ctx)

	/* unmap and close data file */
	munmap((char *)ctx->table, ctx->end);
	close(ctx->datafd);

	/* free items array and context structure */
	free(ctx->items);
	free(ctx);

	return (WRB_DONE);
}

/*
 * MyWRBApp_Authorize--before servicing a request, this function checks
 * whether the client is authorized to issue the request
 */
WRBReturnCode
MyWRBApp_Authorize(void *WRBCtx, void *appCtx, boolean *bAuthorized)
{
	char *URL, *req, *user, *password;
	datablock *data;
	myappctx *ctx = (myappctx *)appCtx;
	int cmp;

	/* get request URL */
	URL = WRBGetURL(WRBCtx);
	URL = strdup(URL);		/* copy to local memory */
#ifdef DEBUG
	sprintf(debug, "MyWRBApp_Authorize: Request URL is: %s", URL);
	WRBLogMessage(WRBCtx, debug, 1);
#endif

	/* last path element defines request name */
	req = strrchr(URL, '/');
	req++;
	if (!strncmp(req, "newuser", 7)) {
		/* client is creating a new account, and is therefore authorized */
		*bAuthorized = TRUE;
		return (WRB_DONE);
	}

	/*
	 * set up a new basic authentication realm called "MyWRBApp"
	 * and share it with the client
	 */
	WRBSetAuthorization(WRBCtx, WRB_AUTH_BASIC_NEW, "MyWRBApp", FALSE);

	/* get the username provided by the client */
	user = WRBGetUserID(WRBCtx);
	if (!user) {
		/*
		 * This is probably the client's first call to this app--
		 * Just return normally with authorization failed
		 */
		*bAuthorized = FALSE;
#ifdef DEBUG
		sprintf(debug,
		  "MyWRBApp_Authorize: WRBGetUserID failed");
		WRBLogMessage(WRBCtx, debug, 1);
#endif
		return (WRB_DONE);
	}

	/* copy username to local memory */
	user = strdup(user);

	/* get data block for this user */
	data = getDataBlock(user, ctx, WRBCtx);
	if (!data) {
		/* unknown user - not authorized */
		*bAuthorized = FALSE;
#ifdef DEBUG
		sprintf(debug, "MyWRBApp_Authorize: unknown user %s not authorized",
		  user);
		WRBLogMessage(WRBCtx, debug, 1);
#endif
		return(WRB_DONE);
	}

	/* get the password provided by the client and copy to local memory */
	password = WRBGetPassword(WRBCtx);
	password = strdup(password);

	RDLOCK(DBLOCK_OFF(data, ctx), sizeof(datablock), ctx)

	/* compare stored password with password given */
	cmp = strcmp(password, /* XXX decrypt(*/data->password/*)*/);

	UNLOCK(ctx)

	if (!cmp) {
		*bAuthorized = TRUE;
	}
	else {
		*bAuthorized = FALSE;
#ifdef DEBUG
		sprintf(debug,
		  "MyWRBApp_Authorize: user %s gave an incorrect password: %s",
		  user, password);
		WRBLogMessage(WRBCtx, debug, 1);
#endif
	}

	return(WRB_DONE);
}

/*
 * MyWRBApp_Exec--handles incoming requests. The request is determined by
 * the last element in the URL
 */
WRBReturnCode
MyWRBApp_Exec(void *WRBCtx, void *appCtx)
{
	char *URL, *req;
	myappctx *ctx = (myappctx *)appCtx;

	/* get request URL */
	URL = WRBGetURL(WRBCtx);
	URL = strdup(URL);

	/* last path element defines request name */
	req = strrchr(URL, '/');
	req++;

#ifdef DEBUG
	sprintf(debug, "MyWRBApp_Exec: request is %s", req);
	WRBLogMessage(WRBCtx, debug, 1);
#endif

	if (!strncmp(req, "newuser", 7)) {
		return (newUser(ctx, WRBCtx));
	}
	else if (!strncmp(req, "getuserdata", 11)) {
		return (getUserData(ctx, WRBCtx));
	}
	else if (!strncmp(req, "edituserdata", 12)) {
		return (editUserData(ctx, WRBCtx));
	}
	else if (!strncmp(req, "getcatalog", 10)) {
		return(getCatalog(ctx, WRBCtx));
	}
	else if (!strncmp(req, "placeorder", 10)) {
		return(placeOrder(ctx, WRBCtx));
	}
	else if (!strncmp(req, "confirm", 7)) {
		return(confirmOrder(ctx, WRBCtx));
	}

	/* bad URL--send HTTP error */
	WRBReturnHTTPError(WRBCtx, (WRBErrorCode)400, NULL, TRUE);

	return(WRB_DONE);
}

/*
 * MyWRBApp_Reload--loads cartridge configuration data
 */
WRBReturnCode
MyWRBApp_Reload(void* WRBCtx, void *appCtx)
{
	myappctx *ctx = (myappctx*)appCtx;
	char *tax;
	char *cp;

	/* get configuration parameters */
	ctx->state = WRBGetConfigVal(WRBCtx, "state");
	tax = WRBGetConfigVal(WRBCtx, "tax");

	if (tax) {
		/* remove percent sign from tax, if any */
		cp = strchr(tax, '%');
		if (cp) {
			cp = '\0';
		}
		ctx->taxpct = atof(tax);
	}
	else {
		ctx->taxpct = (double)0;
	}

	return (WRB_DONE);
}

/*
 * newUser--handles "newuser" requests.
 */
WRBReturnCode
newUser(myappctx *ctx, void *WRBCtx)
{
	char *user, *password, *confirm, *cp;
	boolean confirmed;
	datablock newdata;
	WRBReturnCode ret;
	WRBEntry *entries;
	int numentries;
	char wbuf[1024];
	int len;

	/* get username from form data */
	WRBGetParsedContent(WRBCtx, &entries, &numentries);
	user = WRBGetNamedEntry("username", entries, numentries);

	/* check whether this name is in use */
	if (getDataBlock(user, ctx, WRBCtx)) {
		/*
		 * The given username is already in use--
		 * respond with an error page
		 */
		userDataError("The username you entered is already registered to another user. Please choose another username.",
		  "/sample/wrbsdk/mywrbapp/newuser.html", ctx, WRBCtx);

		return (WRB_DONE);
	}

	/* start filling in newdata */
	strcpy(newdata.username, user);

	/* get password from form data */
	password = WRBGetNamedEntry("password", entries, numentries);

	/* get password confirmation and compare with password */
	confirm = WRBGetNamedEntry("confirm", entries, numentries);
	if (!strcmp(password, confirm)) {
		/* password and confirmation string match--fill in password */
		confirmed = TRUE;
		strcpy(newdata.password, password);		/* XXX encrypt? */
	}
	else {
		/* they don't match--null out password for now */
		confirmed = FALSE;
		newdata.password[0] = '\0';
	}

	/* add this user to the datafile */
	ret = addUser(&newdata, ctx, WRBCtx);
	if (ret != WRB_DONE) {
		return (ret);
	}

	ret = storeInfo(user, ctx, WRBCtx);
	if (ret != WRB_DONE) {
		return (ret);
	}

	if (!confirmed) {
		/*
		 * confirmation doesn't match password--generate error page
		 */
		userDataError("The password you entered does not match your confirmation string. Please reenter your password",
		  "/mywrbapp/bin/getuserdata", ctx, WRBCtx);

		return (WRB_DONE);
	}

	/* done--go to catalog */
	return (getCatalog(ctx, WRBCtx));
}

/*
 * getUserData--handles getuserdata requests.
 */
WRBReturnCode
getUserData(myappctx *ctx, void *WRBCtx)
{
	char *user;
	datablock *data;
	WRBReturnCode ret;

	/* get name of currently authenticated user */
	user = WRBGetUserID(WRBCtx);
	user = strdup(user);
	if (!user) {
		/* this shouldn't happen--Authorize has already been called */
		return (WRB_ERROR);
	}

	/* get datablock for this user */
	data = getDataBlock(user, ctx, WRBCtx);
	if (!data) {
		/*
		 * this shouldn't happen--if the user is authenticated, there
		 * should be a datablock
		 */
		return (WRB_ERROR);
	}

	RDLOCK(DBLOCK_OFF(data, ctx), sizeof(datablock), ctx)

	/* fill in HTML form template and write it to the client */
	ret = formatUserData(data, ctx, WRBCtx);

	UNLOCK(ctx)

	return (ret);
}

/*
 * editUserData--handles edituserdata requests
 */
WRBReturnCode
editUserData(myappctx *ctx, void *WRBCtx)
{
	char *user, *password, *confirm;
	boolean confirmed, nameInUse = FALSE;
	char wbuf[1024];
	int len;
	datablock newdata;
	datablock *data;
	WRBEntry *entries;
	int numentries;

	/* get data from form */
	WRBGetParsedContent(WRBCtx, &entries, &numentries);
	user = WRBGetNamedEntry("username", entries, numentries);
	password = WRBGetNamedEntry("password", entries, numentries);

	/* get password confirmation and compare with password */
	confirm = WRBGetNamedEntry("confirm", entries, numentries);
	if (!strcmp(password, confirm)) {
		/* password and confirmation string match */
		confirmed = TRUE;
	}
	else {
		confirmed = FALSE;
	}
		
	/* look up currently authenticated user */
	data = getDataBlock(WRBGetUserID(WRBCtx), ctx, WRBCtx);

	/*
	 * has the user changed his/her username?
	 * if so, and the new name is not in use, rehash datablock
	 */

	RDLOCK(DBLOCK_OFF(data, ctx), sizeof(datablock), ctx)

	if (strcmp(user, data->username)) {
		/* new usernamee */
		if (!getDataBlock(user, ctx, WRBCtx)) {
			/* new username not in use--copy it to newdata */
			nameInUse = FALSE;
			strcpy(newdata.username, user);
		}
		else {
			/* new name is not in use--leave username unchanged */
			nameInUse = TRUE;
			strcpy(newdata.username, data->username);
		}

#ifdef DEBUG
		sprintf(debug, "editUserData: old username: %s\n\tnew username %s",
		  data->username, user);
		WRBLogMessage(WRBCtx, debug, 1);
#endif

		if (confirmed) {
			strcpy(newdata.password, password);		/* XXX encrypt? */
		}
		else {
			/* confirmation failed--leave password unchanged */
			strcpy(newdata.password, data->password);
		}

		if (rehash(data->username, &newdata, ctx, WRBCtx) != WRB_DONE) {
			UNLOCK(ctx)

			return (WRB_ERROR);
		}
	}
	else {
		UPGRADE(ctx)

		/* change password only if confirmation matched password */
		if (confirmed) {
			strcpy(data->password, password);		/* XXX encrypt? */
		}

		/* sync datafile */
		msync((char *)ctx->table, ctx->end, MS_SYNC | MS_INVALIDATE);

		DOWNGRADE(ctx)
	}

	/* store the rest of the form data */
	storeInfo(data->username, ctx, WRBCtx);

	UNLOCK(ctx)

	if (nameInUse) {
		/* specified username is already in use--generate error page */
		userDataError("The username you entered is already registered to another user. Please choose another username.",
		  "/mywrbapp/bin/getuserdata", ctx, WRBCtx);

		return (WRB_DONE);
	}

	if (!confirmed) {
		/* confirmation doesn't match password--generate error page */
		userDataError("The password you entered does not match your confirmation string. Please reenter your password",
		  "/mywrbapp/bin/getuserdata", ctx, WRBCtx);

		return (WRB_DONE);
	}

	/* done--go to catalog */
	return(getCatalog(ctx, WRBCtx));
}

/*
 * getCatalog--handles getcatalog requests
 */
WRBReturnCode
getCatalog(myappctx *ctx, void *WRBCtx)
{
	FILE *cat;
	char buf[1024];
	char wbuf[1024];
	int len;
	char *cp, *tp;
	char part[PARTNUMLEN + 1];
	char qty[5] = "\0";
	char *qp;
	char catfile[256];
	char *ohome;

	/* open catalog */
	ohome = WRBGetORACLE_HOME(WRBCtx);
	sprintf(catfile, "%s/ows21/sample/wrbsdk/mywrbapp/catalog.txt", ohome);
	cat = fopen(catfile, "r");
	if (!cat) {
#ifdef DEBUG
		sprintf(debug, "getCatalog: failed to open catalog: %s",
		  strerror(errno));
		WRBLogMessage(WRBCtx, debug, 1);
#endif
		return (WRB_ABORT);
	}

	/* start generating HTML for the client */
	WRBClientWrite(WRBCtx, "Content-type: text/html\n\n", 25);

	len = sprintf(wbuf,
	  "<HTML><HEAD><TITLE>Hot Goods Catalog</TITLE></HEAD>\n");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "<BODY BGCOLOR=\"FFFFFF\">\n");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "<H1>Hot Goods Catalog</H1>\n");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf,
	  "<FORM ACTION=\"/mywrbapp/bin/placeorder\" METHOD=\"POST\">\n");
	WRBClientWrite(WRBCtx, wbuf, len);

	/* get cookie from the client */
	cp = WRBGetEnvironmentVariable(WRBCtx, "HTTP_COOKIE");
#ifdef DEBUG
	if (!cp) {
		WRBLogMessage(WRBCtx, "getCatalog: no cookie found", 0);
	}
#endif

	/*
	 * Loop through the catalog generating HTML for each line--
	 * for each part number listed in the catalog, check the 
	 * cookie to see if the user has already entered an order quantity
	 * for the item
	 */
	while (fgets(buf, 1024, cat)) {
		/* write the description line to the client */
		WRBClientWrite(WRBCtx, "<P>", 3);
		WRBClientWrite(WRBCtx, buf, strlen(buf));
		WRBClientWrite(WRBCtx, "</P>\n<P>", 8);

		/* get part number line and write it out without the newline */
		fgets(buf, 1024, cat);
		WRBClientWrite(WRBCtx, buf, strlen(buf) - 1);

		/* the part number is the first PARTNUMLEN chars of buf */
		strncpy(part, buf, PARTNUMLEN);
		part[PARTNUMLEN] = '\0';

		if (tp = cp) {
			/* search through cookie for part number */
			qp = qty;
			while (tp) {
				if (!strncmp(tp, part, PARTNUMLEN)) {
					/* found part number--now get quantity */
					tp = strchr(tp, '=');
					tp++;
					while (*tp && (*tp != ';')) {
						*qp++ = *tp++;
					}
					break;
				}
				tp = strchr(tp, ';');
				if (tp) {
					tp += 2;
				}
			}
			*qp = '\0';
		}

		/*
		 * complete the HTML line with an input box and set its value to
		 * the quantity stored in the cookie (if any)
		 */
		len = sprintf(wbuf,
		  " Order quantity: <INPUT TYPE=\"text\" NAME=\"%s\" ", part);
		WRBClientWrite(WRBCtx, wbuf, len);

		len = sprintf(wbuf, "SIZE=\"4\" VALUE=\"%s\"></P>\n", qty);
		WRBClientWrite(WRBCtx, wbuf, len);
	}

	/* finish HTML page */
	len = sprintf(wbuf, "<INPUT TYPE=\"submit\" NAME=\"submit\" ");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "VALUE=\"Place Order\">\n");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "</FORM>\n</BODY>\n</HTML>");
	WRBClientWrite(WRBCtx, wbuf, len);

	fclose(cat);
	return (WRB_DONE);
}

/*
 * placeOrder--handles placeorder requests
 */
WRBReturnCode
placeOrder(myappctx *ctx, void *WRBCtx)
{
	WRBReturnCode ret;
	WRBEntry *entries;
	int numentries, item, ent;
	char wbuf[1024];
	int len;
	char *cp, *tp;
	char *qp;
	orderitem *items;

	item = 0;
	items = ctx->items;

	/* get cookie from the client */
	cp = WRBGetEnvironmentVariable(WRBCtx, "HTTP_COOKIE");
	if (cp) {
		/* put cookie name-value pairs into items array */
		tp = cp;
		while (item < MAXITEMS) {
			/*
			 * include only names that start with a part number
			 */
			if (isdigit(*tp)) {
				strncpy(items[item].partnum, tp, PARTNUMLEN);
				items[item].partnum[PARTNUMLEN] = '\0';

				/* the value is the order quantity */
				tp = strchr(tp, '=');
				tp++;
				qp = items[item].qty;
				while (*tp && (*tp != ';')) {
					*qp++ = *tp++;
				}
				*qp = '\0';
				item++;
			}
			else {
				/* not a numeric name--skip this name-value pair */
				tp = strchr(tp, ';');
			}
			if (!tp || (*tp == '\0')) {
				/* reached the end of the cookie */
				break;
			}
			tp += 2;
		}
	}
#ifdef DEBUG
	else {
		WRBLogMessage(WRBCtx, "placeOrder: no cookie found", 0);
	}
#endif

	/* save number of items found in cookie */
	ctx->numitems = item;
#ifdef DEBUG
	sprintf(debug, "placeOrder: numitems: %d", ctx->numitems);
	WRBLogMessage(WRBCtx, debug, 1);
#endif

	/* get form data */
	WRBGetParsedContent(WRBCtx, &entries, &numentries);
	for (ent = 0; ent < numentries; ent++) {
		/*
		 * for each name-value pair from the form, search through
		 * part numbers found in the cookie for a duplicate--
		 * if found, replace the cookie data with the form data
		 */
		for (item = 0; item < ctx->numitems; item++) {
			if (!strcmp(entries[ent].name, items[item].partnum)) {
				/* found a duplicate */
				strcpy(items[item].partnum, entries[ent].name);
				strcpy(items[item].qty, entries[ent].value);
				entries[ent].name[0] = '\0';
				entries[ent].value[0] = '\0';
				break;
			}
		}
	}

	/* transfer any remaining form data to items array */
	item = ctx->numitems; /* take up where we left off */
	for (ent = 0; (ent < numentries) && (item < MAXITEMS); ent++) {
		if (isdigit(entries[ent].name[0]) && entries[ent].value[0] &&
		  strcmp(entries[ent].value, "0")) {
			/* the name is a part number with a non-zero value (quantity) */
			strcpy(items[item].partnum, entries[ent].name);
			strcpy(items[item].qty, entries[ent].value);
			item ++;
		}
	}
	ctx->numitems = item;

#ifdef DEBUG
	sprintf(debug, "placeOrder: numitems: %d", ctx->numitems);
	WRBLogMessage(WRBCtx, debug, 1);
#endif

	/* sort items array */
	qsort(items, ctx->numitems, sizeof(orderitem), itemcmp);

	/* begin writing response page */
	WRBClientWrite(WRBCtx, "Content-type: text/html\n", 24);
	item = 0;

	/* write cookie data */
	while (item < ctx->numitems) {
		if (items[item].qty[0] && strcmp(items[item].qty, "0")) {
			/* item has non-zero quantity--put it in the cookie */
			len = sprintf(wbuf, "Set-Cookie: %s=%s; path=/\n",
			  items[item].partnum, items[item].qty);
			WRBClientWrite(WRBCtx, wbuf, len);
		}
		else {
			/*
			 * the item has a zero quantity--delete it from the cookie
			 * by setting past expiration date
			 */
			len = sprintf(wbuf,
			  "Set-Cookie: %s=0; path=/; ", items[item].partnum);
			WRBClientWrite(WRBCtx, wbuf, len);

			len = sprintf(wbuf, 
			  "expires=Monday, 01-Jan-96 00:00:00 GMT\n");
			WRBClientWrite(WRBCtx, wbuf, len);
		}
		item++;
	}

	/* remember the empty line before "<HTML>" */
	WRBClientWrite(WRBCtx, "\n", 1);

	if (item >= MAXITEMS) {
		/* XXX orders array maxed out--write warning message */
	}

	len = sprintf(wbuf, "<HTML><HEAD><TITLE>Order Form</TITLE></HEAD>\n");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "<BODY BGCOLOR=\"FFFFFF\">\n");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "<H1>Placing an Order</H1>\n");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf,
	  "<P>These are the items and the quantities you have selected. ");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf,
	  "To change the quantity of an item you want to order, ");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf,
	  "just change the value in the quantity box for that item. ");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, 
	  "If you decide you don't want to order an item after all, ");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf,
	  "just delete the contents of the item's quantity box. ");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, 
	  "To add more items to your order, you can ");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf,
	  "<A HREF=\"/mywrbapp/bin/getcatalog\">return to the catalog</A>.</P>\n");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "<FORM ACTION=\"/mywrbapp/bin/confirm\">\n");
	WRBClientWrite(WRBCtx, wbuf, len);

	/* write out the ordered items */
	ret = formatOrder(FALSE, ctx, WRBCtx);
	if (ret != WRB_DONE) {
		return (WRB_ERROR);
	}

	len = sprintf(wbuf, "<INPUT TYPE=\"submit\" VALUE=\"Confirm Order\">\n");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "</FORM>\n</BODY>\n</HTML>\n");
	WRBClientWrite(WRBCtx, wbuf, len);

	return (WRB_DONE);
}

/*
 * confirmOrder--handles confirm requests
 */
WRBReturnCode
confirmOrder(myappctx *ctx, void *WRBCtx)
{
	WRBReturnCode ret;
	WRBEntry *entries;
	int numentries, item, ent;
	char wbuf[1024];
	int len;
	char *cp, *tp;
	char part[PARTNUMLEN + 1];
	orderitem *items;

	/* begin response */
	WRBClientWrite(WRBCtx, "Content-type: text/html\n", 24);

	/* get cookie from the client */
	cp = WRBGetEnvironmentVariable(WRBCtx, "HTTP_COOKIE");
	if (cp) {
		/*
		 * the order is now placed--delete cookie entries by setting
		 * past expiration date
		 */
		tp = cp;
		while (tp && *tp) {
			if (isdigit(*tp)) {
				/* this name-value pair is an order item--delete it */
				strncpy(part, tp, PARTNUMLEN);
				part[PARTNUMLEN] = '\0';

				len = sprintf(wbuf, "Set-Cookie: %s=0; path=/; ", part);
				WRBClientWrite(WRBCtx, wbuf, len);

				len = sprintf(wbuf, "expires=Monday, 01-Jan-96 00:00:00 GMT\n");
				WRBClientWrite(WRBCtx, wbuf, len);
			}

			/* find the next name-value pair */
			tp = strchr(tp, ';');
			if (!tp) {
				/* reached the end of the cookie */
				break;
			}
			tp += 2;
		}
	}

	/* remember the blank line */
	WRBClientWrite(WRBCtx, "\n", 1);

	len = sprintf(wbuf, "<HTML><HEAD><TITLE>Thank You</TITLE></HEAD>\n");
	WRBClientWrite(WRBCtx, wbuf, len);
	len = sprintf(wbuf, "<BODY BGCOLOR=\"FFFFFF\">\n");
	WRBClientWrite(WRBCtx, wbuf, len);
	len = sprintf(wbuf, "<H1>Thank you for your order</H1>\n");
	WRBClientWrite(WRBCtx, wbuf, len);
	len = sprintf(wbuf,
	  "<P>These are the items and the quantities you have ordered.</P>\n");
	WRBClientWrite(WRBCtx, wbuf, len);

	/* get form data and fill in ordered items array */
	WRBGetParsedContent(WRBCtx, &entries, &numentries);
	items = ctx->items;
	item = 0;
	for (ent = 0; (ent < numentries) && (item < MAXITEMS); ent++) {
		if (isdigit(entries[ent].name[0]) && entries[ent].value[0]) {
			strcpy(items[item].partnum, entries[ent].name);
			strcpy(items[item].qty, entries[ent].value);
			item ++;
		}
	}
	ctx->numitems = item;

	/* write out the order summary and total by setting invoice to TRUE */
	ret = formatOrder(TRUE, ctx, WRBCtx);
	if (ret != WRB_DONE) {
		return (WRB_ERROR);
	}

	len = sprintf(wbuf,
	  "<P><A HREF=\"/mywrbapp/bin/getcatalog\">Return to the catalog");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "</A>.</P>\n</BODY>\n</HTML>\n");
	WRBClientWrite(WRBCtx, wbuf, len);

	return (WRB_DONE);
}

/*
 * addUser--allocates a new datablock in the datafile, fills it with the
 * data passed in newdata, and links it into the hash table
 */
WRBReturnCode
addUser(const datablock* newdata, myappctx* ctx, void *WRBCtx)
{
	unsigned hashval, idx;
	char *cp;
	datablock *data;

	WRLOCK(FILE_START, FILE_SIZE, ctx)

	if (*(ctx->firstfree)) {
		/* there's an unused datablock--take it off the free list */
		idx = *(ctx->firstfree);
		data = ctx->datablocks + idx;
		*(ctx->firstfree) = data->nextidx;
#ifdef DEBUG
		sprintf(debug, "addUser: taking block of free list, index %u", idx);
		WRBLogMessage(WRBCtx, debug, 1);
		sprintf(debug, "firstfree is now %u", *(ctx->firstfree));
		WRBLogMessage(WRBCtx, debug, 1);
#endif
	}
	else {
		/*
		 * add a new datablock to the end of the datablocks array--
		 * pre-inc datacount to assure no datablock has index 0--
		 * index 0 means "end of linked list"
		 */
		(*(ctx->datacount))++;

		if (DATABLOCKS_OFF + (*(ctx->datacount) * sizeof(datablock)) 
		  > ctx->end) {
			/* datafile is full--extend it */

			UNLOCK(ctx)

			if (growdata(ctx, WRBCtx) != WRB_DONE) {
				return (WRB_ABORT);
			}

			WRLOCK(FILE_START, FILE_SIZE, ctx)
		}

		/*
		 * calculate address of the new datablock by adding the
		 * new datacount to the base address of the array
		 */
		idx = *(ctx->datacount);
		data = ctx->datablocks + idx;
#ifdef DEBUG
		sprintf(debug, "addUser: adding new datablock for %s, index %u",
		  newdata->username, idx);
		WRBLogMessage(WRBCtx, debug, 1);
#endif
	}

	/* fill in the new datablock from the data passed in */
	strcpy(data->username, newdata->username);
	strcpy(data->password, newdata->password);

	/* hash on username--add new datablock to hash table */
	cp = data->username;
	THASH(hashval, cp)
#ifdef DEBUG
	sprintf(debug, "addUser: hashval for %s is %d", data->username, hashval);
	WRBLogMessage(WRBCtx, debug, 1);
#endif
	data->nextidx = ctx->table[hashval];
	ctx->table[hashval] = idx;
#ifdef DEBUG
	sprintf(debug, "addUser: putting new datablock for %s in bin %d", 
	  data->username, hashval);
	WRBLogMessage(WRBCtx, debug, 1);
#endif

	/* sync datafile */
	msync((char *)ctx->table, ctx->end, MS_SYNC | MS_INVALIDATE);

	UNLOCK(ctx)

	return (WRB_DONE);
}

/*
 * rehash--moves a datablock in the hash table. Called by editUserData when
 * a username change requires a datablock to be rehashed. oldname is the
 * username on which the datablock is currently hashed--newdata contains
 * the new username and updated data
 */
WRBReturnCode rehash(const char *oldname, const datablock* newdata,
  myappctx* ctx, void *WRBCtx)
{
	unsigned idx, hashval;
	datablock *data, *lastdata;
	char *cp;
	off_t size;

	WRLOCK(FILE_START, FILE_SIZE, ctx)

	/*
	 * check to see if another WRBX has extended the datafile--
	 * if so, remap the file
	 */
	size = lseek(ctx->datafd, 0, SEEK_END);
	if (size > ctx->end) {
		/* file has grown--remap it */

		UNLOCK(ctx)

		if (remapdata(ctx, WRBCtx) != WRB_DONE) {
			return (WRB_ABORT);
		}

		WRLOCK(FILE_START, FILE_SIZE, ctx)
	}

	/* hash on oldname--retrieve datablock from hash table */
	cp = strdup(oldname);
	THASH(hashval, cp)
	lastdata = NULL;
	idx = ctx->table[hashval];
	data = ctx->datablocks + idx;
	while (data != ctx->datablocks) {
		/*
		 * end of list not yet reached--compare datablock username
		 * with oldname--break out if match
		 */
		if (!strcmp(oldname, data->username)) {
			break;
		}

		lastdata = data;
		idx = data->nextidx;
		data = ctx->datablocks + idx;
	}

	if (data == ctx->datablocks) {
		/* end of hash list reached--no datablock found for given username */
		return (WRB_ERROR);
	}

	/* unlink data block */
	if (lastdata) {
		lastdata->nextidx = data->nextidx;
	}
	else {
		ctx->table[hashval] = data->nextidx;
	}

	/* copy new data into datablock */
	strcpy(data->username, newdata->username);
	strcpy(data->password, newdata->password);

	/* hash on username--relocate datablock in hash table */
	cp = data->username;
	THASH(hashval, cp)
#ifdef DEBUG
	sprintf(debug, "rehash: hashval for %s is %d", data->username, hashval);
	WRBLogMessage(WRBCtx, debug, 1);
#endif
	data->nextidx = ctx->table[hashval];
	ctx->table[hashval] = idx;
#ifdef DEBUG
	sprintf(debug, "rehash: putting new datablock for %s in bin %d", 
	  data->username, hashval);
	WRBLogMessage(WRBCtx, debug, 1);
#endif

	/* sync datafile */
	msync((char *)ctx->table, ctx->end, MS_SYNC | MS_INVALIDATE);

	UNLOCK(ctx)

	return (WRB_DONE);
}

/*
 * formatUserData--formats the user data passed in as HTML and sends it to
 * the client. formatUserData relies on the caller to handle any necessary
 * locking on data
 */
WRBReturnCode
formatUserData(const datablock *data, myappctx *ctx, void *WRBCtx)
{
	char buf[1024];
	char wbuf[1024];
	char *bp, *ep;
	FILE *info;
	int len;
	char infofile[256];
	char *ohome;

	/*
	 * write out data form
	 */
#ifdef DEBUG
	WRBLogMessage(WRBCtx, "formatUserData: starting client writes", 0);
#endif

	WRBClientWrite(WRBCtx, "Content-type: text/html\n\n", 25);

	len = sprintf(wbuf,
	  "<HTML>\n<HEAD><TITLE>Registration Form</TITLE></HEAD>\n");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "<BODY BGCOLOR=\"FFFFFF\">\n");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf,
	  "<FORM ACTION=\"/mywrbapp/bin/edituserdata\" METHOD=\"POST\">\n");
	WRBClientWrite(WRBCtx, wbuf, len);

	/* username */
	len = sprintf(wbuf, "<P>Username: <INPUT TYPE=\"text\" NAME=\"username\" ");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "VALUE=\"%s\" MAXLENGTH=\"10\" SIZE=\"10\"></P>\n",
	  data->username);
	WRBClientWrite(WRBCtx, wbuf, len);

	/* password */
	len = sprintf(wbuf,
	  "<P>Password: <INPUT TYPE=\"password\" NAME=\"password\" ");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "VALUE=\"%s\" MAXLENGTH=\"10\" SIZE=\"10\">\n",
	  data->password);
	WRBClientWrite(WRBCtx, wbuf, len);

	/* confirm password */
	len = sprintf(wbuf,
	  " Confirm Password: <INPUT TYPE=\"password\" NAME=\"confirm\" ");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "VALUE=\"%s\" MAXLENGTH=\"10\" SIZE=\"10\"></P>\n",
	  data->password);
	WRBClientWrite(WRBCtx, wbuf, len);

#ifdef DEBUG
	WRBLogMessage(WRBCtx, "formatUserData: opening infofile", 0);
#endif

	/* open infofile and write its data to the client */
	ohome = WRBGetORACLE_HOME(WRBCtx);
	sprintf(infofile, "%s/ows21/sample/wrbsdk/mywrbapp/%s.info", ohome,
	  data->username);
	info = fopen(infofile, "r");

	/* fullname */
	fgets(buf, 1024, info);
	bp = strchr(buf, ':');
	bp += 2;
	ep = strchr(bp, '\n');
	*ep = '\0';

	len = sprintf(wbuf,
	  "<P>Full Name: <INPUT TYPE=\"text\" NAME=\"fullname\" ");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "VALUE=\"%s\"></P>\n", bp);
	WRBClientWrite(WRBCtx, wbuf, len);

	/* address */
	fgets(buf, 1024, info);
	bp = strchr(buf, ':');
	bp += 2;
	ep = strchr(bp, '\n');
	*ep = '\0';

	len = sprintf(wbuf,
	  "<P>Street Address: <INPUT TYPE=\"text\" NAME=\"address\" ");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "VALUE=\"%s\"></P>\n", bp);
	WRBClientWrite(WRBCtx, wbuf, len);

	/* city */
	fgets(buf, 1024, info);
	bp = strchr(buf, ':');
	bp += 2;
	ep = strchr(bp, '\n');
	*ep = '\0';

	len = sprintf(wbuf,
	  "<P>City: <INPUT TYPE=\"text\" NAME=\"city\" ");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "VALUE=\"%s\"></P>\n", bp);
	WRBClientWrite(WRBCtx, wbuf, len);

	/* state */
	fgets(buf, 1024, info);
	bp = strchr(buf, ':');
	bp += 2;
	ep = strchr(bp, '\n');
	*ep = '\0';

	len = sprintf(wbuf,
	  "<P>State: <INPUT TYPE=\"text\" NAME=\"state\" ");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "VALUE=\"%s\" MAXLENGTH=\"2\" SIZE=\"2\"></P>\n", bp);
	WRBClientWrite(WRBCtx, wbuf, len);

	/* zip */
	fgets(buf, 1024, info);
	bp = strchr(buf, ':');
	bp += 2;
	ep = strchr(bp, '\n');
	*ep = '\0';

	len = sprintf(wbuf,
	  "<P>Zip: <INPUT TYPE=\"text\" NAME=\"zip\" ");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "VALUE=\"%s\"></P>\n", bp);
	WRBClientWrite(WRBCtx, wbuf, len);

	/* country */
	fgets(buf, 1024, info);
	bp = strchr(buf, ':');
	bp += 2;
	ep = strchr(bp, '\n');
	*ep = '\0';

	len = sprintf(wbuf,
	  "<P>Country: <INPUT TYPE=\"text\" NAME=\"country\" ");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "VALUE=\"%s\"></P>\n", bp);
	WRBClientWrite(WRBCtx, wbuf, len);

	/* email */
	fgets(buf, 1024, info);
	bp = strchr(buf, ':');
	bp += 2;
	ep = strchr(bp, '\n');
	*ep = '\0';

	len = sprintf(wbuf,
	  "<P>Email Address: <INPUT TYPE=\"text\" NAME=\"email\" ");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, " SIZE=\"40\" VALUE=\"%s\"></P>\n", bp);
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "<INPUT TYPE=\"submit\" NAME=\"submit\" ");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "VALUE=\"Save Changes\">\n</FORM>\n");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf,
	  "<P><A HREF=\"/mywrbapp/bin/getcatalog\">Go to the catalog</A></P>\n");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "</BODY>\n</HTML>\n");
	WRBClientWrite(WRBCtx, wbuf, len);

#ifdef DEBUG
	WRBLogMessage(WRBCtx, "formatUserData: finished client writes", 0);
#endif

	fclose(info);

	return (WRB_DONE);
}

/*
 * userDataError--generates an error page in response to bad user data input.
 */
void
userDataError(const char *message, const char *URL, myappctx* ctx, void *WRBCtx)
{
	char wbuf[1024];
	int len;

	WRBClientWrite(WRBCtx, "Content-type: text/html\n\n", 25);

	len = sprintf(wbuf, "<HTML><HEAD><TITLE>Error</TITLE></HEAD>\n");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "<BODY BGCOLOR=\"FFFFFF\">\n<H1>Error</H1>\n");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "<P>%s</P>\n", message);
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf,
	  "<P><A HREF=\"%s\">Return ", URL);
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "to the registration form</A>.</P>\n");
	WRBClientWrite(WRBCtx, wbuf, len);

	len = sprintf(wbuf, "</BODY>\n</HTML>\n");
	WRBClientWrite(WRBCtx, wbuf, len);

	return;
}

/*
 * storeInfo--parses form data for user and stores it on disk
 */
WRBReturnCode
storeInfo(const char *user, myappctx *ctx, void *WRBCtx)
{
	int fd;
	char buf[256];
	char *cp;
	WRBEntry *entries;
	int numentries;
	char infofile[256];
	char *ohome;

	/* create infofile for this user */
	ohome = WRBGetORACLE_HOME(WRBCtx);
	sprintf(infofile, "%s/ows21/sample/wrbsdk/mywrbapp/%s.info", ohome, user);
	fd = open(infofile, O_CREAT | O_TRUNC | O_RDWR, 0664);
	if (fd == -1) {
		return (WRB_ABORT);
	}

	/* get form data */
	WRBGetParsedContent(WRBCtx, &entries, &numentries);

	cp = WRBGetNamedEntry("fullname", entries, numentries);
	sprintf(buf, "Full Name: %s\n", cp);
	write(fd, buf, strlen(buf));

	cp = WRBGetNamedEntry("address", entries, numentries);
	sprintf(buf, "Street Address: %s\n", cp);
	write(fd, buf, strlen(buf));

	cp = WRBGetNamedEntry("city", entries, numentries);
	sprintf(buf, "City: %s\n", cp);
	write(fd, buf, strlen(buf));

	cp = WRBGetNamedEntry("state", entries, numentries);
	sprintf(buf, "State: %s\n", cp);
	write(fd, buf, strlen(buf));

	cp = WRBGetNamedEntry("zip", entries, numentries);
	sprintf(buf, "Zip Code: %s\n", cp);
	write(fd, buf, strlen(buf));

	cp = WRBGetNamedEntry("country", entries, numentries);
	sprintf(buf, "Country: %s\n", cp);
	write(fd, buf, strlen(buf));

	cp = WRBGetNamedEntry("email", entries, numentries);
	sprintf(buf, "Email Address: %s\n", cp);
	write(fd, buf, strlen(buf));

	close(fd);
	return (WRB_DONE);
}

/*
 * getDataBlock--retrieves datablock for user
 */
datablock *
getDataBlock(const char *user, myappctx *ctx, void *WRBCtx)
{

	unsigned hashval;
	char *cp;
	datablock *data = NULL;
	off_t size;

	RDLOCK(FILE_START, FILE_SIZE, ctx)

	/*
	 * check to see if another WRBX has extended the datafile--
	 * if so, remap the file
	 */
	size = lseek(ctx->datafd, 0, SEEK_END);
	if (size > ctx->end) {
		/* file has grown--remap it */

		UNLOCK(ctx)

		if (remapdata(ctx, WRBCtx) != WRB_DONE) {
			return (NULL);
		}

		RDLOCK(FILE_START, FILE_SIZE, ctx)
	}

	/* hash on username--retrieve datablock from hash table */
	cp = strdup(user);
	THASH(hashval, cp)
	data = ctx->datablocks + ctx->table[hashval];
	while (data != ctx->datablocks) {
		/*
		 * end of list not yet reached--compare datablock username
		 * with given value--break out if match
		 */
		if (!strcmp(user, data->username)) {
			break;
		}

		data = ctx->datablocks + data->nextidx;
	}

	UNLOCK(ctx)

	if (data == ctx->datablocks) {
		/* end of hash list reached--no datablock found for given username */
		return (NULL);
	}

#ifdef DEBUG
	sprintf(debug, "getDataBlock: data block found for user %s",
	  data->username);
	WRBLogMessage(WRBCtx, debug, 1);
#endif

	return (data);
}

/*
 * formatOrder--formats the client order encapsulated in the ctx structure
 * as HTML and sends it to the client. If invoice is TRUE, outputs a
 * non-editable HTML page and prints price totals. Otherwise, outputs
 * an editable HTML page with <INPUT> fields. Does *not* output Content-type
 * or HTML header or trailer
 */
WRBReturnCode
formatOrder(const boolean invoice, myappctx *ctx, void *WRBCtx)
{
	FILE *cat;
	char lbuf[1024];
	char *lp;
	char wbuf[1024];
	int len;
	orderitem* items;
	int item = 0;
	double itemprice;
	double quantity;
	double total = 0;
	char catfile[256];
	char *ohome;

	/* open catalog */
	ohome = WRBGetORACLE_HOME(WRBCtx);
	sprintf(catfile, "%s/ows21/sample/wrbsdk/mywrbapp/catalog.txt", ohome);
	cat = fopen(catfile, "r");
	if (!cat) {
#ifdef DEBUG
		WRBLogMessage(WRBCtx, "formatOrder: failed to open catalog", 0);
#endif
		return (WRB_ABORT);
	}

	/* 
	 * because both the items array and the catalog file are sorted by
	 * part number, loop through without seeking backward
	 */
	items = ctx->items;
	while ((item < ctx->numitems)) {
		if ((items[item].qty[0] == '\0') || (items[item].qty[0] == '0')) {
			/* skip empty quantities */
			item++;
			continue;
		}

		/* skip description line, get part number line */
		fgets(lbuf, 1024, cat);
		if (!fgets(lbuf, 1024, cat)) {
			break;
		}
		if (!strncmp(lbuf, items[item].partnum, PARTNUMLEN)) {
			/*
			 * found the catalog entry for current item--
			 * write it out to the client
			 */
			WRBClientWrite(WRBCtx, "<P>", 3);
			WRBClientWrite(WRBCtx, lbuf, strlen(lbuf));

			if (invoice) {
				/* calculate and print price, add to subtotal */
				lp = strchr(lbuf, '$');
				lp++;
				itemprice = atof(lp);
				quantity = atof(items[item].qty);
				len = sprintf(wbuf, " Quantity: %s @ $%.2f = $%.2f</P>\n",
				  items[item].qty, itemprice, itemprice * quantity);
				WRBClientWrite(WRBCtx, wbuf, len);

				total += itemprice * quantity;
			}
			else {
				/*
				 * not an invoice--write quantity out as an editable
				 * input field
				 */
				len = sprintf(wbuf, " Order quantity: <INPUT TYPE=\"text\" ");
				WRBClientWrite(WRBCtx, wbuf, len);

				len = sprintf(wbuf, "NAME=\"%s\" ", items[item].partnum);
				WRBClientWrite(WRBCtx, wbuf, len);

				len = sprintf(wbuf,
				  "SIZE=\"4\" VALUE=\"%s\"></P>\n", items[item].qty);
				WRBClientWrite(WRBCtx, wbuf, len);
			}
			item++;
		}
	}

	if (invoice) {
		if (taxable(WRBGetUserID(WRBCtx), ctx, WRBCtx)) {
			/* print subtotal */
			len = sprintf(wbuf, "<P>Subtotal: $%.2f</P>\n", total);
			WRBClientWrite(WRBCtx, wbuf, len);

			/* calc and print tax */
			len = sprintf(wbuf, "<P>Tax @ %.2f%%: $%.2f</P>\n",
			  ctx->taxpct, (ctx->taxpct/100)*total);
			WRBClientWrite(WRBCtx, wbuf, len);

			/* print total with tax */
			len = sprintf(wbuf, "<P>Your total is: $%.2f</P>\n",
			  total + (ctx->taxpct/100)*total);
			WRBClientWrite(WRBCtx, wbuf, len);
		}
		else {
			/* print total (no tax) */
			len = sprintf(wbuf, "<P>Your total is: $%.2f</P>\n", total);
			WRBClientWrite(WRBCtx, wbuf, len);
		}
	}

	fclose(cat);

	return (WRB_DONE);
}

/*
 * taxable()--determines whether the user lives in our home state
 */
boolean
taxable(char *user, myappctx *ctx, void *WRBCtx)
{
	FILE *info;
	char *ohome;
	char buf[1024];
	char *cp = NULL;

#ifdef DEBUG
	WRBLogMessage(WRBCtx, "taxable: entering", 0);
#endif
	/* open user's info file */
	ohome = WRBGetORACLE_HOME(WRBCtx);
	sprintf(buf, "%s/ows21/sample/wrbsdk/mywrbapp/%s.info", ohome, user);
	info = fopen(buf, "r");

	/* get user's home state */
	while (fgets(buf, 1024, info)) {
		if (!strncmp(buf, "State:", 6)) {
			cp = strchr(buf, ':');
			cp += 2;
			break;
		}
	}

	/* compare it with our home state */
	if (cp && ctx->state && !strncmp(cp, ctx->state, 2)) {
		/* they're in our state--tax 'em */
#ifdef DEBUG
		WRBLogMessage(WRBCtx, "taxable: returning TRUE", 0);
#endif
		return (TRUE);
	}

#ifdef DEBUG
		WRBLogMessage(WRBCtx, "taxable: returning FALSE", 0);
#endif
	return (FALSE);
}

/*
 * itemcmp() is used by qsort(3) in sorting the orderitems array--
 * the args are declared as const void* to stifle compiler warnings
 */
int
itemcmp(const void* item1, const void* item2)
{
	return(strcmp(((orderitem *)item1)->partnum,
	  ((orderitem *)item2)->partnum));
}

/*
 * mapdata--allocates application context structure, maps the datafile
 * identified by fd into memory and sets up context
 */
myappctx *
mapdata(const int fd, myappctx *ctx, void *WRBCtx)
{
	off_t size;

	if (!ctx) {
		/* NULL context means allocate context */
		if (!(ctx = (myappctx *)malloc(sizeof(myappctx)))) {
#ifdef DEBUG
			WRBLogMessage(WRBCtx, "mapdata: context malloc failed", 0);
#endif
			return (NULL);
		}
	}

	RDLOCK(FILE_START, FILE_SIZE, ctx)

	/* fd refers to the open datafile--find its size */
	size = lseek(fd, 0, SEEK_END);
#ifdef DEBUG
	sprintf(debug, "mapdata: datafile size is %u", size);
	WRBLogMessage(WRBCtx, debug, 1);
#endif

	if (size < MINFILESIZE) {
		/* data file too small--it was probably just created */

		UPGRADE(ctx)

		/* extend file */
		size = lseek(fd, MINFILESIZE - 1, SEEK_END);
		if (write(fd, "\0", 1) != 1) {
#ifdef DEBUG
			sprintf(debug, "mapdata: failed to extend file:");
			WRBLogMessage(WRBCtx, debug, 1);
			sprintf(debug, "\t%s", strerror(errno));
			WRBLogMessage(WRBCtx, debug, 1);
#endif
			goto error;
		}

		size = lseek(fd, 0, SEEK_END);
#ifdef DEBUG
		sprintf(debug, "mapdata: extended datafile to size: %u", size);
		WRBLogMessage(WRBCtx, debug, 1);
#endif

		DOWNGRADE(ctx)
	}

	/* map entire file into memory */
	ctx->table = (int *)mmap(NULL, size, PROT_READ | PROT_WRITE, 
	  MAP_SHARED, fd, (off_t)0);
	if (ctx->table == MAP_FAILED) {
#ifdef DEBUG
		sprintf(debug, "mapdata: failed to mmap datafile:");
		WRBLogMessage(WRBCtx, debug, 1);
		sprintf(debug, "%s", strerror(errno));
		WRBLogMessage(WRBCtx, debug, 1);
#endif
		goto error;
	}

	/* set up rest of context--defines data file format */
	ctx->firstfree = (int *)(ctx->table + TSIZE);
	ctx->datacount = (int *)(ctx->firstfree + 1);
	ctx->datablocks = (datablock *)(ctx->datacount + 1);
	ctx->datafd = fd;
	ctx->end = size;

	UNLOCK(ctx)

	return (ctx);

error:
	UNLOCK(ctx)

	return (NULL);
}

/*
 * remapdata--unmaps and remaps datafile into memory
 */
WRBReturnCode
remapdata(myappctx *ctx, void *WRBCtx)
{

	/* unmap data file */
	if (munmap((char *)ctx->table, ctx->end) == -1) {
		return (WRB_ABORT);
	}

	/* remap data file */
	if (!mapdata(ctx->datafd, ctx, WRBCtx)) {
		return (WRB_ABORT);
	}

	return (WRB_DONE);
}

/*
 * growdata--extends datafile. Called when the datafile is full
 */
WRBReturnCode
growdata(myappctx *ctx, void *WRBCtx)
{
	off_t size;

	WRLOCK(FILE_START, FILE_SIZE, ctx)

	/* extend file by seeking past the end and writing a byte */
	size = lseek(ctx->datafd, MINFILESIZE + 1, SEEK_END);
#ifdef DEBUG
	sprintf(debug, "growdata: extended datafile to size: %u", size);
	WRBLogMessage(WRBCtx, debug, 1);
#endif
	if (write(ctx->datafd, "\0", 1) != 1) {
#ifdef DEBUG
		sprintf(debug, "growdata: failed to extend datafile: %s",
		  strerror(errno));
		WRBLogMessage(WRBCtx, debug, 1);
#endif
		goto error;
	}

	/* sync datafile */
	if (msync((char *)ctx->table, ctx->end, MS_SYNC | MS_INVALIDATE) == -1) {
#ifdef DEBUG
		sprintf(debug, "growdata: failed to msync datafile: %s",
		  strerror(errno));
		WRBLogMessage(WRBCtx, debug, 1);
#endif
		goto error;
	}

	UNLOCK(ctx)

	/* remap datafile */
	if (remapdata(ctx, WRBCtx) != WRB_DONE) {
		return (WRB_ABORT);
	}

	return (WRB_DONE);

error:
	UNLOCK(ctx)

	return(WRB_ABORT);
}
