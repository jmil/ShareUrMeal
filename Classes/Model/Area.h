//
//  Area.h
//  ShareUrMeal
//
//  Created by Andy Mroczkowski on 8/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@interface Area :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) CLLocation * location;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * lattitude;
@property (nonatomic, retain) NSSet* restaurants;

@end


@interface Area (CoreDataGeneratedAccessors)
- (void)addRestaurantsObject:(NSManagedObject *)value;
- (void)removeRestaurantsObject:(NSManagedObject *)value;
- (void)addRestaurants:(NSSet *)value;
- (void)removeRestaurants:(NSSet *)value;

@end

