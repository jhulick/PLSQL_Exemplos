/*
**  Copyright (c) 1996 by Oracle Corporation. All rights reserved. 
**    NAME
**      mywrbapp.h
**    DESCRIPTION
**      
**    RETURNS
** 
**    NOTES
**      
**    MODIFIED   (MM/DD/YY)
**     mfreedma      09/11/96 -  Added Banner 
*/

#ifndef ORATYPES_ORACLE
#include <oratypes.h>
#endif

#ifndef WRB_ORACLE
#include <wrb.h>
#endif

#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>

/* maximum string lengths */
#define MAXNAMELEN 12
#define MAXPASSLEN 32
#define PARTNUMLEN 9

#define MAXITEMS 170		/* max items allowed in orderitems array */
#define TSIZE 128			/* number of bins in hash table--tune to taste */

/*
 * datablock stores authentication data for a user--
 * allocate arrays rather than pointers because the datafile must
 * contain no pointers, as each process can map the file at a 
 * different address
 */
typedef struct datablock {
	int nextidx;		/* index into datablocks array of next datablock */
	char username[MAXNAMELEN];
	char password[MAXPASSLEN];	/* encrypted */
	/* more to come? */
} datablock;

/* orderitem stores information about an item that a user has ordered */
typedef struct orderitem {
	char partnum[PARTNUMLEN + 1];
	char qty[5];
} orderitem;

/*
 * application context--set up by Init function and subsequently passed
 * to each cartridge function by the WRB application engine
 */
typedef struct myappctx {
	int *table;			/* hash table of indeces into datablocks array */
	int *firstfree;		/* index of first free datablock--currently unused */
	int *datacount;		/* current number of datablocks, including free */
	datablock *datablocks;		/* first datablock struct in large array */
	int datafd;			/* data file descriptor */
	off_t end;			/* offset of current EOF */
	orderitem *items;	/* pointer to ordered items array */
	int numitems;		/* number of orders currently in array */
	struct flock lock;	/* lock structure used in locking the datafile */
	char *state;		/* our home state, read from configuration data */
	double taxpct;		/* tax in our area, read from configuration data */
} myappctx;

/*
 * datafile section offsets
 */
#define FILE_START 0
#define TABLE_OFF FILE_START
#define FIRSTFREE_OFF (TABLE_OFF + (TSIZE * sizeof(int)))
#define DATACOUNT_OFF (FIRSTFREE_OFF + sizeof(int))
#define DATABLOCKS_OFF (DATACOUNT_OFF + sizeof(int))

/*
 * datafile section sizes
 */
#define FILE_SIZE 0	/* FILE_SIZE of zero means "to EOF" in locking calls */
#define TABLE_SIZE (TSIZE * sizeof(int))
#define FIRSTFREE_SIZE sizeof(int)
#define DATACOUNT_SIZE sizeof(int)

/* DATABLOCKS_SIZE of zero means "to EOF" in locking calls */
#define DATABLOCKS_SIZE 0

/* minimum datafile size--tune to taste */
#define MINFILESIZE (DATABLOCKS_OFF + (TSIZE * sizeof(datablock)))

/* DBLOCK_OFF calculates the offset of a datablock from beginning of file */
#define DBLOCK_OFF(data, ctx)	(DATABLOCKS_OFF + \
		(data - ctx->datablocks)*sizeof(datablock))

/*
 * hash macro
 */
#define PRIME 157
#define THASH(count, cp)	for (count = 0; *cp; cp++) \
								count = *cp + PRIME * count; \
							count %= TSIZE;

/*
 * locking macros--used to maintain the integrity of the shared datafile
 */
#define LOCK(type, off, len, ctx)	ctx->lock.l_type = type; \
		ctx->lock.l_whence = SEEK_SET; \
		ctx->lock.l_start = off; \
		ctx->lock.l_len = len; \
		fcntl(ctx->datafd, F_SETLKW, &(ctx->lock));

#define RDLOCK(off, len, ctx)	LOCK(F_RDLCK, off, len, ctx)
#define WRLOCK(off, len, ctx)	LOCK(F_WRLCK, off, len, ctx)
#define UNLOCK(ctx)	ctx->lock.l_type = F_UNLCK; \
		fcntl(ctx->datafd, F_SETLKW, &(ctx->lock));

#define UPGRADE(ctx)	UNLOCK(ctx) \
		ctx->lock.l_type = F_WRLCK; \
		fcntl(ctx->datafd, F_SETLKW, &(ctx->lock));

#define DOWNGRADE(ctx)	UNLOCK(ctx) \
		ctx->lock.l_type = F_RDLCK; \
		fcntl(ctx->datafd, F_SETLKW, &(ctx->lock));

/*
 * MyWRBApp cartridge functions
 */
WRBReturnCode
MyWRBApp_Entry(WRBCallbacks *WRBCalls);

WRBReturnCode
MyWRBApp_Init(void *WRBCtx, void **appCtx);

WRBReturnCode
MyWRBApp_Shutdown(void *WRBCtx, void *appCtx);

WRBReturnCode
MyWRBApp_Authorize(void *WRBCtx, void *appCtx, boolean *bAuthorized);

WRBReturnCode
MyWRBApp_Exec(void *WRBCtx, void *appCtx);

WRBReturnCode
MyWRBApp_Reload(void *WRBCtx, void *appCtx);
