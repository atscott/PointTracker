//
//  TableListViewController.m
//  PointTracker
//
//  Created by Andrew Moore on 4/16/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//
//  This class serves as the base/starting point upon launch of the application.


#import "TableListViewController.h"
#import "MoreInfoViewController.h"
#import "AddFormViewController.h"
#import "MyLogInViewController.h"
#import "MySignUpViewController.h"
#import "SettingsViewController.h"
#import "PersonDetailsViewController.h"
#import "CheckinViewController.h"

@interface TableListViewController ()

@end

@implementation TableListViewController
@synthesize idValues;

-(id)init
{
    self = [super initWithStyle: UITableViewStylePlain ];
    if (self)
    {
        // Set which "class" on parse this table is related to
        self.parseClassName = @"People";
        self.pullToRefreshEnabled = YES;
        
        // Set the title and logo on the lower tab bar
        self.title = @"List";
        self.tabBarItem.image = [UIImage imageNamed:@"List"];
        
        // Set the NavItem and title on the top navigation bar
        [[self navigationItem] setTitle:@"People"];
        
        // Create and place the "+" button 
        UIBarButtonItem *addPersonButton = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                  target:self
                                                  action:@selector(addNewItem:)];
        // Create and place the "<-" logout button
        UIImage *signoutImage = [UIImage imageNamed:@"SignOut.png"];
        UIButton *signoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [signoutButton setImage:signoutImage forState:UIControlStateNormal];
        signoutButton.frame = CGRectMake(0, 0, signoutImage.size.width+10, signoutImage.size.height);

        UIBarButtonItem *signoutBarButton = [[UIBarButtonItem alloc] initWithCustomView:signoutButton];
        [signoutButton addTarget:self action:@selector(logOutButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // Create and set up "settings" bar button 
        UIImage *settingsImage = [UIImage imageNamed:@"Setting.png"];
        UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingsButton setImage:settingsImage forState:UIControlStateNormal];
        settingsButton.frame = CGRectMake(0, 0, settingsImage.size.width+10, settingsImage.size.height);
        
        //UIBarButtonItem *settingsBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
        //[settingsButton addTarget:self action:@selector(settingsButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // Create and place Array of LeftBarButtons
        NSArray *leftBarButtons = [[NSArray alloc] initWithObjects:signoutBarButton, /*settingsBarButton,*/ nil];
        [[self navigationItem] setLeftBarButtonItems:leftBarButtons animated:YES];
        
        // Create and place Array of RightBarButtons 
        NSArray *barButtons = [[NSArray alloc] initWithObjects: addPersonButton, nil];
        [[self navigationItem] setRightBarButtonItems:barButtons animated:YES];
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self handleLogin];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    UIColor * color = [UIColor colorWithRed:130/255.0f green:22/255.0f blue:241/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setTintColor:color];
    [self loadObjects];
}

-(void) viewDidLoad
{
    [super viewDidLoad];
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

- (IBAction)addNewItem:(id)sender
{
    AddFormViewController *addForm = [[AddFormViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [addForm setUserBeingEdited:nil];
    
    [[self navigationController] pushViewController:addForm animated:YES];
}

- (IBAction)logOutButtonTapAction:(id)sender {
    UIActionSheet *confirmSheet = [[UIActionSheet alloc]
                                   initWithTitle:@"Are you sure you want to Logout?"
                                   delegate:self
                                   cancelButtonTitle:@"Cancel"
                                   destructiveButtonTitle:@"Logout"
                                   otherButtonTitles:nil, nil];
    [confirmSheet showFromTabBar:self.tabBarController.tabBar];
}

- (IBAction)settingsButtonTapAction:(id)sender
{
    [[self navigationController] pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [PFUser logOut];
        [self handleLogin];
    }
}

/***************************************************************/
/* Overridden Methods for extending PFQueryTableViewController */
/***************************************************************/
#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    PFQuery *query = [self queryForTable];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            idValues = [NSArray arrayWithArray:objects];
        }
        else
        {
            NSLog(@"Error getting idValues");
        }
    }];
}

// Override to customize what kind of query to perform on the class.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    [query orderByAscending:@"isBoy"];

    return query;
}

// Override to customize the look of a cell representing an object. 
- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSString *first = [object objectForKey:@"firstName"];
    NSString *last = [object objectForKey:@"lastName"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", first, last];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Points: %@", [object objectForKey:@"points"]];
    bool isBoy = [[object objectForKey:@"isBoy"]boolValue];
    
    if(isBoy){
        UIView *back = [[UIView alloc]initWithFrame:CGRectZero];
        [back setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"finalBoyBack.jpeg"]]];
        cell.backgroundView = back;
    }
    else if(!isBoy){
        UIView *back = [[UIView alloc]initWithFrame:CGRectZero];
        [back setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"girlCellBack.jpeg"]]];
        cell.backgroundView = back;
    }
    
    cell.textLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.accessoryView.backgroundColor = [UIColor clearColor];
    cell.accessoryView.backgroundColor = [UIColor clearColor];
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    PFQuery *checkinQuery = [PFQuery queryWithClassName:@"Attendance"];
    [checkinQuery whereKey:@"personPointer" equalTo:object];
    [checkinQuery orderByAscending:@"date"];
    [checkinQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(objects.count > 0){
            PFObject *checkinLog = [objects objectAtIndex:0];
            NSDate *date = checkinLog.createdAt;
            NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
            NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
            if([today day] == [otherDay day] &&
               [today month] == [otherDay month] &&
               [today year] == [otherDay year] &&
               [today era] == [otherDay era]) {
                    cell.textLabel.textColor = [UIColor blackColor];
                    cell.detailTextLabel.textColor = [UIColor blackColor];
            }
        }
    }];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [[self navigationController] pushViewController:[[PersonDetailsViewController alloc] initWithID:idValues[indexPath.row]] animated:YES];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [[self navigationController]pushViewController:[[CheckinViewController alloc]initWithID:idValues[indexPath.row]] animated:YES];
}

/**************************************************/
/* Login Stuff                                    */
/**************************************************/
#pragma mark - PFLogInViewControllerDelegate

- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        // Begin login process
        return YES; 
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    // Interrupt login process
    return NO; 
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
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
        [match saveInBackground];
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
