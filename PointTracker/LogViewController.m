//
//  LogViewController.m
//  PointTracker
//
//  Created by Andrew Moore on 4/17/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "LogViewController.h"

@interface LogViewController ()

@end

@implementation LogViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"History", @"History");
        self.tabBarItem.image = [UIImage imageNamed:@"History"];
        UINavigationItem *navItem = [self navigationItem];
    }
    return self;
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
