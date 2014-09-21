//
//  MainLandingViewController.m
//  PointTracker
//
//  Created by Andrew Moore on 9/7/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "MainLandingViewController.h"
#import "MyLogInViewController.h"
#import "MySignUpViewController.h"
#import "TableListViewController.h"

@interface MainLandingViewController ()

@end

@implementation MainLandingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Home";
        self.tabBarItem.image = [UIImage imageNamed:@"List"];
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self handleLogin];
}
-(void) viewDidAppear:(BOOL)animated
{
    if([PFUser currentUser])
    {
        if([[[PFUser currentUser] objectForKey:@"isLeader"]boolValue] == YES)
        {
            if(viewControllerOnDisplay == nil)
                viewControllerOnDisplay =[[TableListViewController alloc] init];
            else
                [self.navigationController popViewControllerAnimated:NO];
            
            [[self navigationController] pushViewController:viewControllerOnDisplay animated:NO];
            
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleLogin
{
    if (![PFUser currentUser]) {
        // Customize the Log In View Controller
        MyLogInViewController *logInViewController = [[MyLogInViewController alloc] init];
        [logInViewController setDelegate:self];
        [logInViewController setFields:
         PFLogInFieldsUsernameAndPassword |
         PFLogInFieldsSignUpButton |
         PFLogInFieldsDismissButton ];
        
        // Customize the Sign Up View Controller
        MySignUpViewController *signUpViewController = [[MySignUpViewController alloc] init];
        [signUpViewController setDelegate:self];
        [signUpViewController setFields:PFSignUpFieldsDefault | PFSignUpFieldsAdditional];
        [logInViewController setSignUpController:signUpViewController];
        
        // Present Log In View Controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
}


#pragma mark - PFLogInViewControllerDelegate

- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    
    if (username && password && username.length != 0 && password.length != 0)
        return YES;
    
    [[[UIAlertView alloc] initWithTitle:@"Oops"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"Will do"
                      otherButtonTitles:nil] show];
    return NO;
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PFSignUpViewControllerDelegate

- (BOOL)doesAUserExistInPeopleTableWithEmail:(NSString *) email
{
    BOOL __block exists = false;
    PFQuery *query = [PFQuery queryWithClassName:@"People"];
    [query whereKey:@"email" equalTo:email];
    PFObject *match = [query getFirstObject ];
    if(match != nil)
    {
        exists = true;
    }
    return exists;
}


// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    BOOL goodEmail = YES;
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) {
            informationComplete = NO;
            break;
        }
        if([key isEqualToString:@"email"])
        {
            goodEmail = [self doesAUserExistInPeopleTableWithEmail:field];
        }
    }
    
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }else if(!goodEmail) {
        [[[UIAlertView alloc] initWithTitle:@"No Matching Email"
                                    message:@"There is no matching person with that email in the database."
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    return (informationComplete && goodEmail);
}

- (void) createPointerInPeopleTableInBackground:(PFUser *) withUser
{
    NSString *emailForUser = [withUser objectForKey:@"email"];
    PFQuery *query = [PFQuery queryWithClassName:@"People"];
    [query whereKey:@"email" containsString:emailForUser];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *match, NSError *error) {
        [match setObject:withUser forKey:@"userLink"];
        [match saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error != nil)
            {
                [[[UIAlertView alloc]initWithTitle:@"Connection Falure" message:@"Please connect to the internet and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
        }];
    }];
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self createPointerInPeopleTableInBackground: user];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}



@end
