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
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
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
    CGRect frame = [[UIScreen mainScreen] bounds];

    
    CGRect synopsisLabelRect = [self.synopsisLabel.text boundingRectWithSize:CGSizeMake(frame.size.width-20, CGFLOAT_MAX)
                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                  attributes:@{NSFontAttributeName: self.synopsisLabel.font}
                                                                     context:nil];

    CGPoint detailViewOrigin = self.detailView.frame.origin;
    CGSize detailViewSize = CGSizeMake(frame.size.width, self.titleLabel.frame.size.height + synopsisLabelRect.size.height + 20);
    if (detailViewSize.height < frame.size.height - self.detailView.frame.origin.y) {
        detailViewSize.height = frame.size.height - self.detailView.frame.origin.y;
    }
    [self.detailView setFrame: CGRectMake(detailViewOrigin.x, detailViewOrigin.y, detailViewSize.width, detailViewSize.height)];
    NSLog(@"%@",NSStringFromCGRect(self.detailView.frame));
    
    synopsisLabelRect.origin.x = 10;
    synopsisLabelRect.origin.y = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 10;
    self.synopsisLabel.frame = synopsisLabelRect;

    NSLog(@"%@",NSStringFromCGRect(synopsisLabelRect));
    NSLog(@"synopsisLabel.frame: %@",NSStringFromCGRect(self.synopsisLabel.frame));
    NSLog(@"scrollView.bounds: %@",NSStringFromCGRect(self.scrollView.bounds));
    NSLog(@"synopsisLabel.bounds %@",NSStringFromCGRect(self.synopsisLabel.bounds));
    NSLog(@"detailView.frame: %@",NSStringFromCGRect(self.detailView.frame));

    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize: CGSizeMake(frame.size.width, self.detailView.frame.origin.y + self.detailView.frame.size.height)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
