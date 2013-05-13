//
//  PersonDetailsViewController.m
//  PointTracker
//
//  Created by Andrew Moore on 4/25/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "PersonDetailsViewController.h"
#import "AddFormViewController.h"

@interface PersonDetailsViewController ()

@end

@implementation PersonDetailsViewController

@synthesize gradeGenderLabel;
@synthesize addressTextView;
@synthesize emailTextView;
@synthesize emergencyPhoneTextView;
@synthesize phoneNumberTextView;
@synthesize pointsLabel;

NSNumber *pointValSelected;
PFObject *selectedUser;
NSString *reason;

-(id)initWithID:(PFObject *)person
{
    //self = [super initWithNibName:@"PersonDetailsViewController.xib" bundle:nil];
    self = [super init];
    if(self)
    {
        selectedUser = person;
        
        CGRect frame = CGRectMake(272, 65, 40, 40);
        BButton *addPointsButton = [[BButton alloc] initWithFrame:frame];
        [addPointsButton setTitle:@"+" forState:UIControlStateNormal];
        [addPointsButton setType:BButtonTypePrimary];
        [addPointsButton addTarget:self action:@selector(addPointsButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addPointsButton];
        
        CGRect frame2 = CGRectMake(10, 65, 40, 40);
        BButton *rmvPointsButton = [[BButton alloc] initWithFrame:frame2];
        [rmvPointsButton setTitle:@"-" forState:UIControlStateNormal];
        [rmvPointsButton setType:BButtonTypeDanger];
        [rmvPointsButton addTarget:self action:@selector(rmvPointsButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rmvPointsButton];
        
        
        UIBarButtonItem *editPersonButton = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                             target:self
                                             action:@selector(editPerson:)];
        [[self navigationItem] setRightBarButtonItem:editPersonButton];
        
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
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"newBackground.png"]]];
    
    [self.navigationController.navigationBar setTintColor:[UIColor orangeColor]];
    
    self.gradeGenderLabel.text = [NSString stringWithFormat:@"%dth", [[selectedUser objectForKey:@"grade"] intValue]];
    self.gradeGenderLabel.font = [UIFont fontWithName:@"Arial" size:20];
    self.gradeGenderLabel.textColor = [UIColor blackColor];
    
    
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
    
    self.addressTextView.text = [NSString stringWithFormat:@"%@ %@, %@ %@",
                                 [selectedUser objectForKey:@"streetAddress"],
                                 [selectedUser objectForKey:@"city"],
                                 [selectedUser objectForKey:@"state"],
                                 [selectedUser objectForKey:@"zipCode"]];
    self.addressTextView.font = [UIFont fontWithName:@"Arial" size:18];
    self.addressTextView.textColor = [UIColor whiteColor];
    
    //    self.otherLabel.text = [NSString stringWithFormat:@"Miscellaneous Info: %@",
    //                            [selectedUser objectForKey:@"other"]];
    //    self.otherLabel.font = [UIFont fontWithName:@"Arial" size:18];
    //    self.otherLabel.textColor = [UIColor whiteColor];
    
    self.pointsLabel.text = [NSString stringWithFormat:@"%@",[selectedUser objectForKey:@"points"]];
    self.pointsLabel.font = [UIFont fontWithName:@"Arial" size:28];
    self.pointsLabel.textAlignment = NSTextAlignmentRight;
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@",
                                 [selectedUser objectForKey:@"firstName"],
                                 [selectedUser objectForKey:@"lastName"]];
    
    pointScale = [[TDRatingView alloc]init];
    pointScale.maximumRating = 600;
    pointScale.minimumRating = 100;
    pointScale.widthOfEachNo = 35;
    pointScale.heightOfEachNo = 50;
    pointScale.sliderHeight = 22;
    pointScale.difference = 100;
    pointScale.delegate = self;
    pointScale.scaleBgColor = [UIColor colorWithRed:40.0f/255 green:38.0f/255 blue:46.0f/255 alpha:1.0];
    pointScale.arrowColor = [UIColor colorWithRed:0.0f/255 green:215.0f/255 blue:255.0f/255 alpha:1.0];
    pointScale.disableStateTextColor = [UIColor colorWithRed:202.0f/255 green:183.0f/255 blue:172.0f/255 alpha:1.0];
    [pointScale drawRatingControlWithX:55 Y:40];
    [self.view addSubview:pointScale];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    UIAlertView *confirmationAlert = [[UIAlertView alloc] initWithTitle:@"Really?" message:@"Are you sure you want to remove these points?" delegate:self cancelButtonTitle:@"Nevermind" otherButtonTitles:@"Yes!", nil];
    [confirmationAlert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSNumber *currentPoints = [selectedUser objectForKey:@"points"];
        NSNumber *dif = [NSNumber numberWithFloat:([currentPoints floatValue] - [pointValSelected floatValue])];
        
        [selectedUser setObject:dif forKey:@"points"];
        [pointsLabel setText:(@"%@", [dif stringValue])];
        [selectedUser saveEventually];
        
        PFObject *log = [PFObject objectWithClassName:@"PointLog"];
        [log setObject: self.navigationItem.title forKey:@"addedTo"];
        [log setObject: selectedUser forKey:@"addedToPointer"];
        [log setObject: [[PFUser currentUser] username] forKey:@"addedBy"];
        [log setObject: @"REMOVED" forKey: @"reason"];
        [log setObject: pointValSelected forKey:@"pointsAdded"];
        [log saveEventually];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        reason = @"Nose";
        NSLog(@"Nose");
    }
    else if(buttonIndex == 1)
    {
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
        [pointsLabel setText:(@"%@", [sum stringValue])];
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


-(void) addPoints:(NSNumber*)numToAdd
{
    
    
}


-(IBAction)editPerson:(id)sender
{
    AddFormViewController *editView = [[AddFormViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [editView setUserBeingEdited:selectedUser];
    
    [[self navigationController] pushViewController:editView animated:YES];
}

@end
