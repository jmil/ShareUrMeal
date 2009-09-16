//
//  NSString+SUMExtensions.m
//  ShareUrMeal
//
//  Created by Corey Floyd on 9/15/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import "NSString+SUMExtensions.h"


@implementation NSString (SUM)


- (BOOL)containsString:(NSString *)aString{
    
    BOOL answer = YES;
    
    NSRange rangeOfSubString = [self rangeOfString:aString];
    
    if(rangeOfSubString.location == NSNotFound)
        answer = NO;
    
    return answer;
    
}


@end
