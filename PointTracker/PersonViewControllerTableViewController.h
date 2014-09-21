//
//  PersonViewControllerTableViewController.h
//  PointTracker
//
//  Created by Andrew Moore on 9/20/14.
//  Copyright (c) 2014 SE4910I. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PersonViewControllerTableViewController : UITableViewController <UIActionSheetDelegate>

- (id)initWithPerson: (PFObject*) person;


@end
