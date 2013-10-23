//
//  NewRequestOrPraiseViewController.m
//  PointTracker
//
//  Created by Andrew Moore on 9/8/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "NewRequestOrPraiseViewController.h"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface NewRequestOrPraiseViewController ()

@end

@implementation NewRequestOrPraiseViewController
@synthesize postTypeSegControl;
@synthesize postTextView;
bool forLeader = NO;

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
    [self.navigationController.navigationBar setTintColor:[UIColor lightGrayColor]];
    forLeader = [[[PFUser currentUser] objectForKey:@"isLeader"]boolValue];
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

    if (!forLeader)
    {
        PFQuery *query = [PFQuery queryWithClassName:@"People"];
        NSString *emailOfCurrentUser = [[PFUser currentUser]email];
        [query whereKey:@"email" equalTo:emailOfCurrentUser];
        NSArray *objects = [query findObjects];
        NSString *name;
        if(objects.count == 1)
        {
            PFObject *person = [objects objectAtIndex:0];
            NSString *firstName = [person objectForKey:@"firstName"];
            NSString *lastName = [person objectForKey:@"lastName"];
            name = [NSString stringWithFormat:@"%@ %@",firstName, lastName];
            [post setObject:name forKey:@"submitter"];
        }
    }
    if (forLeader)
    {
        [post setObject:[[PFUser currentUser] username] forKey:@"submitter"];
    }
    [post saveEventually];
    
    [[self navigationController] popViewControllerAnimated:YES];
}
@end
