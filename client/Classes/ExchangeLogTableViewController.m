//
//  ExchangeLogTableViewController.m
//  LiZhuan
//
//  Created by 杨玉东 on 14-9-21.
//
//

#import "ExchangeLogTableViewController.h"
#import "ExchangeLogTableViewCell.h"
#import "UIDevice+IdentifierAddition.h"

@interface ExchangeLogTableViewController ()

@end

@implementation ExchangeLogTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    self.title = @"兑换记录";
    
    exchanges = [[NSMutableArray alloc]init];
    [exchanges removeAllObjects];
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
    self.tableView.headerRefreshingText = @"刷新兑换记录";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self queryExchange];
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [exchanges count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellId";
    
    ExchangeLogTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil)
    {
        cell = [[ExchangeLogTableViewCell alloc] initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSInteger rowNo = [indexPath row];
    
    cell.userInteractionEnabled = NO;
    ExchangeLog *this_exchange = [exchanges objectAtIndex:rowNo];
    
    cell.dateField.text = this_exchange.date;
    cell.cashField.text = this_exchange.cash;
    cell.accountField.text= this_exchange.account;
    cell.statusField.text = this_exchange.status;
    
    return cell;
}

- (void)queryExchange{
    NSString *id = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    //获取IDFA
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSLog(@"HELLO, WORLD *********IDFA: %@", adId);
    
    NSString* StrUser = [[NSString stringWithFormat:@"user/?msg=1007&user_id=%@", adId] stringByAppendingString:[NSString stringWithFormat:@"&id=%@", id]];
    NSString* StrUrl = [HOST stringByAppendingString:StrUser];
    
    NSURL *url = [NSURL URLWithString:StrUrl];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if (!error) {
        NSString *response = [request responseString];
        NSDictionary *object = [response objectFromJSONString];
        [exchanges removeAllObjects];
        for (NSDictionary *dic in object){
            NSDateFormatter *fromatter = [[[NSDateFormatter alloc] init] autorelease];

            [fromatter setDateFormat:@"MM-dd HH:mm"];
            
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"time"]intValue]];
            
            NSString *dateString = [fromatter stringFromDate:date];
            
            int type = [[dic objectForKey:@"type"]intValue];
            NSString *typeStr = [[[NSString alloc]init]autorelease];
            typeStr = [ExchangeLogTableViewController getTypeStr:type];
            
            NSString *accountString = [dic objectForKey:@"account"];
            
            float cashInt = [[dic objectForKey:@"num"]floatValue];
            float cashFloat = cashInt/100;
            NSString *cashString = [NSString stringWithFormat:@"%.2f元",cashFloat];
            
            NSLog(@"hello, world!%f %f %@: ", cashInt, cashFloat, cashString);

//            NSString *cashString = [dic objectForKey:@"num"];
            NSString *status = [self get_status:[[dic objectForKey:@"status"] intValue]];
            
            ExchangeLog* new_exchange = [[ExchangeLog alloc] init];
            
            new_exchange.date = dateString;
            new_exchange.cash = [typeStr stringByAppendingString:cashString];
            new_exchange.account = accountString;
            new_exchange.status = status;
            
            [exchanges addObject:new_exchange];
        }
        [self.tableView reloadData];
    }else{
        NSLog(@"HELLO, WORLD ***ERROR:%@", error);
    }
}

+(NSString*) getTypeStr:(int)type
{
    NSString *typeStr = [[[NSString alloc]init]autorelease];
    switch (type) {
        case 0:
            typeStr = @"支付宝";
            break;
        default:
            typeStr = @"未知";
            break;
    }
    return typeStr;
}

-(NSString*) get_status:(int)status
{
    switch (status) {
        case 1:
            return @"已发放";
            break;
        default:
            return @"审核中";
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

- (void)dealloc {
    [super dealloc];
}
@end
