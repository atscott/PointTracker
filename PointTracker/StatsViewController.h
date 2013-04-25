//
//  StatsViewController.h
//  PointTracker
//
//  Created by Andrew Moore on 4/17/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PowerPlot.h"
#include <stdlib.h>
@interface StatsViewController :UIViewController


@property (nonatomic, weak) WSChart *barChart;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end
