//
//  TaskLogTableTableViewController.m
//  LiZhuan
//
//  Created by sngyai on 14-9-7.
//
//

#import "TaskLogTableTableViewController.h"

@interface TaskLogTableTableViewController ()

@end

@implementation TaskLogTableTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"任务记录";
    
    tasks = [[NSMutableArray alloc]init];
    [tasks removeAllObjects];
    [self setupRefresh];
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
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self queryTasks];
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tasks count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 20.0;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * myId = @"TaskIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myId];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:myId];
    }
    
    NSInteger rowNo = [indexPath row];
    
    cell.textLabel.textColor = [UIColor blueColor];
//    cell.textLabel.adjustsFontSizeToFitWidth = YES;
//    cell.textLabel.minimumFontSize = 6;
    UIFont *myFont = [UIFont fontWithName: @"Arial" size:12];
    cell.textLabel.font  = myFont;
    cell.textLabel.text = [tasks objectAtIndex:rowNo];
//    cell.textLabel.highlightedTextColor = [UIColor redColor];
    
//    cell.textLabel.font = [UIFont fontWithName:cell.textLabel.text size:25];
    
    return cell;
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
- (void)queryTasks{
    //获取IDFA
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSLog(@"HELLO, WORLD *********IDFA: %@", adId);
    
    NSString* StrUser = [NSString stringWithFormat:@"user/?msg=1002&user_id=%@", adId];
    NSString* StrUrl = [HOST stringByAppendingString:StrUser];
    
    NSURL *url = [NSURL URLWithString:StrUrl];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"HELLO, WORLD *********** RESPONSE:%@", response);
//        NSDictionary *object = [[NSString alloc] initWithData:[response objectFromJSONString] encoding:NSUTF8StringEncoding];
        NSDictionary *object = [response objectFromJSONString];
        [tasks removeAllObjects];
        for (NSDictionary *dic in object){
            NSDateFormatter *fromatter = [[[NSDateFormatter alloc] init] autorelease];
            [fromatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"time"]intValue]];
            
            NSString *dateString = [fromatter stringFromDate:date];
            
            int channel = [[dic objectForKey:@"channel"]intValue];
            NSString *channelString = [[[NSString alloc]init]autorelease];
            channelString = [self getChannelStr:channel];
            
            NSString *appNameString = [dic objectForKey:@"app_name"];
            
            NSString *cashString = [dic objectForKey:@"score"];
            
            NSString* TaskLog =
                [[[[[[dateString
                     stringByAppendingString:@"   "]
                     stringByAppendingString:channelString]
                  stringByAppendingString:@"   "]
                   stringByAppendingString:appNameString]
                    stringByAppendingString:@"   "]
                 stringByAppendingString:cashString];

            [tasks addObject:TaskLog];
        }
        NSLog(@"HELLO, WORLD DICT task_log, %@", tasks);
        [self.tableView reloadData];
    }else{
        NSLog(@"HELLO, WORLD ***ERROR:%@", error);
    }
}

-(NSString*) getChannelStr:(int)channel
{
    NSString *channelString = [[[NSString alloc]init]autorelease];
    NSLog(@"channel:%d", channel);
    switch (channel) {
        case 1:
            channelString = @"有米";
            break;
        case 2:
            channelString = @"米迪";
            break;
        case 3:
            channelString = @"果盟";
            break;
        case 5:
            channelString = @"触控";
            break;
        case 6:
            channelString = @"多盟";
            break;
        default:
            channelString = @"未知";
            break;
    }
    NSLog(@"HELLO, WORLD *********%@",channelString);
    return channelString;
}

@end
