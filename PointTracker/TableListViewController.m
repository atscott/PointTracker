//
//  TableListViewController.m
//
//  Created by Andrew Moore on 4/16/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//
//  This class serves as the base/starting point upon launch of the application.


#import "TableListViewController.h"
#import "AddFormViewController.h"
#import "MyLogInViewController.h"
#import "MySignUpViewController.h"
#import "PersonDetailsViewController.h"
#import "CheckinViewController.h"
#import "PrayerRequestYeahGodViewController.h"
#import "CurrentRosterViewController.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface TableListViewController ()

@end

@implementation TableListViewController

@synthesize idValues;

-(id)init
{
    self = [super initWithStyle: UITableViewStylePlain];
    if (self)
    {
        // Set which "class" on parse this table is related to
        self.parseClassName = @"People";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        
        // Set the title and logo on the lower tab bar
        self.title = @"List";
        self.tabBarItem.image = [UIImage imageNamed:@"List"];
        
        // Set the NavItem and title on the top navigation bar
        [[self navigationItem] setTitle:@"People"];
        
        // Create and place the "<-" logout button
        UIImage *signoutImage = [UIImage imageNamed:@"SignOut.png"];
        UIButton *signoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [signoutButton setImage:signoutImage forState:UIControlStateNormal];
        [signoutButton setFrame:CGRectMake(0, 0, signoutImage.size.width+10, signoutImage.size.height)];
        
        UIBarButtonItem *signoutBarButton = [[UIBarButtonItem alloc] initWithCustomView:signoutButton];
        [signoutButton addTarget:self action:@selector(logOutButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];

        NSArray *leftBarButtons = [[NSArray alloc] initWithObjects:signoutBarButton, nil];
        [[self navigationItem] setLeftBarButtonItems:leftBarButtons animated:YES];
        
        // Create and place the right bar button item
        UIImage *downArrowImage = [UIImage imageNamed:@"downArrow.png"];
        UIButton *downArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [downArrowButton setImage:downArrowImage forState:UIControlStateNormal];
        [downArrowButton setFrame:CGRectMake(0, 0, downArrowImage.size.width+10, downArrowImage.size.height)];
        
        UIBarButtonItem *moreOptionsBarButton = [[UIBarButtonItem alloc] initWithCustomView:downArrowButton];
        [downArrowButton addTarget:self action:@selector(moreOptionsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *addKidBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addKid:)];
        
        NSString *username = [PFUser currentUser].username;
        bool isAdmin = [username isEqualToString: @"andrewm"] || [username isEqualToString: @"carlac"] || [username isEqualToString: @"suee"];
        [[self navigationItem] setRightBarButtonItem: isAdmin ? moreOptionsBarButton : addKidBarButton];
        
        myTableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, 80.0)];
        
        NSArray *itemArray = [NSArray arrayWithObjects: @"First Name", @"Last Name", @"Points", nil];
        segControl = [[UISegmentedControl alloc] initWithItems:itemArray];
        segControl.frame = CGRectMake(0.0, 40.0, 320.0, 40.0);
        segControl.selectedSegmentIndex = 0;
        segControl.segmentedControlStyle = 7;
        segControl.tintColor = [UIColor darkGrayColor];
        [segControl addTarget:self
                    action:@selector(segTapped:)
                    forControlEvents:UIControlEventValueChanged];
        [myTableHeaderView addSubview:segControl];
        
        mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
        mySearchBar.placeholder = segControl.selectedSegmentIndex == 1 ? @"Enter Last Name" : @"Enter First Name";
        mySearchBar.showsCancelButton = YES;
        mySearchBar.delegate = self;
        mySearchBar.tintColor = [UIColor lightGrayColor];
        
        [myTableHeaderView addSubview:mySearchBar];
        
        self.tableView.tableHeaderView = myTableHeaderView;
        
        
    }
    return self;
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchName = searchBar.text;
    [searchBar resignFirstResponder];
    [self loadObjects];
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchName = @"";
    searchBar.text = @"";
    [mySearchBar resignFirstResponder];
    [self loadObjects];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    

    [self.navigationController.navigationBar setTintColor:[UIColor lightGrayColor]];
    [self loadObjects];
}


-(void) viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (IBAction)moreOptionsButtonTapped:(id)sender
{
    UIActionSheet *confirmSheet = [[UIActionSheet alloc]
                                   initWithTitle:@"I want to..."
                                   delegate:self
                                   cancelButtonTitle:@"Cancel"
                                   destructiveButtonTitle:nil
                                   otherButtonTitles:@"Add a Kid", @"Email Stats", nil];
    [confirmSheet showFromTabBar:self.tabBarController.tabBar];
}

