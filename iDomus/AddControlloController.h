//
//  AddControlloController.h
//  iDomus
//
//  Created by Giuseppe Acito on 19/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddControlloController : UIViewController {
    IBOutlet UITextField *name;
    IBOutlet UITextField *onURL;
    IBOutlet UITextField *offURL;
    
    NSManagedObjectContext *managedObjectContext;
}

@property (atomic, retain) UITextField *name;
@property (atomic, retain) UITextField *onURL;
@property (atomic, retain) UITextField *offURL;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;




-(IBAction) saveControl:(id)sender;

@end
