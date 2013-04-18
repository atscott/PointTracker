//
//  AddPersonViewController.h
//  tableViewLearning
//
//  Created by Andrew Moore on 4/16/13.
//  Copyright (c) 2013 moorea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPersonViewController : UIViewController
{
    IBOutlet UIScrollView *scroller;
}

-(IBAction)savePerson:(id)sender;
@end
