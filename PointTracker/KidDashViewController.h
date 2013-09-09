//
//  KidDashViewController.h
//  PointTracker
//
//  Created by Andrew Moore on 6/28/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface KidDashViewController : UIViewController
<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *pictureTitle;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

- (IBAction)logOutButtonTapAction:(id)sender;

@end
