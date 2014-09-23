//
//  TableListViewController.h
//
//  Created by Andrew Moore on 4/16/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface TableListViewController : PFQueryTableViewController
<UIActionSheetDelegate, UISearchBarDelegate, MFMailComposeViewControllerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
{
    UIView *myTableHeaderView;
    UIView *moreOptionsMenuView;
    UIButton *addKidButton;
    UIButton *currentAttendanceButton;
    UIButton *viewRequestsAndYeahsButton;
    UISegmentedControl *segControl;
    UISearchBar *mySearchBar;
    NSString *searchName;
}

- (IBAction)logOutButtonTapAction:(id)sender;

@property (nonatomic, strong) NSArray *idValues;


@end
