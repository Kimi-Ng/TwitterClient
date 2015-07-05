//
//  TwitterButtonDelegate.h
//  TwitterClient
//
//  Created by Cheng-Yuan Wu on 7/4/15.
//  Copyright (c) 2015 Kimi. All rights reserved.
//

@protocol TwitterButtonDelegate <NSObject>

@required
- (void)onClickReply:(UITableViewCell *)cell sender:(UIButton *)sender;//(Tweet *)tweet;
- (void)onClickRetweet:(UITableViewCell *)cell sender:(UIButton *)sender;//(Tweet *)tweet;
- (void)onClickAddFavorite:(UITableViewCell *)cell sender:(UIButton *)sender;//(Tweet *)tweet;

@end