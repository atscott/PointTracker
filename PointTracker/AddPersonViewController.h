//
//  AddPersonViewController.h
//  tableViewLearning
//
//  Created by Andrew Moore on 4/16/13.
//  Copyright (c) 2013 moorea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPersonViewController : UIViewController
{
}
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;

-(IBAction)savePerson:(id)sender;
@end
