//
//  PrayerRequestYeahGodViewController.m
//  PointTracker
//
//  Created by Andrew Moore on 9/7/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "PrayerRequestYeahGodViewController.h"
#import "NewRequestOrPraiseViewController.h"

@interface PrayerRequestYeahGodViewController ()

@end

@implementation PrayerRequestYeahGodViewController
@synthesize values;

- (id)init
{
    self = [super init];
    if (self) {
        // Set which "class" on parse this table is related to
        self.parseClassName = @"RequestsAndPraises";
        self.pullToRefreshEnabled = YES;
        
        [[self navigationItem] setTitle:@"Home"];
        
        UIImage *signoutImage = [UIImage imageNamed:@"SignOut.png"];
        UIButton *signoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [signoutButton setImage:signoutImage forState:UIControlStateNormal];
        [signoutButton setFrame:CGRectMake(0, 0, signoutImage.size.width+10, signoutImage.size.height)];
        
        UIBarButtonItem *signoutBarButton = [[UIBarButtonItem alloc] initWithCustomView:signoutButton];
        [signoutButton addTarget:self action:@selector(logOutButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];
        
        NSArray *leftBarButtons = [[NSArray alloc] initWithObjects:signoutBarButton, nil];
        [[self navigationItem] setLeftBarButtonItems:leftBarButtons animated:YES];
        
        UIBarButtonItem *addPersonButton = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                            target:self
                                            action:@selector(addNewItem:)];
        [[self navigationItem] setRightBarButtonItem: addPersonButton];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadObjects];
    
    UIView *tableHeaderView = [[UIView alloc] init];
    [tableHeaderView setFrame: CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)];
    
    UILabel *nameAndPointValue = [[UILabel alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)];
    [nameAndPointValue setText: [NSString stringWithFormat:@"Loading data..." ]];
    [nameAndPointValue setTextAlignment:NSTextAlignmentCenter];
    [nameAndPointValue setBackgroundColor:[UIColor lightGrayColor]];
    
    PFQuery *query = [PFQuery queryWithClassName:@"People"];
    NSString *emailOfCurrentUser = [[PFUser currentUser]email];
    [query whereKey:@"email" equalTo:emailOfCurrentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(objects.count == 1)
        {
            PFObject *person = [objects objectAtIndex:0];
            NSString *name = [person objectForKey:@"firstName"];
            NSString *points = [NSString stringWithFormat:@"%@",[person objectForKey:@"points"]];
            [nameAndPointValue setText: [NSString stringWithFormat:@"%@, you have %@ bidding points", name, points]];
        }
    }];
    [tableHeaderView addSubview: nameAndPointValue];
    [[self tableView]setTableHeaderView: tableHeaderView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)addNewItem:(id)sender
{
    NewRequestOrPraiseViewController *addForm = [[NewRequestOrPraiseViewController alloc] init];
    
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

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [PFUser logOut];
        [[self navigationController] popToRootViewControllerAnimated: YES];
    }
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
            values = [NSArray arrayWithArray:objects];
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
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath object:(PFObject *)object
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [[cell textLabel] setText: [NSString stringWithFormat:@"%@",[object objectForKey:@"textSubmitted"]]];
    
    // Set the background of the cell based on gender
    bool isRequest = [[object objectForKey:@"isRequest"]boolValue];
    UIView *back = [[UIView alloc]initWithFrame:CGRectZero];
    if(isRequest){
        [back setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"finalBoyBack.jpeg"]]];
        cell.backgroundView = back;
    }
    else if(!isRequest){
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    PFObject *selectedPost = values[indexPath.row];
    bool isRequest = [[selectedPost objectForKey:@"isRequest"]boolValue];
    NSString *postText = [selectedPost objectForKey:@"textSubmitted"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: isRequest ? @"Prayer Request" : @"Yeah God!" message:postText delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
    [alert show];
}




@end
