//
//  NightDetailViewController.m
//  PointTracker
//
//  Created by Andrew Moore on 5/7/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "NightDetailViewController.h"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface NightDetailViewController ()

@end

@implementation NightDetailViewController

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
    titleField = [[UITextView alloc] initWithFrame: CGRectMake(10.0f, 30.0f, 300.0f, 70.0f)];
    titleField.text = [night objectForKey:@"title"];
    titleField.textColor = [UIColor whiteColor];
    titleField.backgroundColor = [UIColor clearColor];
    titleField.textAlignment = NSTextAlignmentCenter;
    titleField.font = [UIFont fontWithName:@"American Typewriter" size:24];
    
    topicField = [[UITextView alloc] initWithFrame: CGRectMake(10.0f, 110.0f, 300.0f, 70.0f)];
    topicField.text = [NSString stringWithFormat:@"Topic:\r %@",[night objectForKey:@"topic"]];
    topicField.textColor = [UIColor whiteColor];
    topicField.backgroundColor = [UIColor clearColor];
    topicField.textAlignment = NSTextAlignmentCenter;
    topicField.font = [UIFont fontWithName:@"American Typewriter" size:18];
    
    verseField = [[UITextView alloc] initWithFrame: CGRectMake(10.0f, 190.0f, 300.0f, 160.0f)];
    verseField.text = [NSString stringWithFormat:@"Memory Verse: \r%@", [night objectForKey:@"verse"]];
    verseField.textColor = [UIColor whiteColor];
    verseField.backgroundColor = [UIColor clearColor];
    verseField.textAlignment = NSTextAlignmentCenter;
    verseField.font = [UIFont fontWithName:@"American Typewriter" size:14];
    
    [self.view addSubview:titleField];
    [self.view addSubview:topicField];
    [self.view addSubview:verseField];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *dateString = [dateFormatter stringFromDate:[night objectForKey:@"date"]];
    [[self view] setBackgroundColor:[UIColor lightGrayColor]];
    self.navigationItem.title = dateString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
