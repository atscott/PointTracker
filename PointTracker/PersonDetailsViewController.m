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

-(id)initWithID:(NSString *)objectId
{
    //self = [super initWithNibName:@"PersonDetailsViewController.xib" bundle:nil];
    self = [super init];
    
    identifier = objectId;
        
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
    
    

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"CoolBackground.jpg"]]];
    // Do any additional setup after loading the view from its nib.
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    PFObject *selectedUser = [query getObjectWithId:identifier];

    self.phoneNumberLabel.text = [selectedUser objectForKey:@"phoneNumber"];
    self.emergencyPhoneLabel.text = [selectedUser objectForKey:@"emergencyPhoneNumber"];
    self.emailLabel.text = [selectedUser objectForKey:@"email"];
    self.streetAddressLabel.text = [selectedUser objectForKey:@"streetAddress"];
    self.cityStateZipLabel.text = [NSString stringWithFormat:@"%@, %@ %@",
                             [selectedUser objectForKey:@"city"],
                             [selectedUser objectForKey:@"state"],
                             [selectedUser objectForKey:@"zipCode"]];
    self.otherLabel.text = [selectedUser objectForKey:@"other"];
    self.pointsLabel.text = [NSString stringWithFormat:@"%@",[selectedUser objectForKey:@"points"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
