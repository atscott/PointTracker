//
//  PersonDetailsViewController.h
//  PointTracker
//
//  Created by Andrew Moore on 4/25/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "BButton.h"
#import "TDRatingView.h"

@interface PersonDetailsViewController : UIViewController
<TDRatingViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>
{
    TDRatingView *pointScale;
}
@property (weak, nonatomic) IBOutlet UILabel *gradeGenderLabel;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (weak, nonatomic) IBOutlet UITextView *emailTextView;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UITextView *phoneNumberTextView;
@property (weak, nonatomic) IBOutlet UITextView *emergencyPhoneTextView;

-(id)initWithID:(PFObject *)person;
- (IBAction)addPointsButtonTapAction:(id)sender;
- (IBAction)rmvPointsButtonTapAction:(id)sender;


@end
