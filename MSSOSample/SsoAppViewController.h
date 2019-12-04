//
//  SsoAppViewController.h
//  MSSOSample
//


#import <UIKit/UIKit.h>
#import "CommonUtil.h"
#import "SsoWebViewController.h"
#import "iposso.h"

@interface SsoAppViewController : UIViewController {
    int rHttpLastError;
    int rSSOLastError;
    int initResult;
}

@property (nonatomic, strong) IBOutlet UITextField *userIdText;

+ (void) setCommonUtil:(CommonUtil *)iCommonUtil;   //commonUtil class data 전달 받는 메서드
- (IBAction)issoaAppOpen:(id)sender;    //SSO 다른 샘플인 issoa을 실행시키는 메서드
- (IBAction)appLogout:(id)sender;   //SSO 로그아웃 메서드
-(void) setLastError:(CommonUtil *)commonUtil;  //rHttpLastError, rSSOLastError 변수에 값 세팅
@end
