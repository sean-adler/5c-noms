//
//  DetailViewController.m
//  5CWineAndDine
//
//  Created by SDA on 9/14/13.
//  Copyright (c) 2013 Sean Adler. All rights reserved.
//

#import "DetailViewController.h"

#define FONT_SIZE 12.0

@interface DetailViewController ()

@property (nonatomic, strong) NSArray *mealTitles;
@property (nonatomic, strong) NSArray *meals;

@end

@implementation DetailViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    self.navigationItem.title = self.diningHallTitle;
    
    if (!self.weekdayString) {
        self.weekdayString = @"Monday";
    }
    self.navigationItem.title = @"Monday";
    
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
    return self.dayMeals.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *meals = [[self.dayMeals objectAtIndex:section] allValues][0];
    //    NSString *mealString = self.dayMeals[indexPath.section][1][indexPath.row];
    
    return meals.count;
    
//    return self.mealData.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    UILabel *label = [[UILabel alloc] init];
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[self.dayMeals objectAtIndex:section] allKeys][0] capitalizedString];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MealCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *meals = [[self.dayMeals objectAtIndex:indexPath.section] allValues][0];
    //    NSString *mealString = self.dayMeals[indexPath.section][1][indexPath.row];
    NSString *mealString = [meals objectAtIndex:indexPath.row];
    
    // Configure the cell...
    
    // Make long meal strings wrap around
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:FONT_SIZE];
    cell.textLabel.text = mealString;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    // Configure header label
    cell.detailTextLabel.text = @"awesome";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *meals = [[self.dayMeals objectAtIndex:indexPath.section] allValues][0];
//    NSString *mealString = self.dayMeals[indexPath.section][1][indexPath.row];
    NSString *mealString = [meals objectAtIndex:indexPath.row];
    CGSize stringSize = [mealString sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:FONT_SIZE]
                               constrainedToSize:CGSizeMake(320, 9999)
                                   lineBreakMode:NSLineBreakByWordWrapping];
    return stringSize.height + 25;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
