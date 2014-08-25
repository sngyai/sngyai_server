//
//  CodeAdViewController.h
//  MiidiSdkSample_Banner
//
//  Created by adpooh miidi on 12-5-18.
//  Copyright 2012 miidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiidiAdViewDelegate.h"
#import "MiidiAdView.h"

@interface CodeAdViewController_iPhone : UIViewController <MiidiAdViewDelegate>{
	MiidiAdView		*adView_;
}

@end
