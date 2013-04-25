//
//  StatsViewController.m
//  PointTracker
//
//  Created by Andrew Moore on 4/17/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "StatsViewController.h"
#import "PowerPlot.h"
#import "ChartData.h"

@interface StatsViewController ()

@end

@implementation StatsViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Stats", @"Stats");
        self.tabBarItem.image = [UIImage imageNamed:@"Stats"];
        
               
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft)  ||
            (interfaceOrientation == UIInterfaceOrientationLandscapeRight) ||
            (interfaceOrientation == UIInterfaceOrientationPortrait));
}

- (void)CreateGraph:(id)obj
{
    [_loadingIndicator setHidden:NO];
    [_loadingIndicator startAnimating];
    if(_barChart)
    {
        [_barChart removeFromSuperview];
    }
        // Create data set.
        WSData *barData = [[ChartData top10] indexedData];
        
        // Create and configure a bar chart.
        _barChart = [WSChart barPlotWithFrame:[self.view bounds]
                                         data:barData
                                        style:kChartBarPlain
                                  colorScheme:kColorWhite];
        //        WSPlotAxis *axis = [_barChart firstPlotAxis];
        //        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        //        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        //        [formatter setGroupingSeparator:@""];
        //        [[axis ticksX] setTickLabelsWithFormatter:formatter];
        [_barChart setChartTitle:NSLocalizedString(@"Top 10", @"")];
        
        _barChart.autoresizingMask = 63;
        [[self view] addSubview:_barChart];
        
        [_loadingIndicator stopAnimating];
        [_loadingIndicator setHidden:YES];

//    [self performSelectorOnMainThread:@selector(workDone:) withObject:nil waitUntilDone:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self performSelectorInBackground:@selector(CreateGraph:) withObject:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
