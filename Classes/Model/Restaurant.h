//
//  Restaurant.h
//  ShareUrMeal
//
//  Created by Andy Mroczkowski on 8/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@class Post;
@class Area;

@interface Restaurant :  NSManagedObject  
{
}

@property (nonatomic, retain) CLLocation * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSSet* posts;
@property (nonatomic, retain) Area * area;

@end


@interface Restaurant (CoreDataGeneratedAccessors)
- (void)addPostsObject:(Post *)value;
- (void)removePostsObject:(Post *)value;
- (void)addPosts:(NSSet *)value;
- (void)removePosts:(NSSet *)value;

@end

