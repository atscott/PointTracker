//
//  PersonViewControllerTableViewController.m
//  PointTracker
//
//  Created by Andrew Moore on 9/20/14.
//  Copyright (c) 2014 SE4910I. All rights reserved.
//

#import "PersonViewControllerTableViewController.h"
#import "CheckinViewController.h"
#import "AddFormViewController.h"
#import "BButton.h"

@interface PersonViewControllerTableViewController ()

@end

@implementation PersonViewControllerTableViewController
{
    PFObject *selectedUser;
    BButton *checkinButton;
    NSArray *dataKeys;
    NSArray *dataValues;
    UIView *header;
    NSMutableArray *pointValues;
}

- (id)initWithPerson: (PFObject*) person
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        selectedUser = person;
        [selectedUser refresh];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];
    [self updateValues];
    [[self tableView]reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setKeys];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@",
                                 [selectedUser objectForKey:@"firstName"],
                                 [selectedUser objectForKey:@"lastName"]];
    
    UIBarButtonItem *editPersonButton = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                         target:self
                                         action:@selector(editPerson:)];
    [[self navigationItem] setRightBarButtonItem: editPersonButton];
    
    PFQuery *checkinQuery = [PFQuery queryWithClassName:@"Attendance"];
    [checkinQuery whereKey:@"personPointer" equalTo:selectedUser];
    [checkinQuery orderByDescending:@"createdAt"];
    NSArray *objects = [checkinQuery findObjects];
    if(objects.count > 0)
    {
        PFObject *checkinLog = [objects objectAtIndex:0];
        NSDate *date = checkinLog.createdAt;
        NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
        if([today day] != [otherDay day] ||
           [today month] != [otherDay month] ||
           [today year] != [otherDay year] ||
           [today era] != [otherDay era])
        {
            [self createCheckinButton];
        }
    }
    else
    {
        [self createCheckinButton];
    }
    [[self tableView] setTableHeaderView: [self latestHeaderView]];
    UIView* bview = [[UIView alloc] init];
    bview.backgroundColor = [UIColor lightGrayColor];
    [self.tableView setBackgroundView:bview];
}

- (void) createCheckinButton
{
    CGRect checkinFrame = CGRectMake(20, 20, 280, 40);
    checkinButton = [[BButton alloc] initWithFrame:checkinFrame];
    [checkinButton setTitle:@"Checkin" forState:UIControlStateNormal];
    [checkinButton setType:BButtonTypeSuccess];
    [checkinButton addTarget:self action:@selector(checkinButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) setKeys
{
    dataKeys = [[NSArray alloc]initWithObjects:
                  @"Grade",
                  @"Points",
                  @"Group Leader",
                  @"Phone #",
                  @"Emer. Phone #",
                  @"Email",
                  nil];
}

- (void) updateValues
{
    dataValues = [[NSArray alloc]initWithObjects:
                  [NSString stringWithFormat:@"%dth", [[selectedUser objectForKey:@"grade"] intValue]],
                  [NSString stringWithFormat:@"%@",[selectedUser objectForKey:@"points"]],
                  [selectedUser objectForKey:@"groupLeader"],
                  [NSString stringWithFormat:@"%@", [selectedUser objectForKey:@"phoneNumber"]],
                  [NSString stringWithFormat:@"%@", [selectedUser objectForKey:@"emergencyPhoneNumber"]],
                  [NSString stringWithFormat:@"%@",[selectedUser objectForKey:@"email"]],
                  nil];
}

- (UIView*) latestHeaderView
{
    float headerHeight = checkinButton == nil ? 70.0f : 125.0f;
    float buttonsY = checkinButton == nil ? 5.0f : CGRectGetMaxY(checkinButton.frame);
    
    header = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, headerHeight)];

    if (checkinButton != nil)
    {
        [header addSubview:checkinButton];
    }
    
    CGRect rmvPointsframe = CGRectMake(20, buttonsY + 15.0f, 130, 40);
    BButton *rmvPointsButton = [[BButton alloc] initWithFrame:rmvPointsframe];
    [rmvPointsButton setTitle:@"Remove Points" forState:UIControlStateNormal];
    [rmvPointsButton setType:BButtonTypeDanger];
    [rmvPointsButton addTarget:self action:@selector(rmvPointsButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:rmvPointsButton];
    
    CGRect addPointsframe = CGRectMake(170, buttonsY + 15.0f, 130, 40);
    BButton *addPointsButton = [[BButton alloc] initWithFrame:addPointsframe];
    [addPointsButton setTitle:@"Add Points" forState:UIControlStateNormal];
    [addPointsButton setType:BButtonTypePrimary];
    [addPointsButton addTarget:self action:@selector(addPointsButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:addPointsButton];

    return header;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataValues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.textLabel setText: dataKeys[indexPath.row]];
    [cell.detailTextLabel setText: dataValues[indexPath.row]];
    
    return cell;
}

- (IBAction)addPointsButtonTapAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Points"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles: @"100", @"200", @"300", @"400", @"500", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
}

- (IBAction)rmvPointsButtonTapAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Remove Points"
                                                             delegate:self
                                                    cancelButtonTitle:@"No, Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"100", @"200", @"300", @"400", @"500", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
}

- (IBAction)checkinButtonTapAction:(id)sender
{
    [[self navigationController]pushViewController:[[CheckinViewController alloc]initWithID:selectedUser] animated:YES];
}

-(IBAction)editPerson:(id)sender
{
    AddFormViewController *editView = [[AddFormViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [editView setUserBeingEdited:selectedUser];
    
    [[self navigationController] pushViewController:editView animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        if ([[actionSheet title] isEqualToString:@"Remove Points"])
        {
            NSNumber *currentPoints = [selectedUser objectForKey:@"points"];
            NSNumber *dif = [NSNumber numberWithFloat:([currentPoints floatValue] - ((buttonIndex + 1) * 100))];
            
            [selectedUser setObject:dif forKey:@"points"];
            [selectedUser save];
            
            PFObject *log = [PFObject objectWithClassName:@"PointLog"];
            [log setObject: self.navigationItem.title forKey:@"addedTo"];
            [log setObject: selectedUser forKey:@"addedToPointer"];
            [log setObject: [[PFUser currentUser] username] forKey:@"addedBy"];
            [log setObject: [NSNumber numberWithInt: -((buttonIndex + 1) * 100)] forKey:@"pointsAdded"];
            [log saveEventually];
            
        }
        else
        {
            NSNumber *currentPoints = [selectedUser objectForKey:@"points"];
            NSNumber *sum = [NSNumber numberWithFloat:([currentPoints floatValue] + ((buttonIndex + 1) * 100))];
            
            [selectedUser setObject:sum forKey:@"points"];
            [selectedUser save];
            
            PFObject *log = [PFObject objectWithClassName:@"PointLog"];
            [log  setObject: self.navigationItem.title forKey:@"addedTo"];
            [log setObject: selectedUser forKey:@"addedToPointer"];
            [log setObject: [[PFUser currentUser] username] forKey:@"addedBy"];
            [log setObject: [NSNumber numberWithInt: ((buttonIndex + 1) * 100)] forKey:@"pointsAdded"];
            [log saveEventually];
        }
        [self updateValues];
        [[self tableView] reloadData];
    }
}

@end
