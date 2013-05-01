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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Stats", @"Stats");
        self.tabBarItem.image = [UIImage imageNamed:@"Stats"];
    }
    
    return self;
}

- (IBAction)top10:(id)sender
{
    [[self navigationController] pushViewController:[[StatsViewController alloc]init] animated:YES];
}


- (IBAction)history:(id)sender
{
    [[self navigationController] pushViewController:[[StatsViewController alloc]initWithType:History] animated:YES];
}

- (IBAction)boysVsGirls:(id)sender
{
    [[self navigationController] pushViewController:[[StatsViewController alloc]initWithType:BoysVsGirls] animated:YES];
}

- (IBAction)pointsByWeek:(id)sender {
    [[self navigationController] pushViewController:[[StatsViewController alloc]initWithType:PointsForLast5Weeks] animated:YES];
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
