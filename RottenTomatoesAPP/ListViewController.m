//
//  ListViewController.m
//  RottenTomatoesAPP
//
//  Created by kaden Chiang on 2015/6/15.
//  Copyright (c) 2015年 kaden Chiang. All rights reserved.
//

#import "ListViewController.h"
#import "DetailViewController.h"
#import "MovieCell.h"
#import <UIImageView+AFNetworking.h>
#import <SVProgressHUD.h>

@interface ListViewController ()

@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UILabel *ErrorLabel;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (nonatomic, strong) NSDictionary *retJson;
@property (nonatomic, strong) NSString *dataType;
@property (nonatomic, strong) NSString *dataSubtype;

// aready define in tableViewController
//@property (nonatomic, weak) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tabBar.delegate = self;
    [self.tabBar setSelectedItem: self.tabBar.items[0]];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    self.retJson = @{@"movies": @[]};
    self.dataType = @"movies";
    self.dataSubtype = @"box_office";
    [self refreshData];
}

- (void) refreshData{
    [SVProgressHUD showInfoWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    [RottenTomatoesUtil callAPIWithType:self.dataType subtype:self.dataSubtype limit:20 onComplete: ^(NSData* data, NSError *error){
        if (data != nil) {
            NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            
            self.retJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        }
        // use GCD for best performance
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (error != nil) {
                [self showErrorView:@"Network Error"];
            } else {
                [self.tableView reloadData];
            }
            [SVProgressHUD dismiss];
            [self.refreshControl endRefreshing];
        });
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showErrorView:(NSString *) errorMsg {
    [self.errorView setAlpha:0.0];
    [self.ErrorLabel setText:errorMsg];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.errorView setHidden: NO];
        [self.errorView setAlpha:0.8f];
        CGRect frameRect = self.errorView.frame;
        frameRect.origin.y += 42;
        self.errorView.frame = frameRect;
    } completion: ^(BOOL finished){
        [UIView animateWithDuration:0.5 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect frameRect = self.errorView.frame;
            frameRect.origin.y -= 42;
            self.errorView.frame = frameRect;
        } completion: ^(BOOL finished) {
            [self.errorView setHidden: YES];
        }];
    }];
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger barItemIdx = [tabBar.items indexOfObject:item];
    if (barItemIdx == 0) {
        self.navigationItem.title = @"Box Office";
        self.dataType = @"movies";
        self.dataSubtype = @"box_office";
    } else if (barItemIdx == 1){
        self.navigationItem.title = @"Top Rentals";
        self.dataType = @"dvds";
        self.dataSubtype = @"top_rentals";
    }
    [self refreshData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.retJson objectForKey:@"movies"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    NSDictionary *movieData = [self.retJson objectForKey:@"movies"][indexPath.row];
    cell.titleLabel.text = [movieData objectForKey:@"title"];
    cell.synopsisLabel.text = [movieData objectForKey:@"synopsis"];
    NSString *posterUrlString = [movieData valueForKeyPath:@"posters.thumbnail"];
//    NSString *posterUrlString = [RottenTomatoesUtil hiResImageUrl:[movieData valueForKeyPath:@"posters.thumbnail"]];
    [cell.posterImage setImageWithURL:[NSURL URLWithString:posterUrlString]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqual:@"detailSegue"]) {
        MovieCell *cell = (MovieCell *)sender;
        DetailViewController *viewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        viewController.movieData = self.retJson[@"movies"][indexPath.row];
        viewController.placeholderImage = [cell.posterImage image];
    }
}

@end
