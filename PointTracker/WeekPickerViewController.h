//
//  iCarouselExampleViewController.h
//  iCarouselExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//
//  Adaptions by Andrew Moore on 5/14/2013

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import <Parse/Parse.h>

@interface WeekPickerViewController : UIViewController
<iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, retain) IBOutlet iCarousel *carousel;

@end
