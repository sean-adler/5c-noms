//
//  DetailViewController.h
//  5CWineAndDine
//
//  Created by SDA on 9/14/13.
//  Copyright (c) 2013 Sean Adler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UITableViewController

//@property (nonatomic, strong) NSArray *mealData;
@property (nonatomic, strong) NSArray *dayMeals;
@property (nonatomic, strong) NSString *diningHallTitle;
@property (nonatomic, strong) NSString *currentMeal;
@property (nonatomic, strong) NSString *weekdayString;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
