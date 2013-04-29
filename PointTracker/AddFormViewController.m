//
//  AddPersonViewController.m
//  tableViewLearning
//
//  Created by Andrew Moore on 4/16/13.
//  Copyright (c) 2013 moorea. All rights reserved.
//

#import "AddFormViewController.h"
@interface AddFormViewController ()

@end

@implementation AddFormViewController

@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize email = _email;
@synthesize phoneNum = _phoneNum;
@synthesize emergencyNum = _emergencyNum;
@synthesize address = _address;
@synthesize city = _city;
@synthesize state = _state;
@synthesize zip = _zip;
@synthesize other = _other;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.firstName = @"";
    self.lastName = @"";
    self.email = @"";
    self.phoneNum = @"";
    self.emergencyNum = @"";
    self.address = @"";
    self.city = @"";
    self.state = @"";
    self.zip = @"";
    self.other = @"";
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UINavigationItem *navItem = [self navigationItem];
    
    [navItem setTitle:@"New Person"];
    
    UIBarButtonItem *savePersonButton = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                         target:self
                                         action:@selector(savePerson:)];
    [[self navigationItem] setRightBarButtonItem:savePersonButton];
    
    _firstNameField.tag = 0;
    _lastNameField.tag = 1;
    _emailField.tag = 2;
    _phoneNumberField.tag = 3;
    _emergencyNumberField.tag = 4;
	_addressField.tag = 5;
    _cityField.tag = 6;
    _stateField.tag = 7;
    _zipField.tag = 8;
	_otherField.tag = 9;
    
    [_firstNameField setReturnKeyType:UIReturnKeyNext];
    [_lastNameField setReturnKeyType:UIReturnKeyNext];
    [_emailField setReturnKeyType:UIReturnKeyNext];
    [_phoneNumberField setReturnKeyType:UIReturnKeyNext];
    [_emergencyNumberField setReturnKeyType:UIReturnKeyNext];
	[_addressField setReturnKeyType:UIReturnKeyNext];
    [_cityField setReturnKeyType:UIReturnKeyNext];
    [_stateField setReturnKeyType:UIReturnKeyNext];
    [_zipField setReturnKeyType:UIReturnKeyNext];
	[_otherField setReturnKeyType:UIReturnKeyNext];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    // Make cell unselectable
	cell.selectionStyle = UITableViewCellSelectionStyleNone;    
	
	UITextField* tf = nil ;
	switch (indexPath.row) {
		case 0: {
			cell.textLabel.text = @"First Name" ;
			tf = _firstNameField = [self makeTextField:self.firstName placeholder:@"Carla"];
            [tf setReturnKeyType:UIReturnKeyNext];
            [tf setTag:0];
            [tf setDelegate:self];
			[cell addSubview: _firstNameField];
			break;
		}
		case 1:{
			cell.textLabel.text = @"Last Name" ;
			tf = _lastNameField = [self makeTextField:self.lastName placeholder:@"Clueless"];
            [tf setReturnKeyType:UIReturnKeyNext];
            [tf setTag:1];
            [tf setDelegate:self];
			[cell addSubview: _lastNameField];
			break;
		}
		case 2: {
			cell.textLabel.text = @"Email" ;
			tf = _emailField = [self makeTextField:self.email placeholder:@"example@gmail.com"];
            [tf setReturnKeyType:UIReturnKeyNext];
            [tf setTag:2];
            [tf setDelegate:self];
			[cell addSubview: _emailField];
			break;
		}
		case 3: {
			cell.textLabel.text = @"Phone #" ;
			tf = _phoneNumberField = [self makeTextField:self.phoneNum placeholder:@"(414)123-4567"];
            [tf setReturnKeyType:UIReturnKeyNext];
            [tf setTag:3];
            [tf setDelegate:self];
			[cell addSubview: _phoneNumberField];
			break;
		}
        case 4: {
			cell.textLabel.text = @"Emerg. #" ;
			tf = _emergencyNumberField = [self makeTextField:self.emergencyNum placeholder:@"(414)123-HELP"];
            [tf setReturnKeyType:UIReturnKeyNext];
            [tf setTag:4];
            [tf setDelegate:self];
			[cell addSubview: _emergencyNumberField];
			break;
		}
        case 5: {
			cell.textLabel.text = @"Street" ;
			tf = _addressField = [self makeTextField:self.address placeholder:@"100 Pilgram Rd."];
            [tf setReturnKeyType:UIReturnKeyNext];
            [tf setTag:5];
            [tf setDelegate:self];
			[cell addSubview: _addressField];
			break;
		}
        case 6: {
			cell.textLabel.text = @"City" ;
			tf = _cityField = [self makeTextField:self.city placeholder:@"Milwaukee"];
            [tf setReturnKeyType:UIReturnKeyNext];
            [tf setTag:6];
            [tf setDelegate:self];
			[cell addSubview: _cityField];
			break;
		}
        case 7: {
			cell.textLabel.text = @"State" ;
			tf = _stateField = [self makeTextField:self.state placeholder:@"WI"];
            [tf setReturnKeyType:UIReturnKeyNext];
            [tf setTag:7];
            [tf setDelegate:self];
			[cell addSubview: _stateField];
			break;
		}
        case 8: {
			cell.textLabel.text = @"ZIP code" ;
			tf = _zipField = [self makeTextField:self.zip placeholder:@"53202"];
            [tf setReturnKeyType:UIReturnKeyNext];
            [tf setTag:8];
            [tf setDelegate:self];
			[cell addSubview: _zipField];
			break;
		}
        case 9: {
			cell.textLabel.text = @"Misc. Info" ;
			tf = _otherField = [self makeTextField:self.other placeholder:@"random stuff?"];
            [tf setReturnKeyType:UIReturnKeyNext];
            [tf setTag:9];
            [tf setDelegate:self];
			[cell addSubview: _otherField];
			break ;
		}
	}
    
	// Textfield dimensions
	tf.frame = CGRectMake(120, 12, 170, 30);
    
    return cell;
}


