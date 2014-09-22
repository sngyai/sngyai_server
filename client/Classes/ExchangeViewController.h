//
//  ExchangeViewController.h
//  LiZhuan
//
//  Created by 杨玉东 on 14-9-21.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ExchangeViewController : UIViewController<UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UIView *ExchangeView;
@property (retain, nonatomic) IBOutlet UITextField *textExchange;
@property (retain, nonatomic) IBOutlet UIButton *buttonExchange;

-(IBAction)backgroundTap:(id)sender;

@end
