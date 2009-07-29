//
//  MyViewController.m
//  MyTabBar
//
//  Created by Evan Doll on 10/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TabBarController.h"


@implementation TabBarController


// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
        self.title = @"MyView";
        self.tabBarItem.image = [UIImage imageNamed:@"all.png"];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}


@end
