//
//  PersonDetailsViewController.h
//
//  Created by Andrew Moore on 4/25/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "BButton.h"

@interface PersonDetailsViewController : UIViewController
<UIAlertViewDelegate, UIActionSheetDelegate>
{
    PFObject *selectedUser;
    NSString *reason;
    UIBarButtonItem *checkinPersonButton;
}
@property (weak, nonatomic) IBOutlet UILabel *gradeGenderLabel;
@property (weak, nonatomic) IBOutlet UITextView *emailTextView;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UITextView *phoneNumberTextView;
@property (weak, nonatomic) IBOutlet UITextView *emergencyPhoneTextView;
@property (weak, nonatomic) IBOutlet UITextView *leaderTextView;

-(id)initWithID:(PFObject *)person;
- (IBAction)addPointsButtonTapAction:(id)sender;
- (IBAction)rmvPointsButtonTapAction:(id)sender;
- (IBAction)checkinButtonTapAction:(id)sender;


@end
