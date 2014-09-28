//
//  ExchangeLogTableViewController.h
//  LiZhuan
//
//  Created by 杨玉东 on 14-9-21.
//
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "MJRefresh.h"
#import "ExchangeLog.h"

@interface ExchangeLogTableViewController : UITableViewController
<UITableViewDataSource>
{
    NSMutableArray *exchanges;
}
+(NSString*) getTypeStr:(int)type;

@end
