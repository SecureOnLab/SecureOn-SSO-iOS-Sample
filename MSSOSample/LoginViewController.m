//
//  LoginViewController.m
//  MSSOSample
//


#import <AdSupport/ASIdentifierManager.h>
#import "LoginViewController.h"
#import "CommonUtil.h"
#import "SsoAppViewController.h"
#import "SsoWebViewController.h"
#import "SsoApiTestViewController.h"
//#import "iposso.h"
//#import <CommonCrypto/CommonDigest.h>

@implementation LoginViewController

static CommonUtil *commonUtil;

@synthesize userIdText = _userIdText;
@synthesize userPwdText = _userPwdText;
@synthesize secIdTextView = _secIdTextView;
@synthesize ssoVersion = _ssoVersion;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"LoginViewController - MSSOSample start..");
    commonUtil = [[CommonUtil alloc] init];
    
    //plist 읽어오기
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"sso_config" ofType:@"plist"];
    NSDictionary *configDic = [[NSDictionary alloc] initWithContentsOfFile:configPath];
    [commonUtil setSecIdFlag:[configDic objectForKey:@"SEC_ID_FLAG"]];
    NSLog(@"LoginViewController - SEC_ID_FLAG : %@", commonUtil.secIdFlag);
    
    NSString *secId;
    if ([commonUtil.secIdFlag isEqualToString:@"TRUE"]) {
        secId = getSecId();
        self.secIdTextView.editable = NO;
        self.secIdTextView.text = secId;
        
        NSLog(@"LoginViewController - secId : %@", secId);
    }
    
    initResult = -1;
    
    //sso 초기화
    [commonUtil setSsoTokenKey:ipo_sso_init([CommonUtil expPageUrl])];
    
    [self setLastError:commonUtil];
    
    if (rHttpLastError < 200 || rHttpLastError > 300) {
        [CommonUtil appAlert:[CommonUtil alertTitle] message:commonUtil.rHttpLastErrorMSG];
        return;
    }
    
    if(rSSOLastError !=0) {
        [CommonUtil appAlert:[CommonUtil alertTitle] message:commonUtil.rSSOLastErrorMSG];
        return;
    } else {
        NSLog(@"LoginViewController - MSSO Sample SSO init success..");
        
        //ssoToken 가져오기
        [commonUtil setSsoToken:ipo_get_ssotoken(commonUtil.ssoTokenKey)];
        
        //토큰이 있는지 확인 및 있는 경우 검증 후 로그인 처리
        if (commonUtil.ssoToken != nil || commonUtil.ssoToken != NULL) {
            NSLog(@"LoginViewController - SSO Token is exist..");
            
//          20140804 smoh modify
//            [commonUtil setVerifyResult:ipo_sso_verify_token(commonUtil.ssoToken, [CommonUtil clientIp])];
//            [commonUtil setVerifyResult:ipo_sso_verify_token_sec(commonUtil.ssoToken, [CommonUtil clientIp], getSecId())];
//            [commonUtil setVerifyResult:ipo_sso_verify_token(commonUtil.ssoToken, [CommonUtil clientIp], getSecId())];
            if ([commonUtil.secIdFlag isEqualToString:@"TRUE"]) {
                [commonUtil setVerifyResult:ipo_sso_verify_token(commonUtil.ssoToken, [CommonUtil clientIp], getSecId())];
            } else {
                [commonUtil setVerifyResult:ipo_sso_verify_token(commonUtil.ssoToken, [CommonUtil clientIp], nil)];
            }
            
            NSLog(@"LoginViewController - verifyResult : %@", commonUtil.verifyResult);

            [self setLastError:commonUtil];
            
            if (rHttpLastError < 200 || rHttpLastError > 300) {
                [CommonUtil appAlert:[CommonUtil alertTitle] message:commonUtil.rHttpLastErrorMSG];
                return;
            }
            
            if (rSSOLastError != 0) {
                [CommonUtil appAlert:[CommonUtil alertTitle] message:commonUtil.rSSOLastErrorMSG];
                //test용
                //initResult = 0;
                return;
            } else {
                NSLog(@"LoginViewController - Verify Success and userID setting..");
                initResult = 0;
                [commonUtil setUserId:commonUtil.verifyResult];
            }
        } else {
            NSLog(@"LoginViewController - SSO Token is no exist..");
        }
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"LoginViewController - initResult : %d", initResult);
    
    if (initResult == 0) {
         [self tabBarSegueCall];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//return 키 이벤트 처리 메서드
- (BOOL) textFieldShouldReturn:(UITextField *) textField
{
    if (textField == self.userIdText) {
        [self.userPwdText becomeFirstResponder];    //사용자 ID에서 패스워드 텍스트필드로 이동
    }else {
        [textField resignFirstResponder];
    }
    return NO;
}

//키보드 올라올때 이벤트 처리메서드. 여기서는 textField 클릭 시 화면이 올라가도록 함
- (void) textFieldDidBeginEditing:(UITextField *) textField {
    if(textField == self.userIdText) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 110), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    } else if (textField == self.userPwdText) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 170), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

