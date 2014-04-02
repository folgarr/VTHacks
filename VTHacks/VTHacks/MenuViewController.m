//
//  MenuViewController.m
//  VTHacks
//
//  Created by Vincent Ngo on 4/1/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import "MenuViewController.h"
#import "VVNTransparentView.h"
#import "MenuCell.h"
#import "ScheduleViewController.h"
#import "AnnoucementViewController.h"

@interface MenuViewController ()

//Menu Properties
@property (nonatomic, strong) NSDictionary *menuDict;
@property (nonatomic, strong) NSArray *menuList;

@property (nonatomic, strong) UIBarButtonItem *menuBarButton;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) VVNTransparentView *transparentView;
@property (nonatomic, assign) NSInteger selectedCell;

@end

@implementation MenuViewController

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    
    if ([viewController isKindOfClass:[ScheduleViewController class]])
    {
        ScheduleViewController *scheduleController = (ScheduleViewController *)viewController;
        scheduleController.menuController = self;
    }
    else if ([viewController isKindOfClass:[AnnoucementViewController class]])
    {
        AnnoucementViewController *annoucementController = (AnnoucementViewController *)viewController;
        annoucementController.menuController = self;
    }
    
    
    [self createMenuWithViewController:viewController];
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
    self.navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
//    self.navigationItem.backBarButtonItem = nil;
//    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
//    self.navigationController.navigationBar.topItem.titleView = nil;
//    UIView *staticTitle = [[UIView alloc]initWithFrame:self.navigationController.navigationBar.bounds];
//    [staticTitle setBackgroundColor:[UIColor greenColor]];
//    [staticTitle setUserInteractionEnabled:NO];
//    [self.navigationController.navigationBar addSubview:staticTitle];
//    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 100, 60)];
//    [customButton setBackgroundColor:[UIColor whiteColor]];
//    [customButton addTarget:self action:@selector(handleBackBtn) forControlEvents:UIControlEventTouchUpInside];
//    [customButton setTitle:@"Button" forState:UIControlStateNormal];
//    [staticTitle addSubview:customButton];
}

#pragma mark - Creation of UI

- (void)createMenuWithViewController: (UIViewController *)viewController
{
    //Set up Menu Data
    self.menuList = @[@"Annoucements", @"Schedule", @"Contacts", @"Map", @"Awards", @"Social"];
    
    //Stores the awesomefont id that cooresponds to the company name.
    self.menuDict = @{@"Annoucements": @"\uf179", @"Schedule" : @"\uf17c", @"Contacts" : @"\uf0c0", @"Map" : @"\uf09a", @"Awards" : @"\uf113", @"Social" : @"\uf0e1"};
    
    //Add Ellipse Menu Button
    self.menuBarButton = [[UIBarButtonItem alloc] initWithTitle:@"^_^"
                                                          style:UIBarButtonItemStyleDone target:self action:@selector(showMenu)];
    UIFont *font = [UIFont fontWithName:@"fontawesome" size:20];
    [self.menuBarButton setTitleTextAttributes:@{NSFontAttributeName: font} forState:UIControlStateNormal];
    [self.menuBarButton setTitle:@"\uf142"];
    viewController.navigationItem.rightBarButtonItem = self.menuBarButton;
    
}


#pragma mark - TableView Datasource

- (void)showMenu
{
    self.transparentView = [[VVNTransparentView alloc]initWithFrame:self.view.frame];
    [self.transparentView showView];
    
    // Add a tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.transparentView.frame.size.width, self.transparentView.frame.size.height - 64 - 150)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.transparentView addSubview:self.tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell;
    static NSString *cellId = @"menuCell";
    
    UINib *nib = [UINib nibWithNibName:@"MenuCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellId];
    cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    NSString *menuItemName = self.menuList[indexPath.row];
    NSString *menuCode = self.menuDict[menuItemName];
    UIFont *awesomeFont = [UIFont fontWithName:@"FontAwesome" size:25.0f];
    UIFont *biggerFont = [UIFont fontWithName:@"HelveticaNeue-bold" size:17.0f];
    UIFont *currentFont = cell.titleLabel.font;
    
    cell.titleLabel.text = menuItemName;
    cell.titleLabel.textColor = [UIColor whiteColor];
    cell.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.iconLabel.font = awesomeFont;
    cell.iconLabel.text = menuCode;
    cell.iconLabel.textAlignment = NSTextAlignmentCenter;
    cell.iconLabel.textColor = [UIColor whiteColor];
    
    cell.titleLabel.font = (self.selectedCell == indexPath.row) ? biggerFont : currentFont;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.alpha = 0;
    
    [UIView beginAnimations:@"opacity" context:nil];
    [UIView setAnimationDuration:0.8];
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = (MenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *menuSelected = cell.titleLabel.text;
    
    [self openSelectedMenuItem:menuSelected];
    [tableView setUserInteractionEnabled:NO];
    [cell animateCellWithStyle:CCAnimationStyleRubberBand completion:^(BOOL finished) {
        [tableView setUserInteractionEnabled:YES];
        self.selectedCell = indexPath.row;
        [self.transparentView closeView];
    }];
}

- (void)openSelectedMenuItem: (NSString *)selectedMenuItem
{
    NSLog(@"Count of number of viewControllers on the stack is %lu", (unsigned long)[[self.navigationController viewControllers] count]);
    
    if ([self.navigationController.viewControllers count] > 1)
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    if ([selectedMenuItem isEqualToString:@"Annoucements"])
    {
        NSLog(@"Annoucements View Controller");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"annoucementViewController"];
        [vc setModalPresentationStyle:UIModalPresentationFullScreen];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([selectedMenuItem isEqualToString:@"Schedule"])
    {
        NSLog(@"Schedule View Controller");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"scheduleViewController"];
        [vc setModalPresentationStyle:UIModalPresentationFullScreen];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([selectedMenuItem isEqualToString:@"Contacts"])
    {
        NSLog(@"Contacts View Controller");
    }
    else if ([selectedMenuItem isEqualToString:@"Map"])
    {
        NSLog(@"Map View Controller");
    }
    else if ([selectedMenuItem isEqualToString:@"Awards"])
    {
        NSLog(@"Awards View Controller");
    }
    else //Social
    {
        NSLog(@"Social View Controller");
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

//Credit to Joan Lluch
@implementation UIViewController(MenuViewController)

- (MenuViewController*)menuViewController
{
    UIViewController *parent = self;
    Class menuClass = [MenuViewController class];
    
    while ( nil != (parent = [parent parentViewController]) && ![parent isKindOfClass:menuClass] )
    {
    }
    
    return (id)parent;
}

@end

