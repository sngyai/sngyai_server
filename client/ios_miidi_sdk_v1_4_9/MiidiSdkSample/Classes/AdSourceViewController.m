//
//  AdSourceViewController.m
//  MiidiSDKApp
//
//  Created by xuyi on 14-2-10.
//  Copyright (c) 2014年 miidi. All rights reserved.
//

#import "AdSourceViewController.h"
#import "MiidiAdDesc.h"
#import "UIImageView+WebCache.h"
#import "MiidiAdWall.h"

@interface AdSourceViewController ()

@end

@implementation AdSourceViewController
@synthesize adDescArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
#ifdef __IPHONE_7_0
        if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7) {
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
        }
#endif
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"源数据列表";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if (!self.adDescArray){
        return 0;
    }
    return [self.adDescArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"c";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID] autorelease];
    }
    // 获得一个App的信息
    MiidiAdDesc *addesc = self.adDescArray[indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:addesc.iconUrl] placeholderImage:[UIImage imageNamed:@"Icon.png"]];
    [cell.textLabel setText:[NSString stringWithFormat:@"%d分:%@", addesc.points,addesc.title]];
    [cell.detailTextLabel setText:addesc.text];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 安装一个APP
    MiidiAdDesc *addesc = self.adDescArray[indexPath.row];
    [MiidiAdWall requestClickAd:addesc];
}

@end
