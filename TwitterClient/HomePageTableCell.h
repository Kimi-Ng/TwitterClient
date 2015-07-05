//
//  HomePageTableCell.h
//  TwitterClient
//
//  Created by Cheng-Yuan Wu on 7/2/15.
//  Copyright (c) 2015 Kimi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterButtonDelegate.h"
#import "HomePageTableVC.h"
@interface HomePageTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *replayBtn;
@property (weak, nonatomic) IBOutlet UIButton *retweetBtn;
@property (weak, nonatomic) IBOutlet UIButton *addFavoriteBtn;
@property (weak, nonatomic) IBOutlet UILabel *tagLineLabel;
@property (weak, nonatomic) id <TwitterButtonDelegate> delegate;
@end
