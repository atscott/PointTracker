//
//  GraphpickerViewController.m
//  PointTracker
//
//  Created by Andrew Moore on 4/28/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.

#import "GraphpickerViewController.h"
#import "HistoryViewController.h"
#import "StatsViewController.h"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface GraphpickerViewController ()

@end

@implementation GraphpickerViewController
@synthesize top10;
@synthesize boysVGirls;
@synthesize pointsByWeek;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Statistics";
        self.tabBarItem.image = [UIImage imageNamed:@"Stats"];
    }
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"classy_fabric.png"]]];
    [top10 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"TopTenIcon.png"]]];
    [boysVGirls setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"GirlVsBoy.png"]]];
    [pointsByWeek setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"WeekIcon.png"]]];
    return self;
}

- (IBAction)top10:(id)sender
{
    [[self navigationController] pushViewController:[[StatsViewController alloc]initWithType:Top10 andTitle:@"Leaderboard"] animated:YES];
}

- (IBAction)boysVsGirls:(id)sender
{
    [[self navigationController] pushViewController:[[StatsViewController alloc]initWithType:BoysVsGirls andTitle:@"Girls vs Guys"] animated:YES];
}

- (IBAction)pointsByWeek:(id)sender {
    [[self navigationController] pushViewController:[[StatsViewController alloc]initWithType:PointsForLast5Weeks andTitle:@"Total points per week"] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
