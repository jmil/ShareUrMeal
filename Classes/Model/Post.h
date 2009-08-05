//
//  Post.h
//  ShareUrMeal
//
//  Created by Andy Mroczkowski on 8/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@interface Post :  NSManagedObject  
{
}

@property (nonatomic, retain) CLLocation * location;
@property (nonatomic, retain) NSNumber * lattitude;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSManagedObject * user;
@property (nonatomic, retain) NSManagedObject * restaurant;

@end



