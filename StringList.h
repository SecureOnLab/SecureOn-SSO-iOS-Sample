//
//  StringList.h
//  iposso
//
//  Created by dev1 on 10. 6. 21..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#ifndef __STRINGLIST_H__
#define __STRINGLIST_H__

#ifdef __cplusplus
extern "C" {
#endif 
	
	typedef struct _STRINGLIST_ELMT * PSTRINGLIST_ELMT;
	
	typedef struct _STRINGLIST_ELMT {
		char *sData;
		int	nSize;
		PSTRINGLIST_ELMT pLink;
	} STRINGLIST_ELMT;
	
	typedef struct _STRINGLIST * PSTRINGLIST;
	
	typedef struct _STRINGLIST {
		PSTRINGLIST_ELMT header;
	} STRINGLIST;
	
	int StrList_Add (PSTRINGLIST pList, char * sData, int nSize);
	
	void StrList_New (STRINGLIST stList);
	
	int StrList_Clear (PSTRINGLIST pList);
	
	PSTRINGLIST StrList_Init ();
	
	int StrList_Release (PSTRINGLIST pList);
	
	char* StrList_Alloc(PSTRINGLIST pList, int nSize);
	
	char* StrList_Duplicate(PSTRINGLIST pList, char* szSrc);
	
#ifdef __cplusplus
}
#endif

#endif

