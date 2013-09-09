//
//  PrayerRequestYeahGodViewController.h
//  PointTracker
//
//  Created by Andrew Moore on 9/7/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PrayerRequestYeahGodViewController : PFQueryTableViewController
<UIActionSheetDelegate>

@property (nonatomic, strong) NSArray *values;

- (IBAction)addNewItem:(id)sender;
- (IBAction)logOutButtonTapAction:(id)sender;

@end
