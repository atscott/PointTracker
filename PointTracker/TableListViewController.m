//
//  TableListViewController.m
//  PointTracker
//
//  Created by Andrew Moore on 4/16/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "TableListViewController.h"
#import "MoreInfoViewController.h"
#import "AddPersonViewController.h"
#import "Person.h"
#import "Group.h"

@interface TableListViewController ()

@end

@implementation TableListViewController

-(id)init
{
    self = [super initWithStyle: UITableViewStyleGrouped];
    if (self)
    {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        UINavigationItem *navItem = [self navigationItem];
        
        [navItem setTitle:@"People"];
        
        UIBarButtonItem *createNewPersonButton = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                  target:self
                                                  action:@selector(addNewItem:)];
        //[[self navigationItem] setRightBarButtonItem:createNewPersonButton];
        
        UIBarButtonItem *createRandomButton = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                               target:self
                                               action:@selector(addRandom:)];
        NSArray *barButtons = [[NSArray alloc] initWithObjects:createNewPersonButton, createRandomButton, nil];
        
        [[self navigationItem] setRightBarButtonItems:barButtons];
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    }
    return self;
}

-(void) loadView
{
    [super loadView];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)addNewItem:(id)sender
{
    [[self navigationController] pushViewController:[[AddPersonViewController alloc]init] animated:YES];
}

-(IBAction)addRandom:(id)sender
{
    Person *newPerson = [Person createRandomStranger];
    [[Group defaultGroup] addPerson:newPerson];
    int lastRow = [[[Group defaultGroup] getGroup] indexOfObject:newPerson];
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    // Insert this new row into the table.
    [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationRight];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[Group defaultGroup] getGroup] count];
}

-(void)  tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[Group defaultGroup] movePersonAtIndex:[sourceIndexPath row] toIndex:[destinationIndexPath row]];
}
-(void) tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self navigationController] pushViewController:[[MoreInfoViewController alloc]init] animated:YES];
    NSLog(@"Tapped Cell");
}

-(void)  tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        Group *group = [Group defaultGroup];
        NSArray *people = [group getGroup];
        Person *beingRemoved = [people objectAtIndex:[indexPath row]];
        [group removePerson: beingRemoved];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    Person *person = [[[Group defaultGroup] getGroup] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[person description]];
    
    return cell;
}

- (IBAction)logOutButtonTapAction:(id)sender {
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
