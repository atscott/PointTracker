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
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *emergencyPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityStateZipLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;

-(id)initWithID:(PFObject *)person;
- (IBAction)addPointsButtonTapAction:(id)sender;
- (IBAction)rmvPointsButtonTapAction:(id)sender;


@end
