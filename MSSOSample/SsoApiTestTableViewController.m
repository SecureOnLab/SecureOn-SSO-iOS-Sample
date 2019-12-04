//
//  SsoApiTestTableViewController.m
//  MSSOSample
//


#import "SsoApiTestTableViewController.h"
#import "SsoApiTestViewController.h"

@implementation SsoApiTestTableViewController

@synthesize ssoApiListData = _ssoApiListData;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"putValue()", @"getValue()", @"getAllValues()", @"userPwdInit()", @"userModifyPwd()", @"userSearch()", @"userView()", @"getUserRoleList()", @"getResourcePermission()", @"getResourceList()", nil];
    self.ssoApiListData = array;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0) {
        return [self.ssoApiListData count];
    } else {
        return 0;   
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ssoApiTableCellIdentitfier = @"SsoApiTableCellIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ssoApiTableCellIdentitfier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ssoApiTableCellIdentitfier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ssoApiTableCellIdentitfier];
    }
    
    cell.textLabel.text = [self.ssoApiListData objectAtIndex:indexPath.row];
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UIViewController *ssoApiTestViewController = [UIViewController alloc];
//    [self.navigationController pushViewController:ssoApiTestViewController animated:YES];
//}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SsoApiTestSegue"]) {
        SsoApiTestViewController *ssoApiTestViewController = segue.destinationViewController;
        UITableViewCell *selectedSsoApiTableCell = (UITableViewCell *)sender;
        
//        [ssoApiTestViewController setApiTestModeValue:[[selectedSsoApiTableCell textLabel] text]];
        [ssoApiTestViewController setApiTestModeValue:[[selectedSsoApiTableCell textLabel] text]];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
