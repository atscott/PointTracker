//
//  iCarouselExampleViewController.m
//  iCarouselExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//
//  Adaptions by Andrew Moore on 5/14/2013

#import "WeekPickerViewController.h"
#import "NightDetailViewController.h"


@implementation WeekPickerViewController

@synthesize carousel;
NSArray *weeks;
int mostRecentSelection;

-(id)init
{
    self = [super init];
    self.tabBarItem.image = [UIImage imageNamed:@"Schedule"];
    self.title = @"Schedule";
    mostRecentSelection = 0;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Nights"];
    [query orderByAscending:@"date"];
    [query whereKey:@"date" greaterThanOrEqualTo:[NSDate date]];
    weeks = [query findObjects];
    
    return self;
}

- (void)dealloc
{
    carousel.delegate = nil;
    carousel.dataSource = nil;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    carousel.type = iCarouselTypeCoverFlow;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];
    
    [[self view] setBackgroundColor:[UIColor lightGrayColor]];
    [carousel setCurrentItemIndex:mostRecentSelection];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.carousel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return (unsigned long)weeks.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{ 
	UIButton *button = (UIButton *)view;
	if (button == nil)
	{
		//no button available to recycle, so create new one
        
		UIImage *image = [UIImage imageNamed:@"page.png"];

		button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button.titleLabel setFont:[UIFont fontWithName:@"American Typewriter" size:36]];
        [button setBackgroundImage:image forState:UIControlStateNormal];
		button.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
	}

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:[weeks[index] objectForKey:@"date"]];
	[button setTitle:[NSString stringWithFormat:@"%@", dateString] forState:UIControlStateNormal];
	
	return button;
}

#pragma mark -
#pragma mark Button tap event

- (void)buttonTapped:(UIButton *)sender
{
	//get item index for button
	NSInteger index = [carousel indexOfItemViewOrSubview:sender];
	mostRecentSelection = index;
    [[self navigationController] pushViewController:[[NightDetailViewController alloc] initWithNight:weeks[index]] animated:YES];
}

@end
