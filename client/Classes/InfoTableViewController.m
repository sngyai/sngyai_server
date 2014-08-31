//
//  InfoTableViewController.m
//  LiZhuan
//
//  Created by sngyai on 14-8-30.
//
//

#import "InfoTableViewController.h"
#import "MJRefresh.h"

@interface InfoTableViewController ()

@end

@implementation InfoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if ([super initWithStyle:style] != nil)
    {
        UITabBarItem * item = [[UITabBarItem alloc]
                               initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];
        self.tabBarItem = item;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
    
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    self.refreshControl.tintColor = [UIColor grayColor];
//    
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc]
//                                           initWithString:@"下拉刷新"];
//    [self.refreshControl addTarget:self action:@selector(refreshScore)
//                               forControlEvents:UIControlEventValueChanged];
    [self setupRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];

    [self.tableView headerBeginRefreshing];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"刷新积分";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    //RootViewController  *tabBarController = (RootViewController*)(self.tabBarController);
    //NSNumber* newScore = [[[NSNumber alloc] initWithInt:[tabBarController.score intValue]+1] autorelease];
    
    //tabBarController.score = newScore;
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myId = @"Info Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myId];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:myId];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        RootViewController  *tabBarController = (RootViewController*)(self.tabBarController);
        
        NSString *totalScore = [NSString stringWithFormat:@"用户总积分:\t %@", tabBarController.score];
        cell.textLabel.text = totalScore;
    }
    
    return cell;
}

//- (void) refreshScore
//{
//    [self performSelector:@selector(handleScore) withObject:nil afterDelay:0.5];
//}
//
//- (void) handleScore
//{
//    RootViewController  *tabBarController = (RootViewController*)(self.tabBarController);
//    NSNumber* newScore = [[[NSNumber alloc] initWithInt:[tabBarController.score intValue]+1] autorelease];
//    
//    tabBarController.score = newScore;
//    
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc]
//                                           initWithString:@"正在刷新..."];
//    [self.refreshControl endRefreshing];
//    
//    [self.tableView reloadData];
//}


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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
