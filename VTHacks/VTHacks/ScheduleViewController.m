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


- (void)dealloc
{
    [self.tableView.refreshControl containingViewDidUnload];
}

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
    
    self.messageBoard = [MessageBoard instance];
    [self.messageBoard getDataFromServer:@"schedule" completionHandler:^(NSDictionary *jsonDictionary, NSError *serverError)
    {

        if (jsonDictionary)
        {
            self.scheduleDict = jsonDictionary;
            
            self.sectionDay = [NSMutableArray arrayWithArray:[jsonDictionary allKeys]];
            [DateUtilities sortArrayBasedOnDay:self.sectionDay ascending:YES];
            
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
    __unsafe_unretained typeof(self) weakSelf = self;
    
    
    [self.tableView addPullToRefreshWithDrawingImgs:horseDrawingImgs andLoadingImgs:horseLoadingImgs andActionHandler:^{

        NSLog(@"PULL TO REFRESH is happening ScheduleViewController!");
        [[MessageBoard instance] getDataFromServer:@"schedule" completionHandler:^(NSDictionary *jsonDictionary, NSError *serverError)
         {
             if (jsonDictionary)
             {
                 weakSelf.scheduleDict = jsonDictionary;
                 
                 weakSelf.sectionDay = [NSMutableArray arrayWithArray:[jsonDictionary allKeys]];
                 [DateUtilities sortArrayBasedOnDay:weakSelf.sectionDay ascending:YES];
                 
                 [weakSelf.tableView reloadData];
             }
             
             [tempScrollView performSelector:@selector(didFinishPullToRefresh) withObject:nil afterDelay:2];
         }];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, tableView.frame.size.width, 30)];
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    NSString *string = self.sectionDay[section];
    
    label.textAlignment = NSTextAlignmentLeft;

    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor sectionColor]]; //your background color...
//    scheduleHeaderCell
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    [view setBackgroundColor:[UIColor whiteColor]];
    return view;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
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
//    NSArray *eventsSortedDescending = [DateUtilities sortArrayOfEventDictByTimeStamp:events ascending:YES];
    
    NSDictionary *event = events[row];
    
    [cell.timeLabel setText:event[@"timestamp"]];
    [cell.eventLabel setText:event[@"description"]];
    [cell.cellTitle setText:event[@"title"]];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    NSString *nameDate = self.sectionDay[section];
    NSArray *events = self.scheduleDict[nameDate];
    
    NSDictionary *event = events[row];
    
    NSString *description = event[@"description"];
    
    CGSize size = [description boundingRectWithSize:CGSizeMake(280, FLT_MAX)
                                            options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:14.0]}
                                            context:nil].size;

    return 52 + size.height + 52;
}


#pragma mark - scroll view delegates

-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    float scrollOffset = scrollView.contentOffset.y;
    if (scrollOffset == 0 || scrollOffset < 20)
    {
        if (![self.tableView.backgroundColor isEqual:[UIColor maroonColor]])
        {
            [self.tableView setBackgroundColor:[UIColor maroonColor]];
        }
        
    }
    else if (scrollOffset > 21)
    {
        if (![self.tableView.backgroundColor isEqual:[UIColor whiteColor]])
        {
            [self.tableView setBackgroundColor:[UIColor whiteColor]];
        }
        
    }
}




//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    float scrollViewHeight = scrollView.frame.size.height;
//    float scrollContentSizeHeight = scrollView.contentSize.height;
//    float scrollOffset = scrollView.contentOffset.y;
//    
//    if (scrollOffset == 0)
//    {
//        [self.tableView setBackgroundColor:[UIColor redColor]];
//    }
//    else if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
//    {
//        [self.tableView setBackgroundColor:[UIColor whiteColor]];
//    }
//}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    
//}


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