-(IBAction)savePerson:(id)sender
{
    PFObject *newDude = [PFObject objectWithClassName:@"People"];
    [newDude setObject:_firstName forKey:@"firstName"];
    [newDude setObject:_lastName forKey:@"lastName"];
    [newDude setObject:_email forKey:@"email"];
    [newDude setObject:_phoneNum forKey:@"phoneNumber"];
    [newDude setObject:_emergencyNum forKey:@"emergencyPhoneNumber"];
    [newDude setObject:_address forKey:@"streetAddress"];
    [newDude setObject:_city forKey:@"city"];
    [newDude setObject:_state forKey:@"state"];
    [newDude setObject:_zip forKey:@"zipCode"];
    [newDude setObject:_other forKey:@"other"];
    [newDude setObject:[NSNumber numberWithInt:0] forKey:@"points"];
    [newDude saveEventually];
    
    [[self navigationController] popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    //if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    //} else {
        // Not found, so remove keyboard.
        //[textField resignFirstResponder];
    //}
    return NO; // We do not want UITextField to insert line-breaks.
}

-(UITextField*) makeTextField: (NSString*)text
                  placeholder: (NSString*)placeholder  {
	UITextField *tf = [[UITextField alloc] init];
	tf.placeholder = placeholder ;
	tf.text = text ;
	tf.autocorrectionType = UITextAutocorrectionTypeNo ;
	tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
	tf.adjustsFontSizeToFitWidth = YES;
	tf.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
	return tf ;
}

// Textfield value changed, store the new value.
- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (textField == _firstNameField) {
		self.firstName = textField.text ;
	} else if (textField == _lastNameField) {
		self.lastName = textField.text ;
	} else if (textField == _emailField) {
		self.email = textField.text ;
	} else if (textField == _phoneNumberField) {
		self.phoneNum = textField.text ;
	} else if (textField == _emergencyNumberField) {
		self.emergencyNum = textField.text ;
	} else if (textField == _addressField) {
		self.address = textField.text ;
	} else if (textField == _cityField) {
		self.city = textField.text ;
	} else if (textField == _stateField) {
		self.state = textField.text ;
	} else if (textField == _zipField) {
		self.zip = textField.text ;
	} else if (textField == _otherField) {
		self.other = textField.text ;
	}
}

@end
