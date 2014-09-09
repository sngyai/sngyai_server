//
//  RootViewController.h
//  MiidiSdkSample_Wall
//
//  Created by adpooh miidi on 12-5-20.
//  Copyright 2012 miidi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YouMiWall.h"
#import "MiidiAdSpot.h"
#import "MiidiAdWall.h"
#import "CSAppZone.h"
#import "MiidiManager.h"
#import "GuoMobWallViewController.h"
#import "MiidiAdWallGetPointsDelegate.h"
#import "MiidiAdWallAwardPointsDelegate.h"
#import "MiidiAdWallSpendPointsDelegate.h"
#import "MiidiAdWallShowAppOffersDelegate.h"
#import "MiidiAdWallRequestToggleDelegate.h"





@interface RootViewController : UITabBarController <MiidiAdWallShowAppOffersDelegate
, MiidiAdWallAwardPointsDelegate
, MiidiAdWallSpendPointsDelegate
, MiidiAdWallGetPointsDelegate
, MiidiAdWallRequestToggleDelegate
, GuoMobWallDelegate>
{
    GuoMobWallViewController * _guomobwall_vc;
    NSNumber *_score;
}
@property(nonatomic,copy)GuoMobWallViewController *guomobwall_vc;
@property(nonatomic,copy)NSNumber *score;

@end
