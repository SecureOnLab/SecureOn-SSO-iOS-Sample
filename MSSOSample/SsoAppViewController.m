//
//  SsoAppViewController.m
//  MSSOSample
//


#import "SsoAppViewController.h"
#import "CommonUtil.h"
#import "SsoWebViewController.h"
#import "iposso.h"

@implementation SsoAppViewController

@synthesize userIdText = _userIdText;

static CommonUtil *commonUtil;

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
    
}
        
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"SsoAppViewController - test : %@", commonUtil.ssoTokenKey);
    NSLog(@"SsoAppViewController - ViewDidLoad..");
    initResult = -1;
    
    //verify token 함
    //토큰이 있는지 확인 및 있는 경우 검증 후 로그인 처리
    if (commonUtil.ssoToken != nil || commonUtil.ssoToken != NULL) {
        NSLog(@"SsoAppViewController - SSO Token is exist..");
        
//        20140804 smoh modify
//        [commonUtil setVerifyResult:ipo_sso_verify_token(commonUtil.ssoToken, [CommonUtil clientIp])];
//        [commonUtil setVerifyResult:ipo_sso_verify_token_sec(commonUtil.ssoToken, [CommonUtil clientIp], getSecId())];
        if ([commonUtil.secIdFlag isEqualToString:@"TRUE"]) {
            [commonUtil setVerifyResult:ipo_sso_verify_token(commonUtil.ssoToken, [CommonUtil clientIp], getSecId())];
        } else {
            [commonUtil setVerifyResult:ipo_sso_verify_token(commonUtil.ssoToken, [CommonUtil clientIp], nil)];
        }
        
        NSLog(@"SsoAppViewController - verifyResult : %@", commonUtil.verifyResult);
        
        [self setLastError:commonUtil];
        
        if (rHttpLastError < 200 || rHttpLastError > 300) {
            //[CommonUtil appAlert:[CommonUtil alertTitle] message:commonUtil.rHttpLastErrorMSG];
            NSLog(@"SsoAppViewController - rHttpLastError error.");
        }
        
        if (rSSOLastError != 0) {
            //[CommonUtil appAlert:[CommonUtil alertTitle] message:commonUtil.rSSOLastErrorMSG];
            NSLog(@"SsoAppViewController - rSSOLastError error.");
        } else {
            
            NSLog(@"SsoAppViewController - getVale : %@ ", ipo_sso_get_value(@"PutKey", 0, commonUtil.ssoToken, [CommonUtil clientIp], getSecId()));
            
            NSLog(@"SsoAppViewController - Verify Success and userID setting..");
            initResult = 0;
            [commonUtil setUserId:commonUtil.verifyResult];
            _userIdText.text = commonUtil.userId;
        }
    }else {
        NSLog(@"SsoAppViewController - Token is null. LoginViewController redirect.");
    }
    
    NSLog(@"SsoAppViewController - initResult : %d", initResult);
    
    if (initResult == -1) {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
}
        
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
        


+ (void) setCommonUtil:(CommonUtil *)iCommonUtil {
    commonUtil = iCommonUtil;
}

- (IBAction)issoaAppOpen:(id)sender {
    NSString *issoaURL = [NSString stringWithFormat:@"issoa://?sso_token=%@", commonUtil.ssoToken];
    
    NSLog(@"MSSOSample - issoaURL - %@", issoaURL);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:issoaURL]];
}

//App Logout
- (IBAction)appLogout:(id)sender {
    UIAlertView *iConfirmAlert = [[UIAlertView alloc] initWithTitle:@"SSO Logout"
                                                            message:@"SSO 로그아웃 하시겠습니까?"
                                                           delegate:self
                                                  cancelButtonTitle:@"아니요"
                                                  otherButtonTitles:@"네", nil ];
    [iConfirmAlert show];
}

//confirm 세팅
- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //사용자가 네를 선택한 경우
//    NSLog(@"%@", alertView.title);
//    NSLog(@"%d", buttonIndex);
    
//    if([alertView.title isEqualToString:@"SSO Logout"]) {
    if (buttonIndex == 1) {
        NSLog(@"SsoAppViewController - App Logout..");
        ipo_sso_logout(commonUtil.ssoTokenKey);     //sso logout
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];    //로그아웃 후 로그인 컨트롤러로 이동
    }
//    }
}

//rHttpLastError, rSSOLastError 변수에 값 세팅
-(void) setLastError:(CommonUtil *)commonUtil {
    rHttpLastError = getHttpLastError();
    rSSOLastError = getSSOLastError();
    [commonUtil setRHttpLastErrorMSG:[NSString stringWithFormat:@"HTTP 에러코드 : %d",rHttpLastError]];
    [commonUtil setRSSOLastErrorMSG:[NSString stringWithFormat:@"SSO 에러코드 : %d", rSSOLastError]];
    
    NSLog(@"SsoAppViewController - HTTP Return Code : %d", rHttpLastError);
    NSLog(@"SsoAppViewController - commonUtil.rHttpLastErrorMSG : %@", commonUtil.rHttpLastErrorMSG);
    NSLog(@"SsoAppViewController - SSO Return Code : %d", rSSOLastError);
    NSLog(@"SsoAppViewController - commonUtil.rSSOLastErrorMSG : %@", commonUtil.rSSOLastErrorMSG);
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if( !url ) {return NO;}
    
    NSLog(@"SsoAppViewController - url.absoluteString: %@", url.absoluteString);
    NSLog(@"SsoAppViewController - url query : %@", [url query]);
    
    NSString *ssoToken = [url query];
    
    //ssoToken이 있으면 값 세팅
    if (ssoToken != nil || ssoToken != NULL) {
        NSString *ssoTokenKey = ipo_sso_init([CommonUtil expPageUrl]);
        ssoToken = [ssoToken substringFromIndex:9];
        NSLog(@"AppDelegate - ssoToken : %@", ssoToken);
        
        ipo_set_ssotoken(ssoToken, ssoTokenKey);
//        20140804 smoh modify
//        ipo_sso_verify_token(ssoToken, [CommonUtil clientIp]);
//        ipo_sso_verify_token_sec(ssoToken, [CommonUtil clientIp], getSecId());
        if ([commonUtil.secIdFlag isEqualToString:@"TRUE"]) {
            ipo_sso_verify_token(ssoToken, [CommonUtil clientIp], getSecId());
        } else {
            ipo_sso_verify_token(ssoToken, [CommonUtil clientIp], nil);
        }
    }
    
    NSString *UrlString = [url absoluteString];
    
    [[NSUserDefaults standardUserDefaults] setObject:UrlString forKey:@"url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
    
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
