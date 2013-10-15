//
//  MainLandingViewController.h
//  PointTracker
//
//  Created by Andrew Moore on 9/7/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MainLandingViewController : UIViewController
<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UIActionSheetDelegate>
{
    UIViewController *viewControllerOnDisplay;
}
@end
