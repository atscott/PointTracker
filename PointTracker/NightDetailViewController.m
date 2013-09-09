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
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"American Typewriter" size:30];
    
    topicLabel.text = [NSString stringWithFormat:@"Topic:\r %@",[night objectForKey:@"topic"]];
    topicLabel.textColor = [UIColor whiteColor];
    topicLabel.textAlignment = NSTextAlignmentCenter;
    topicLabel.font = [UIFont fontWithName:@"American Typewriter" size:20];
    
    verseLabel.text = [NSString stringWithFormat:@"Memory Verse: \r%@", [night objectForKey:@"verse"]];
    verseLabel.textColor = [UIColor whiteColor];
    verseLabel.textAlignment = NSTextAlignmentCenter;
    verseLabel.font = [UIFont fontWithName:@"American Typewriter" size:20];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *dateString = [dateFormatter stringFromDate:[night objectForKey:@"date"]];
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"classy_fabric.png"]]];
    self.navigationItem.title = dateString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
