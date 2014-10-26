//
//  AccountSettingsViewController.m
//  LiZhuan
//
//  Created by 杨玉东 on 14-9-21.
//
//

#import "AccountSettingsViewController.h"
#import "UIDevice+IdentifierAddition.h"

@interface AccountSettingsViewController ()

@end

@implementation AccountSettingsViewController

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
    self.confirmButton.backgroundColor = NAVIGATION_BACKGROUND;
    self.confirmButton.showsTouchWhenHighlighted = YES;
    RootViewController  *tabBarController = (RootViewController*)(self.tabBarController);

    [tabBarController getAccount];
    
    self.textAlipay.keyboardType = UIKeyboardTypeURL;
    self.textAlipay.clearButtonMode = UITextFieldViewModeAlways;
    self.textAlipay.text = tabBarController.alipay;
    self.textAlipay.delegate = self;

    NSLog(@"HAHA");
    
    [self.confirmButton addTarget:self action:@selector(bindAlipay) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //[nameTextField resignFirstResponder];
    //    [numberTextField resignFirstResponder];
    [textField resignFirstResponder];//等于上面两行的代码
    
    NSLog(@"textFieldShouldReturn");//测试用
    return YES;
}

-(IBAction)backgroundTap:(id)sender
{
    [self.textAlipay resignFirstResponder];
}

- (void)dealloc {
    [AccountSettingsViewController release];
    [_confirmButton release];
    [_textAlipay release];
    [super dealloc];
}

- (void)bindAlipay{
    NSLog(@"bind alipay");
    NSString *alipay = self.textAlipay.text;
    
    if ([alipay isEqualToString:@""]  || alipay == nil){
        [self alertMessage:[NSString stringWithFormat:@"支付宝账号不能为空"]];
    }else{
        //获取IDFA
        NSString *id = [[UIDevice currentDevice] uniqueDeviceIdentifier];
        NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

        NSString* StrUser = [[[NSString stringWithFormat:@"user/?msg=1004&user_id=%@", adId]stringByAppendingString:[NSString stringWithFormat:@"&alipay=%@", alipay]] stringByAppendingString:[NSString stringWithFormat:@"&id=%@", id]];
        
        NSString* StrUrl = [HOST stringByAppendingString:StrUser];
        
        NSURL *url = [NSURL URLWithString:StrUrl];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        request.delegate = self;
        
        [request startSynchronous];
        
        NSError *error = [request error];
        
        if (!error) {
            [self noticeOK:[NSString stringWithFormat:@"设定成功"]];
        }else{
            NSLog(@"HELLO, WORLD ***ERROR:%@", error);
        }
    }
}


-(void) alertMessage:(NSString*)msg{
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"错误"
														message:msg
													   delegate:nil
											  cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

-(void) noticeOK:(NSString*)msg{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
														message:msg
													   delegate:nil
											  cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

@end
