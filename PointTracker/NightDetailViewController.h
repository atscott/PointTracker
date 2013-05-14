//
//  NightDetailViewController.h
//  PointTracker
//
//  Created by Andrew Moore on 5/7/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface NightDetailViewController : UIViewController

-(id)initWithNight:(PFObject *)night;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UILabel *verseLabel;
@end
