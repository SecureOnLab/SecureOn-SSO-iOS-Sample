//
//  LoginViewController.h
//  MSSOSample
//


#import <UIKit/UIKit.h>
#import <AdSupport/ASIdentifierManager.h>
#import "CommonUtil.h"
#import "SsoAppViewController.h"
#import "SsoWebViewController.h"
//#import "iposso.h"

@interface LoginViewController : UIViewController {
    int rHttpLastError; //http 오류 저장 변수
    int rSSOLastError;  //sso 
    int initResult;
}

@property (nonatomic, strong) IBOutlet UITextField *userIdText; //사용자 id 필드
@property (nonatomic, strong) IBOutlet UITextField *userPwdText;    //사용자 패스워드 필드
@property (nonatomic, strong) IBOutlet UISegmentedControl *ssoVersion;  //SSO 버전에 따른 인증방식 처리

@property (nonatomic, strong)IBOutlet UITextView *secIdTextView;

-(IBAction)keypadHide:(id)sender;   //전체화면을 채워서 화면에 숨기게 동작
-(IBAction)userLogin:(id)sender;    //로그인 처리 메서드

-(void) setLastError:(CommonUtil *)commonUtil;               //rHttpLastError, rSSOLastError 변수에 값 세팅
-(void) tabBarSegueCall;    //로그인 성공 시 호출되어지는 tabbar 호출 메서드
@end
