//
//  TaskTableViewController.m
//  LiZhuan
//
//  Created by sngyai on 14-8-27.
//
//

#import "TaskTableViewController.h"
#import "CompositeSubviewBasedApplicationCell.h"
#import "HybridSubviewBasedApplicationCell.h"


@interface TaskTableViewController ()

@end

@implementation TaskTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if ([super initWithStyle:style] != nil)
    {
        UITabBarItem * item = [[UITabBarItem alloc]
                               initWithTitle:@"任务中心" image:[UIImage imageNamed:@"globe_enabled"] tag:0];
        self.tabBarItem = item;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
	
	// Configure the table view.
    self.tableView.rowHeight = 73.0;
//    self.tableView.backgroundColor = DARK_BACKGROUND;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
	// Load the data.
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    self.data = [NSArray arrayWithContentsOfFile:dataPath];
	
	self.cellNib = [UINib nibWithNibName:@"IndividualSubviewsBasedApplicationCell" bundle:nil];

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
    return [_data count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 40.0;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ApplicationCell";
    
    ApplicationCell *cell = (ApplicationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
    {

        [self.cellNib instantiateWithOwner:self options:nil];
		cell = _tmpCell;
		self.tmpCell = nil;
    }
    
	// Display dark and light background in alternate rows -- see tableView:willDisplayCell:forRowAtIndexPath:.
    cell.useDarkBackground = NO;//(indexPath.row % 2 == 0);
	
	// Configure the data for the cell.
    NSDictionary *dataItem = [_data objectAtIndex:indexPath.row];
    cell.icon = [UIImage imageNamed:[dataItem objectForKey:@"Icon"]];
    cell.publisher = [dataItem objectForKey:@"Publisher"];
    cell.name = [dataItem objectForKey:@"Name"];
    cell.numRatings = [[dataItem objectForKey:@"NumRatings"] intValue];
    cell.rating = [[dataItem objectForKey:@"Rating"] floatValue];
    cell.price = [dataItem objectForKey:@"Price"];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    cell.backgroundColor = ((ApplicationCell *)cell).useDarkBackground ? DARK_BACKGROUND : LIGHT_BACKGROUND;
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
            break;
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

-(void) setNav{
    self.navigationItem.title = @"欢迎使用";
//    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"左边按钮" style:UIBarButtonItemStylePlain
//                                                                      target:self action:@selector(OnLeftButton:)];
//    self.navigationItem.leftBarButtonItem = leftButtonItem;
//    [leftButtonItem release];
//    
//    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"右边按钮" style:UIBarButtonItemStylePlain
//                                                                       target:self action:@selector(OnRightButton:)];
//    self.navigationItem.rightBarButtonItem = rightButtonItem;
//    [rightButtonItem release];
    [self.navigationController.navigationBar setTintColor:[UIColor purpleColor]];
    [self.navigationController.navigationBar setBarTintColor:NAVIGATION_BACKGROUND];
//    [self.tabBarController.tabBar setBarTintColor:NAVIGATION_BACKGROUND];
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
