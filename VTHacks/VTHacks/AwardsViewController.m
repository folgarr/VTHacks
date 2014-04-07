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

@interface AwardsViewController ()

@property (nonatomic, strong) MessageBoard *messageBoard;

@property (nonatomic, strong) NSMutableArray *awardsList;


@end

@implementation AwardsViewController

- (void)dealloc
{
    [self.tableView.refreshControl containingViewDidUnload];
}

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
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [self.tableView addPullToRefreshWithDrawingImgs:horseDrawingImgs andLoadingImgs:horseLoadingImgs andActionHandler:^{
        
        weakSelf.messageBoard = [MessageBoard instance];
        [weakSelf.messageBoard getDataFromServer:@"awards" completionHandler:^(NSDictionary *jsonDictionary, NSError *serverError) {
            
            NSLog(@"awards %lu", (unsigned long)[jsonDictionary[@"awards"] count]);
            weakSelf.awardsList = jsonDictionary[@"awards"];
            
            [weakSelf.tableView reloadData];
            [tempScrollView performSelector:@selector(didFinishPullToRefresh) withObject:nil afterDelay:2];
        }];
    }];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.awardsList count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, tableView.frame.size.width, 30)];
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    
    NSDictionary *award = self.awardsList[section];
    NSString *string = award[@"title"];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"awardsCell";
    AwardsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSInteger section = [indexPath section];
    NSDictionary *award = self.awardsList[section];
    NSString *company = award[@"company"];
//    NSString *url = award[@"url"];
    NSString *prize = award[@"prize"];
    NSString *description = award[@"description"];
    
    [cell.companyLabel setText:company];
    [cell.descriptionView setText:description];

    [cell.prizeLabel setText:prize];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSDictionary *award = self.awardsList[section];
    NSString *description = award[@"description"];
    
    CGSize size = [description boundingRectWithSize:CGSizeMake(280, FLT_MAX)
                                            options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:14.0]}
                                            context:nil].size;
    
    return 50 + size.height + 50;
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
