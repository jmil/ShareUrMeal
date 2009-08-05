//
//  MyDocument.m
//  DBTool
//
//  Created by Andy Mroczkowski on 8/4/09.
//  Copyright __MyCompanyName__ 2009 . All rights reserved.
//

#import "ShareUrMealDocument.h"

@implementation ShareUrMealDocument

- (id)init 
{
    self = [super init];
    if (self != nil) {
        // initialization code
    }
    return self;
}

- (NSString *)windowNibName 
{
    return @"ShareUrMealDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController 
{
    [super windowControllerDidLoadNib:windowController];
    // user interface preparation code
}

@end
