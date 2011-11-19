//
//  RootViewController.h
//  iDomus
//
//  Created by Giuseppe Acito on 19/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController {
   // NSMutableArray *controlsArray;
    NSManagedObjectContext *managedObjectContext;
}

@property (atomic, retain) NSMutableArray *controlsArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
