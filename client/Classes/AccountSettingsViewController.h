//
//  AccountSettingsViewController.h
//  LiZhuan
//
//  Created by 杨玉东 on 14-9-21.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AccountSettingsViewController : UIViewController<UITextFieldDelegate>{

}
@property (retain, nonatomic) IBOutlet UIViewController *AccountSettingViewController;
@property (retain, nonatomic) IBOutlet UITextField *textAlipay;
@property (retain, nonatomic) IBOutlet UIButton *confirmButton;

-(IBAction)backgroundTap:(id)sender;

@end