- (IBAction)segTapped:(id)sender
{
    mySearchBar.placeholder = segControl.selectedSegmentIndex == 1 ? @"Enter Last Name" : @"Enter First Name";
    searchName = @"";
    mySearchBar.text = @"";
    [mySearchBar resignFirstResponder];
    [self loadObjects];

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

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet.title isEqualToString: @"Are you sure you want to Logout?"])
        if (buttonIndex == 0) {
            [PFUser logOut];
            [[self navigationController] popToRootViewControllerAnimated: YES];
        }
    if ([actionSheet.title isEqualToString: @"I want to..."])
    {
        if (buttonIndex == 0) {
            NSLog(@"Add Kid");
            AddFormViewController *addForm = [[AddFormViewController alloc]initWithStyle:UITableViewStyleGrouped];
            [[self navigationController] pushViewController:addForm animated:YES];
        }
        if (buttonIndex == 1) {
            NSLog(@"Email Stats");
            [self sendAttendanceStats];
        }
    }
}

- (void)sendAttendanceStats
{
    PFQuery *query = [PFQuery queryWithClassName:@"PointLog"];
    [query whereKey:@"reason" equalTo:@"CheckIn"];
    [query orderByDescending:@"createdAt"];
    query.limit = 1000;
    NSArray *data = [query findObjects];

    NSString *messageBody = @"";
    
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];

    
    for (int i = 0; i < [data count]; i++)
    {
        NSString *name = [[data objectAtIndex:i] objectForKey:@"addedTo"];
        
        NSDate *date = [[data objectAtIndex:i] createdAt];
        NSString *stringFromDate = [formatter stringFromDate:date];
        
        
        NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
        if([today day] == [otherDay day] &&
           [today month] == [otherDay month] &&
           [today year] == [otherDay year] &&
           [today era] == [otherDay era])
        {
            messageBody = [messageBody stringByAppendingString:[NSString stringWithFormat: @"%@, %@ \n", name, stringFromDate]];
        }
    }
    
    NSString *emailTitle = [NSString stringWithFormat:@"KidBlast Attendance %u/%u/%u", [today month], [today day], [today year]];
    
    NSArray *toRecipents = [NSArray arrayWithObjects: @"susane@crosswaygt.org", @"carlac@crosswaygt.org", @"admoore14@gmail.com", nil];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];

    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/***************************************************************/
/* Overridden Methods for extending PFQueryTableViewController */
/***************************************************************/
#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
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

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    if (segControl.selectedSegmentIndex == 0)
    [query orderByAscending:@"firstName"];
    else if (segControl.selectedSegmentIndex == 1)
    [query orderByAscending:@"lastName"];
    else if (segControl.selectedSegmentIndex == 2)
    [query orderByDescending:@"points"];

    if(searchName.length > 0)
    {
        if(segControl.selectedSegmentIndex == 1)
            [query whereKey:@"lastName" containsString:searchName.capitalizedString];
        else
            [query whereKey:@"firstName" containsString:searchName.capitalizedString];

    }
    return query;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Get the first and last name of the person this cell is for
    NSString *first = [object objectForKey:@"firstName"];
    NSString *last = [object objectForKey:@"lastName"];
    
    // Set the text of the labels of the cell
    if (segControl.selectedSegmentIndex == 1)
        cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", last, first];
    else
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", first, last];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Points: %@", [object objectForKey:@"points"]];
    
    // Set the background of the cell based on gender
    bool isBoy = [[object objectForKey:@"isBoy"]boolValue];
    UIView *back = [[UIView alloc]initWithFrame:CGRectZero];
    if(isBoy){
        [back setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"finalBoyBack.jpeg"]]];
        cell.backgroundView = back;
    }
    else if(!isBoy){
        [back setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"girlCellBack.jpeg"]]];
        cell.backgroundView = back;
    }
    
    // Set colors
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.accessoryView.backgroundColor = [UIColor clearColor];
    cell.accessoryView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [[self navigationController] pushViewController:[[PersonDetailsViewController alloc] initWithID:idValues[indexPath.row]] animated:YES];
}

- (IBAction)addKid:(id)sender{
    AddFormViewController *addForm = [[AddFormViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [[self navigationController] pushViewController:addForm animated:YES];
}

@end
