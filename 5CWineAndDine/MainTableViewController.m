//
//  MainTableViewController.m
//  5CWineAndDine
//
//  Created by SDA on 9/14/13.
//  Copyright (c) 2013 Sean Adler. All rights reserved.
//

#import "MainTableViewController.h"
#import "DetailViewController.h"
#import "SWRevealViewController.h"


#define DH_API_URL @"http://dining-api.herokuapp.com/all"
#define DH_FONT_SIZE 18.0

// defined in this file for ease of setDetailVC method below.
#define DETAIL_VIEW_CONTROLLER ((DetailViewController *)[(UINavigationController *)self.revealViewController.frontViewController viewControllers][0])

@interface MainTableViewController ()

@property (nonatomic) long weekday;
@property (nonatomic) long hour;
@property (nonatomic, strong) NSString *currentMeal;
@property (nonatomic, strong) NSString *weekdayString;

@end


@implementation MainTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSURL *url = [NSURL URLWithString:DH_API_URL];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] init];
    spinner.color = [UIColor grayColor];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.3f, 1.3f);
    spinner.transform = transform;
    
    spinner.frame = CGRectMake(10,10,300,300);
    [DETAIL_VIEW_CONTROLLER.tableView addSubview:spinner];
    [spinner startAnimating];
    
    dispatch_queue_t getMealsQ = dispatch_queue_create("get meals from API", NULL);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    dispatch_async(getMealsQ, ^{
        // Async thread that loads data from API
        NSData *data = [NSData dataWithContentsOfURL:url];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Get back to main (UI) thread to finagle "loading" UI properties
            [self setPropertiesFromJsonData:data];
            [self.revealViewController setFrontViewPosition:FrontViewPositionRight animated:YES];
            [spinner stopAnimating];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            DETAIL_VIEW_CONTROLLER.navigationItem.title = @"← Pick a Dining Hall";
        });
    });
}

- (void)setPropertiesFromJsonData:(NSData *)data
{
    self.mealData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    unsigned units = NSWeekdayCalendarUnit | NSHourCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    self.weekday = (long)components.weekday;
    self.hour = (long)components.hour;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.revealViewController setFrontViewPosition:FrontViewPositionRight animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.mealData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DiningHallTVC";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[[self.mealData allKeys] objectAtIndex:indexPath.row] capitalizedString];
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:DH_FONT_SIZE];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (NSString *)keyPathForDay:(long)day andHour:(long)hour
{
    NSString *dayString = @"Contact App Owner";
    NSString *mealString = @"Contact App Owner";
    
    switch (day) {
        case 1:
            dayString = @"sun";
            break;
        case 2:
            dayString = @"mon";
            break;
        case 3:
            dayString = @"tue";
            break;
        case 4:
            dayString = @"wed";
            break;
        case 5:
            dayString = @"thu";
            break;
        case 6:
            dayString = @"fri";
            break;
        case 7:
            dayString = @"sat";
            break;
        default:
            break;
    }
    
    if ([dayString isEqualToString:@"sat"] || [dayString isEqualToString:@"sun"]) {
        if (hour < 14) mealString = @"brunch";
        else mealString = @"dinner";
        
    } else {
        if (hour < 11) mealString = @"breakfast";
        else if (hour < 17) mealString = @"lunch";
        else mealString = @"dinner";
    }
    
    // Now we pass everything for the current day.
    NSString *keyPath = [NSString stringWithFormat:@"%@", dayString];
    
    // Save mealString and dayString and pass later to detail view
    self.currentMeal = mealString;
    self.weekdayString = dayString;
    
    return keyPath;
}


#pragma mark - Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *detailVC = segue.destinationViewController;
    
    if ([[segue identifier] isEqualToString:@"showMenu"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *diningHall = [[self.mealData allKeys] objectAtIndex:indexPath.row];
        NSString *keyPath = [NSString stringWithFormat:@"%@.%@",
                             diningHall, [self keyPathForDay:self.weekday andHour:self.hour]];
        
        NSLog(@"keyPath: %@", keyPath);
        
        NSDictionary *dayMealsDict = [self.mealData valueForKeyPath:keyPath];
        NSArray *dayMealsDictKeys = [dayMealsDict allKeys];
        
        NSMutableArray *dayMeals = [[NSMutableArray alloc] initWithCapacity:dayMealsDict.count];
        
            if ([dayMealsDictKeys containsObject:@"brunch"]) {
                [dayMeals addObject:@{@"brunch": dayMealsDict[@"brunch"]}];
            }
            if ([dayMealsDictKeys containsObject:@"breakfast"]) {
                [dayMeals addObject:@{@"breakfast": dayMealsDict[@"breakfast"]}];
            }
            if ([dayMealsDictKeys containsObject:@"lunch"]) {
                [dayMeals addObject:@{@"lunch": dayMealsDict[@"lunch"]}];
            }
            if ([dayMealsDictKeys containsObject:@"dinner"]) {
                [dayMeals addObject:@{@"dinner": dayMealsDict[@"dinner"]}];
            }
        
        NSLog(@"Day Meals Dict: %@", dayMealsDict);
        NSLog(@"Day Meals: %@", dayMeals);
        NSLog(@"Day Meals first obj: %@", dayMeals[0]);
//        NSLog(@"mealData: %@", mealData);
        
        
        [detailVC setWeekdayString:self.weekdayString];
        [detailVC setCurrentMeal:self.currentMeal];
        [detailVC setDayMeals:dayMeals];
        [detailVC setDiningHallTitle:[diningHall capitalizedString]];
    }
    
        if ([segue isKindOfClass:[SWRevealViewControllerSegue class]]) {
            SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue *)segue;
            
            swSegue.performBlock = ^(SWRevealViewControllerSegue *rvc_segue, UIViewController *svc, UIViewController *dvc) {
                UINavigationController *navController = (UINavigationController *)self.revealViewController.frontViewController;
                [navController setViewControllers:@[dvc] animated:NO];
                [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
            };
        }
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"indexPath: %@", indexPath);
//    
//    NSString *className = NSStringFromClass([DetailViewController class]);
//    DetailViewController *detailVC = [[DetailViewController alloc] initWithNibName:className bundle:nil];
//    
//    
//    detailVC.mealData = [self mealDataForDay:self.weekday andHour:self.hour];
//    [self.navigationController pushViewController:detailVC animated:YES];
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
//}

@end
