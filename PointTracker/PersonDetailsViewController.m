//
//  PersonDetailsViewController.m
//
//  Created by Andrew Moore on 4/25/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "PersonDetailsViewController.h"
#import "AddFormViewController.h"
#import "CheckinViewController.h"

@interface PersonDetailsViewController ()

@end

@implementation PersonDetailsViewController

@synthesize gradeGenderLabel;
@synthesize addressTextView;
@synthesize emailTextView;
@synthesize emergencyPhoneTextView;
@synthesize phoneNumberTextView;
@synthesize pointsLabel;

-(id)initWithID:(PFObject *)person
{
    self = [super init];
    if(self)
    {
        selectedUser = person;
        pointValSelected = [NSNumber numberWithInt:100];
        
        CGRect frame = CGRectMake(272, 75, 40, 40);
        BButton *addPointsButton = [[BButton alloc] initWithFrame:frame];
        [addPointsButton setTitle:@"+" forState:UIControlStateNormal];
        [addPointsButton setType:BButtonTypePrimary];
        [addPointsButton addTarget:self action:@selector(addPointsButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addPointsButton];
        
        CGRect frame2 = CGRectMake(10, 75, 40, 40);
        BButton *rmvPointsButton = [[BButton alloc] initWithFrame:frame2];
        [rmvPointsButton setTitle:@"-" forState:UIControlStateNormal];
        [rmvPointsButton setType:BButtonTypeDanger];
        [rmvPointsButton addTarget:self action:@selector(rmvPointsButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rmvPointsButton];
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
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    self.gradeGenderLabel.text = [NSString stringWithFormat:@"%dth", [[selectedUser objectForKey:@"grade"] intValue]];
    self.gradeGenderLabel.font = [UIFont fontWithName:@"Arial" size:20];    
    
    self.phoneNumberTextView.text = [NSString stringWithFormat:@"%@",
                                     [selectedUser objectForKey:@"phoneNumber"]];
    self.phoneNumberTextView.font = [UIFont fontWithName:@"Arial" size:18];
    self.phoneNumberTextView.textColor = [UIColor whiteColor];
    
    self.emergencyPhoneTextView.text = [NSString stringWithFormat:@"%@",
                                        [selectedUser objectForKey:@"emergencyPhoneNumber"]];
    self.emergencyPhoneTextView.font = [UIFont fontWithName:@"Arial" size:18];
    self.emergencyPhoneTextView.textColor = [UIColor whiteColor];
    
    self.emailTextView.text = [NSString stringWithFormat:@"%@",[selectedUser objectForKey:@"email"]];
    self.emailTextView.font = [UIFont fontWithName:@"Arial" size:18];
    self.emailTextView.textColor = [UIColor whiteColor];
    
    self.addressTextView.text = [NSString stringWithFormat:@"%@ %@ %@ %@",
                                 [selectedUser objectForKey:@"streetAddress"],
                                 [selectedUser objectForKey:@"city"],
                                 [selectedUser objectForKey:@"state"],
                                 [selectedUser objectForKey:@"zipCode"]];
    self.addressTextView.font = [UIFont fontWithName:@"Arial" size:18];
    self.addressTextView.textColor = [UIColor whiteColor];
    
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
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"classy_fabric.png"]]];

    pointScale = [[TDRatingView alloc]init];
    pointScale.maximumRating = 600;
    pointScale.minimumRating = 100;
    pointScale.widthOfEachNo = 35;
    pointScale.heightOfEachNo = 50;
    pointScale.sliderHeight = 22;
    pointScale.difference = 100;
    pointScale.delegate = self;
    pointScale.scaleBgColor = [UIColor colorWithRed:40.0f/255 green:38.0f/255 blue:46.0f/255 alpha:1.0];
    pointScale.arrowColor = [UIColor blackColor];
    pointScale.disableStateTextColor = [UIColor colorWithRed:202.0f/255 green:183.0f/255 blue:172.0f/255 alpha:1.0];
    [pointScale drawRatingControlWithX:55 Y:50];
    [self.view addSubview:pointScale];
    
    UIBarButtonItem *editPersonButton = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                         target:self
                                         action:@selector(editPerson:)];
    
    checkinPersonButton = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                            target:self
                                            action:@selector(checkinPerson:)];
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithObjects:editPersonButton, checkinPersonButton, nil];
    [[self navigationItem] setRightBarButtonItems: buttons];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void) selectedRating:(NSString *)scale
{
    NSLog(@"SelectedRating:::%@",scale);
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    pointValSelected = [formatter numberFromString:scale];
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

-(void)removePoints
{
    NSNumber *currentPoints = [selectedUser objectForKey:@"points"];
    NSNumber *dif = [NSNumber numberWithFloat:([currentPoints floatValue] - [pointValSelected floatValue])];
    
    [selectedUser setObject:dif forKey:@"points"];
    [pointsLabel setText:[NSString stringWithFormat:@"%@",[dif stringValue]]];
    [selectedUser saveEventually];
    
    PFObject *log = [PFObject objectWithClassName:@"PointLog"];
    [log setObject: self.navigationItem.title forKey:@"addedTo"];
    [log setObject: selectedUser forKey:@"addedToPointer"];
    [log setObject: [[PFUser currentUser] username] forKey:@"addedBy"];
    [log setObject: @"REMOVED" forKey: @"reason"];
    [log setObject: pointValSelected forKey:@"pointsAdded"];
    [log saveEventually];
    
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
        NSNumber *currentPoints = [selectedUser objectForKey:@"points"];
        NSNumber *sum = [NSNumber numberWithFloat:([currentPoints floatValue] + [pointValSelected floatValue])];
        
        [selectedUser setObject:sum forKey:@"points"];
        [pointsLabel setText:[NSString stringWithFormat:@"%@", [sum stringValue]]];
        [selectedUser saveEventually];
        
        PFObject *log = [PFObject objectWithClassName:@"PointLog"];
        [log  setObject: self.navigationItem.title forKey:@"addedTo"];
        [log setObject: selectedUser forKey:@"addedToPointer"];
        [log setObject: [[PFUser currentUser] username] forKey:@"addedBy"];
        [log setObject: reason forKey: @"reason"];
        [log setObject: pointValSelected forKey:@"pointsAdded"];
        [log saveEventually];
    }
}

-(IBAction)editPerson:(id)sender
{
    AddFormViewController *editView = [[AddFormViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [editView setUserBeingEdited:selectedUser];
    
    [[self navigationController] pushViewController:editView animated:YES];
}

-(IBAction)checkinPerson:(id)sender
{
    [[self navigationController]pushViewController:[[CheckinViewController alloc]initWithID:selectedUser] animated:YES];
}

@end
