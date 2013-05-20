//
//  CheckinViewController.h
//
//  Created by Andrew Moore on 5/14/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CheckinViewController : UIViewController
{
    PFObject *selectedPerson;
    bool hasBible;
    bool didVerse;
    NSNumber *friends;
    NSString *costume;
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *bibleSeg;
@property (weak, nonatomic) IBOutlet UISegmentedControl *verseSeg;
@property (weak, nonatomic) IBOutlet UISegmentedControl *friendSeg;
@property (weak, nonatomic) IBOutlet UISegmentedControl *costumeSeg;

-(id)initWithID:(PFObject *)person;

-(IBAction)save:(id)sender;

@end
