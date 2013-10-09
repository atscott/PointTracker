//
//  LogViewController.m
//
//  Created by Andrew Moore on 4/17/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "LogViewController.h"

@interface LogViewController ()

@end

@implementation LogViewController

-(id)init
{
    self = [super initWithStyle: UITableViewStylePlain];
    if (self)
    {
        self.parseClassName = @"PointLog";
        self.pullToRefreshEnabled = YES;
        
        self.title = @"Point Log";
        self.tabBarItem.image = [UIImage imageNamed:@"History"];
        
        self.view.backgroundColor = [UIColor blackColor];
        [self.tableView setBackgroundColor:[UIColor blackColor]];
        self.tableView.backgroundView = nil;
        
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];   
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadObjects];
    [[self tableView] reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
}

// Override to customize what kind of query to perform on the class.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    showOnePersonInfo = NO;
    personToShow = nil;
    
    PFQuery *peopleQuery = [PFQuery queryWithClassName:@"People"];
    NSString *emailOfCurrentUser = [[PFUser currentUser]email];
    if(emailOfCurrentUser == nil)
        emailOfCurrentUser = [NSString stringWithFormat:@"noemail@gmail.com"];
    [peopleQuery whereKey:@"email" equalTo:emailOfCurrentUser];
    NSArray *objects = [peopleQuery findObjects];
    if(objects.count == 1)
    {
       personToShow = [objects objectAtIndex:0];
       showOnePersonInfo = [[personToShow objectForKey:@"isKid"]boolValue];
    }
    
    if(showOnePersonInfo)
    {
        [query whereKey:@"addedToPointer" equalTo:personToShow];
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    //[query orderByDescending:@"points"];
    [query orderByDescending:@"createdAt"];
    
    return query;
}

// Override to customize the look of a cell representing an object.
- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSString *receiver = [object objectForKey:@"addedTo"];
    NSString *giver = [object objectForKey:@"addedBy"];
    NSString *amount = [NSString stringWithFormat:@"%@",[object objectForKey:@"pointsAdded"]];
    
    NSDate *date = object.createdAt;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yy"];
    NSString *dateString = [dateFormatter stringFromDate: date];
    
    NSString *reason = [object objectForKey:@"reason"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@pts -> %@", amount, receiver];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@) By: %@ Reason: %@", dateString, giver, reason];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    [cell setUserInteractionEnabled: NO];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end