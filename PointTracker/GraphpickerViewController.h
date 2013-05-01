//
//  GraphpickerViewController.h
//  PointTracker
//
//  Created by wxynot on 4/28/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphpickerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *top10;
@property (weak, nonatomic) IBOutlet UIButton *history;
@property (weak, nonatomic) IBOutlet UIButton *boysVGirls;
- (IBAction)history:(id)sender;
- (IBAction)top10:(id)sender;
- (IBAction)boysVsGirls:(id)sender;
- (IBAction)pointsByWeek:(id)sender;

@end
