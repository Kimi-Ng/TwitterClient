//
//  DetailPageVC.m
//  TwitterClient
//
//  Created by Cheng-Yuan Wu on 7/3/15.
//  Copyright (c) 2015 Kimi. All rights reserved.
//

#import "DetailPageVC.h"
#import "ComposePageVC.h"
#import "Tweet.h"
#import "User.h"
#import <UIImageView+AFNetworking.h>
#import "TwitterClient.h"

@interface DetailPageVC ()
@property (strong, nonatomic) UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *replayIconBtn;
@property (weak, nonatomic) IBOutlet UIButton *retweetIconBtn;
@property (weak, nonatomic) IBOutlet UIButton *addFavoriteIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic) Tweet *tweet;
//@property (strong, nonatomic) User *user;

@end

@implementation DetailPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tweet";
    [self setupReplyButton:@"Reply"];
    UIBarButtonItem *replyBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.replyButton];
    [self.navigationItem setRightBarButtonItem:replyBarItem];
    [self setupData];
    [self drawLayerLine:self.view.layer lineFromPointA:CGPointMake(10.0f, 245.0f) toPointB:CGPointMake(340.0f, 245.0f) color:[UIColor grayColor]];
    [self drawLayerLine:self.view.layer lineFromPointA:CGPointMake(10.0f, 305.0f) toPointB:CGPointMake(340.0f, 305.0f) color:[UIColor grayColor]];
    [self drawLayerLine:self.view.layer lineFromPointA:CGPointMake(10.0f, 340.0f) toPointB:CGPointMake(340.0f, 340.0f) color:[UIColor grayColor]];
    
    [self.replayIconBtn setImage:[UIImage imageNamed:@"reply_hover.png"] forState:UIControlStateHighlighted];
    [self.addFavoriteIconBtn setImage:[UIImage imageNamed:@"favorite_hover.png"] forState:UIControlStateHighlighted];
    [self.retweetIconBtn setImage:[UIImage imageNamed:@"retweet_hover.png"] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithTweetData:(Tweet *)tweet {
//    self = [super init];
    self = [super initWithNibName:@"DetailPageVC" bundle:nil];
    if (self) {
        self.tweet = tweet;
    }
    return  self;
}

- (void)setupReplyButton:(NSString *)buttonTitle {
    self.replyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    [self.replyButton setBackgroundColor:[UIColor redColor]];
    [self.replyButton.layer setBorderWidth:1.5f];
    [self.replyButton.layer setBorderColor:[UIColor brownColor].CGColor];
    [self.replyButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self.replyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.replyButton addTarget:self action:@selector(replyButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)replyButtonAction {
    [self.navigationController pushViewController:[[ComposePageVC alloc] initWithTweetData:self.tweet] animated:YES];
}
- (IBAction)addFavoriteButtonPressed:(UIButton *)sender {
    //api request
    [[TwitterClient sharedInstance] addFavoriteWithId:[self.tweet.tweetId integerValue]completion:^(NSArray *response, NSError *error) {
        //completed
        //refresh data
        /*[[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
            for (Tweet *tweet in tweets) {
                [self.timeline addObject:tweet];
            }
            [self.tableView reloadData];
        }]; */
        self.tweet.isFavorited = !self.tweet.isFavorited;
        [self setupAddFavoriteIcon];
    }];
}
- (IBAction)replayButtonPressed:(UIButton *)sender {
    [self.navigationController pushViewController:[[ComposePageVC alloc] initWithTweetData:self.tweet] animated:YES];
}
- (IBAction)retweetButtonPressed:(UIButton *)sender {
    //api request
    [[TwitterClient sharedInstance] retweetWithId:[self.tweet.tweetId integerValue] completion:^(NSArray *response, NSError *error) {
        self.tweet.isRetweeted = !self.tweet.isRetweeted;
        [self setupRetweetIcon];
    }];

}




- (void)setupData{
    User *user = (User *)self.tweet.user;
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = user.screenname;
    self.tagLineLabel.text = self.tweet.text;
    self.descriptionLabel.text = user.tagline;
    [self.mainImage setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
    
    
    self.postTimeLabel.text = [formatter stringFromDate:self.tweet.createAt];
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.tweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.tweet.favoriteCount];
    [self setupAddFavoriteIcon];
    [self setupRetweetIcon];

}

- (void)setupAddFavoriteIcon {
    if (self.tweet.isFavorited) {
        [self.addFavoriteIconBtn setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
    }
    else {
        [self.addFavoriteIconBtn setImage:[UIImage imageNamed:@"favorite_on.png"] forState:UIControlStateNormal];
    }
}
- (void)setupRetweetIcon {
    if (self.tweet.isRetweeted) {
        [self.retweetIconBtn setImage:[UIImage imageNamed:@"retweet.png"] forState:UIControlStateNormal];
    }
    else {
        [self.retweetIconBtn setImage:[UIImage imageNamed:@"retweet_on.png"] forState:UIControlStateNormal];
    }
}

- (void)drawLayerLine:(CALayer *)layer lineFromPointA:(CGPoint)pointA toPointB:(CGPoint)pointB color:(UIColor *)color
{
    CAShapeLayer *line = [CAShapeLayer layer];
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint: pointA];
    [linePath addLineToPoint:pointB];
    line.path=linePath.CGPath;
    line.fillColor = nil;
    line.opacity = 1.0;
    line.strokeColor = color.CGColor;
    [layer addSublayer:line];
}

@end
