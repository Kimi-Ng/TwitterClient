//
//  DetailPageVC.h
//  TwitterClient
//
//  Created by Cheng-Yuan Wu on 7/3/15.
//  Copyright (c) 2015 Kimi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface DetailPageVC : UIViewController
- (id)initWithTweetData:(Tweet *)tweet;
@end
