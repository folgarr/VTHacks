//
//  AnnoucementViewController.m
//  VTHacks
//
//  Created by Vincent Ngo on 3/1/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import "AnnoucementViewController.h"
#import "ViewController.h"
#import "AnnoucementCell.h"
#import "AppDelegate.h"
#import "MessageBoard.h"
#import "VVNTransparentView.h"
#import "MenuCell.h"
#import "UIScrollView+GifPullToRefresh.h"
#import "MessageBoard.h"



static NSString *notifySubject;
static NSString *notifyBody;

@interface AnnoucementViewController ()

@property (nonatomic, strong) __block NSMutableDictionary *annoucementDict;

@property (nonatomic, strong) NSMutableArray *annoucementKeys;
@property (nonatomic, strong) NSMutableArray *eventKeys;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *monthFormatter;

@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, assign) CGFloat currentDescriptionHeight;

@property (nonatomic, strong) AppDelegate *appDelegate;


@end

@implementation AnnoucementViewController


- (void)dealloc
{
    [self.tableView.refreshControl containingViewDidUnload];
}

NSComparisonResult sortDictsByDate(NSDictionary *d1, NSDictionary *d2, void *context) {
    NSDate *date1 = d1[@"date"];
    NSDate *date2 = d2[@"date"];
    return [date2 compare:date1];
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

    //Creates an instance of MessageBoard

//    MessageBoard *messageBoard = [MessageBoard instance];


    // someplace where you create the UINavigationController
//[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backgroundColor.png"] forBarMetrics:UIBarMetricsDefault];
//    

    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"annoucementCache"
                                                         ofType:@"plist"];
    self.annoucementDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    self.annoucementKeys = [[NSMutableArray alloc] initWithArray:[self.annoucementDict allKeys]];
    NSMutableDictionary *eventDict = self.annoucementDict[self.annoucementKeys[0]];
    self.eventKeys = [[NSMutableArray alloc] initWithArray:[eventDict allKeys]];
    //TODO: order the dates.

    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.monthFormatter = [[NSDateFormatter alloc] init];
    
    [self.dateFormatter setDateFormat:@"h:mm a"];
    [self.monthFormatter setDateFormat:@"EEEE"];
    
    self.selectedRow = -1;
    self.currentDescriptionHeight = 0;
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.appDelegate.announceVC = self;
    if (notifyBody || notifySubject)
    {
        [self announceWithSubject:notifySubject andBody:notifyBody];
    }
    notifyBody = nil;
    notifySubject = nil;
    
    NSMutableArray *horseDrawingImgs = [NSMutableArray array];
    NSMutableArray *horseLoadingImgs = [NSMutableArray array];
    for (NSUInteger i  = 0; i <= 15; i++)
    {
        NSString *fileName = [NSString stringWithFormat:@"hokieHorse-%lu.png", (unsigned long)i];
        [horseDrawingImgs addObject:[UIImage imageNamed:fileName]];
    }
    
    for (NSUInteger i  = 0; i <= 15; i++) {
        NSString *fileName = [NSString stringWithFormat:@"hokieHorse-%lu.png", (unsigned long)i];
        [horseLoadingImgs addObject:[UIImage imageNamed:fileName]];
    }
    __weak UIScrollView *tempScrollView = self.tableView;
    __unsafe_unretained typeof(self) weakSelf = self;
//    __unsafe_unretained typeof(self) weakSelfTableView = self.tableView;
    
    
    
    
    [self.tableView addPullToRefreshWithDrawingImgs:horseDrawingImgs andLoadingImgs:horseLoadingImgs andActionHandler:^{
        
        //Grab annoucements data. This call will NOT use the cache (because user is explicitely asking to refresh).
        [[MessageBoard instance] getAnnouncements:^(NSMutableArray *jsonList, NSError *serverError) {
            if (!serverError && jsonList)
            {
                NSLog(@"PULL TO REFRESH FOUDN THIS MANY ANNOUNCEMENTS IN QUEUE: %tu", [jsonList count]);
                weakSelf.announcementDictionaries = jsonList;
                [weakSelf.tableView reloadData];
            }
            else if (serverError)
            {
                NSLog(@"Error: pull to refresh tried to get queue messages but errored out with this message: %@", [serverError description]);
            }
        } usingPullToRefresh:YES];
        [tempScrollView performSelector:@selector(didFinishPullToRefresh) withObject:nil afterDelay:2];
    }];
}

