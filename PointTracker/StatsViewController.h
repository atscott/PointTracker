//
//  StatsViewController.h
//  PointTracker
//
//  Created by Andrew Scott on 4/17/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PowerPlot.h"
#include <stdlib.h>
@interface StatsViewController :UIViewController <WSControllerGestureDelegate>


typedef NS_ENUM(NSInteger, ChartType) {
    Top10,
    History,
    BoysVsGirls,
    PointsForLast5Weeks,
};

- (id)initWithType:(ChartType)type andTitle:(NSString *)title;

@property (nonatomic) ChartType type;
@property (nonatomic) WSData *barData;
@property (nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic) IBOutlet UILabel *resultLabel;
@property (nonatomic) IBOutlet WSChart *barChart;



@end
