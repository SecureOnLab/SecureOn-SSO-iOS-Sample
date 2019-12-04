//
//  iposso.h
//  iposso
//
//  Created by dev1 on 10. 6. 15..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

int	nHttpErrorCode;
int nSSOErrorCode;

NSString *nsUrl;
NSString *ssoToken;

NSString* ipo_sso_init(NSString *url);
//20140722 smoh modify
//NSString* ipo_sso_auth_id(NSString *uid, NSString *pwd, NSString *bOverwrite, NSString *cip);
NSString* ipo_sso_auth_id(NSString *uid, NSString *pwd, NSString *bOverwrite, NSString *cip, NSString *appUUID);
//NSString* ipo_sso_verify_token(NSString *sToken, NSString *cip);
NSString* ipo_sso_verify_token(NSString *sToken, NSString *cip, NSString *appUUID);
void ipo_sso_unregusersession(NSString *sToken);
NSString* ipo_sso_user_view(NSString *sToken, NSString *cip);
NSString* ipo_sso_get_service_list(NSString *sbase, NSString *scope, NSString *sToken, NSString *permission, NSString *cip);
NSString* ipo_sso_get_permission(NSString *srdn, NSString *sToken, NSString *cip);
void ipo_set_ssotoken(NSString *nstoken, NSMutableString *ssoTokenKey);
NSString *ipo_get_ssotoken(NSMutableString *ssoTokenKey);
void ipo_sso_logout(NSMutableString *ssoTokenKey);


void setSSOLastError(int nError);
int getSSOLastError();

void setHttpLastError(int nError);
int getHttpLastError();

int makeErrorCode(char *err);

void setUrlString(NSString *url);
NSString* getUrlString();
static NSString* hexval(NSData *data);
NSString * EncryptString(NSString *plainSourceStringToEncrypt);
NSString * DecryptString(NSString *base64StringToDecrypt);

//20140722 smoh add
NSString* getAppUUID();
