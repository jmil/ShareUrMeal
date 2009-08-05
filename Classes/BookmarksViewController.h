//
//  BookmarksViewController.h
//  CorePeptides
//
//  Created by Jordan on 7/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BookmarksViewController : UITableViewController
{
	NSArray* restaurants;
}

@property (nonatomic, retain) NSArray* restaurants;

@end
