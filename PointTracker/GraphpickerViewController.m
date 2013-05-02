//
//  GraphpickerViewController.m
//  PointTracker
//
//  Created by wxynot on 4/28/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "GraphpickerViewController.h"
#import "HistoryViewController.h"
#import "StatsViewController.h"

@interface GraphpickerViewController ()

@end

@implementation GraphpickerViewController
@synthesize top10;
@synthesize history;
@synthesize boysVGirls;
@synthesize pointsByWeek;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Stats", @"Stats");
        self.tabBarItem.image = [UIImage imageNamed:@"Stats"];
    }
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"classy_fabric.png"]]];
    [top10 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"TopTenIcon.png"]]];
    [boysVGirls setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"GirlVsBoy.png"]]];
    [history setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"HistoryIcon.png"]]];
    [pointsByWeek setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"WeekIcon.png"]]];
    return self;
}

- (IBAction)top10:(id)sender
{
    [[self navigationController] pushViewController:[[StatsViewController alloc]initWithType:Top10 andTitle:@"Leaderboard"] animated:YES];
}


- (IBAction)history:(id)sender
{
    [[self navigationController] pushViewController:[[StatsViewController alloc]initWithType:History andTitle:@"Recent Activity"] animated:YES];
}

- (IBAction)boysVsGirls:(id)sender
{
    [[self navigationController] pushViewController:[[StatsViewController alloc]initWithType:BoysVsGirls andTitle:@"Girls vs Boys"] animated:YES];
}

- (IBAction)pointsByWeek:(id)sender {
    [[self navigationController] pushViewController:[[StatsViewController alloc]initWithType:PointsForLast5Weeks andTitle:@"5 Week History"] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
