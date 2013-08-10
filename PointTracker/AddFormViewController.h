//
//  AddFormViewController.h
//
//  Created by Andrew Moore on 4/22/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddFormViewController : UITableViewController
<UITextFieldDelegate>
{
    bool isBoy;
    int gradeIndex;
    int genderIndex;
    PFObject *userBeingEdited;
	NSString *_firstName;
    NSString *_lastName;
    NSString *_email;
    NSString *_phoneNum;
    NSString *_emergencyNum;
	NSString *_address;
    NSString *_city;
    NSString *_state;
    NSString *_zip;
    NSString *_other;
    NSString *_gender;
    
	UITextField *_firstNameField;
    UITextField *_lastNameField;
    UITextField *_emailField;
    UITextField *_phoneNumberField;
    UITextField *_emergencyNumberField;
	UITextField *_addressField;
    UITextField *_cityField;
    UITextField *_stateField;
    UITextField *_zipField;
	UITextField *_otherField;
    UISegmentedControl *_genderSelector;
    UISegmentedControl *_gradeSelector;
}

-(UITextField*) makeTextField: (NSString*)text
                  placeholder: (NSString*)placeholder;
-(void) setUserBeingEdited:(PFObject *)other;
-(IBAction)savePerson:(id)sender;

@property (nonatomic,copy) NSString* firstName;
@property (nonatomic,copy) NSString* lastName;
@property (nonatomic,copy) NSString* email;
@property (nonatomic,copy) NSString* phoneNum;
@property (nonatomic,copy) NSString* emergencyNum;
@property (nonatomic,copy) NSString* address;
@property (nonatomic,copy) NSString* city;
@property (nonatomic,copy) NSString* state;
@property (nonatomic,copy) NSString* zip;
@property (nonatomic,copy) NSString* other;

@end