//
//  ScheduleViewController.m
//  VTHacks
//
//  Created by Vincent Ngo on 3/2/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import "ScheduleViewController.h"
#import "ScheduleCell.h"
#import "MessageBoard.h"
#import "DateUtilities.h"
#import "UIScrollView+GifPullToRefresh.h"
@interface ScheduleViewController ()

@property (nonatomic, strong) NSDictionary *scheduleDict;
@property (nonatomic, strong) NSArray *nameOfDay;

@property (nonatomic, strong) MessageBoard *messageBoard;

@property (nonatomic, strong) NSMutableArray *sectionDay;
@property (nonatomic, strong) NSDictionary *dayScheduleDict;

@property (nonatomic, strong) NSArray *sundayEvents;
@property (nonatomic, strong) NSMutableArray *saturdayEvents;
@property (nonatomic, strong) NSMutableArray *fridayEvents;

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
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"scheduleCache" ofType:@"plist"];
    self.scheduleDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    // this is an array of dicts (exactly two of them)
    self.nameOfDay = [self.scheduleDict allKeys];
    
    self.messageBoard = [MessageBoard instance];
    [self.messageBoard getDataFromServer:@"schedule" completionHandler:^(NSDictionary *jsonDictionary, NSError *serverError) {

        if(jsonDictionary)
        {
            self.scheduleDict = jsonDictionary;
            
            self.sectionDay = [NSMutableArray arrayWithArray:[jsonDictionary allKeys]];
            [DateUtilities sortArrayBasedOnDay:self.sectionDay ascending:NO];
            
            [self.tableView reloadData];
        }
    }];
    
    NSMutableArray *horseDrawingImgs = [NSMutableArray array];
    NSMutableArray *horseLoadingImgs = [NSMutableArray array];
    for (NSUInteger i  = 0; i <= 15; i++) {
        NSString *fileName = [NSString stringWithFormat:@"hokieHorse-%lu.png", (unsigned long)i];
        [horseDrawingImgs addObject:[UIImage imageNamed:fileName]];
    }
    
    for (NSUInteger i  = 0; i <= 15; i++) {
        NSString *fileName = [NSString stringWithFormat:@"hokieHorse-%lu.png", (unsigned long)i];
        [horseLoadingImgs addObject:[UIImage imageNamed:fileName]];
    }
    __weak UIScrollView *tempScrollView = self.tableView;
    
    [self.tableView addPullToRefreshWithDrawingImgs:horseDrawingImgs andLoadingImgs:horseLoadingImgs andActionHandler:^{

        [tempScrollView performSelector:@selector(didFinishPullToRefresh) withObject:nil afterDelay:2];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *currentDate = self.sectionDay[section];
    return currentDate;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionDay count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *events = self.scheduleDict[self.sectionDay[section]];
    return [events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"scheduleCell";
    ScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    NSString *nameDate = self.sectionDay[section];
    NSArray *events = self.scheduleDict[nameDate];
    NSArray *eventsSortedDescending = [DateUtilities sortArrayOfEventDictByTimeStamp:events ascending:NO];
    
    NSDictionary *event = eventsSortedDescending[row];
    
    [cell.timeLabel setText:event[@"timestamp"]];
    [cell.eventLabel setText:event[@"description"]];
    [cell.cellTitle setText:event[@"title"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
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
