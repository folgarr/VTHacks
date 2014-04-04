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
#import "ContactsViewController.h"
#import "SocialViewController.h"
#import "AwardsViewController.h"
@interface MenuViewController ()

//Menu Properties
@property (nonatomic, strong) NSDictionary *menuDict;
@property (nonatomic, strong) NSArray *menuList;

@property (nonatomic, strong) UIBarButtonItem *menuBarButton;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) VVNTransparentView *transparentView;
@property (nonatomic, assign) NSInteger selectedCell;

@property (nonatomic, strong) NSString *menuSelected;

@end

@implementation MenuViewController

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([viewController isKindOfClass:[ScheduleViewController class]])
    {
        ScheduleViewController *scheduleController = (ScheduleViewController *)viewController;
        scheduleController.menuController = self;
        scheduleController.navigationController.title = @"Schedule";
    }
    else if ([viewController isKindOfClass:[AnnoucementViewController class]])
    {
        AnnoucementViewController *annoucementController = (AnnoucementViewController *)viewController;
        annoucementController.menuController = self;
        annoucementController.navigationController.title = @"Annoucements";
    }
    else if ([viewController isKindOfClass:[ContactsViewController class]])
    {
        ContactsViewController *contactsController = (ContactsViewController *)viewController;
        contactsController.menuController = self;
        contactsController.navigationController.title = @"Contacts";
    }
    else if ([viewController isKindOfClass:[SocialViewController class]])
    {
        SocialViewController *socialController = (SocialViewController *)viewController;
        socialController.menuController = self;
        socialController.navigationController.title = @"Social";
    }
    else if ([viewController isKindOfClass:[AwardsViewController class]])
    {
        AwardsViewController *awardsController = (AwardsViewController *)viewController;
        awardsController.menuController = self;
        awardsController.navigationController.title = @"Awards";
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
    self.menuSelected = @"Annoucements";
    
    //Initially push Annoucement view controller on the stack
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"annoucementViewController"];
    [vc setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [self.navigationController pushViewController:vc animated:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Creation of UI

- (void)createMenuWithViewController: (UIViewController *)viewController
{
    //Set up Menu Data
    self.menuList = @[@"Annoucements", @"Schedule", @"Contacts", @"Map", @"Awards", @"Social"];
    
    //Stores the awesomefont id that cooresponds to the company name.
    self.menuDict = @{@"Annoucements": @"\uf0f3", @"Schedule" : @"\uf133", @"Contacts" : @"\uf007", @"Map" : @"\uf041", @"Awards" : @"\uf091", @"Social" : @"\uf099"};
    
    //Add Ellipse Menu Button
    self.menuBarButton = [[UIBarButtonItem alloc] initWithTitle:@"^_^"
                                                          style:UIBarButtonItemStyleDone target:self action:@selector(showMenu)];
    UIFont *font = [UIFont fontWithName:@"fontawesome" size:20];
    [self.menuBarButton setTitleTextAttributes:@{NSFontAttributeName: font} forState:UIControlStateNormal];
    [self.menuBarButton setTitle:@"\uf142"];
    viewController.navigationItem.rightBarButtonItem = self.menuBarButton;
    [viewController.navigationController.navigationBar setTranslucent:NO];
//    [viewController.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init]
//                       forBarPosition:UIBarPositionAny
//                           barMetrics:UIBarMetricsDefault];
//    
//    [viewController.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
//
    
//        [self.navigationController.navigationBar setBackgroundColor:[UIColor greenColor]];
    viewController.navigationItem.hidesBackButton = YES;
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
    
    if (![self.menuSelected isEqualToString:menuSelected])
    {
        [self openSelectedMenuItem:menuSelected];
        self.menuSelected = menuSelected;
        [tableView setUserInteractionEnabled:NO];
        [cell animateCellWithStyle:CCAnimationStyleRubberBand completion:^(BOOL finished) {
            [tableView setUserInteractionEnabled:YES];
            self.selectedCell = indexPath.row;
            [self.transparentView closeView];
        }];
    }
    else
    {
        [cell animateCellWithStyle:CCAnimationStyleRubberBand completion:^(BOOL finished) {
            [self.transparentView closeView];
        }];
    }

}

- (void)openSelectedMenuItem: (NSString *)selectedMenuItem
{
    NSLog(@"Count of number of viewControllers on the stack is %lu", (unsigned long)[[self.navigationController viewControllers] count]);
    
    if ([self.navigationController.viewControllers count] > 1)
    {
        [self.navigationController popViewControllerAnimated:NO];
//        [self.navigationController popToRootViewControllerAnimated:NO]
    }
    
    if ([selectedMenuItem isEqualToString:@"Annoucements"])
    {
        NSLog(@"Annoucements View Controller");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"annoucementViewController"];
//        [vc setModalPresentationStyle:UIModalPresentationFullScreen];

        [self.navigationController pushViewController:vc animated:NO];
    }
    else if ([selectedMenuItem isEqualToString:@"Schedule"])
    {
        NSLog(@"Schedule View Controller");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"scheduleViewController"];
        
        [vc setModalPresentationStyle:UIModalPresentationFullScreen];

        [self.navigationController pushViewController:vc animated:NO];
    }
    else if ([selectedMenuItem isEqualToString:@"Contacts"])
    {
        NSLog(@"Contacts View Controller");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"contactsViewController"];
        
        [vc setModalPresentationStyle:UIModalPresentationFullScreen];
        
        [self.navigationController pushViewController:vc animated:NO];
    }
    else if ([selectedMenuItem isEqualToString:@"Map"])
    {
        NSLog(@"Map View Controller");
    }
    else if ([selectedMenuItem isEqualToString:@"Awards"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"awardsViewController"];
        
        [vc setModalPresentationStyle:UIModalPresentationFullScreen];
        
        [self.navigationController pushViewController:vc animated:NO];

    }
    else //Social
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"socialViewController"];
        
        [vc setModalPresentationStyle:UIModalPresentationFullScreen];
        
        [self.navigationController pushViewController:vc animated:NO];
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

