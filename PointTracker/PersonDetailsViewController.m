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
UINavigationItem *navItem;


-(id)initWithID:(NSString *)objectId
{
    //self = [super initWithNibName:@"PersonDetailsViewController.xib" bundle:nil];
    self = [super init];
    if(self)
    {
        identifier = objectId;

        navItem = [self navigationItem];
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
    
    

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"CoolBackground.jpg"]]];

    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    PFObject *selectedUser = [query getObjectWithId:identifier];

    self.phoneNumberLabel.text = [NSString stringWithFormat:@"Phone #: %@",
                                 [selectedUser objectForKey:@"phoneNumber"]];
    
    self.emergencyPhoneLabel.text = [NSString stringWithFormat:@"Emergency #: %@",
                                    [selectedUser objectForKey:@"emergencyPhoneNumber"]];
    
    self.emailLabel.text = [selectedUser objectForKey:@"email"];
    
    self.streetAddressLabel.text = [selectedUser objectForKey:@"streetAddress"];
                                    
    self.cityStateZipLabel.text = [NSString stringWithFormat:@"%@, %@ %@",
                             [selectedUser objectForKey:@"city"],
                             [selectedUser objectForKey:@"state"],
                             [selectedUser objectForKey:@"zipCode"]];
    
    self.otherLabel.text = [NSString stringWithFormat:@"Miscellaneous Info: %@",
                           [selectedUser objectForKey:@"other"]];
    
    self.pointsLabel.text = [NSString stringWithFormat:@"%@",[selectedUser objectForKey:@"points"]];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@",
                                 [selectedUser objectForKey:@"firstName"],
                                 [selectedUser objectForKey:@"lastName"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
