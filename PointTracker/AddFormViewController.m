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
bool isBoy;
int gradeIndex;
int genderIndex;
PFObject *userBeingEdited;

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
    
    if(userBeingEdited && userBeingEdited != nil){
        [self setUserDefaults];
    }else{
        [self setBlankDefaults];
    }
}

- (void) setBlankDefaults
{
    self.firstName = @"";
    self.lastName = @"";
    self.email = @"";
    self.phoneNum = @"";
    self.emergencyNum = @"";
    self.address = @"";
    self.city = @"";
    self.state = @"";
    self.zip = @"";
    self.other = @"No other notes";
    gradeIndex = 0;
}

- (void) setUserDefaults
{
    self.firstName = [userBeingEdited objectForKey:@"firstName"];
    self.lastName = [userBeingEdited objectForKey:@"lastName"];
    self.email = [userBeingEdited objectForKey:@"email"];
    self.phoneNum = [userBeingEdited objectForKey:@"phoneNumber"];
    self.emergencyNum = [userBeingEdited objectForKey:@"emergencyPhoneNumber"];
    self.address = [userBeingEdited objectForKey:@"streetAddress"];
    self.city = [userBeingEdited objectForKey:@"city"];
    self.state = [userBeingEdited objectForKey:@"state"];
    self.zip = [userBeingEdited objectForKey:@"zipCode"];
    self.other = [userBeingEdited objectForKey:@"other"];
    
    [self checkDefaultNulls];
    
    gradeIndex = [[userBeingEdited objectForKey:@"grade"] intValue]-4;
    if(gradeIndex <0 || gradeIndex > 3)
    {
        gradeIndex = 0;
    }
    
    genderIndex = [[userBeingEdited objectForKey:@"isBoy"] intValue];
    
}

- (void)checkDefaultNulls
{
    if(self.firstName == NULL)
        self.firstName = @"";
    if(self.lastName == NULL)
        self.lastName = @"";
    if(self.email == NULL)
        self.email = @"";
    if(self.phoneNum == NULL)
        self.phoneNum = @"";
    if(self.emergencyNum == NULL)
        self.emergencyNum = @"";
    if(self.address == NULL)
        self. address = @"";
    if(self.city == NULL)
        self.city = @"";
    if(self.state == NULL)
        self.state = @"";
    if(self.zip == NULL)
        self.zip = @"";
    if(self.other == NULL)
        self.other = @"";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UINavigationItem *navItem = [self navigationItem];
    
    [navItem setTitle:@"New Person"];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];

    
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
    return 12;
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
			[cell addSubview: _firstNameField];
			break;
		}
		case 1:{
			cell.textLabel.text = @"Last Name" ;
			tf = _lastNameField = [self makeTextField:self.lastName placeholder:@"Clueless"];
            [tf setReturnKeyType:UIReturnKeyNext];
            [tf setTag:1];
			[cell addSubview: _lastNameField];
			break;
		}
		case 2: {
			cell.textLabel.text = @"Email" ;
			tf = _emailField = [self makeTextField:self.email placeholder:@"example@gmail.com"];
            [tf setReturnKeyType:UIReturnKeyNext];
            [tf setTag:2];
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
			[cell addSubview: _emergencyNumberField];
			break;
		}
        case 5: {
			cell.textLabel.text = @"Street" ;
			tf = _addressField = [self makeTextField:self.address placeholder:@"100 Pilgram Rd."];
            [tf setReturnKeyType:UIReturnKeyNext];
            [tf setTag:5];
			[cell addSubview: _addressField];
			break;
		}
        case 6: {
			cell.textLabel.text = @"City" ;
			tf = _cityField = [self makeTextField:self.city placeholder:@"Milwaukee"];
            [tf setReturnKeyType:UIReturnKeyNext];
            [tf setTag:6];
			[cell addSubview: _cityField];
			break;
		}
        case 7: {
			cell.textLabel.text = @"State" ;
			tf = _stateField = [self makeTextField:self.state placeholder:@"WI"];
            [tf setReturnKeyType:UIReturnKeyNext];
            [tf setTag:7];
			[cell addSubview: _stateField];
			break;
		}
        case 8: {
			cell.textLabel.text = @"ZIP code" ;
			tf = _zipField = [self makeTextField:self.zip placeholder:@"53202"];
            [tf setReturnKeyType:UIReturnKeyNext];
            [tf setTag:8];
			[cell addSubview: _zipField];
			break;
		}
        case 9: {
			cell.textLabel.text = @"Misc. Info" ;
			tf = _otherField = [self makeTextField:self.other placeholder:@"random stuff?"];
            [tf setReturnKeyType:UIReturnKeyNext];
            [tf setTag:9];
			[cell addSubview: _otherField];
			break ;
		}
            
        case 10: {
            cell.textLabel.text = @"Gender" ;
            
            NSArray *gendersArray = [NSArray arrayWithObjects: @"Girl", @"Boy", nil];
            _genderSelector = [[UISegmentedControl alloc] initWithItems:gendersArray];
            _genderSelector.frame = CGRectMake(110, 5, 180, 35);
            _genderSelector.segmentedControlStyle = UISegmentedControlStylePlain;
            _genderSelector.selectedSegmentIndex = genderIndex;
            [_genderSelector addTarget:self
                                action:@selector(updateGenderIndex:)
                      forControlEvents:UIControlEventValueChanged];
            [cell addSubview: _genderSelector];
            break;
        }
            
        case 11: {
            cell.textLabel.text = @"Grade" ;
            
            NSArray *gradesArray = [NSArray arrayWithObjects: @"4th", @"5th", @"6th", @"7th", nil];
            _gradeSelector= [[UISegmentedControl alloc] initWithItems:gradesArray];
            _gradeSelector.frame = CGRectMake(110, 5, 180, 35);
            _gradeSelector.segmentedControlStyle = UISegmentedControlStylePlain;
            _gradeSelector.selectedSegmentIndex = gradeIndex;
            [_gradeSelector addTarget:self
                               action:@selector(updateGradeIndex:)
                     forControlEvents:UIControlEventValueChanged];
            [cell addSubview: _gradeSelector];
            break;
        }
	}
    
	// Textfield dimensions
	tf.frame = CGRectMake(120, 12, 170, 30);
    
    return cell;
}


