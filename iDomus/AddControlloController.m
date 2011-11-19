//
//  AddControlloController.m
//  iDomus
//
//  Created by Giuseppe Acito on 19/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AddControlloController.h"
#import "Control.h"
#import "RootViewController.h"

@implementation AddControlloController

@synthesize managedObjectContext;

@synthesize name;
@synthesize onURL;
@synthesize offURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    self.title = @"Add Control";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.name = nil;
    self.onURL = nil;
    self.offURL = nil;
    self.managedObjectContext = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction) saveControl:(id)sender {
    NSLog(@"Called");
        
    Control* control = (Control *)[NSEntityDescription insertNewObjectForEntityForName:@"Control" inManagedObjectContext:managedObjectContext];
        
    control.name = self.name.text;
    control.urlOn = self.onURL.text;
    control.urlOff = self.offURL.text;
    control.creationDate = [NSDate date];
    
    NSError *error = nil;
    if(![managedObjectContext save:&error]) {
        NSLog(@"errore in insert");
    }
    
    RootViewController *rvc =(RootViewController *)[self.navigationController popViewControllerAnimated:YES];
    [rvc.controlsArray insertObject:control atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [rvc.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [rvc.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(IBAction)editingEnded:(id)sender{
    NSLog(@"hello!");
    [sender resignFirstResponder]; 
}

@end
