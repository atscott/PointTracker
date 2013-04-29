//
//  TableListViewController.m
//  PointTracker
//
//  Created by Andrew Moore on 4/16/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//
//  This class serves as the base/starting point upon launch of the application.
//
//  It it responsible for the following:
//  - Presenting the Login screen
//  - Presenting and managing the list of people
//

#import "TableListViewController.h"
#import "MoreInfoViewController.h"
#import "AddFormViewController.h"
#import "MyLogInViewController.h"
#import "MySignUpViewController.h"
#import "SettingsViewController.h"
#import "PersonDetailsViewController.h"

@interface TableListViewController ()

@end

@implementation TableListViewController

-(id)init
{
    self = [super initWithStyle: UITableViewStyleGrouped ];
    if (self)
    {
        
        ///[[self view] setBackgroundColor:[UIColor blackColor]];
        
        // Set which "class" on parse this table is related to
        self.parseClassName = @"People";
        self.pullToRefreshEnabled = YES;
        
        // Set the title and logo on the lower tab bar
        self.title = @"List";
        self.tabBarItem.image = [UIImage imageNamed:@"List"];
        
        // Set the NavItem and title on the top navigation bar
        UINavigationItem *navItem = [self navigationItem];
        [navItem setTitle:@"People"];
        
        // Create and place the "+" button 
        UIBarButtonItem *createNewPersonButton = [[UIBarButtonItem alloc]
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
        
        UIBarButtonItem *settingsBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
        [settingsButton addTarget:self action:@selector(settingsButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // Create and place Array of LeftBarButtons
        NSArray *leftBarButtons = [[NSArray alloc] initWithObjects:signoutBarButton, settingsBarButton, nil];
        [[self navigationItem] setLeftBarButtonItems:leftBarButtons animated:YES];
        
        // Create and place Array of RightBarButtons 
        NSArray *barButtons = [[NSArray alloc] initWithObjects: [self editButtonItem], createNewPersonButton, nil];
        [[self navigationItem] setRightBarButtonItems:barButtons animated:YES];
    }
    // Return this wonderful view we've just put together
    return self;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CoolBackground.png"]];
    [self handleLogin];
    [self loadObjects];
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:214/255.0f green:226/255.0f blue:226/255.0f alpha:1.0f];
    self.tableView.backgroundView = nil;
    //self.view.backgroundView = nil;
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CoolBackground.png"]];
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
    [[self navigationController] pushViewController:[[AddFormViewController alloc]initWithStyle:UITableViewStyleGrouped] animated:YES];
}

- (IBAction)logOutButtonTapAction:(id)sender {
    UIActionSheet *confirmSheet = [[UIActionSheet alloc]
                                   initWithTitle:@"Are you sure you want to Logout?"
                                   delegate:self
                                   cancelButtonTitle:@"Cancel"
                                   destructiveButtonTitle:@"Logout"
                                   otherButtonTitles:nil, nil];
    [confirmSheet showInView:self.view];
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
        // This method is called before a PFQuery is fired to get more objects
}

// Override to customize what kind of query to perform on the class.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    [query orderByDescending:@"points"];
    return query;
}

// Override to customize the look of a cell representing an object. 
- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    NSString *first = [object objectForKey:@"firstName"];
    NSString *last = [object objectForKey:@"lastName"];
    cell.textLabel.text = [[first stringByAppendingString:@" "] stringByAppendingString:last];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Points: %@", [object objectForKey:@"points"]];
    if( [indexPath row] % 2)
        [cell setBackgroundColor:[UIColor colorWithRed:229/255.0f green:256/255.0f blue:255/255.0f alpha:1.0f]];
    else
        [cell setBackgroundColor:[UIColor colorWithRed:221/255.0f green:256/255.0f blue:235/255.0f alpha:1.0f]];
    return cell;
}
/*************************************************************************/
/* TableView methods I may or may not implement in the future */
/*************************************************************************/

/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - Table view data source
/*************************************************************************/
/* TableView Data Source methods I may or may not implement in the future */
/*************************************************************************/

 
 /* Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }*/

 /* Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
 }*/

 /* Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {  } */

 /* Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
 } */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray *name = [cell.textLabel.text componentsSeparatedByString:@" "];
       
    PFQuery *query = [PFQuery queryWithClassName:@"People"];
    [query whereKey:@"firstName" equalTo: name[0]];
    [query whereKey:@"lastName" equalTo: name[1]];
    
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // The find succeeded.
//            NSLog(@"Successfully retrieved %d scores.", objects.count);
//            PFObject *user = objects[0];
//            [user setObject:[NSNumber numberWithInt:500] forKey:@"points"];
//            [user saveEventually];
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
    [[self navigationController] pushViewController:[[PersonDetailsViewController alloc]initWithID:[NSNumber numberWithInt:9]] animated:YES];
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

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) {
            informationComplete = NO;
            break;
        }
    }
    
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
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
