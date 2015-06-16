//
//  ViewController.h
//  RottenTomatoesAPP
//
//  Created by kaden Chiang on 2015/6/14.
//  Copyright (c) 2015年 kaden Chiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RottenTomatoesUtil.h"

@interface DetailViewController : UIViewController

@property(nonatomic, strong) NSDictionary *movieData;
@property (strong, nonatomic) UIImage *placeholderImage;

@end

