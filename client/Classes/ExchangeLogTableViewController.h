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

@interface ExchangeLogTableViewController : UITableViewController
{
    NSMutableArray *exchanges;
}
+(NSString*) getTypeStr:(int)type;
@end
