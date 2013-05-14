//
//  NightDetailViewController.m
//  PointTracker
//
//  Created by Andrew Moore on 5/7/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "NightDetailViewController.h"

@interface NightDetailViewController ()

@end

@implementation NightDetailViewController

@synthesize titleLabel;
@synthesize topicLabel;
@synthesize verseLabel;

PFObject *night;

-(id)initWithNight:(id)theNight
{
    self = [super init];
    if(self){
        night = theNight;
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    titleLabel.text = [night objectForKey:@"title"];
    topicLabel.text = [night objectForKey:@"topic"];
    verseLabel.text = [night objectForKey:@"verse"];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *dateString = [dateFormatter stringFromDate:[night objectForKey:@"date"]];
    self.navigationItem.title = dateString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
