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

-(id)initWithID:(NSNumber *)identifier
{
    self = [super init];
    
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"CoolBackground.jpg"]]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
