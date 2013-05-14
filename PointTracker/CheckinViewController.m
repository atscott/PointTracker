//
//  CheckinViewController.m
//  PointTracker
//
//  Created by Andrew Moore on 5/14/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "CheckinViewController.h"

@interface CheckinViewController ()

@end

@implementation CheckinViewController

-(id) initWithID:(PFObject *)person
{
    self = [super init];
    if(self){
        
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *savePersonButton = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                         target:self
                                         action:@selector(save:)];
    [[self navigationItem] setRightBarButtonItem:savePersonButton];
    [[self navigationItem] setTitle:@"Check-In"];
}

- (IBAction)save:(id)sender
{
    [[self navigationController]popViewControllerAnimated:YES];
}

@end
