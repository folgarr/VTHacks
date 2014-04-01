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

static NSString *notifySubject;
static NSString *notifyBody;

@interface AnnoucementViewController ()

@property (nonatomic, strong) UIBarButtonItem *menuBarButton;
@property (nonatomic, strong) UIActionSheet *menuActionSheet;

@property (nonatomic, strong) UIView *blackView;

@property (nonatomic, strong) NSMutableDictionary *annoucementDict;

@property (nonatomic, assign) NSInteger numberOfRows;

@property (nonatomic, strong) NSMutableArray *annoucementKeys;
@property (nonatomic, strong) NSMutableArray *eventKeys;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *monthFormatter;

@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, assign) CGFloat currentDescriptionHeight;

@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation AnnoucementViewController

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
    
    [self createMenuBarButton];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.appDelegate.announceVC = self;
    if (notifyBody || notifySubject)
    {
        [self announceWithSubject:notifySubject andBody:notifyBody];
    }
    notifyBody = nil;
    notifySubject = nil;


}

#pragma mark - Creating Menu Buttons
- (void)createMenuBarButton
{
    //Add Ellipse Menu Button
    self.menuBarButton = [[UIBarButtonItem alloc] initWithTitle:@"^_^"
                                                          style:UIBarButtonItemStyleDone target:self action:@selector(showMenu)];
    UIFont *font = [UIFont fontWithName:@"fontawesome" size:20];
    [self.menuBarButton setTitleTextAttributes:@{NSFontAttributeName: font} forState:UIControlStateNormal];
    [self.menuBarButton setTitle:@"\uf142"];
    self.navigationItem.rightBarButtonItem = self.menuBarButton;
    self.navigationItem.leftBarButtonItem = nil;
    
}

- (void)createSocialBarButton
{
    //TODO: createSocialBarButton.
}

#pragma mark - Menu Action
- (void)showMenu
{
    //Creates a blackView that is initially hidden, and alpha to completely transparent.
    self.blackView = [[UIView alloc]initWithFrame:self.view.frame];
    [self.blackView setBackgroundColor:[UIColor blackColor]];
    self.blackView.alpha = 0;
    self.blackView.hidden = YES;
    
    //Creating an Action sheet with no buttons, to act as a way to disable superView.
    self.menuActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    //Make actionsheet slightly transparent so it doesn't flash in front of the users eyes.
    self.menuActionSheet.alpha = 0.9;
    //Add the currently hidden blackView to the actionSheet's view.
    [self.menuActionSheet addSubview:self.blackView];
    
    //Show the blackView, it's still not showing because alpha is set to zero.
    self.blackView.hidden = NO;
    
    //Going to bring the blackView to visability. up to alpha 0.9.
    [UIView animateWithDuration: 0.2
                          delay: 0.0
                        options: UIViewAnimationOptionTransitionCurlUp
                     animations:^{
                        self.blackView.alpha = 0.95;
                     }
                     completion:nil];

#if 0
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    NSLog(@"action sheet %@", NSStringFromCGRect(self.menuActionSheet.frame));
#endif
    
    //Bring up the action sheet.
    [self.menuActionSheet showInView:self.view];
    
    //Adjust actionsheet frame to make view visible.
    CGRect updateASFrame = self.view.superview.frame;
    [self.menuActionSheet setFrame:updateASFrame];
    
    
    [self createMenuButtons];
    [self createMenuButtonIcons];
}

- (void)createMenuButtonIcons
{
    UIImageView *annoucementImage = [[UIImageView alloc] initWithFrame:CGRectMake(49, 92, 37, 21)];
    [annoucementImage setImage:[UIImage imageNamed:@"annoucementIcon"]];
    [annoucementImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.menuActionSheet addSubview:annoucementImage];
    
    UIImageView *scheduleImage = [[UIImageView alloc] initWithFrame:CGRectMake(49, 148, 37, 21)];
    [scheduleImage setImage:[UIImage imageNamed:@"scheduleIcon"]];
    [scheduleImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.menuActionSheet addSubview:scheduleImage];
    
    UIImageView *contactsImage = [[UIImageView alloc] initWithFrame:CGRectMake(49, 204, 37, 21)];
    [contactsImage setImage:[UIImage imageNamed:@"contactsIcon"]];
    [contactsImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.menuActionSheet addSubview:contactsImage];
    
    UIImageView *mapImage = [[UIImageView alloc] initWithFrame:CGRectMake(49, 260, 37, 21)];
    [mapImage setImage:[UIImage imageNamed:@"mapIcon"]];
    [mapImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.menuActionSheet addSubview:mapImage];
    
    UIImageView *awardImage = [[UIImageView alloc] initWithFrame:CGRectMake(49, 316, 37, 21)];
    [awardImage setImage:[UIImage imageNamed:@"awardsIcon"]];
    [awardImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.menuActionSheet addSubview:awardImage];
    
    UIImageView *photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(49, 372, 37, 21)];
    [photoImage setImage:[UIImage imageNamed:@"photoIcon"]];
    [photoImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.menuActionSheet addSubview:photoImage];
}

-(void) announceWithSubject:(NSString *)subject andBody:(NSString *)body
{
    NSDate *now = [NSDate date];
    NSDictionary *eventDict = @{@"time": now, @"location": @"AWS", @"description" : body};
    
    NSString *currentDate = self.annoucementKeys[0];
    NSMutableDictionary *listOfEventsWithinDate = [[NSMutableDictionary alloc] initWithDictionary:self.annoucementDict[currentDate]];
    
    [listOfEventsWithinDate setObject:eventDict forKey:subject];
    [self.eventKeys insertObject:subject atIndex:0];
    
    self.annoucementDict[currentDate] = listOfEventsWithinDate;
    
    [self.tableView reloadData];
    
    self.tableView.scrollsToTop = YES;


    NSLog(@"\nMESSAGE TITLE: %@\nMESSAGE BODY: %@\n", subject, body);
}

