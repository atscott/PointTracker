//
//  HistoryViewController.m
//  PointTracker
//
//  Created by wxynot on 4/28/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "HistoryViewController.h"
#import "ChartData.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Stats", @"Stats");
    }
    return self;
}

- (void)setupTapFeature
{
    // Configure the single tap feature.
    WSPlotController *aCtrl = [self.chart plotAtIndex:0];
    aCtrl.tapEnabled = YES;
    aCtrl.delegate = self;
    aCtrl.hitTestMethod = kHitTestX;
    aCtrl.hitResponseMethod = kHitResponseDatum;
}

- (void)CreateGraph:(id)obj
{
    [_loadingIndicator setHidden:NO];
    [_loadingIndicator startAnimating];
    // Create a few line plots with their controllers.
    [self.chart generateControllerWithData:nil
                                 plotClass:[WSPlotAxis class]
                                     frame:self.chart.frame];
    WSPlotAxis *axis = (WSPlotAxis *)[self.chart lastPlot].view;
    _lineData = [[ChartData historyForUser:@"dummy" fromLog:@"dummy"] indexedData];

    [self.chart generateControllerWithData:_lineData
                                 plotClass:[WSPlotData class]
                                     frame:self.chart.frame];
    WSPlotData *line1 = (WSPlotData *)[self.chart lastPlot].view;
    
    // Configure the appearance of the lines.
    axis.axisX.axisStyle = kAxisPlain;
    axis.axisY.gridStyle = kGridDotted;
    [axis.ticksY setTickLabelsWithStrings:[_lineData values]];
    [axis.ticksX setTickLabelsWithStrings:[_lineData annotationsFromData]];
    axis.ticksX.ticksStyle = kTicksLabels;
    axis.axisStrokeWidth = 2.0;
    [axis.ticksY autoTicksWithRange:NARangeMake(0.0, 180.0) number:6];
    axis.ticksY.ticksDir = kTDirectionNone;
    axis.gridStrokeWidth = 1.0;
    line1.lineColor = [UIColor redColor];
    line1.propDefault.symbolStyle = kSymbolEmptySquare;
    line1.propDefault.symbolColor = line1.lineColor;
    line1.intStyle = kInterpolationSpline;
    // Finally, configure the axis and chart title.
    [self.chart autoscaleAllAxisX];
    [self.chart autoscaleAllAxisY];    
    [self.chart setAllAxisLocationXD:0.0];
    [self.chart setAllAxisLocationYD:0.0];
    [self.chart setChartTitle:NSLocalizedString(@"Multiple stocks", @"")];
    [self setupTapFeature];
    [self.view sendSubviewToBack:_chart];
    [_loadingIndicator stopAnimating];
    [_loadingIndicator setHidden:YES];
    
}

#pragma mark - WSControllerGestureDelegate

- (void)controller:(WSPlotController *)controller
  singleTapAtDatum:(NSInteger)i {
    WSDatum *target = [self.lineData datumAtIndex:i];
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
