//
//  NewRequestOrPraiseViewController.h
//  PointTracker
//
//  Created by Andrew Moore on 9/8/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NewRequestOrPraiseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *postTypeSegControl;
@property (weak, nonatomic) IBOutlet UITextView *postTextView;

-(IBAction)save:(id)sender;

@end
