//
//  ExchangeViewController.m
//  LiZhuan
//
//  Created by 杨玉东 on 14-9-21.
//
//

#import "ExchangeViewController.h"

@interface ExchangeViewController ()

@end

@implementation ExchangeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.buttonExchange.backgroundColor = NAVIGATION_BACKGROUND;
    self.buttonExchange.showsTouchWhenHighlighted = YES;
    RootViewController  *tabBarController = (RootViewController*)(self.tabBarController);
    
    [tabBarController getAccount];
    
    self.textExchange.keyboardType = UIKeyboardTypeDecimalPad;
    self.textExchange.delegate = self;
    self.textExchange.clearButtonMode = UITextFieldViewModeAlways;

    NSLog(@"HAHA");
    
    [self.buttonExchange addTarget:self action:@selector(doExchange) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //[nameTextField resignFirstResponder];
    //    [numberTextField resignFirstResponder];
    [textField resignFirstResponder];//等于上面两行的代码
    
    NSLog(@"textFieldShouldReturn 2");//测试用
    return YES;
}

-(IBAction)backgroundTap:(id)sender
{
    [self.textExchange resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [ExchangeViewController release];

    [_textExchange release];
    [_ExchangeView release];
    [_buttonExchange release];
    [super dealloc];
}

-(void) doExchange{
    NSLog(@"bind alipay");
    NSString *strExchange = self.textExchange.text;
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    float numExchange = [[f numberFromString:strExchange]floatValue];
    NSLog(@"numExchange: %f", numExchange);
    if (numExchange > 0){
        //获取IDFA
        NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        
        NSString* StrUser = [[NSString stringWithFormat:@"user/?msg=1006&user_id=%@", adId]stringByAppendingString:[NSString stringWithFormat:@"&exchange=%f", numExchange]];
        NSString* StrUrl = [HOST stringByAppendingString:StrUser];
        
        NSLog(@"HELLO, WORLD ***** URL:%@", StrUrl);
        
        NSURL *url = [NSURL URLWithString:StrUrl];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        request.delegate = self;
        
        [request startSynchronous];
        
        NSError *error = [request error];
        
        if (!error) {
            NSString *response = [request responseString];
            NSDictionary *object = [response objectFromJSONString];//获取返回数据，有时有些网址返回数据是NSArray类型，可先获取后打印出来查看数据结构，再选择处理方法，得到所需数据
            
            NSLog(@"HELLO, WORLD ***object:%@", object);
            NSString *errorCode = [object objectForKey:@"error"];
            if(!errorCode){
                RootViewController  *tabBarController = (RootViewController*)(self.tabBarController);
                [tabBarController queryScore];
                NSArray *viewControllers = self.navigationController.viewControllers;
                InfoTableViewController *infoViewController = (InfoTableViewController*)[viewControllers objectAtIndex:viewControllers.count - 2];
                [infoViewController.tableView reloadData];
                [self alertMessage:[NSString stringWithFormat:@"兑换成功"]];
            }
            else{
                NSString *errorString = [self get_error_string:errorCode];
                [self alertMessage:errorString];
            }
        }else{
            NSLog(@"HELLO, WORLD ***ERROR:%@", error);
        }
    }
    else{
        [self alertMessage:[NSString stringWithFormat:@"兑换金额不能为空"]];
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

-(NSString*) get_error_string:(NSString*)errorCode
{
    if([errorCode isEqualToString:@"score_not_enough"])
        return @"积分不足";
    if([errorCode isEqualToString:@"bind_account"])
        return @"请先绑定账号";
    if([errorCode isEqualToString:@"wrong_num"])
        return @"错误的金额";
}

@end
