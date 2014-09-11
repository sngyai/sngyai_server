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
    self.navigationItem.title = @"欢迎使用";
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
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Task Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *indexStr = [[NSString alloc] init];
    indexStr = [TaskLogTableTableViewController getChannelStr:indexPath.row];
    cell.textLabel.text = [indexStr stringByAppendingString:@"积分墙"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	switch (indexPath.row) {
        case 0:
            {
                // 初始化并登录积分墙
                BOOL result = ZKcmoneOWPresentZKcmtwo(@"85a4821e2aca4035b3591de8e0e8cd4a", self);
                if(!result)
                {
                    NSInteger errCode = ZKcmoneOWFetchLatestErrorCode();
                    NSLog(@"Initialization error, because %@", errCodeList[errCode]);
                }
                else
                    NSLog(@"Initialization successfully!");
            }
            break;
        case 1:
            [YouMiWall showOffers:YES didShowBlock:^{
                NSLog(@"有米积分墙已显示");
            } didDismissBlock:^{
                NSLog(@"有米积分墙已退出");
            }];
            break;
        case 2: //米迪积分墙[下应用奖励积分]
            [MiidiAdWall showAppOffers:self withDelegate:self];
			break;
        case 3:
            {
                RootViewController  *tabBarController = (RootViewController*)(self.tabBarController);
                [tabBarController.guomobwall_vc pushGuoMobWall:YES Hscreen:NO];
             }
            break;
        case 4:
            {
                [[CSAppZone sharedAppZone] showAppZoneWithScale:0.9f];
            }
            break;
        case 5:
            {
                RootViewController  *tabBarController = (RootViewController*)(self.tabBarController);
                [tabBarController.offerWallManager presentOfferWallWithViewController:self type:eDMOfferWallTypeList];
            }
            break;
        case 6:
            {
                RootViewController  *tabBarController = (RootViewController*)(self.tabBarController);
                [tabBarController.mobisagejoy presentJoyWithViewController:self];
            }
        case 7:
            [JupengWall showOffers:self
                      didShowBlock:^{
                          NSLog(@"巨朋积分墙已显示");
                      } didDismissBlock:^{
                          NSLog(@"巨朋积分墙已退出");
                      }];
            break;
		default:
			break;
	}
}

static NSString* const errCodeList[] = {
    
    @"successful",
    @"offer wall is disabled",
    @"login connection failed",
    @"offer wall has not been loginned",
    @"offer wall is not initialized",
    @"offer wall has been loginned",
    @"unknown error",
    @"invalid event flag",
    @"app list request failed",
    @"app list response failed",
    @"app list parameter malformatted",
    @"app list is being requested",
    @"offer wall is not ready for show",
    @"keywords malformatted",
    @"current device has not enough space to save resource",
    @"resource malformatted",
    @"resource load failed",
    @"you are have already loginned",
    @"exceed max show count",
    @"exceed max login count",
    @"you have not enough points",
    @"points consumption is not available",
    @"point is negative number",
    @"receive point is error",
    @"network request error"
    @"network request too often",
    @"network request too often"
    
};
@end
