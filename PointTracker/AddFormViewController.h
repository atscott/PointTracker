//
//  FormTableController.h
//  TableWithTextField
//
//  Created by Andrew Lim on 4/15/11.
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddFormViewController : UITableViewController
<UITextFieldDelegate>
{
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
}

// Creates a textfield with the specified text and placeholder text
-(UITextField*) makeTextField: (NSString*)text
                  placeholder: (NSString*)placeholder  ;

// Handles UIControlEventEditingDidEndOnExit
//-(IBAction)textFieldFinished:(id)sender ;

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