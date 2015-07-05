//
//  HomePageTableVC.m
//  TwitterClient
//
//  Created by Cheng-Yuan Wu on 7/1/15.
//  Copyright (c) 2015 Kimi. All rights reserved.
//

#import "HomePageTableVC.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "HomePageTableCell.h"
#import <UIImageView+AFNetworking.h>
#import "DetailPageVC.h"
#import "ComposePageVC.h"
#import "TwitterButtonDelegate.h"
@interface HomePageTableVC () <UITableViewDataSource, UITableViewDelegate, TwitterButtonDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIButton *signOutButton;
@property (strong, nonatomic) UIButton *newbutton;
@property (strong, nonatomic) NSMutableArray *timeline;


@end

@implementation HomePageTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"HomePageTableCell" bundle:nil] forCellReuseIdentifier:@"HomePageTableCell"];

    [self setupNavigationBar];

    //setup pull to refresh
    UIRefreshControl *pullToRefreshControl = [[UIRefreshControl alloc] init];
    [pullToRefreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    pullToRefreshControl.tintColor =  [UIColor magentaColor];
    self.refreshControl = pullToRefreshControl;
    
    
    //setup data object for timeline
    //call api for timeline
    self.timeline = [[NSMutableArray alloc] init];
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        for (Tweet *tweet in tweets) {
            [self.timeline addObject:tweet];
        }
        [self.tableView reloadData];
    }];
}

- (void)reloadData {
    self.timeline = [[NSMutableArray alloc] init];
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        [self.timeline removeAllObjects];
        for (Tweet *tweet in tweets) {
            [self.timeline addObject:tweet];
        }
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];

    }];
}
- (void)viewWillAppear:(BOOL)animated {
    self.timeline = [[NSMutableArray alloc] init];
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        [self.timeline removeAllObjects];
        for (Tweet *tweet in tweets) {
            [self.timeline addObject:tweet];
        }
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.timeline count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomePageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageTableCell" forIndexPath:indexPath];
    Tweet *tweet = (Tweet *)self.timeline[indexPath.row];
    User *user = (User *)((Tweet *)self.timeline[indexPath.row]).user;
    cell.nameLabel.text = user.name;
    cell.screenNameLabel.text = user.screenname;
    cell.tagLineLabel.text = tweet.text;
    cell.createTimeLabel.text = [NSString stringWithFormat:@"%ldH", (long)[tweet.relativeTime integerValue]];
    cell.delegate = self;
    [cell.mainImage setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    [self setupAddFavoriteIcon:cell.addFavoriteBtn isFavorited:tweet.isFavorited];
    [self setupRetweetIcon:cell.retweetBtn isFavorited:tweet.isRetweeted];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  90.0f;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    //DetailPageVC *detailPageController = [[DetailPageVC alloc] initWithNibName:@"DetailPageVC" bundle:nil];
    DetailPageVC *detailPageController = [[DetailPageVC alloc] initWithTweetData:(Tweet *)self.timeline[indexPath.row]];
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailPageController animated:YES];
}

- (void)setupSignOutButton:(NSString *)buttonTitle {
    self.signOutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    [self.signOutButton setBackgroundColor:[UIColor yellowColor]];
    [self.signOutButton.layer setBorderWidth:1.5f];
    [self.signOutButton.layer setBorderColor:[UIColor brownColor].CGColor];
    [self.signOutButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self.signOutButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.signOutButton addTarget:self action:@selector(signOutButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupNewButton:(NSString *)buttonTitle {
    self.newbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    [self.newbutton setBackgroundColor:[UIColor yellowColor]];
    [self.newbutton.layer setBorderWidth:1.5f];
    [self.newbutton.layer setBorderColor:[UIColor brownColor].CGColor];
    [self.newbutton setTitle:buttonTitle forState:UIControlStateNormal];
    [self.newbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.newbutton addTarget:self action:@selector(newButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)signOutButtonAction{
    [User logout];
}

- (void)newButtonAction{
    //DetailPageVC *detailPageController = [[DetailPageVC alloc] initWithTweetData:(Tweet *)self.timeline[indexPath.row]];
    ComposePageVC *composeController = [[ComposePageVC alloc] initWithNibName:@"ComposePageVC" bundle:nil];
    [self.navigationController pushViewController:composeController animated:YES];
    
}

- (void)setupNavigationBar {
    [self setTitle:@"Home"];
    [self setupSignOutButton:@"Sign Out"];
    [self setupNewButton:@"New"];
    UIBarButtonItem *signOutBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.signOutButton];
    [self.navigationItem setLeftBarButtonItem:signOutBarItem];
    UIBarButtonItem *tweetBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.newbutton];
    [self.navigationItem setRightBarButtonItem:tweetBarItem];
}


- (void)setupAddFavoriteIcon:(UIButton *)button isFavorited:(BOOL)isFavorited {
    if (isFavorited) {
        [button setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
    }
    else {
        [button setImage:[UIImage imageNamed:@"favorite_on.png"] forState:UIControlStateNormal];
    }
}
- (void)setupRetweetIcon:(UIButton *)button isFavorited:(BOOL)isRetweeted {
    if (isRetweeted) {
        [button setImage:[UIImage imageNamed:@"retweet.png"] forState:UIControlStateNormal];
    }
    else {
        [button setImage:[UIImage imageNamed:@"retweet_on.png"] forState:UIControlStateNormal];
    }
}

- (void)onClickAddFavorite:(UITableViewCell *)cell sender:(UIButton *)sender {
    Tweet *tweet = (Tweet *)self.timeline[[self.tableView indexPathForCell:cell].row];
    //api request
    [[TwitterClient sharedInstance] addFavoriteWithId:[tweet.tweetId integerValue]completion:^(NSArray *response, NSError *error) {
        ((Tweet *)self.timeline[[self.tableView indexPathForCell:cell].row]).isFavorited = !((Tweet *)self.timeline[[self.tableView indexPathForCell:cell].row]).isFavorited;

        [self setupAddFavoriteIcon:((HomePageTableCell *)cell).addFavoriteBtn isFavorited:((Tweet *)self.timeline[[self.tableView indexPathForCell:cell].row]).isFavorited];
    }];
}

- (void)onClickReply:(UITableViewCell *)cell sender:(UIButton *)sender {
    ComposePageVC *composeController = [[ComposePageVC alloc] initWithNibName:@"ComposePageVC" bundle:nil];
    [self.navigationController pushViewController:composeController animated:YES];
}

- (void)onClickRetweet:(UITableViewCell *)cell sender:(UIButton *)sender {
    Tweet *tweet = (Tweet *)self.timeline[[self.tableView indexPathForCell:cell].row];
    //api request
    [[TwitterClient sharedInstance] retweetWithId:[tweet.tweetId integerValue] completion:^(NSArray *response, NSError *error) {
        ((Tweet *)self.timeline[[self.tableView indexPathForCell:cell].row]).isRetweeted = !((Tweet *)self.timeline[[self.tableView indexPathForCell:cell].row]).isRetweeted;
        [self setupRetweetIcon:((HomePageTableCell *)cell).retweetBtn isFavorited:((Tweet *)self.timeline[[self.tableView indexPathForCell:cell].row]).isRetweeted];
    }];
}

@end
