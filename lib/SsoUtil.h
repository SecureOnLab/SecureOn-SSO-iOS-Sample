//
//  SsoUtil.h
//  iposso
//
//  Created by smoh on 2014. 12. 16..
//
//

#import <Foundation/Foundation.h>

@interface SsoUtil : NSObject

//null 체크 메서드
+(NSString *)checkNull:(NSString *)str;
//number 체크 메서드
+(BOOL)isNumber:(NSString *)str;

@end
