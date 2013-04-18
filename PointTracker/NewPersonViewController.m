//
//  AddPersonViewController.m
//  tableViewLearning
//
//  Created by Andrew Moore on 4/16/13.
//  Copyright (c) 2013 moorea. All rights reserved.
//

#import "NewPersonViewController.h"
#import "Person.h"
#import "Group.h"

@interface NewPersonViewController ()

@end

@implementation NewPersonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UINavigationItem *navItem = [self navigationItem];
        
        [navItem setTitle:@"New Person"];
        
        UIBarButtonItem *savePersonButton = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                             target:self
                                             action:@selector(savePerson:)];
        [[self navigationItem] setRightBarButtonItem:savePersonButton];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 600)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)savePerson:(id)sender
{
    // Create a new Person and add it to the store
    /*Person *newPerson = [[Person alloc] initWithFirstName:self.firstNameTextField.text
     lastName:self.lastNameTextField.text
     phoneNumber:self.phoneNumberTextField.text];
     [[Group defaultGroup] addPerson:newPerson];*/
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    //[self setFirstNameTextField:nil];
    //[self setLastNameTextField:nil];
    //[self setPhoneNumberTextField:nil];
    [super viewDidUnload];
}
@end
