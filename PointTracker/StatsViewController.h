//
//  StatsViewController.h
//  PointTracker
//
//  Created by Andrew Moore on 4/17/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
@interface StatsViewController : UIViewController <CPTBarPlotDataSource, CPTBarPlotDelegate>

@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) CPTXYGraph *graph;
@property (nonatomic, retain) IBOutlet CPTGraphHostingView *hostingView;


- (void) generateBarPlot;

@end
