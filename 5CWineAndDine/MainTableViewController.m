//
//  MainTableViewController.m
//  5CWineAndDine
//
//  Created by SDA on 9/14/13.
//  Copyright (c) 2013 Sean Adler. All rights reserved.
//

#import "MainTableViewController.h"
#import "DetailViewController.h"


#define API_URL @"http://dining-api.herokuapp.com/all"

@interface MainTableViewController ()

@property (nonatomic, strong) NSDictionary *mealData;
@property (nonatomic) long weekday;
@property (nonatomic) long hour;

@end


@implementation MainTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // other init stuff here
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
    NSURL *url = [NSURL URLWithString:API_URL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.mealData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@", self.mealData);
    
    
    // Find current weekday and hour.
    unsigned units = NSWeekdayCalendarUnit | NSHourCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    self.weekday = (long)components.weekday;
    self.hour = (long)components.hour;
    NSLog(@"day: %ld, hour: %ld", (long)components.weekday, (long)components.hour);
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
    static NSString *CellIdentifier = @"DiningHallCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[[self.mealData allKeys] objectAtIndex:indexPath.row] capitalizedString];
    // Configure the cell...
    
    
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
            dayString = @"sunday";
            break;
        case 2:
            dayString = @"monday";
            break;
        case 3:
            dayString = @"tuesday";
            break;
        case 4:
            dayString = @"wednesday";
            break;
        case 5:
            dayString = @"thursday";
            break;
        case 6:
            dayString = @"friday";
            break;
        case 7:
            dayString = @"saturday";
            break;
        default:
            break;
    }
    
    if ([dayString isEqualToString:@"saturday"] || [dayString isEqualToString:@"sunday"]) {
        if (hour < 14) mealString = @"brunch";
        else mealString = @"dinner";
        
    } else {
        if (hour < 11) mealString = @"breakfast";
        else if (hour < 17) mealString = @"lunch";
        else mealString = @"dinner";
    }
    
    // only CMC has snack
    
    NSString *keyPath = [NSString stringWithFormat:@"%@.%@", dayString, mealString];
//    NSArray *array = [self.mealData valueForKeyPath:keyPath];
    NSLog(@"keyPath: %@", keyPath);
        
    return keyPath;
}


#pragma mark - Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *detailVC = segue.destinationViewController;
    
    if ([[segue identifier] isEqualToString:@"pushToDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *rowTitle = [[self.mealData allKeys] objectAtIndex:indexPath.row];
        NSString *keyPath = [NSString stringWithFormat:@"%@.%@",
                             rowTitle, [self keyPathForDay:self.weekday andHour:self.hour]];
        
        NSArray *mealData = [self.mealData valueForKeyPath:keyPath];
//        NSLog(@"mealData: %@", mealData);
        
        
        [detailVC setMealData:mealData];
//        NSArray *mealz = [self mealDataForDay:self.weekday andHour:self.hour];
//        NSLog(@"meals: %@", mealz);
//        NSLog(@"detailVC's mealData: %@", detailVC.mealData);
    }
    
//    NSString *className = NSStringFromClass([DetailViewController class]);
//    DetailViewController *detailVC = [[DetailViewController alloc] initWithNibName:className bundle:nil];
//    
//    
//    detailVC.mealData = [self mealDataForDay:self.weekday andHour:self.hour];
//    [self.navigationController pushViewController:detailVC animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
}

@end
