//
//  FirstViewController.h
//  PointTracker
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FirstViewController : UIViewController
<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

- (IBAction)logOutButtonTapAction:(id)sender;
@end