-(void) reloadAnnouncementsWithInstance:(MessageBoard *)instance
{
    NSMutableArray *rawJSON = nil;
    rawJSON = [instance getMessagesFromQueue];
    NSError *localError = nil;
    NSMutableArray *multipleJsons = [[NSMutableArray alloc] initWithCapacity:[rawJSON count]];
    for (SQSMessage *rawMessage in rawJSON)
    {
        NSString *body = [rawMessage body];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[body dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&localError];
        
        // get the date from time-stamp (initially comes in as utc timezone)
        NSDate *utcDate = [NSDate dateWithISO8061Format:jsonDict[@"Timestamp"]];
        NSString *localDateString = [NSDateFormatter localizedStringFromDate:utcDate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
        NSString * message = jsonDict[@"Message"];
        NSArray *components = [message componentsSeparatedByString:@"|"];
        if ([components count] == 2)
        {
            NSString *simpleTimeString = [MessageBoard getSimpleTimeFromDateString:localDateString];
            NSDictionary *simpleDictionary = @{@"title" : components[0], @"body" : components[1], @"date":utcDate, @"dateString":localDateString, @"simpleTimeString":simpleTimeString};
            [multipleJsons addObject:simpleDictionary];
        }
    }
    
    // sort the array in descending order
    NSArray *sorted = [multipleJsons sortedArrayUsingFunction:sortDictsByDate context:nil];
    NSMutableArray *sortedAnnouncements = [NSMutableArray arrayWithArray:sorted];
    self.announcementDictionaries = sortedAnnouncements;
    [self.tableView reloadData];

}

-(void) announceWithSubject:(NSString *)subject andBody:(NSString *)body
{
    NSDate *now = [NSDate date];
//    NSDictionary *eventDict = @{@"time": now, @"location": @"AWS", @"description" : body};
//    
//    NSString *currentDate = self.annoucementKeys[0];
//    NSMutableDictionary *listOfEventsWithinDate = [[NSMutableDictionary alloc] initWithDictionary:self.annoucementDict[currentDate]];
//    
//    [listOfEventsWithinDate setObject:eventDict forKey:subject];
//    [self.eventKeys insertObject:subject atIndex:0];
//    
//    self.annoucementDict[currentDate] = listOfEventsWithinDate;
    
    
    if (self.announcementDictionaries != nil)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        NSString *currentTime = [dateFormatter stringFromDate:now];
        NSDictionary *newAnnouncement = @{@"title" : subject, @"body" : body, @"date":now, @"dateString":@"temporary date string?", @"simpleTimeString":currentTime};
        [[MessageBoard instance] updateCacheWithAnnouncement:newAnnouncement];
        [self.announcementDictionaries insertObject:newAnnouncement atIndex:0];
        
        [self.tableView reloadData];
        self.tableView.scrollsToTop = YES;
    }


    NSLog(@"\nMESSAGE TITLE: %@\nMESSAGE BODY: %@\n", subject, body);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    __unsafe_unretained typeof(self) weakSelf = self;

//    //Grab annoucements data that is cached on initial load
//    [[MessageBoard instance] getAnnouncements:^(NSMutableArray *jsonList, NSError *serverError) {
//        NSLog(@"viewWillAppear: Here are the announcements: %@", jsonList);
//        weakSelf.announcementDictionaries = jsonList;
//        [weakSelf.tableView reloadData];
//        [self.tableView setNeedsDisplay];
//
//    } usingPullToRefresh:NO];
}

- (void)showScheduleView

{
    NSLog(@"CLICKED ON THE Show Schedule Button!");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"scheduleViewController"];
    [vc setModalPresentationStyle:UIModalPresentationFullScreen];
//    
//    [self presentViewController:vc animated:NO completion:nil];
    [[self navigationController] pushViewController:vc animated:YES];

//    [self presentViewController:vc animated:YES completion:nil];

    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString *currentDate = self.annoucementKeys[section];
