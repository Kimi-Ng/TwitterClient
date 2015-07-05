//
//  HomePageTableCell.m
//  TwitterClient
//
//  Created by Cheng-Yuan Wu on 7/2/15.
//  Copyright (c) 2015 Kimi. All rights reserved.
//

#import "HomePageTableCell.h"

@implementation HomePageTableCell

- (void)awakeFromNib {
    // Initialization code
    [self.replayBtn setImage:[UIImage imageNamed:@"reply_hover.png"] forState:UIControlStateHighlighted];
    [self.addFavoriteBtn setImage:[UIImage imageNamed:@"favorite_hover.png"] forState:UIControlStateHighlighted];
    [self.retweetBtn setImage:[UIImage imageNamed:@"retweet_hover.png"] forState:UIControlStateHighlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)replayButtonPressed:(id)sender {
    [self.delegate onClickReply:self sender:sender];
}

- (IBAction)retweetButtonPressed:(id)sender {
    [self.delegate onClickRetweet:self sender:sender];
}

- (IBAction)addFavoriteButtonPressed:(id)sender {
    [self.delegate onClickAddFavorite:self sender:sender];
}



@end
