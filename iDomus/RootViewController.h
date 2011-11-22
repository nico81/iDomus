//
//  RootViewController.h
//  iDomus
//
//  Created by Giuseppe Acito on 19/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Control;

@interface RootViewController : UITableViewController {
    NSMutableArray *controlsArray;
    NSManagedObjectContext *managedObjectContext;
    IBOutlet UITableView *myTableView;
}

@property (atomic, retain) NSMutableArray *controlsArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(void) addControl:(Control *) control;

@end
