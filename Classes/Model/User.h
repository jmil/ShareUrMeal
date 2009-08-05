//
//  User.h
//  ShareUrMeal
//
//  Created by Andy Mroczkowski on 8/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Post;

@interface User :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * realname;
@property (nonatomic, retain) NSSet* posts;

@end


@interface User (CoreDataGeneratedAccessors)
- (void)addPostsObject:(Post *)value;
- (void)removePostsObject:(Post *)value;
- (void)addPosts:(NSSet *)value;
- (void)removePosts:(NSSet *)value;

@end

