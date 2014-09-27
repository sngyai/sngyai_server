//
//  ExchangeLogTableViewCell.m
//  LiZhuan
//
//  Created by 杨玉东 on 14-9-27.
//
//

#import "ExchangeLogTableViewCell.h"
 
@implementation ExchangeLogTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.dateField = [[UILabel alloc]
                          initWithFrame:CGRectMake(5 , 5 , 140 , 20)];
        self.dateField.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.dateField];
        
		self.statusField = [[UILabel alloc]
                             initWithFrame:CGRectMake(5 , 30 , 70 , 20)];
        self.statusField.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.statusField];
        
        self.cashField = [[UILabel alloc]
                           initWithFrame:CGRectMake(160 , 5 , 150 , 20)];
		self.cashField.textAlignment = NSTextAlignmentRight;
        self.cashField.textColor = [UIColor blueColor];
        [self.contentView addSubview:self.cashField];
        
        self.accountField = [[UILabel alloc]
                             initWithFrame:CGRectMake(90 , 30 , 220 , 20)];
        self.accountField.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.accountField];

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
