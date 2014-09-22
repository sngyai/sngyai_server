//
//  MiidiAdView.h
//  MiidiAd
//
//  Created by adpooh miidi on 12-2-20.
//  Copyright 2012 miidi. All rights reserved.
//
#import <UIKit/UIKit.h>



@protocol MiidiAdViewDelegate;

typedef enum {
    MiidiAdSizeUnknow     = 0,
    MiidiAdSize320x50     = 1,	// iPhone and iPod Touch ad size
	
	MiidiAdSize50x50      = 2,	// iphone & ipad ad size
	MiidiAdSize200x200    = 3,  // Minimum Rectangle size for the iPad
	
	MiidiAdSize460x72     = 4,	// ipad
	MiidiAdSize768x72     = 5	// ipad
		
} MiidiAdSizeIdentifier;





@interface MiidiAdView : UIView {
	
}
// 广告条的尺寸 

// 详解：
// MiidiAdSizeUnknow   --> 未知
// MiidiAdSize320x50   --> CGSizeMake(320, 50)
// MiidiAdSize50x50    --> CGSizeMake(50, 50)
// MiidiAdSize460x72   --> CGSizeMake(460, 72)
// MiidiAdSize768x72   --> CGSizeMake(768, 72)
// MiidiAdSize200x200  --> CGSizeMake(200, 200)
@property(nonatomic, assign, readonly)          MiidiAdSizeIdentifier adSizeIdentifier;

// 委托
@property(nonatomic, assign)                    id<MiidiAdViewDelegate> delegate;




+ (MiidiAdView *)createMiidiAdViewWithSizeIdentifier:(MiidiAdSizeIdentifier)adSizeIdentifier delegate:(id<MiidiAdViewDelegate>)delegate;
- (id)initMiidiAdViewWithContentSizeIdentifier:(MiidiAdSizeIdentifier)adSizeIdentifier delegate:(id<MiidiAdViewDelegate>)delegate;

- (void) requestAd;
@end
