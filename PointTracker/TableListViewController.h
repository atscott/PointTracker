//
//  TableListViewController.h
//  PointTracker
//
//  Created by Andrew Moore on 4/16/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface TableListViewController : UITableViewController
<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
{ }

- (IBAction)addNewItem:(id)sender;
- (IBAction)addRandom:(id)sender;
- (IBAction)logOutButtonTapAction:(id)sender;

@end
