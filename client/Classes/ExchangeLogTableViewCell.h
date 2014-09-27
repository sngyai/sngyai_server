//
//  ExchangeLogTableViewCell.h
//  LiZhuan
//
//  Created by 杨玉东 on 14-9-27.
//
//

#import <UIKit/UIKit.h>

@interface ExchangeLogTableViewCell : UITableViewCell
{
    UILabel* _dateField;
    UILabel* _cashField;
    UILabel* _accountField;
    UILabel* _statusField;
}
@property(strong) UILabel* dateField;
@property(strong) UILabel* cashField;
@property(strong) UILabel* accountField;
@property(strong) UILabel* statusField;
@end