//    return currentDate;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSInteger row = [indexPath row];
    NSDictionary *announcement = self.announcementDictionaries[row];
    NSString *description = announcement[@"body"];
    
    CGSize size = [description boundingRectWithSize:CGSizeMake(280, FLT_MAX)
                                            options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:13.0]}
                                            context:nil].size;
    
    return 75 + size.height + 38;
    
    
//        NSString *currentDate = self.annoucementKeys[indexPath.section];
//        NSDictionary *listOfEventsWithinDate = self.annoucementDict[currentDate];
//        NSArray *listOfEventsNames = [listOfEventsWithinDate allKeys];
//        NSString *event = listOfEventsNames[indexPath.row];
//        
//        NSDictionary *annoucement = listOfEventsWithinDate[event];
//        NSString *description = annoucement[@"description"];
//        NSUInteger characterCount = [description length];
//        
//        if (self.selectedRow == [indexPath row] && characterCount > 200)
//        {
//            return 320;
//        }
//        else
//        {
//            return 100;
//        }
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
   
//        NSString *currentDate = self.annoucementKeys[section];
//        NSDictionary *listOfEventsWithinDate = self.annoucementDict[currentDate];
    
    return self.announcementDictionaries == nil? 0 : [self.announcementDictionaries count];


}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSInteger row = [indexPath row];
       // NSInteger section = [indexPath section];

        
        static NSString *CellIdentifier = @"annoucementCell";
        AnnoucementCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //NSString *currentDate = self.annoucementKeys[section];
        //NSDictionary *listOfEventsWithinDate = self.annoucementDict[currentDate];
        //    NSArray *listOfEventsNames = [listOfEventsWithinDate allKeys];
        //NSString *event = self.eventKeys[row];
        
        NSDictionary *annoucement = self.announcementDictionaries[row];//listOfEventsWithinDate[event];
        
        [cell.annoucementTitle setText:annoucement[@"title"]];
    
        [cell.annoucementTime setText:annoucement[@"simpleTimeString"]];
        //[cell.annoucementMonth setText:[self.monthFormatter stringFromDate:annoucement[@"time"]]];
        
        [cell.subDescription setText:annoucement[@"body"]];
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
//        if (self.selectedRow == indexPath.row)
//        {
//            self.selectedRow = -1;
//            [tableView beginUpdates];
//            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView endUpdates];
//            
//        }
//        else
//        {
//            self.selectedRow = indexPath.row;
//            [tableView beginUpdates];
//            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView endUpdates];
//            AnnoucementCell *cell = (AnnoucementCell *)[tableView cellForRowAtIndexPath:indexPath];
//            
//            NSString *currentDate = self.annoucementKeys[indexPath.section];
//            NSDictionary *listOfEventsWithinDate = self.annoucementDict[currentDate];
//            NSArray *listOfEventsNames = [listOfEventsWithinDate allKeys];
//            NSString *event = listOfEventsNames[indexPath.row];
//            
//            NSDictionary *annoucement = listOfEventsWithinDate[event];
//            NSString *description = annoucement[@"description"];
//            NSUInteger characterCount = [description length];
//            
//            if (characterCount > 200)
//            {
//                cell.subDescription.numberOfLines = 0;
//                [cell.subDescription sizeToFit];
//            }
//            
//        }
//        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

}

- (CGFloat)textViewHeightForText:(NSString *)text andWidth:(CGFloat)width
{
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    NSDictionary *attrsDictionary =
    [NSDictionary dictionaryWithObject:font
                                forKey:NSFontAttributeName];
    NSAttributedString *string = [[NSAttributedString alloc]initWithString:text attributes:attrsDictionary];
    
    UITextView *textView = [[UITextView alloc] init];
    [textView setAttributedText:string];
    CGSize size = [textView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

- (CGSize)text:(NSString *)text sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
        CGRect frame = [text boundingRectWithSize:size
                                          options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                       attributes:@{NSFontAttributeName:font}
                                          context:nil];
        return frame.size;
}


+(void) setSubject:(NSString *)subj andBody:(NSString *)body
{
    notifySubject = subj;
    notifyBody = body;
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
