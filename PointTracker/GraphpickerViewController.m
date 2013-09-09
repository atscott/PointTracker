//
//  GraphpickerViewController.m
//  PointTracker
//
//  Created by Andrew Moore on 4/28/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.

#import "GraphpickerViewController.h"
#import "HistoryViewController.h"
#import "StatsViewController.h"

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
    // Do any additional setup after loading the view from its nib.
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
