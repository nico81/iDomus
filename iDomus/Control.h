//
//  Control.h
//  iDomus
//
//  Created by Giuseppe Acito on 19/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Control : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * urlOn;
@property (nonatomic, retain) NSString * urlOff;
@property (nonatomic, retain) NSDate * creationDate;

@end
