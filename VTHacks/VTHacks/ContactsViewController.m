//
//  ContactsViewController.m
//  VTHacks
//
//  Created by Vincent Ngo on 4/2/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import "ContactsViewController.h"
#import "MessageBoard.h"
#import "ContactsCell.h"
#import "UIScrollView+GifPullToRefresh.h"
@interface ContactsViewController ()

@property (nonatomic, strong) MessageBoard *messageBoard;
@property (nonatomic, strong) NSDictionary *contactsDictionary;

@property (nonatomic, strong) NSMutableArray *companyListWithContactsDict;
@property (nonatomic, strong) NSMutableArray *companyListWithContactsDictSorted;


@end

@implementation ContactsViewController

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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
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

    
    
    self.messageBoard = [MessageBoard instance];
    [self.messageBoard getDataFromServer:@"contacts" completionHandler:^(NSDictionary *jsonDictionary, NSError *serverError) {
        
        self.contactsDictionary = jsonDictionary;
        self.companyListWithContactsDict = jsonDictionary[@"companies"];
        [self.tableView reloadData];
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.companyListWithContactsDict count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *company = self.companyListWithContactsDict[section];
    NSString *companyName = company[@"name"];
    return companyName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *company = self.companyListWithContactsDict[section];
    NSMutableArray *contacts = company[@"contacts"];
    
    return [contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"contactsCell";
    ContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    NSDictionary *company = self.companyListWithContactsDict[section];
    NSMutableArray *companyContacts = company[@"contacts"];
    
    NSDictionary *contact = companyContacts[row];
    NSArray *skills = contact[@"skills"];
    NSMutableString *skillString = [[NSMutableString alloc]init];
    
    int index = 0;
    NSUInteger length = [skills count] - 1;
    for (NSString *skill in skills)
    {
        NSString *withComma = [NSString stringWithFormat:@"%@, ", skill];
        [skillString appendString:((index != length) ? withComma : skill)];
        index++;
    }
    
    [cell.nameLabel setText:contact[@"name"]];
    [cell.skillLabel setText:skillString];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
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
