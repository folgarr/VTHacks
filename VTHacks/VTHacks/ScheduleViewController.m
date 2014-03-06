//
//  ScheduleViewController.m
//  VTHacks
//
//  Created by Vincent Ngo on 3/2/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import "ScheduleViewController.h"
#import "ScheduleCell.h"

@interface ScheduleViewController ()

@property (nonatomic, strong) NSDictionary *scheduleDict;
@property (nonatomic, strong) NSArray *nameOfDay;
@end

@implementation ScheduleViewController

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

    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"scheduleCache"
                                                         ofType:@"plist"];
    self.scheduleDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    self.nameOfDay = [self.scheduleDict allKeys];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *currentDate = self.nameOfDay[section];
    return currentDate;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.nameOfDay count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *events = self.scheduleDict[self.nameOfDay[section]];
    
    return [events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"scheduleCell";
    ScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    NSString *nameDate = self.nameOfDay[section];
    NSDictionary *events = self.scheduleDict[nameDate];
    NSArray *arrayOfEvents = [events allKeys];

    
    NSString *time = arrayOfEvents[row];
    [cell.timeLabel setText:time];
    [cell.eventLabel setText:events[time]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