- (void)createMenuButtons
{
    UIButton *annoucementButton = [[UIButton alloc] initWithFrame:CGRectMake(94, 88, 130, 30)];
    [annoucementButton addTarget:self
                          action:@selector(exitMenu)
                forControlEvents:UIControlEventTouchDown];
    [annoucementButton setTitle:@"Annoucements" forState:UIControlStateNormal];
    
    [self.menuActionSheet addSubview:annoucementButton];
    
    UIButton *scheduleButton = [[UIButton alloc] initWithFrame:CGRectMake(94, 144, 130, 30)];
    [scheduleButton addTarget:self
                       action:@selector(showScheduleView)
             forControlEvents:UIControlEventTouchDown];
    
    [scheduleButton setTitle:@"Schedule" forState:UIControlStateNormal];
    
    [self.menuActionSheet addSubview:scheduleButton];
    
    UIButton *contactsButton = [[UIButton alloc] initWithFrame:CGRectMake(94, 200, 130, 30)];
    [contactsButton addTarget:self
                       action:@selector(exitMenu)
             forControlEvents:UIControlEventTouchDown];
    
    [contactsButton setTitle:@"Contacts" forState:UIControlStateNormal];
    
    [self.menuActionSheet addSubview:contactsButton];
    
    UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(94, 256, 130, 30)];
    [mapButton addTarget:self
                  action:@selector(exitMenu)
        forControlEvents:UIControlEventTouchDown];
    
    [mapButton setTitle:@"Map" forState:UIControlStateNormal];
    
    [self.menuActionSheet addSubview:mapButton];
    
    UIButton *awardsButton = [[UIButton alloc] initWithFrame:CGRectMake(94, 312, 130, 30)];
    [awardsButton addTarget:self
                     action:@selector(exitMenu)
           forControlEvents:UIControlEventTouchDown];
    
    [awardsButton setTitle:@"Awards" forState:UIControlStateNormal];
    
    [self.menuActionSheet addSubview:awardsButton];
    
    UIButton *photoButton = [[UIButton alloc] initWithFrame:CGRectMake(94, 368, 130, 30)];
    [photoButton addTarget:self
                    action:@selector(exitMenu)
          forControlEvents:UIControlEventTouchDown];
    
    [photoButton setTitle:@"Photos" forState:UIControlStateNormal];
    
    [self.menuActionSheet addSubview:photoButton];
    
    UIButton *exitButton = [[UIButton alloc] initWithFrame:CGRectMake(134, 454, 50, 50)];
    [exitButton addTarget:self
                    action:@selector(exitMenu)
          forControlEvents:UIControlEventTouchDown];
    
    [exitButton setImage:[UIImage imageNamed:@"exitIcon.png"] forState:UIControlStateNormal];
    [exitButton setTitle:@"" forState:UIControlStateNormal];
    
    [self.menuActionSheet addSubview:exitButton];
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
    [self.menuActionSheet dismissWithClickedButtonIndex:0 animated:NO];
//    [self presentViewController:vc animated:YES completion:nil];

    
}



- (void)exitMenu
{
    self.menuActionSheet.alpha = 0;
    [self.menuActionSheet dismissWithClickedButtonIndex:0 animated:YES];
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
    
    NSString *currentDate = self.annoucementKeys[indexPath.section];
    NSDictionary *listOfEventsWithinDate = self.annoucementDict[currentDate];
    NSArray *listOfEventsNames = [listOfEventsWithinDate allKeys];
    NSString *event = listOfEventsNames[indexPath.row];
    
    NSDictionary *annoucement = listOfEventsWithinDate[event];
    NSString *description = annoucement[@"description"];
    NSUInteger characterCount = [description length];

    if (self.selectedRow == [indexPath row] && characterCount > 200)
    {
        return 320;
    }
    else
    {
        return 100;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    NSString *currentDate = self.annoucementKeys[section];
    NSDictionary *listOfEventsWithinDate = self.annoucementDict[currentDate];
    
    return [listOfEventsWithinDate count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    static NSString *CellIdentifier = @"annoucementCell";
    AnnoucementCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *currentDate = self.annoucementKeys[section];
    NSDictionary *listOfEventsWithinDate = self.annoucementDict[currentDate];
//    NSArray *listOfEventsNames = [listOfEventsWithinDate allKeys];
    NSString *event = self.eventKeys[row];
    
    NSDictionary *annoucement = listOfEventsWithinDate[event];
    
    [cell.annoucementTitle setText:event];
    
    [cell.annoucementTime setText:[self.dateFormatter stringFromDate:annoucement[@"time"]]];
    [cell.annoucementMonth setText:[self.monthFormatter stringFromDate:annoucement[@"time"]]];

    [cell.subDescription setText:annoucement[@"description"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (self.selectedRow == indexPath.row)
    {
        self.selectedRow = -1;
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];

    }
    else
    {
        self.selectedRow = indexPath.row;
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        AnnoucementCell *cell = (AnnoucementCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        NSString *currentDate = self.annoucementKeys[indexPath.section];
        NSDictionary *listOfEventsWithinDate = self.annoucementDict[currentDate];
        NSArray *listOfEventsNames = [listOfEventsWithinDate allKeys];
        NSString *event = listOfEventsNames[indexPath.row];
        
        NSDictionary *annoucement = listOfEventsWithinDate[event];
        NSString *description = annoucement[@"description"];
        NSUInteger characterCount = [description length];
        
        if (characterCount > 200)
        {
            cell.subDescription.numberOfLines = 0;
            [cell.subDescription sizeToFit];
        }
        
    }
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

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
