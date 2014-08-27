    //
//  CodeAdViewController.m
//  MiidiSdkSample_Banner
//
//  Created by adpooh miidi on 12-5-18.
//  Copyright 2012 miidi. All rights reserved.
//

#import "CodeAdViewController_iPhone.h"


@implementation CodeAdViewController_iPhone

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef __IPHONE_7_0
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
#endif
	
	self.title = @"代码方式创建广告条";
	
	//
	// 创建广告条
	adView_ = [[MiidiAdView alloc]initMiidiAdViewWithContentSizeIdentifier:MiidiAdSize320x50 delegate:self];
	// 设置位置
    CGRect frame1 = adView_.frame;
	frame1.origin.x = 0;
	frame1.origin.y = 0;
	adView_.frame = frame1;
	//
	[self.view addSubview:adView_];
    [adView_ requestAd];

}

- (void)viewWillAppear:(BOOL)a{
    [super viewWillAppear:a];
    
    
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	// 确保设置为nil,否则可能会报错
	if(adView_ != nil){
		adView_.delegate = nil;
	
		[adView_ release];
		adView_ = nil;
	}
	
    [super dealloc];
}


#pragma mark  MiidiAdViewDelegate 
// 请求广告条数据成功后调用
//
// 详解:当接收服务器返回的广告数据成功后调用该函数
// 补充：第一次返回成功数据后调用
- (void)didReceiveAd:(MiidiAdView *)adView{
	NSLog(@"Miidi请求广告成功!!!");
}

// 请求广告条数据失败后调用
// 
// 详解:当接收服务器返回的广告数据失败后调用该函数
// 补充：第一次和接下来每次如果请求失败都会调用该函数
- (void)didFailReceiveAd:(MiidiAdView *)adView  error:(NSError *)error{
	NSLog(@"Miidi请求广告失败!!!");
}



#pragma mark Ad Show Notification Methods

// 显示全屏广告成功后调用
//
// 详解:显示一次全屏广告内容后调用该函数
- (void)didShowAdWindow:(MiidiAdView *)adView{
	NSLog(@"Miidi显示全屏广告");
}

// 成功关闭全屏广告后调用
//
// 详解:全屏广告显示完成，关闭全屏广告后调用该函数
- (void)didDismissAdWindow:(MiidiAdView *)adView{
	NSLog(@"Miidi关闭全屏广告");
}
#pragma mark end

@end
