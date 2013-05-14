//
//  iCarouselExampleViewController.h
//  iCarouselExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import <Parse/Parse.h>
#import "ReaderViewController.h"

@interface WeekPickerViewController : UIViewController
<iCarouselDataSource, iCarouselDelegate, UIAlertViewDelegate, ReaderViewControllerDelegate>
{

}
@property (nonatomic, retain) IBOutlet iCarousel *carousel;

-(IBAction)downloadStuffConfirm:(id)sender;

@end
