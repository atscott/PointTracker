//
//  SettingsViewController.m
//
//  Created by Andrew Moore on 4/22/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "SettingsViewController.h"
#import "TableListViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGRect logoutFrame = CGRectMake(50, 300, 225, 50);
        BButton *btn = [[BButton alloc] initWithFrame:logoutFrame];
        [btn setTitle:@"Log Out" forState:UIControlStateNormal];
        [btn addAwesomeIcon:FAIconPlay beforeTitle:YES];
        [btn setType:BButtonTypeDanger];
        [btn addTarget:self action:@selector(logOutButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)logOutButtonTapAction:(id)sender
{
    NSLog(@"LOGOUT");
    
    //[TableListViewController handleLogin];
}
@end
