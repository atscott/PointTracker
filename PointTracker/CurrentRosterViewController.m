//
//  CurrentRosterViewController.m
//  PointTracker
//
//  Created by Andrew Moore on 10/9/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "CurrentRosterViewController.h"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface CurrentRosterViewController ()

@end

@implementation CurrentRosterViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.parseClassName = @"PointLog";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        
        self.tabBarItem.image = [UIImage imageNamed:@"History"];
        self.title = @"Current Attendance";
    }
    return self;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
}

- (void) moveAllSubviewsDown{
    float barHeight = 45.0;
    for (UIView *view in self.view.subviews) {
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + barHeight, view.frame.size.width, view.frame.size.height - barHeight);
        } else {
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + barHeight, view.frame.size.width, view.frame.size.height);
        }
    }
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
    //self.title = [NSString stringWithFormat:@"%lu here today", (unsigned long)self.objects.count];

}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    PFQuery *query = [self queryForTable];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
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
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow: -(60.0f*60.0f*24.0f)];

    [query whereKey:@"reason" equalTo:@"CheckIn"];
    [query whereKey:@"createdAt" greaterThan:yesterday];
    [query orderByAscending:@"addedTo"];
    
    return query;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Get the first and last name of the person this cell is for
    NSString *name = [object valueForKey:@"addedTo"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    
    // Set the text of the labels of the cell
    cell.textLabel.text = [NSString stringWithFormat:@"%u - %@", [indexPath row]+1, name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Checked in %@", [formatter stringFromDate: [object createdAt]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
