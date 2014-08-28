//
//  TaskTableViewController.m
//  LiZhuan
//
//  Created by sngyai on 14-8-27.
//
//

#import "TaskTableViewController.h"

@interface TaskTableViewController ()

@end

@implementation TaskTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if ([super initWithStyle:style] != nil)
    {
        UITabBarItem * item = [[UITabBarItem alloc]
                               initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:0];
        item.badgeValue = @"新";
        self.tabBarItem = item;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置标题和返回
	self.navigationItem.title = @"利赚-手机赚钱";
	UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] init];
	backButtonItem.title = @"返回";
	self.navigationItem.backBarButtonItem = backButtonItem;
	[backButtonItem release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Miidi Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"米迪积分墙";
    }
	
	else if (indexPath.row == 1) {
        cell.textLabel.text = @"有米积分墙";
    }
	
	else if (indexPath.row == 2) {
        cell.textLabel.text = @"果盟积分墙";
    }
    else if (indexPath.row == 3) {
        cell.textLabel.text = @"触控积分墙";
    }
    return cell;
}

- (void)pbOfferWall:(PBOfferWall *)pbOfferWall queryResult:(NSArray *)taskCoins
          withError:(NSError *)error
{
    NSLog(@"----------%s", __PRETTY_FUNCTION__);
    NSLog(@"用户已经完成的任务：%@", taskCoins);
    
    NSMutableString *mstr = [NSMutableString string];
    if (taskCoins) {
        if (taskCoins.count > 0) {
            for (NSDictionary *dic in taskCoins) {
                [mstr appendFormat:@"%@:%@;", [dic objectForKey:@"taskContent"], [dic objectForKey:@"coins"]];
            }
        }
        else {
            [mstr appendString:@"无积分"];
        }
    }
    else {
        [mstr appendString:error.localizedDescription];
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"返回的金币数"
                                                        message:mstr
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
    [alertView release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	switch (indexPath.row) {
		case 0: //米迪积分墙[下应用奖励积分]
            [MiidiAdWall showAppOffers:self withDelegate:self];
			break;
        case 1:
            [YouMiWall showOffers:YES didShowBlock:^{
                NSLog(@"有米积分墙已显示");
            } didDismissBlock:^{
                NSLog(@"有米积分墙已退出");
            }];
            break;
        case 2:
            {
                RootViewController  *tabBarController = (RootViewController*)(self.tabBarController);
                [tabBarController.guomobwall_vc pushGuoMobWall:YES Hscreen:NO];
             }
            break;
        case 3:
            [[PBOfferWall sharedOfferWall] showOfferWallWithScale:0.9f];
            break;
		default:
			break;
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
