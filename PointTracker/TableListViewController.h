//
//  TableListViewController.h
//
//  Created by Andrew Moore on 4/16/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface TableListViewController : PFQueryTableViewController
<UIActionSheetDelegate, UISearchBarDelegate>
{
    UIView *myTableHeaderView;
    UISegmentedControl *segControl;
    UISearchBar *mySearchBar;
    NSString *searchName;
}

- (IBAction)addNewItem:(id)sender;
- (IBAction)logOutButtonTapAction:(id)sender;

@property (nonatomic, strong) NSArray *idValues;


@end
