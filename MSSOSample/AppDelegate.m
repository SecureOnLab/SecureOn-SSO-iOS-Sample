//
//  AppDelegate.m
//  MSSOSample
//

#import "AppDelegate.h"
#import "iposso.h"
#import "CommonUtil.h"
#import "LoginViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //백그라운드로 돌아갈 때 호출되는 메서드
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //여기서는 URL에 값이 있을 경우 처리하기 위하여 사용
    NSLog(@"AppDelegate - applicationDidBecomeActive start..");
    
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
//    UIViewController *vc =[storyBoard instantiateInitialViewController];
//    
//    // Set root view controller and make windows visible
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.rootViewController = vc;
//    [self.window makeKeyAndVisible];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//custom url scheme 사용을 위한 메서드
//url scheme은 Supporting Files - MSSOSampleTests-Info.plist의 URL identifier와 URL scheme
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if( !url ) {return NO;}
    
    NSLog(@"AppDelegate - url.absoluteString: %@", url.absoluteString);
    NSLog(@"AppDelegate - url query : %@", [url query]);
    
    //들어오는 url 잘라내기
//    NSMutableDictionary *mdQueryStrings = [[NSMutableDictionary alloc] init];
//    for (NSString *qs in [url.query componentsSeparatedByString:@"&"]) {
//        [mdQueryStrings setValue:[[[[qs componentsSeparatedByString:@"="] objectAtIndex:1]
//                                   stringByReplacingOccurrencesOfString:@"+" withString:@" "]
//                                  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
//                          forKey:[[qs componentsSeparatedByString:@"="] objectAtIndex:0]];
//    }
//    
//    for (id key in mdQueryStrings) {
//        NSLog(@"Key : %@, value : %@", key, [mdQueryStrings objectForKey:key]);
//    }
    
    //ssoToken이 있으면 값 세팅
    NSString *ssoToken = [url query];
    
    if (ssoToken != nil && ssoToken != NULL) {
        NSLog(@"AppDelegate - ssotoken is not null.");
        
        NSString *ssoTokenKey = ipo_sso_init([CommonUtil expPageUrl]);
        ssoToken = [ssoToken substringFromIndex:9];
        NSLog(@"AppDelegate - ssoToken : %@", ssoToken);
        
        ipo_set_ssotoken(ssoToken, ssoTokenKey);
//        ipo_sso_verify_token(ssoToken, [CommonUtil clientIp]);
//        ipo_sso_verify_token_sec(ssoToken, [CommonUtil clientIp], getSecId());
        ipo_sso_verify_token(ssoToken, [CommonUtil clientIp], getSecId());
    } else {
        NSLog(@"AppDelegate - ssoToken is null and web income");
        NSString *samplePageUrl = [NSString stringWithFormat:@"http://192.168.70.155:7080/m/ios/msso_auth_id_sample.jsp?secId=%@", getSecId()];
        NSURL *sampleUrl = [[NSURL alloc] initWithString:samplePageUrl];
        [[UIApplication sharedApplication] openURL:sampleUrl];
        return NO;
    }

    NSString *UrlString = [url absoluteString];
    
    [[NSUserDefaults standardUserDefaults] setObject:UrlString forKey:@"url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
    
}

//- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    NSLog(@"AppDelegate - Application bundle ID : %@", sourceApplication);
//    NSLog(@"AppDelegate - url scheme : %@", [url scheme]);
//    NSLog(@"AppDelegate - url query : %@", [url query]);
//    
//    return YES;
//}

@end
