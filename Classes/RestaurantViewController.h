//
//  RestaurantViewController.h
//  ShareUrMeal
//
//  Created by Jordan on 7/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Restaurant;

@interface RestaurantViewController : UIViewController
{
	Restaurant* restaurant;

	IBOutlet UILabel* nameLabel;
	IBOutlet UILabel* locationLabel;
}

@property (nonatomic, retain) Restaurant* restaurant;

@property (nonatomic, assign) UILabel* nameLabel;
@property (nonatomic, assign) UILabel* locationLabel;

- (id) initWithRestaurant:(Restaurant*)aRestaurant;


@end
