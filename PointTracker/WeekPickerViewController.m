//
//  iCarouselExampleViewController.m
//  iCarouselExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//
//  Adaptions by Andrew Moore 5/14/2013

#import "WeekPickerViewController.h"
#import "NightDetailViewController.h"
#import "ReaderDocument.h"


@implementation WeekPickerViewController

@synthesize carousel;
NSArray *weeks;

-(id)init
{
    self = [super init];
    self.tabBarItem.image = [UIImage imageNamed:@"Schedule"];
    self.title = @"Schedule";
    
    UIBarButtonItem *downloadScheduleButton = [[UIBarButtonItem alloc]
                                         initWithTitle:@"PDF" style:UIBarButtonItemStyleBordered
                                         target:self
                                         action:@selector(downloadStuffConfirm:)];
    [[self navigationItem] setRightBarButtonItem:downloadScheduleButton];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Nights"];
    [query orderByAscending:@"date"];
    weeks = [query findObjects];
    
    return self;
}

- (void)dealloc
{
    carousel.delegate = nil;
    carousel.dataSource = nil;
}

-(IBAction)downloadStuffConfirm:(id)sender
{
//    UIAlertView *confirmation = [[UIAlertView alloc]initWithTitle:@"Hey there!" message:@"You sure you want to download the whole schedule as a PDF?" delegate:self cancelButtonTitle:@"Nevermind" otherButtonTitles:@"Yes Sir!", nil];
//    [confirmation show];
    
    //        PFQuery *query = [PFQuery queryWithClassName:@"Lessons"];
    //        NSArray *pdfArray = [query findObjects];
    //        FILE *pdfFile = (__bridge FILE *)([pdfArray[0] objectForKey:@"lesson"]);
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"KidBlast Bible topic list" ofType:@"pdf"];
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:file password:nil];
    
    if (document != nil)
    {
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        readerViewController.delegate = self;
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [[self navigationController] pushViewController:readerViewController animated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {

    }
}

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    carousel.type = iCarouselTypeCylinder;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Nights"];
    [query orderByAscending:@"date"];
    weeks = [query findObjects];
}
-(void)viewWillAppear:(BOOL)animated
{
    UIColor * color = [UIColor colorWithRed:171/255.0f green:1/255.0f blue:0/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setTintColor:color];    
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
	//set button label
	[button setTitle:[NSString stringWithFormat:@"%@", dateString] forState:UIControlStateNormal];
	
	return button;
}

#pragma mark -
#pragma mark Button tap event

- (void)buttonTapped:(UIButton *)sender
{
	//get item index for button
	NSInteger index = [carousel indexOfItemViewOrSubview:sender];
	
    [[self navigationController] pushViewController:[[NightDetailViewController alloc] initWithNight:weeks[index]] animated:YES];
    /*[[[UIAlertView alloc] initWithTitle:@"Button Tapped"
                                 message:[NSString stringWithFormat:@"You tapped button number %i", index]
                                delegate:nil
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil] show];*/
}

@end
