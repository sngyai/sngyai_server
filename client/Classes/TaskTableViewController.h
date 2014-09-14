//
//  TaskTableViewController.h
//  LiZhuan
//
//  Created by sngyai on 14-8-27.
//
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "YouMiWall.h"
#import "JupengWall.h"
#import "MiidiAdSpot.h"
#import "MiidiAdWall.h"
#import "CSAppZone.h"
#import "MiidiManager.h"
#import "ZKcmoneZkcmtwo.h"
#import "RootViewController.h"
#import "GuoMobWallViewController.h"
#import "MiidiAdWallGetPointsDelegate.h"
#import "MiidiAdWallAwardPointsDelegate.h"
#import "MiidiAdWallSpendPointsDelegate.h"
#import "MiidiAdWallShowAppOffersDelegate.h"
#import "MiidiAdWallRequestToggleDelegate.h"
#import "DMOfferWallManager.h"
#import "TaskLogTableTableViewController.h"
#import "ApplicationCell.h"

@interface TaskTableViewController : UITableViewController
    <MiidiAdWallShowAppOffersDelegate,
    MiidiAdWallAwardPointsDelegate,
    MiidiAdWallSpendPointsDelegate,
    MiidiAdWallGetPointsDelegate,
    MiidiAdWallRequestToggleDelegate,
    GuoMobWallDelegate>
{
    UILabel *versionTipView_;
    ApplicationCell *_tmpCell;
    NSArray *_data;
    UINib *_cellNib;
}

@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) UINib *cellNib;
@property (nonatomic, retain) ApplicationCell *tmpCell;
@end
