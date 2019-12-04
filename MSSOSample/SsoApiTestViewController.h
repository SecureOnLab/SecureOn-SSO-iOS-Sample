//
//  SsoApiTestViewController.h
//  MSSOSample
//


#import <UIKit/UIKit.h>
#import "CommonUtil.h"
#import "SsoUtil.h"

@interface SsoApiTestViewController : UIViewController

@property (nonatomic, strong) NSString *apiTestModeValue;
@property (nonatomic, strong) IBOutlet UILabel *apiTestModeLabel;
@property (nonatomic, strong) IBOutlet UILabel *firstLabel;
@property (nonatomic, strong) IBOutlet UILabel *secondLabel;
@property (nonatomic, strong) IBOutlet UILabel *scopeLabel;
@property (nonatomic, strong) IBOutlet UILabel *roleSearchLabel;

@property (nonatomic, strong) IBOutlet UITextField *apiTestModeText;
@property (nonatomic, strong) IBOutlet UITextField *firstText;
@property (nonatomic, strong) IBOutlet UITextField *secondText;

@property (nonatomic, strong) IBOutlet UISegmentedControl *scopeSegment;
@property (nonatomic, strong) IBOutlet UISegmentedControl *roleSearchSegment;

@property (nonatomic, strong) IBOutlet UITextView *retTextView;

-(IBAction)keypadHide:(id)sender;   //전체화면을 채워서 화면에 숨기게 동작
-(IBAction)ssoApiExcute:(id)sender; //실행 버튼 이벤트
-(void)selectModeView:(int)modeVal; //화면 감추는 메서드

-(void)putValueAction;
-(void)getValueAction;
-(void)getAllValuesAction;
-(void)userPwdInitAction;
-(void)userModifyPwdAction;
-(void)userSearchAction;
-(void)userViewAction;
-(void)getUserRoleListAction;
-(void)getResourcePermissionAction;
-(void)getResourceListAction;

+ (void) setCommonUtil:(CommonUtil *)iCommonUtil;   //commonUtil class data 전달 받는 메서드

@end
