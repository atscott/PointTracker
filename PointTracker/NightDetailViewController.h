//
//  NightDetailViewController.h
//  PointTracker
//
//  Created by Andrew Moore on 5/7/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface NightDetailViewController : UIViewController
{
    PFObject *night;
    UITextView *titleField;
    UITextView *topicField;
    UITextView *verseField;
}

-(id)initWithNight:(PFObject *)night;

@end