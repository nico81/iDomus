//
//  RootViewController.m
//  iDomus
//
//  Created by Giuseppe Acito on 19/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "AddControlloController.h"
#import "Control.h"

@implementation RootViewController

@synthesize controlsArray;
@synthesize managedObjectContext;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.title = @"iDomus";
    
    //query for init
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Control" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
    NSArray *sortDescriptors = [ NSArray arrayWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    //executing Query
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if(mutableFetchResults == nil) {
        NSLog(@"Errore nella query");
    }
    
    self.controlsArray = mutableFetchResults;
    [mutableFetchResults release];
    [request release];
    NSLog(@"RootViewController.viewDidLoad called");
}



- (void)dealloc {
    [managedObjectContext release];
    [controlsArray release];
    [super dealloc];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animate {
    [super setEditing:editing animated:animate];
    if(editing) {
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addControllo)];
        self.navigationItem.rightBarButtonItem = addButton;
        [addButton release];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}


-(void) addControllo {
    
    AddControlloController *ac = [[AddControlloController alloc] initWithNibName:@"AddControlloController" bundle:nil];
    ac.managedObjectContext = self.managedObjectContext;
    ac.controlsArray = self.controlsArray;
    [self.navigationController pushViewController:ac animated:YES];
    //[self.view addSubview: ac.view];
    [self setEditing:NO animated:NO];
    [ac release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.controlsArray = nil;
    self.managedObjectContext = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.controlsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Control *control = (Control *)[controlsArray objectAtIndex:indexPath.row];
    
    cell.frame = CGRectMake(0, 0, 320, 80);
    cell.textLabel.text = control.name;
    UISwitch *interruttore = [[UISwitch alloc] init];
    interruttore.tag = indexPath.row;
    [interruttore addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = interruttore;
    [interruttore release];
    
    return cell;
}


-(void) addControl: (Control *) control {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void) toggleSwitch:(id) sender {
    NSLog(@"RootViewController.toggleSwitch called");
    
    UISwitch *interruttore = (UISwitch *) sender;
    
    //getting the model
    
    Control *control = [controlsArray objectAtIndex:interruttore.tag];
    
    NSURL *url;
    
    if(interruttore.on) {
        url = [NSURL URLWithString:control.urlOn];
    } else {
        url = [NSURL URLWithString:control.urlOff];
    }
    
    NSError *error = nil;
    [NSString stringWithContentsOfURL:[NSURL URLWithString:control.urlOn] encoding:NSUnicodeStringEncoding error:&error];
    if(error) {
        NSLog(@"Errore %@", error);
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Control *toBeDeleted = (Control *)[self.controlsArray objectAtIndex:indexPath.row];
        [self.managedObjectContext deleteObject:toBeDeleted];
        NSError *error = nil;
        [self.managedObjectContext save:&error];
        if(error) {
             NSLog(@"Errore %@", error);
        }
        [self.controlsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
 //   else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 //   }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    Control *from = [self.controlsArray objectAtIndex:fromIndexPath.row];
    Control *to = [self.controlsArray objectAtIndex:toIndexPath.row];
    
    //swap dates for ordering
    NSDate *tmp = nil;
    tmp = to.creationDate;
    to.creationDate = from.creationDate;
    from.creationDate = tmp;
    
    [self.controlsArray replaceObjectAtIndex:fromIndexPath.row withObject:to];
    [self.controlsArray replaceObjectAtIndex:toIndexPath.row withObject:from];
    
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    if(error) {
        NSLog(@"Errore %@", error);
    }
    
    NSLog(@"%@", fromIndexPath);
    NSLog(@"%@", toIndexPath);
}
 

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}


@end
