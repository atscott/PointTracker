//
//  StatsViewController.m
//  PointTracker
//
//  Created by Andrew Scott on 4/17/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "StatsViewController.h"
#import "PowerPlot.h"
#import "ChartData.h"

@interface StatsViewController ()

@end

@implementation StatsViewController

- (id)initWithType:(ChartType)type andTitle:(NSString *)title{
    self=[super init];
    if (self) {
        self.title = NSLocalizedString(title, title);
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
        self.view.backgroundColor = [UIColor blackColor];
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

-(void)getChartData{
    if(_type == Top10){
        _barData = [ChartData top10];
    }
    else if(_type == BoysVsGirls){
        _barData = [ChartData boysVsGirls];
    }else if(_type == PointsForLast5Weeks)
    {
        _barData = [ChartData totalPointsLast5Weeks];
    }
}

- (void)CreateGraph:(id)obj
{
    self.resultLabel.text = @"";
    [_loadingIndicator setHidden:NO];
    [_loadingIndicator startAnimating];
    if(_barChart != NULL && [[self.view subviews] containsObject:_barChart])
    {
        [_barChart removeFromSuperview];
    }
    
    [self getChartData];
    if(_barData != NULL && [_barData count] > 0)
    {
        // Create and configure a bar chart.
        CGRect frame = [self.view bounds];
        frame.size.width -= 30;
        frame.size.height -= 10;
        frame.origin.x += 40;
        _barChart = [WSChart barPlotWithFrame:frame
                                         data:_barData
                                        style:kChartBarPlain
                                  colorScheme:kColorDarkBlue];
        [self setupTapFeature];
        self.resultLabel.text = @"Tap a column to view values";
        [[self view] addSubview:_barChart];
        [self.view sendSubviewToBack:_barChart];
    }
    else
    {
        [self indicateNoDataToDisplay];
    }
    
    [_loadingIndicator stopAnimating];
    [_loadingIndicator setHidden:YES];
}

-(void) indicateNoDataToDisplay
{
    self.resultLabel.text = @"No relevant data could be retrieved";
    [self.view bringSubviewToFront:_resultLabel];
}

#pragma mark - WSControllerGestureDelegate

- (void)controller:(WSPlotController *)controller
  singleTapAtDatum:(NSInteger)i {
    WSDatum *target = [self.barData datumAtIndex:i];
    if(target.annotation.length > 0){
        self.resultLabel.text = [NSString stringWithFormat:@"%@: %.f",
                                 target.annotation,
                                 target.value];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self performSelectorInBackground:@selector(CreateGraph:) withObject:nil];
}

@end
