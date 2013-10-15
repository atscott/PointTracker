//
//  CheckinViewController.m
//
//  Created by Andrew Moore on 5/14/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "CheckinViewController.h"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface CheckinViewController ()

@end

@implementation CheckinViewController

@synthesize nameLabel;
@synthesize bibleSeg;
@synthesize verseSeg;
@synthesize costumeSeg;
@synthesize friendSeg;

-(id) initWithID:(PFObject *)person
{
    self = [super init];
    if(self){
        selectedPerson = person;
        hasBible = NO;
        didVerse = NO;
        friends = [NSNumber numberWithInt:0];
        costume = @"None";
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *savePersonButton = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                         target:self
                                         action:@selector(save:)];
    [[self navigationItem] setRightBarButtonItem:savePersonButton];
    [[self navigationItem] setTitle:@"Check-In"];
    
    NSString *first = [selectedPerson objectForKey:@"firstName"];
    NSString *last = [selectedPerson objectForKey:@"lastName"];
    
    nameLabel.text = [NSString stringWithFormat:@"%@ %@", first, last];
    nameLabel.textColor = [UIColor whiteColor];
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"classy_fabric.png"]]];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (IBAction)save:(id)sender
{
    [[self navigationController]popToRootViewControllerAnimated:YES];
    int points = 100;
    
    if ([bibleSeg selectedSegmentIndex] > 0) {
        hasBible = YES;
        points += 100;
    }
    
    if ([verseSeg selectedSegmentIndex] > 0) {
        didVerse = YES;
        points += 200;
    }
    
    if ([friendSeg selectedSegmentIndex] > 0) {
        friends = [NSNumber numberWithInteger:[friendSeg selectedSegmentIndex]];
        points += 400;
    }
    
    if ([costumeSeg selectedSegmentIndex] > 0) {
        costume = [costumeSeg titleForSegmentAtIndex:[costumeSeg selectedSegmentIndex]];
        switch ([costumeSeg selectedSegmentIndex]) {
            case 0:
                break;
            case 1:
                points += 100;
                break;
            case 2:
                points += 200;
                break;
            case 3:
                points += 300;
                break;
            default:
                break;
        }
    }
    
    NSNumber *currentPoints = [selectedPerson objectForKey:@"points"];
    NSNumber *sum = [NSNumber numberWithFloat:([currentPoints floatValue] + [[NSNumber numberWithInt:points] floatValue])];
    
    [selectedPerson setObject: sum forKey:@"points"];
    [selectedPerson saveEventually];
    
    PFObject *log = [PFObject objectWithClassName:@"PointLog"];
    [log setObject: [NSString stringWithFormat:@"%@ %@",[selectedPerson objectForKey:@"firstName"], [selectedPerson objectForKey:@"lastName"]] forKey:@"addedTo"];
    [log setObject: selectedPerson forKey:@"addedToPointer"];
    [log setObject: [[PFUser currentUser] username] forKey:@"addedBy"];
    [log setObject: @"CheckIn" forKey: @"reason"];
    [log setObject: [NSNumber numberWithInt:points] forKey:@"pointsAdded"];
    [log saveEventually];
    
    PFObject *attendLog = [PFObject objectWithClassName:@"Attendance"];
    [attendLog setObject: selectedPerson forKey:@"personPointer"];
    [attendLog setObject: [[PFUser currentUser] username] forKey:@"checkedInBy"];
    [attendLog setObject: friends forKey:@"friends"];
    [attendLog setObject: costume forKey:@"costume"];
    [attendLog setObject: [NSNumber numberWithBool:hasBible] forKey:@"bible"];
    [attendLog setObject: [NSNumber numberWithBool:didVerse] forKey:@"verse"];
    [attendLog saveEventually];
    
    [self.parentViewController.view setNeedsDisplay];
}



@end
