//
//  CheckinViewController.h
//  PointTracker
//
//  Created by Andrew Moore on 5/14/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CheckinViewController : UIViewController

-(id)initWithID:(PFObject *)person;

-(IBAction)save:(id)sender;

@end
