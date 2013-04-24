//
//  StatsViewController.h
//  PointTracker
//
//  Created by Andrew Moore on 4/17/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CorePlot-CocoaTouch.h"
#include <stdlib.h>
@interface StatsViewController : UIViewController <CPTBarPlotDataSource, CPTBarPlotDelegate>

@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) CPTXYGraph *graph;
@property (nonatomic, retain) IBOutlet CPTGraphHostingView *hostingView;
@property (nonatomic, retain) CPTPlotSpaceAnnotation *annotation;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;


- (void) generateBarPlot;
- (void) refreshPlot;

@end
