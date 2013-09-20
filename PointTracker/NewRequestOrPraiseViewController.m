//
//  NewRequestOrPraiseViewController.m
//  PointTracker
//
//  Created by Andrew Moore on 9/8/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "NewRequestOrPraiseViewController.h"

@interface NewRequestOrPraiseViewController ()

@end

@implementation NewRequestOrPraiseViewController

@synthesize postTypeSegControl;
@synthesize postTextView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self navigationItem] setTitle:@"New Post"];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"classy_fabric.png"]]];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                         target:self
                                         action:@selector(save:)];
    [[self navigationItem] setRightBarButtonItem:saveButton];
       
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)save:(id)sender
{
    PFObject *post = [PFObject objectWithClassName:@"RequestsAndPraises"];
    [post setObject: [PFUser currentUser] forKey:@"addedBy"];
    [post setObject: postTextView.text forKey: @"textSubmitted"];
    bool isRequest = [postTypeSegControl selectedSegmentIndex] == 0 ? YES : NO;
    [post setObject: [NSNumber numberWithBool:isRequest] forKey:@"isRequest"];
    [post saveEventually];
    
    [[self navigationController] popViewControllerAnimated:YES];
}
@end
