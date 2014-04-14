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
#import "Constants.h"

static NSString * notifySubject;
static NSString * notifyBody;
static NSMutableArray * cachedDicts;

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

+(void) setAnnouncementsCache:(NSMutableArray*)dict
{
    cachedDicts = dict;
}

- (void)dealloc
{
    [self.tableView.refreshControl containingViewDidUnload];
}

NSComparisonResult sortDictsByDate(NSDictionary *d1, NSDictionary *d2, void *context) {
    NSDate *date1 = d1[@"date"];
    NSDate *date2 = d2[@"date"];
    return [date2 compare:date1];
}


- (void)viewDidLoad
{

    [super viewDidLoad];
    
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
    
    if (cachedDicts && [cachedDicts count] > 0)
        self.announcementDictionaries = cachedDicts;
    else if (!self.announcementDictionaries || [self.announcementDictionaries count] == 0)
        self.announcementDictionaries = [NSMutableArray arrayWithArray:@[@{@"title" : @"Welcome", @"body" : @"Hello World! Welcome to the official VTHacks app. Don't forget that you can pull to refresh on your screen in order to check for new content! Happy Hacking!\n\nNOTICE:\nApple is not a sponsor nor is involved in any way with this event (or any related contests presented here or during the event). All contests and prizes presented in this app are sponsored by VTHacks. The only official rule for these contests is to be a registered VTHacks participant.", @"date":[NSDate date], @"dateString":@"Today", @"simpleTimeString":@"now" }]];
    
    [self.tableView addPullToRefreshWithDrawingImgs:horseDrawingImgs andLoadingImgs:horseLoadingImgs andActionHandler:^{
        MessageBoard *mb = [MessageBoard instance];
        if (mb)
        {
            //Grab annoucements data. This call will NOT use the cache (because user is explicitely asking to refresh).
            [[MessageBoard instance] getAnnouncements:^(NSMutableArray *jsonList, NSError *serverError) {
                if (!serverError && jsonList)
                {
                    NSLog(@"PULL TO REFRESH FOUDN THIS MANY ANNOUNCEMENTS IN QUEUE: %tu", [jsonList count]);
                    if ((cachedDicts && [jsonList count] > [cachedDicts count]) || !cachedDicts)
                    {
                        cachedDicts = jsonList;
                        weakSelf.announcementDictionaries = jsonList;
                        [weakSelf.tableView reloadData];
                        [weakSelf.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
                    }
                    else
                        NSLog(@"NO CHANGES IN QUEUE. PULL TO REFRESH WILL NOT UPDATE TABLE VIEW.");
                }
                else if (serverError)
                {
                    NSLog(@"Error: pull to refresh tried to get queue messages but errored out with this message: %@", [serverError description]);
                }
                [tempScrollView performSelector:@selector(didFinishPullToRefresh) withObject:nil afterDelay:2];
            } usingPullToRefresh:YES];
        }
        else
            [tempScrollView performSelector:@selector(didFinishPullToRefresh) withObject:nil afterDelay:2];
        [tempScrollView performSelector:@selector(didFinishPullToRefresh) withObject:nil afterDelay:2];
    }];
}

-(void) reloadAnnouncementsWithInstance:(MessageBoard *)instance
{
    NSMutableArray *rawJSON = nil;
    NSError *localError = nil;
    rawJSON = [instance getMessagesFromQueueWithError:localError];
    if (localError != nil) {
        [[Constants universalAlertsWithTitle:@"Offline Error" andMessage:@"No Internet Connection! Please connect in order to load the data."] show];
        return;
    }
    localError = nil;
    NSLog(@"RECEIVED THIS MANY MESSAGES FROM THE QUEUE: %lu", (unsigned long)[rawJSON count]);

    NSMutableArray *multipleJsons = [[NSMutableArray alloc] initWithCapacity:[rawJSON count]];
    // keeps track of messages
    NSMutableDictionary *tempMessageHistory = [[NSMutableDictionary alloc] initWithCapacity:[rawJSON count]];
    for (SQSMessage *rawMessage in rawJSON)
    {
        NSString *body = [rawMessage body];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[body dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&localError];
        
        // get the date from time-stamp (initially comes in as utc timezone)
        NSDate *utcDate = [NSDate dateWithISO8061Format:jsonDict[@"Timestamp"]];
        NSString *localDateString = [NSDateFormatter localizedStringFromDate:utcDate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
        NSString * message = jsonDict[@"Message"];

        if (!tempMessageHistory[message]) //dont allow repeats
        {
            NSArray *components = [message componentsSeparatedByString:@"|"];
            if ([components count] == 2)
            {
                NSString *simpleTimeString = [MessageBoard getSimpleTimeFromDateString:localDateString];
                NSDictionary *simpleDictionary = @{@"title" : components[0], @"body" : components[1], @"date":utcDate, @"dateString":localDateString, @"simpleTimeString":simpleTimeString};
                [multipleJsons addObject:simpleDictionary];
            }
            else if (message && [message length] > 0)
            {
                NSString *simpleTimeString = [MessageBoard getSimpleTimeFromDateString:localDateString];
                NSDictionary *simpleDictionary = @{@"title" : @"Announcement", @"body" : message, @"date":utcDate, @"dateString":localDateString, @"simpleTimeString":simpleTimeString};
                [multipleJsons addObject:simpleDictionary];
            }
            else
                NSLog(@"Found a strange message, it didnt use the | seperator. Here it is: %@", message);
        }
        else
            NSLog(@"This message was a duplicate produced by sqs read: %@", message);
        tempMessageHistory[message] = [NSNumber numberWithBool:YES];
    }
    
    // sort the array in descending order
    NSArray *sorted = [multipleJsons sortedArrayUsingFunction:sortDictsByDate context:nil];
    NSMutableArray *sortedAnnouncements = [NSMutableArray arrayWithArray:sorted];
    self.announcementDictionaries = sortedAnnouncements;
    cachedDicts = self.announcementDictionaries;
    [self.tableView reloadData];
    

}

-(void) announceWithSubject:(NSString *)subject andBody:(NSString *)body
{
    NSDate *now = [NSDate date];
   
    if (self.announcementDictionaries != nil)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        NSString *currentTime = [dateFormatter stringFromDate:now];
        NSDictionary *newAnnouncement = @{@"title" : subject, @"body" : body, @"date":now, @"dateString":@"temporary date string?", @"simpleTimeString":currentTime};
        [[MessageBoard instance] updateCacheWithAnnouncement:newAnnouncement];
        [self.announcementDictionaries insertObject:newAnnouncement atIndex:0];
        cachedDicts = self.announcementDictionaries;
        
        [self.tableView reloadData];
        self.tableView.scrollsToTop = YES;
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }

    NSLog(@"\nMESSAGE TITLE: %@\nMESSAGE BODY: %@\n", subject, body);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSInteger row = [indexPath row];
    NSDictionary *announcement = self.announcementDictionaries[row];
    NSString *description = announcement[@"body"];
    
    CGSize size = [description boundingRectWithSize:CGSizeMake(280, FLT_MAX)
                                            options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:15.0]}
                                            context:nil].size;
    
    return 61 + size.height + 36;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.announcementDictionaries == nil? 0 : [self.announcementDictionaries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSInteger row = [indexPath row];
        static NSString *CellIdentifier = @"annoucementCell";
        AnnoucementCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *annoucement = self.announcementDictionaries[row];
        [cell.subDescription setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0]];
        [cell.annoucementTitle setText:annoucement[@"title"]];
        [cell.annoucementTime setText:annoucement[@"simpleTimeString"]];
        [cell.subDescription setText:annoucement[@"body"]];
        return cell;
}

+(void) setSubject:(NSString *)subj andBody:(NSString *)body
{
    notifySubject = subj;
    notifyBody = body;
}


#pragma mark - scroll view delegates 

-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
//    if (scrollView.contentSize.height < 200)
//    {
//        [self.tableView setBackgroundColor:[UIColor whiteColor]];
//    }
//    else
//    {
//        float scrollOffset = scrollView.contentOffset.y;
//        if (scrollOffset == 0 || scrollOffset < 20)
//        {
//            if (![self.tableView.backgroundColor isEqual:[UIColor maroonColor]])
//            {
//                [self.tableView setBackgroundColor:[UIColor maroonColor]];
//            }
//            
//        }
//        else if (scrollOffset > 21)
//        {
//            if (![self.tableView.backgroundColor isEqual:[UIColor whiteColor]])
//            {
//                [self.tableView setBackgroundColor:[UIColor whiteColor]];
//            }
//        }
//    }
}

@end
