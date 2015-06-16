//
//  ViewController.m
//  RottenTomatoesAPP
//
//  Created by kaden Chiang on 2015/6/14.
//  Copyright (c) 2015年 kaden Chiang. All rights reserved.
//

#import "DetailViewController.h"
#import <UIImageView+AFNetworking.h>

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.movieData);
    self.navigationItem.title = [self.movieData objectForKey:@"title"];
    self.titleLabel.text = [self.movieData objectForKey:@"title"];
    self.synopsisLabel.text = [self.movieData objectForKey:@"synopsis"];
    NSLog(@"%@", [self.movieData valueForKeyPath:@"posters.thumbnail"]);
    
    NSString *posterUrlString = [RottenTomatoesUtil hiResImageUrl:[self.movieData valueForKeyPath:@"posters.thumbnail"]];
    [self.posterImage setImageWithURL:[NSURL URLWithString:posterUrlString] placeholderImage: self.placeholderImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
