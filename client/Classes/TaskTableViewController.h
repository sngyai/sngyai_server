//
//  TaskTableViewController.h
//  LiZhuan
//
//  Created by sngyai on 14-8-27.
//
//

#import <UIKit/UIKit.h>

#import "YouMiWall.h"
#import "MiidiAdSpot.h"
#import "MiidiAdWall.h"
#import "CSAppZone.h"
#import "MiidiManager.h"
#import "RootViewController.h"
#import "GuoMobWallViewController.h"
#import "MiidiAdWallGetPointsDelegate.h"
#import "MiidiAdWallAwardPointsDelegate.h"
#import "MiidiAdWallSpendPointsDelegate.h"
#import "MiidiAdWallShowAppOffersDelegate.h"
#import "MiidiAdWallRequestToggleDelegate.h"
#import "DMOfferWallManager.h"

@interface TaskTableViewController : UITableViewController
    <MiidiAdWallShowAppOffersDelegate,
    MiidiAdWallAwardPointsDelegate,
    MiidiAdWallSpendPointsDelegate,
    MiidiAdWallGetPointsDelegate,
    MiidiAdWallRequestToggleDelegate,
    GuoMobWallDelegate>
{
    UILabel *versionTipView_;
}

@end