-(IBAction)savePerson:(id)sender
{
    PFObject *userToSave;
    int points=0;
    if(userBeingEdited && userBeingEdited != nil){
        userToSave = userBeingEdited;
        points = [[userBeingEdited objectForKey:@"points"] intValue];
    }else{
        userToSave = [PFObject objectWithClassName:@"People"];
    }
    
    [userToSave setObject:_firstName forKey:@"firstName"];
    [userToSave setObject:_lastName forKey:@"lastName"];
    [userToSave setObject:_email forKey:@"email"];
    [userToSave setObject:_phoneNum forKey:@"phoneNumber"];
    [userToSave setObject:_emergencyNum forKey:@"emergencyPhoneNumber"];
    [userToSave setObject:_address forKey:@"streetAddress"];
    [userToSave setObject:_city forKey:@"city"];
    [userToSave setObject:_state forKey:@"state"];
    [userToSave setObject:_zip forKey:@"zipCode"];
    [userToSave setObject:_other forKey:@"other"];
    isBoy = [_genderSelector selectedSegmentIndex] == 0 ? NO : YES;
    [userToSave setObject:[NSNumber numberWithBool:isBoy] forKey:@"isBoy"];
    [userToSave setObject:[NSNumber numberWithInt:(_gradeSelector.selectedSegmentIndex +4)] forKey:@"grade"];
    [userToSave setObject:[NSNumber numberWithInt:points] forKey:@"points"];
    [userToSave saveEventually];
    
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
    [tf addTarget:self
           action:@selector(TextFieldChanged:)
 forControlEvents:UIControlEventEditingChanged];
	return tf ;
}

-(IBAction)TextFieldChanged:(id)sender
{
    UITextField * textField = (UITextField *)sender;
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


- (void) setUserBeingEdited:(PFObject *)other
{
    userBeingEdited = other;
}

- (IBAction)updateGradeIndex:(id)sender
{
    gradeIndex = _gradeSelector.selectedSegmentIndex;
}

- (IBAction)updateGenderIndex:(id)sender
{
    genderIndex = _genderSelector.selectedSegmentIndex;
}

@end
