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

- (id)initWithType:(ChartType)type{
    self=[super init];
    if (self) {
        self.title = NSLocalizedString(@"Stats", @"Stats");
        _type = type;
    }
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Stats", @"Stats");
        _type = Top10;
    }
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft)  ||
            (interfaceOrientation == UIInterfaceOrientationLandscapeRight) ||
            (interfaceOrientation == UIInterfaceOrientationPortrait));
}

- (void)setupTapFeature
{
    // Configure the single tap feature.
    WSPlotController *aCtrl = [self.barChart plotAtIndex:0];
    aCtrl.tapEnabled = YES;
    aCtrl.delegate = self;
    aCtrl.hitTestMethod = kHitTestX;
    aCtrl.hitResponseMethod = kHitResponseDatum;
}


-(void)setChartTitle{
    if(_type == Top10){
        [_barChart setChartTitle:NSLocalizedString(@"Top 10", @"")];   
    }
    else if(_type == History){
        [_barChart setChartTitle:NSLocalizedString(@"Point History", @"")];
    }
}

-(void)getChartData{
    if(_type == Top10){
    _barData = [[ChartData top10] indexedData];
    }
    else if(_type == History){
    _barData = [[ChartData historyForUser:@"dummy" fromLog:@"dummy"] indexedData];
    }

}

- (void)CreateGraph:(id)obj
{
    [_loadingIndicator setHidden:NO];
    [_loadingIndicator startAnimating];
    if(_barChart)
    {
        [_barChart removeFromSuperview];
    }
    [self getChartData];
    // Create and configure a bar chart.
    _barChart = [WSChart barPlotWithFrame:[self.view bounds]
                                     data:_barData
                                    style:kChartBarPlain
                              colorScheme:kColorDarkBlue];
    [self getChartData];
    [self setChartTitle];
    [self setupTapFeature];
    _barChart.autoresizingMask = 63;
    [[self view] addSubview:_barChart];
    [self.view sendSubviewToBack:_barChart];
    [_loadingIndicator stopAnimating];
    [_loadingIndicator setHidden:YES];
    
}

#pragma mark - WSControllerGestureDelegate

- (void)controller:(WSPlotController *)controller
  singleTapAtDatum:(NSInteger)i {
    WSDatum *target = [self.barData datumAtIndex:i];
    self.resultLabel.text = [NSString stringWithFormat:@"%@: %2.0f",
                             target.annotation,
                             target.value];
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
