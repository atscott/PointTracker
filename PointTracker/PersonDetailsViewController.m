//
//  PersonDetailsViewController.m
//  PointTracker
//
//  Created by Andrew Moore on 4/25/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "PersonDetailsViewController.h"

@interface PersonDetailsViewController ()

@end

@implementation PersonDetailsViewController

@synthesize phoneNumberLabel;
@synthesize emergencyPhoneLabel;
@synthesize emailLabel;
@synthesize streetAddressLabel;
@synthesize cityStateZipLabel;
@synthesize otherLabel;
@synthesize pointsLabel;

NSString *identifier;
NSNumber *pointValSelected;
PFObject *selectedUser;



-(id)initWithID:(NSString *)objectId
{
    //self = [super initWithNibName:@"PersonDetailsViewController.xib" bundle:nil];
    self = [super init];
    if(self)
    {
        identifier = objectId;
        
        CGRect frame = CGRectMake(260, 275, 50, 40);
        BButton *addPointsButton = [[BButton alloc] initWithFrame:frame];
        [addPointsButton setTitle:@"add" forState:UIControlStateNormal];
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
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DetailsBackground.jpg"]]];
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    selectedUser = [query getObjectWithId:identifier];
    
    self.phoneNumberLabel.text = [NSString stringWithFormat:@"Phone #: %@",
                                  [selectedUser objectForKey:@"phoneNumber"]];
    self.phoneNumberLabel.font = [UIFont fontWithName:@"Arial" size:18];
    self.phoneNumberLabel.textColor = [UIColor whiteColor];
    
    self.emergencyPhoneLabel.text = [NSString stringWithFormat:@"Emergency #: %@",
                                     [selectedUser objectForKey:@"emergencyPhoneNumber"]];
    self.emergencyPhoneLabel.font = [UIFont fontWithName:@"Arial" size:18];
    self.emergencyPhoneLabel.textColor = [UIColor whiteColor];
    
    self.emailLabel.text = [selectedUser objectForKey:@"email"];
    self.emailLabel.font = [UIFont fontWithName:@"Arial" size:18];
    self.emailLabel.textColor = [UIColor whiteColor];
    
    self.streetAddressLabel.text = [selectedUser objectForKey:@"streetAddress"];
    self.streetAddressLabel.font = [UIFont fontWithName:@"Arial" size:18];
    self.streetAddressLabel.textColor = [UIColor whiteColor];
    
    self.cityStateZipLabel.text = [NSString stringWithFormat:@"%@, %@ %@",
                                   [selectedUser objectForKey:@"city"],
                                   [selectedUser objectForKey:@"state"],
                                   [selectedUser objectForKey:@"zipCode"]];
    self.cityStateZipLabel.font = [UIFont fontWithName:@"Arial" size:18];
    self.cityStateZipLabel.textColor = [UIColor whiteColor];
    
    self.otherLabel.text = [NSString stringWithFormat:@"Miscellaneous Info: %@",
                            [selectedUser objectForKey:@"other"]];
    self.otherLabel.font = [UIFont fontWithName:@"Arial" size:18];
    self.otherLabel.textColor = [UIColor whiteColor];
    
    self.pointsLabel.text = [NSString stringWithFormat:@"%@",[selectedUser objectForKey:@"points"]];
    self.pointsLabel.font = [UIFont fontWithName:@"Arial" size:28];
    self.pointsLabel.textAlignment = NSTextAlignmentRight;
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@",
                                 [selectedUser objectForKey:@"firstName"],
                                 [selectedUser objectForKey:@"lastName"]];
    
    pointScale = [[TDRatingView alloc]init];
    pointScale.maximumRating = 500;
    pointScale.minimumRating = 0;
    pointScale.widthOfEachNo = 40;
    pointScale.heightOfEachNo = 50;
    pointScale.sliderHeight = 22;
    pointScale.difference = 100;
    pointScale.delegate = self;
    pointScale.scaleBgColor = [UIColor colorWithRed:40.0f/255 green:38.0f/255 blue:46.0f/255 alpha:1.0];
    pointScale.arrowColor = [UIColor colorWithRed:0.0f/255 green:215.0f/255 blue:255.0f/255 alpha:1.0];
    pointScale.disableStateTextColor = [UIColor colorWithRed:202.0f/255 green:183.0f/255 blue:172.0f/255 alpha:1.0];
    [pointScale drawRatingControlWithX:10 Y:250];
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

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        NSLog(@"Nose");
    }
    else if(buttonIndex == 1)
    {
        NSLog(@"Blaster");
    }
    else if(buttonIndex == 2)
    {
        NSLog(@"Special Challenge");
    }
    else if(buttonIndex == 3)
    {
        NSLog(@"Other");
    }

    // TODO: Log points added
    NSNumber *currentPoints = [selectedUser objectForKey:@"points"];
    NSNumber *sum = [NSNumber numberWithFloat:([currentPoints floatValue] + [pointValSelected floatValue])];

    [selectedUser setObject:sum forKey:@"points"];
    [selectedUser saveEventually];


}

-(void) addPoints:(NSNumber*)numToAdd
{
    

}

@end
