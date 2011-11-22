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
@synthesize controlsArray;

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
    self.controlsArray = nil;
}

-(void) dealloc {
    [name release];
    [onURL release];
    [offURL release];
    [managedObjectContext release];
    [controlsArray release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction) saveControl:(id)sender {
    NSLog(@"AddControlloController.ssaveControl Called");
    
    BOOL dataNotValid = NO;
    
    if([self.name.text length] == 0) {
        self.name.placeholder = @"Name is required!";
        dataNotValid = YES;
    } else {
        self.name.placeholder = @"Name";
    }
    
    if([self.onURL.text length] == 0) {
        self.onURL.placeholder = @"URL to turn on is required!";
        dataNotValid = dataNotValid || YES;
    } else {
        self.onURL.placeholder = @"URL to turn on";
    }
    
    if([self.offURL.text length] == 0) {
        self.offURL.placeholder= @"URL to turn off is required!";
        dataNotValid = dataNotValid || YES;
    } else {
        self.offURL.placeholder= @"URL to turn off";
    }
    
    
    if(!dataNotValid) {
        Control *control = (Control *)[NSEntityDescription insertNewObjectForEntityForName:@"Control" inManagedObjectContext:managedObjectContext];
    
        control.name = self.name.text;
        control.urlOn = self.onURL.text;
        control.urlOff = self.offURL.text;
        control.creationDate = [NSDate date];
    
        NSError *error = nil;
        if(![managedObjectContext save:&error]) {
            NSLog(@"errore in insert %@", error);
        }
        
        [self.controlsArray insertObject:control atIndex:0];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)editingEnded:(id)sender{
    [sender resignFirstResponder]; 
}

@end
