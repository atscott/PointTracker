//
//  HistoryViewController.h
//  PointTracker
//
//  Created by wxynot on 4/28/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PowerPlot.h"
#include <stdlib.h>
@interface HistoryViewController : UIViewController <WSControllerGestureDelegate>

@property (nonatomic, retain) WSData *lineData;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, retain) IBOutlet UILabel *resultLabel;
@property (nonatomic, retain) IBOutlet WSChart *chart;



@end
