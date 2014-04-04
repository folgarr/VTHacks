//
//  AwardsViewController.m
//  VTHacks
//
//  Created by Vincent Ngo on 4/2/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import "AwardsViewController.h"
#import "MessageBoard.h"
#import "AwardsCell.h"
#import "UIScrollView+GifPullToRefresh.h"
#import "FBShimmeringView.h"
@interface AwardsViewController ()

@property (nonatomic, strong) MessageBoard *messageBoard;

@property (nonatomic, strong) NSMutableArray *awardsList;
@property (nonatomic, strong) FBShimmeringView *shimmeringView;

@end

@implementation AwardsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.messageBoard = [MessageBoard instance];
    [self.messageBoard getDataFromServer:@"awards" completionHandler:^(NSDictionary *jsonDictionary, NSError *serverError) {
        
        NSLog(@"awards %lu", (unsigned long)[jsonDictionary[@"awards"] count]);
        self.awardsList = jsonDictionary[@"awards"];
//        self.contactsDictionary = jsonDictionary;
//        self.companyListWithContactsDict = jsonDictionary[@"companies"];
        [self.tableView reloadData];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSDictionary *award = self.awardsList[section];
//    NSString *awardTitle = award[@"title"];
//    return awardTitle;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    return [self.awardsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"awardsCell";
    AwardsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSInteger row = [indexPath row];
    
    NSDictionary *award = self.awardsList[row];
    NSString *company = award[@"company"];
    NSString *url = award[@"url"];
    NSString *prize = award[@"prize"];
    NSString *description = award[@"description"];
    
    [cell.companyLabel setText:company];
    [cell.descriptionLabel setText:description];
    [cell.prizeLabel setText:prize];
//
//    NSDictionary *company = self.companyListWithContactsDict[section];
//    NSMutableArray *companyContacts = company[@"contacts"];
//    
//    NSDictionary *contact = companyContacts[row];
//    NSArray *skills = contact[@"skills"];
//    NSMutableString *skillString = [[NSMutableString alloc]init];
//    
//    int index = 0;
//    NSUInteger length = [skills count] - 1;
//    for (NSString *skill in skills)
//    {
//        NSString *withComma = [NSString stringWithFormat:@"%@, ", skill];
//        [skillString appendString:((index != length) ? withComma : skill)];
//        index++;
//    }
//    
//    [cell.nameLabel setText:contact[@"name"]];
//    [cell.skillLabel setText:skillString];
//    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 147;
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
