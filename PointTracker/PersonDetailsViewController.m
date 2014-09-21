//
//  PersonDetailsViewController.m
//
//  Created by Andrew Moore on 4/25/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "PersonDetailsViewController.h"
#import "AddFormViewController.h"
#import "CheckinViewController.h"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface PersonDetailsViewController ()

@end

@implementation PersonDetailsViewController

@synthesize gradeGenderLabel;
@synthesize emailTextView;
@synthesize emergencyPhoneTextView;
@synthesize phoneNumberTextView;
@synthesize pointsLabel;
@synthesize leaderTextView;

-(id)initWithID:(PFObject *)person
{
    self = [super init];
    if(self)
    {
        selectedUser = person;
        
        
        CGRect checkinFrame = CGRectMake(20, 60, 280, 40);
        BButton *checkinButton = [[BButton alloc] initWithFrame:checkinFrame];
        [checkinButton setTitle:@"Checkin" forState:UIControlStateNormal];
        [checkinButton setType:BButtonTypeSuccess];
        [checkinButton addTarget:self action:@selector(checkinButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:checkinButton];
        
        CGRect rmvPointsframe = CGRectMake(20, 115, 130, 40);
        BButton *rmvPointsButton = [[BButton alloc] initWithFrame:rmvPointsframe];
        [rmvPointsButton setTitle:@"Remove Points" forState:UIControlStateNormal];
        [rmvPointsButton setType:BButtonTypeDanger];
        [rmvPointsButton addTarget:self action:@selector(rmvPointsButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rmvPointsButton];
        
        CGRect addPointsframe = CGRectMake(170, 115, 130, 40);
        BButton *addPointsButton = [[BButton alloc] initWithFrame:addPointsframe];
        [addPointsButton setTitle:@"Add Points" forState:UIControlStateNormal];
        [addPointsButton setType:BButtonTypePrimary];
        [addPointsButton addTarget:self action:@selector(addPointsButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addPointsButton];
        
            }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];
    
    self.gradeGenderLabel.text = [NSString stringWithFormat:@"%dth", [[selectedUser objectForKey:@"grade"] intValue]];
    self.gradeGenderLabel.font = [UIFont fontWithName:@"Arial" size:20];    
    
    NSString *leader = [selectedUser objectForKey:@"groupLeader"];
    self.leaderTextView.text = [NSString stringWithFormat:@"%@ group", leader == nil || leader.length < 1 ? @"Unassigned" : [NSString stringWithFormat:@"%@'s", leader]];
    self.leaderTextView.font = [UIFont fontWithName:@"Arial" size:18];
    self.leaderTextView.textColor = leader == nil || leader.length < 1 ? [UIColor redColor] : [UIColor blackColor];
    self.leaderTextView.textAlignment = NSTextAlignmentCenter;

    self.phoneNumberTextView.text = [NSString stringWithFormat:@"%@",
                                     [selectedUser objectForKey:@"phoneNumber"]];
    self.phoneNumberTextView.font = [UIFont fontWithName:@"Arial" size:18];
    self.phoneNumberTextView.textColor = [UIColor blackColor];
    
    self.emergencyPhoneTextView.text = [NSString stringWithFormat:@"%@", [selectedUser objectForKey:@"emergencyPhoneNumber"]];
    self.emergencyPhoneTextView.font = [UIFont fontWithName:@"Arial" size:18];
    self.emergencyPhoneTextView.textColor = [UIColor blackColor];
    
    self.emailTextView.text = [NSString stringWithFormat:@"%@",[selectedUser objectForKey:@"email"]];
    self.emailTextView.font = [UIFont fontWithName:@"Arial" size:18];
    self.emailTextView.textColor = [UIColor blackColor];
    
    self.pointsLabel.text = [NSString stringWithFormat:@"%@",[selectedUser objectForKey:@"points"]];
    self.pointsLabel.font = [UIFont fontWithName:@"Arial" size:28];
    self.pointsLabel.textAlignment = NSTextAlignmentRight;
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@",
                                 [selectedUser objectForKey:@"firstName"],
                                 [selectedUser objectForKey:@"lastName"]];
    
    PFQuery *checkinQuery = [PFQuery queryWithClassName:@"Attendance"];
    [checkinQuery whereKey:@"personPointer" equalTo:selectedUser];
    [checkinQuery orderByDescending:@"createdAt"];
    [checkinQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if(objects.count > 0)
        {
            PFObject *checkinLog = [objects objectAtIndex:0];
            NSDate *date = checkinLog.createdAt;
            NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
            NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
            if([today day] == [otherDay day] &&
               [today month] == [otherDay month] &&
               [today year] == [otherDay year] &&
               [today era] == [otherDay era])
            {
                checkinPersonButton.enabled = false;
            }
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *editPersonButton = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                         target:self
                                         action:@selector(editPerson:)];
    
    
    [[self navigationItem] setRightBarButtonItem: editPersonButton];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    } else {
        [self moveAllSubviewsDown];
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (IBAction)addPointsButtonTapAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Earned Points Via:"
                                                             delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Nose", @"Blaster", @"Special Challenge", @"Other", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
    
}

- (IBAction)rmvPointsButtonTapAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Really? Are you sure you want to remove these points?"
                                                             delegate:self cancelButtonTitle:@"No, Cancel" destructiveButtonTitle:@"Yes, Remove"
                                                    otherButtonTitles:nil, nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
    
}

- (IBAction)checkinButtonTapAction:(id)sender
{
    [[self navigationController]pushViewController:[[CheckinViewController alloc]initWithID:selectedUser] animated:YES];
}


-(void)removePoints
{
//    NSNumber *currentPoints = [selectedUser objectForKey:@"points"];
//    NSNumber *dif = [NSNumber numberWithFloat:([currentPoints floatValue] - [pointValSelected floatValue])];
//    
//    [selectedUser setObject:dif forKey:@"points"];
//    [pointsLabel setText:[NSString stringWithFormat:@"%@",[dif stringValue]]];
//    [selectedUser saveEventually];
//    
//    PFObject *log = [PFObject objectWithClassName:@"PointLog"];
//    [log setObject: self.navigationItem.title forKey:@"addedTo"];
//    [log setObject: selectedUser forKey:@"addedToPointer"];
//    [log setObject: [[PFUser currentUser] username] forKey:@"addedBy"];
//    [log setObject: @"REMOVED" forKey: @"reason"];
//    [log setObject: pointValSelected forKey:@"pointsAdded"];
//    [log saveEventually];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"INDEX:%d", buttonIndex);
    if(buttonIndex == 0)
    {
        if(actionSheet.destructiveButtonIndex==buttonIndex)
        {
            [self removePoints];
            return;
        }
        reason = @"Nose";
        NSLog(@"Nose");
    }
    else if(buttonIndex == 1)
    {
        if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual: @"No, Cancel"]) {
            return;
        }
        reason = @"Blaster";
        NSLog(@"Blaster");
    }
    else if(buttonIndex == 2)
    {
        reason = @"Special Challenge";
        NSLog(@"Special Challenge");
    }
    else if(buttonIndex == 3)
    {
        reason = @"Other";
        NSLog(@"Other");
    }
    
    if(buttonIndex < 4)
    {
//        NSNumber *currentPoints = [selectedUser objectForKey:@"points"];
//        NSNumber *sum = [NSNumber numberWithFloat:([currentPoints floatValue] + [pointValSelected floatValue])];
//        
//        [selectedUser setObject:sum forKey:@"points"];
//        [pointsLabel setText:[NSString stringWithFormat:@"%@", [sum stringValue]]];
//        [selectedUser saveEventually];
//        
//        PFObject *log = [PFObject objectWithClassName:@"PointLog"];
//        [log  setObject: self.navigationItem.title forKey:@"addedTo"];
//        [log setObject: selectedUser forKey:@"addedToPointer"];
//        [log setObject: [[PFUser currentUser] username] forKey:@"addedBy"];
//        [log setObject: reason forKey: @"reason"];
//        [log setObject: pointValSelected forKey:@"pointsAdded"];
//        [log saveEventually];
    }
}

-(IBAction)editPerson:(id)sender
{
    AddFormViewController *editView = [[AddFormViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [editView setUserBeingEdited:selectedUser];
    
    [[self navigationController] pushViewController:editView animated:YES];
}

@end
