//
//  ListViewController.h
//  RottenTomatoesAPP
//
//  Created by kaden Chiang on 2015/6/15.
//  Copyright (c) 2015年 kaden Chiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RottenTomatoesUtil.h"

@interface ListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITabBarDelegate>

@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) UIRefreshControl *
refreshControl;

@end

