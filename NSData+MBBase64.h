//
//  NSData+Base64.h
//  ShareUrMeal
//
//  Created by Andy Mroczkowski on 10/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


// FROM: http://www.cocoadev.com/index.pl?BaseSixtyFour

@interface NSData (MBBase64)

+ (id)dataWithBase64EncodedString:(NSString *)string;     //  Padding '=' characters are optional. Whitespace is ignored.
- (NSString *)base64Encoding;
@end



