//
//  RootViewController.m
//  MiidiSdkSample_Wall
//
//  Created by adpooh miidi on 12-5-20.
//  Copyright 2012 miidi. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController


#pragma mark -
#pragma mark Initialization


#pragma mark -
#pragma mark View lifecycle


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]; if (self) {
        // 创建积分墙管理器,这⾥里使⽤用的是测试 ID,请按照 User Guide ⽂文档中获取新的 PublisherID。
        _offerWallManager = [[AssetZoneManager alloc] initWithPublisherID:@"96ZJ1IZAzeB0nwTBAd"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  	self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
//    _mobisagejoy = [[MobiSageJoyViewController alloc] initWithPublisherID:@"3c3e990aef814244824e648f024fd170"];
//    _mobisagejoy.delegate = self;

	_guomobwall_vc=[[GuoMobWallViewController alloc] initWithId:@"1igkea2wocd3978"];
    //设置代理
    _guomobwall_vc.delegate = self;
    _offerWallManager.delegate = self;
    
    _qumiViewController = [[QMRecommendApp alloc] initwithPointUserID:nil];
    _qumiViewController.delegate = self;
    _qumiViewController.rootViewController = self;
    //是否隐藏信号区，YES是隐藏，NO显示
    _qumiViewController.isHiddenStatusBar = NO;
    
    [[CSAppZone sharedAppZone] loadAppZone:[CSADRequest request]];
    
    _adWall=[[MBJoyView alloc] initWithAdUnitId:@"de4e1a27c9a80b8e42513e506f8c4033" adType:AdTypeList rootViewController:self userInfo:nil];
    _adWall.delegate = self;
    
    _kgad = [[CoolAdWall alloc] initWithAppID:@"RTB201415280310260wfbj3r67n7igtu" secretKey:@"ilac8ra3tbu8g5j" andDelegate:self];
    [_kgad setCoolAdWallColor:CoolAdWallThemeColor_Blue];
    
    _mopanAdWallControl = [[MopanAdWall alloc] initWithMopan:@"14418" withAppSecret:@"xd32us8u5kivxnhc"];
    _mopanAdWallControl.delegate = self;
    _mopanAdWallControl.rootViewController = self;
}

#pragma mark -
#pragma mark Table view data source

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

// MopanAdWallDelegate delegate start

// 积分墙开始加载数据。
// Adall starts to work.
- (void)adwallDidShowAppsStartLoad
{
    NSLog(@"[mopan] 开始加载积分墙");
	
	
}

// 关闭积分墙页面。
// Offer wall closed.
- (void)adwallDidShowAppsClosed
{
    NSLog(@"[mopan 关闭积分墙");
}

// 积分墙加载失败。可能的原因由error部分提供，例如网络连接失败、被禁用等。
- (void)adwallDidFailShowAppsWithError:(NSError *)error
{
    NSLog(@"[mopan] 加载积分墙失败");
	
}

// 成功请求积分墙开关
//
// 详解:当接收服务器返回积分墙开关成功后调用该函数
// 补充：adWallSwitch: 返回积分墙是否开启
- (void)adwallSuccessAskEnable:(BOOL)adWallEnable
{
    if(adWallEnable == YES){
        NSLog(@"[mopan] 从服务器查询，可以正常使用积分墙");
        
        
    }
    else{
        NSLog(@"[mopan] 从服务器查询，不能使用积分墙 .需要正常使用，需要到后台设置");
        
        
    }
    
}

// 请求积分墙开关失败后调用
//
// 详解:当接收服务器返回的数据失败后调用该函数
// 补充：
- (void)adwallFailAskEnable:(NSError *)error
{
    NSLog(@"[mopan] 获取积分墙开关失败!");
    
	
}



- (void)dealloc {
    //多盟
	_offerWallManager.delegate = nil;
    [_offerWallManager release];
    _offerWallManager = nil;
    // 磨盘释放内存
    _mopanAdWallControl.delegate = nil;
    [_mopanAdWallControl release];
    [super dealloc];
}

-(void) queryScore
{
    //获取IDFA
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSLog(@"HELLO, WORLD *********IDFA: %@", adId);
    
    NSString* StrUser = [NSString stringWithFormat:@"user/?msg=1001&user_id=%@", adId];
    NSString* StrUrl = [HOST stringByAppendingString:StrUser];
    
    NSURL *url = [NSURL URLWithString:StrUrl];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if (!error) {
        NSString *response = [request responseString];
        NSDictionary *object = [response objectFromJSONString];//获取返回数据，有时有些网址返回数据是NSArray类型，可先获取后打印出来查看数据结构，再选择处理方法，得到所需数据
        
        NSString *strScroreCur = [object objectForKey:@"score_current"];
        self.score = [[[NSNumber alloc] initWithInt:[strScroreCur intValue]] autorelease];
    }else{
        NSLog(@"HELLO, WORLD ***ERROR:%@", error);
    }
}

-(void) getAccount
{
    //获取IDFA
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    NSString* StrUser = [NSString stringWithFormat:@"user/?msg=1005&user_id=%@", adId];
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
        NSLog(@"HELLO,WORLD RETURN : %@", response);
        NSLog(@"HELLO,WORLD RETURN : %@", object);
        
        NSString *alipay = [object objectForKey:@"alipay"];
        NSLog(@"HELLO, WORLD ***alipay:%@", alipay);
        self.alipay = alipay;
    }else{
        NSLog(@"HELLO, WORLD ***ERROR:%@", error);
    }
}

@end