//키보드 내려갈때 이벤트 처리 메서드. 여기서는 뷰를 다시 원위치로 돌림
- (void) textFieldDidEndEditing:(UITextField *)textField {
    if(textField == self.userIdText) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 110), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    } else if (textField == self.userPwdText) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 170), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

//전체화면에 줘서 키패드 숨기도록함
-(IBAction)keypadHide:(id)sender {
    [self.userIdText resignFirstResponder];
    [self.userPwdText resignFirstResponder];
}

//로그인 처리 메서드
-(IBAction)userLogin:(id)sender {
    NSLog(@"LoginViewController - userLogin start..");
    NSInteger selectSsoVersion = [self.ssoVersion selectedSegmentIndex];
    //ID가 없는 경우
    if (self.userIdText.text == nil ||[self.userIdText.text  isEqual: @""]) {
        [CommonUtil appAlert:[CommonUtil alertTitle] message:@"사용자 ID를 입력하세요."];
        [self.userIdText becomeFirstResponder]; //focus 가져오기
        return;
    }

    commonUtil.userId = [NSString stringWithFormat:@"%@", self.userIdText.text];
    
    NSLog(@"smoh selectSsoVersion : %ld",selectSsoVersion);
    
    if (selectSsoVersion == -1) {
        [CommonUtil appAlert:[CommonUtil alertTitle] message:@"SSO Version을 선택하세요."];
        return;
    } else if (selectSsoVersion == 0) {
        if ([commonUtil.secIdFlag isEqualToString:@"TRUE"]) {
            commonUtil.loginResult = ipo_sso_make_simple_token(@"3", commonUtil.userId,  CommonUtil.clientIp, getSecId());
        } else {
            commonUtil.loginResult = ipo_sso_make_simple_token(@"3", commonUtil.userId,  CommonUtil.clientIp, nil);
        }
    } else if (selectSsoVersion == 1) {
        if ([commonUtil.secIdFlag isEqualToString:@"TRUE"]) {
            commonUtil.loginResult = ipo_sso_reg_user_session(commonUtil.userId, CommonUtil.clientIp, @"TRUE", getSecId());
        } else {
            commonUtil.loginResult = ipo_sso_reg_user_session(commonUtil.userId, CommonUtil.clientIp, @"TRUE", nil);
        }
    } else if (selectSsoVersion == 2) {
        //PWD가 없는 경우
        if (self.userPwdText.text == nil || [self.userPwdText.text isEqual:@""]) {
            [CommonUtil appAlert:[CommonUtil alertTitle] message:@"사용자 패스워드를 입력하세요."];
            [self.userPwdText becomeFirstResponder];
            return;
        }
        
        commonUtil.userPwd = [NSString stringWithFormat:@"%@", self.userPwdText.text];
        
        if ([commonUtil.secIdFlag isEqualToString:@"TRUE"]) {
            commonUtil.loginResult = ipo_sso_auth_id(commonUtil.userId, commonUtil.userPwd, @"TRUE", CommonUtil.clientIp, getSecId());
        } else {
            commonUtil.loginResult = ipo_sso_auth_id(commonUtil.userId, commonUtil.userPwd, @"TRUE", CommonUtil.clientIp, nil);
        }
        /*
        if ([commonUtil.secIdFlag isEqualToString:@"TRUE"]) {
            commonUtil.loginResult = ipo_sso_auth_id(commonUtil.userId, @"53&wi7c7", @"TRUE", CommonUtil.clientIp, getSecId());
        } else {
            commonUtil.loginResult = ipo_sso_auth_id(commonUtil.userId, @"53&wi7c7", @"TRUE", CommonUtil.clientIp, nil);
        }
         */
    }
    
    NSLog(@"smoh loginResult : %@", commonUtil.loginResult);

    commonUtil.loginResult = ipo_sso_make_simple_token(@"PutKey-PutValuesdata1234*", commonUtil.loginResult, CommonUtil.clientIp, getSecId());
    NSLog(@"LoginViewController MakeToken test Result : %@", commonUtil.loginResult);
    
//    20140804 smoh modify
//    commonUtil.authIdResult = ipo_sso_auth_id(commonUtil.userId, commonUtil.userPwd, @"TRUE", CommonUtil.clientIp);
//    commonUtil.authIdResult = ipo_sso_auth_id_sec(commonUtil.userId, commonUtil.userPwd, @"TRUE", CommonUtil.clientIp, getSecId());
//    commonUtil.authIdResult = ipo_sso_auth_id(commonUtil.userId, commonUtil.userPwd, @"TRUE", CommonUtil.clientIp, getSecId());
    
    [self setLastError:commonUtil];
    
    if (rHttpLastError < 200 || rHttpLastError > 300) {
        [CommonUtil appAlert:[CommonUtil alertTitle] message:commonUtil.rHttpLastErrorMSG];
        return;
    }
    
    if(rSSOLastError !=0) {
        [CommonUtil appAlert:[CommonUtil alertTitle] message:commonUtil.rSSOLastErrorMSG];
        return;
    } else {
        NSLog(@"LoginViewController - MSSO Sample SSO Login Success..");
//        commonUtil.ssoToken = commonUtil.authIdResult;
        commonUtil.ssoToken = commonUtil.loginResult;
        ipo_set_ssotoken(commonUtil.ssoToken, commonUtil.ssoTokenKey);
        
        
        //Tabbar view 호출
        [self tabBarSegueCall];
    }
    
}

