//
//  AddFormViewController.m
//
//  Created by Andrew Moore on 4/22/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "AddFormViewController.h"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

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
@synthesize groupLeader = _groupLeader;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(userBeingEdited && userBeingEdited != nil){
        [self setUserDefaults];
    }else{
        [self setBlankDefaults];
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
        
    } else {
        [self moveAllSubviewsDown];
    }
    
    UIView* bview = [[UIView alloc] init];
    bview.backgroundColor = [UIColor lightGrayColor];
    [self.tableView setBackgroundView:bview];
}

- (void) moveAllSubviewsDown{
    float barHeight = 45.0;
    for (UIView *view in self.view.subviews) {
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + barHeight, view.frame.size.width, view.frame.size.height - barHeight);
        } else {
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + barHeight, view.frame.size.width, view.frame.size.height);
        }
    }
}

- (void) setBlankDefaults
{
    [[self navigationItem] setTitle:@"New Person"];

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
    self.groupLeader = @"";
    gradeIndex = 0;
    genderIndex = 0;
}

- (void) setUserDefaults
{
    [[self navigationItem] setTitle:@"Edit Person"];
    
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
    self.groupLeader = [userBeingEdited objectForKey:@"groupLeader"];
    
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
    if(self.groupLeader == NULL)
        self.groupLeader = @"";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];

    
    UIBarButtonItem *savePersonButton = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                         target:self
                                         action:@selector(savePerson:)];
    [[self navigationItem] setRightBarButtonItem:savePersonButton];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 13;
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
			[cell addSubview: _firstNameField];
			break;
		}
		case 1:{
			cell.textLabel.text = @"Last Name" ;
			tf = _lastNameField = [self makeTextField:self.lastName placeholder:@"Clueless"];
			[cell addSubview: _lastNameField];
			break;
		}
		case 2: {
			cell.textLabel.text = @"Email" ;
			tf = _emailField = [self makeTextField:self.email placeholder:@"example@gmail.com"];
			[cell addSubview: _emailField];
			break;
		}
		case 3: {
			cell.textLabel.text = @"Phone #" ;
			tf = _phoneNumberField = [self makeTextField:self.phoneNum placeholder:@"(414)123-4567"];
            [tf setDelegate:self];
			[cell addSubview: _phoneNumberField];
			break;
		}
        case 4: {
			cell.textLabel.text = @"Emerg. #" ;
			tf = _emergencyNumberField = [self makeTextField:self.emergencyNum placeholder:@"(414)123-HELP"];
			[cell addSubview: _emergencyNumberField];
			break;
		}
        case 5: {
			cell.textLabel.text = @"Street" ;
			tf = _addressField = [self makeTextField:self.address placeholder:@"100 Pilgram Rd."];
			[cell addSubview: _addressField];
			break;
		}
        case 6: {
			cell.textLabel.text = @"City" ;
			tf = _cityField = [self makeTextField:self.city placeholder:@"Milwaukee"];
			[cell addSubview: _cityField];
			break;
		}
        case 7: {
			cell.textLabel.text = @"State" ;
			tf = _stateField = [self makeTextField:self.state placeholder:@"WI"];
			[cell addSubview: _stateField];
			break;
		}
        case 8: {
			cell.textLabel.text = @"ZIP code" ;
			tf = _zipField = [self makeTextField:self.zip placeholder:@"53202"];
			[cell addSubview: _zipField];
			break;
		}
        case 9: {
			cell.textLabel.text = @"Misc. Info" ;
			tf = _otherField = [self makeTextField:self.other placeholder:@"random stuff?"];
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
            cell.textLabel.text = @"Grade";
            
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
        case 12: {
            cell.textLabel.text = @"Leader";
            tf = _groupLeaderField = [self makeTextField:self.groupLeader placeholder:@"Name"];
            [cell addSubview: _groupLeaderField];
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
    int points = 0;
    if(userBeingEdited && userBeingEdited != nil){
        userToSave = userBeingEdited;
        points = [[userBeingEdited objectForKey:@"points"] intValue];
    }else{
        userToSave = [PFObject objectWithClassName:@"People"];
    }
    
    [userToSave setObject:[_firstName capitalizedString] forKey:@"firstName"];
    [userToSave setObject:[_lastName capitalizedString] forKey:@"lastName"];
    [userToSave setObject:_email forKey:@"email"];
    [userToSave setObject:_phoneNum forKey:@"phoneNumber"];
    [userToSave setObject:_emergencyNum forKey:@"emergencyPhoneNumber"];
    [userToSave setObject:_address forKey:@"streetAddress"];
    [userToSave setObject:_city forKey:@"city"];
    [userToSave setObject:_state forKey:@"state"];
    [userToSave setObject:_zip forKey:@"zipCode"];
    [userToSave setObject:_other forKey:@"other"];
    isBoy = genderIndex == 0 ? NO : YES;
    [userToSave setObject:[NSNumber numberWithBool:isBoy] forKey:@"isBoy"];
    [userToSave setObject:[NSNumber numberWithInt:gradeIndex+4] forKey:@"grade"];
    [userToSave setObject:[NSNumber numberWithInt:points] forKey:@"points"];
    [userToSave setObject:[NSNumber numberWithBool:YES] forKey:@"isKid"];
    [userToSave setObject:_groupLeader forKey:@"groupLeader"];
    [userToSave save];
    
    [[self navigationController] popViewControllerAnimated:YES];
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
	} else if (textField == _groupLeaderField){
        self.groupLeader = textField.text;
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
