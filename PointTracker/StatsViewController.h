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
@interface StatsViewController :UIViewController <WSControllerGestureDelegate>


typedef NS_ENUM(NSInteger, ChartType) {
    Top10,
    History,
};

- (id)initWithType:(ChartType)type;

@property (nonatomic) ChartType type;
@property (nonatomic, retain) WSData *barData;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, retain) IBOutlet UILabel *resultLabel;
@property (nonatomic, retain) IBOutlet WSChart *barChart;



@end