//rHttpLastError, rSSOLastError 변수에 값 세팅
-(void) setLastError:(CommonUtil *)commonUtil {
    rHttpLastError = getHttpLastError();
    rSSOLastError = getSSOLastError();
    [commonUtil setRHttpLastErrorMSG:[NSString stringWithFormat:@"HTTP 에러코드 : %d",rHttpLastError]];
    [commonUtil setRSSOLastErrorMSG:[NSString stringWithFormat:@"SSO 에러코드 : %d", rSSOLastError]];
    
    NSLog(@"LoginViewController - HTTP Return Code : %d", rHttpLastError);
    NSLog(@"LoginViewController - commonUtil.rHttpLastErrorMSG : %@", commonUtil.rHttpLastErrorMSG);
    NSLog(@"LoginViewController - SSO Return Code : %d", rSSOLastError);
    NSLog(@"LoginViewController - commonUtil.rSSOLastErrorMSG : %@", commonUtil.rSSOLastErrorMSG);
}

//로그인 성공 후 탭바컨트롤러 페이지 호출
-(void)tabBarSegueCall {
    [self performSegueWithIdentifier:@"TabBarSegue" sender:self];
}

//Segue로 연결된 두 Scene이 넘어가는 순간에 호출되는 메서드 데이터를 다음뷰에 넘기는 역할
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"TabBarSegue"]) {
//        SsoAppViewController *ssoAppViewController = segue.destinationViewController;
        [SsoAppViewController setCommonUtil:(CommonUtil *) commonUtil];
        [SsoWebViewController setCommonUtil:(CommonUtil *) commonUtil];
        [SsoApiTestViewController setCommonUtil:(CommonUtil *) commonUtil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
