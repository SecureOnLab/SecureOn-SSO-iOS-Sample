//
//  SsoWebViewController.h
//  MSSOSample
//
//  Created by smoh on 2014. 7. 7..
//  Copyright (c) 2014년 smoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
#import "SsoAppViewController.h"

@interface SsoWebViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *urlText;    //url 객체
@property (nonatomic, strong) IBOutlet UIWebView *ssoWebView;   //웨뷰

+ (void) setCommonUtil:(CommonUtil *)iCommonUtil;
-(IBAction)goURL:(id)sender;    //이동 버튼 처리 메서드
-(IBAction)barButtonClick:(id)sender;   //탭바 버튼 클릭 이벤트 처리 메서드

-(void) webViewDidStartLoad: (UIWebView *) webView; //웹뷰가 시작 될때 호출되는 메서드
-(void) webViewDidFinishLoad: (UIWebView *) webView;    //웹뷰가 끝날때 호출되는 메서드
-(void) webView: (UIWebView *)webView didFailLoadWithError:(NSError *)error;    //웹뷰가 로딩 실패할때 호출되는 메서드

+ (void) setResponseData:(NSMutableData *)aData;
+ (NSMutableData *)responseData;

+ (void) setResponseEncoding:(NSInteger)aValue;
+ (NSInteger)responseEncoding;

@end
