//
//  RootViewController.h
//  MiidiSdkSample_Wall
//
//  Created by adpooh miidi on 12-5-20.
//  Copyright 2012 miidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiidiAdWallShowAppOffersDelegate.h"
#import "MiidiAdWallAwardPointsDelegate.h"
#import "MiidiAdWallSpendPointsDelegate.h"
#import "MiidiAdWallGetPointsDelegate.h"
#import "MiidiAdWallRequestToggleDelegate.h"
#import "GuoMobWallViewController.h"
#import "PBOfferWall.h"

@interface RootViewController : UITableViewController <MiidiAdWallShowAppOffersDelegate
, MiidiAdWallAwardPointsDelegate
, MiidiAdWallSpendPointsDelegate
, MiidiAdWallGetPointsDelegate
, MiidiAdWallRequestToggleDelegate
, PBOfferWallDelegate
, GuoMobWallDelegate>
{
    GuoMobWallViewController *guomobwall_vc;
    
	UILabel			*versionTipView_;
}

@end
