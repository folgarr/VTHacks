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

@property (nonatomic, strong) NSDictionary *currentContact;

@end

@implementation ContactsViewController

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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.messageBoard = [MessageBoard instance];
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"contacts" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filepath];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:nil];
    if (dict)
    {
        self.contactsDictionary = dict;
        self.companyListWithContactsDict = [self removeSkillsArray:dict];
    }
//    [self.messageBoard getDataFromServer:@"contacts" completionHandler:^(NSDictionary *jsonDictionary, NSError *serverError) {
//        
//        self.contactsDictionary = jsonDictionary;
//        self.companyListWithContactsDict = [self removeSkillsArray:jsonDictionary];
//        
//        [self.tableView reloadData];
//    }];

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
        MessageBoard *mb = [MessageBoard instance];
        if (mb)
        {
            [mb getDataFromServer:@"contacts" completionHandler:^(NSDictionary *jsonDictionary, NSError *serverError) {
                weakSelf.contactsDictionary = jsonDictionary;
                weakSelf.companyListWithContactsDict = [weakSelf removeSkillsArray:jsonDictionary];
                [weakSelf.tableView reloadData];
                [tempScrollView performSelector:@selector(didFinishPullToRefresh) withObject:nil afterDelay:2];
            }];
        }
        else
            [tempScrollView performSelector:@selector(didFinishPullToRefresh) withObject:nil afterDelay:2];
        [tempScrollView performSelector:@selector(didFinishPullToRefresh) withObject:nil afterDelay:2];
    }];
}

//Help me convert the skills array into a string my friend.
- (NSMutableArray *)removeSkillsArray: (NSDictionary *)dict
{
    NSMutableArray *updatedArray = [[NSMutableArray alloc] init];
    
    NSArray *listOfCompanies = dict[@"companies"];
    
    for (int i = 0; i < [listOfCompanies count]; i++)
    {
        NSDictionary *companyDict = listOfCompanies[i];
        NSMutableDictionary *updateCompanyDict = [NSMutableDictionary dictionaryWithDictionary:companyDict];
        
        NSMutableArray *contacts = [NSMutableArray arrayWithArray:companyDict[@"contacts"]];
        
        for (int i = 0; i < [contacts count]; i++)
        {
            
            NSMutableDictionary *mutableContact = [NSMutableDictionary dictionaryWithDictionary:contacts[i]];
            
            NSArray *skills = mutableContact[@"skills"];
            NSMutableString *skillString = [[NSMutableString alloc]init];
            
            int index = 0;
            NSUInteger length = [skills count] - 1;
            for (NSString *skill in skills)
            {
                NSString *withComma = [NSString stringWithFormat:@"%@, ", skill];
                [skillString appendString:((index != length) ? withComma : skill)];
                index++;
            }
            
            mutableContact[@"skills"] = skillString;
            
            contacts[i] = mutableContact;
        }
        
        updateCompanyDict[@"contacts"] = contacts;
        [updatedArray addObject:updateCompanyDict];
    }
    
    return updatedArray;
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, tableView.frame.size.width, 30)];
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    NSDictionary *company = self.companyListWithContactsDict[section];
    NSString *companyName = company[@"name"];
    
    label.textAlignment = NSTextAlignmentLeft;
    
    /* Section header is in 0th index... */
    [label setText:companyName];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor sectionColor]]; //your background color...
    //    scheduleHeaderCell
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

//-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return [[UIView alloc] initWithFrame:CGRectZero];
//}

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

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSDictionary *company = self.companyListWithContactsDict[section];
//    NSString *companyName = company[@"name"];
//    return companyName;
//}

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
    NSString *skills = contact[@"skills"];

    [cell.nameLabel setText:contact[@"name"]];
    [cell.skillLabel setText:skills];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
    NSDictionary *company = self.companyListWithContactsDict[section];
    NSMutableArray *companyContacts = company[@"contacts"];
    
    NSDictionary *contact = companyContacts[row];
    NSString *skills = contact[@"skills"];
    CGSize size = [skills boundingRectWithSize:CGSizeMake(280, FLT_MAX)
                       options:NSStringDrawingUsesLineFragmentOrigin
                    attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:13.0]}
                       context:nil].size;
    
    return 20 + size.height + 20 + 20;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
    NSDictionary *company = self.companyListWithContactsDict[section];
    NSMutableArray *companyContacts = company[@"contacts"];
    
    NSDictionary *contact = companyContacts[row];
    
    self.currentContact = contact;
    
    [self createActionSheetWithTwitter:contact[@"twitter"] withPhone:contact[@"phone"] withEmail:contact[@"email"] withName:contact[@"name"]];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void) createActionSheetWithTwitter: (NSString *)twitter withPhone: (NSString *)phone withEmail: (NSString *)email withName: (NSString *)name
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    if (twitter) [array addObject:@"Twitter"];
    if (phone) [array addObject:@"Phone"];
    if (email) [array addObject:@"Email"];
    
    if ([array count] != 0) [self showActionSheetWithArrayOfButtons:array withName:name];
}

- (void) showActionSheetWithArrayOfButtons: (NSMutableArray *)array withName:(NSString *)name
{
    if ([array count] == 1)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                      initWithTitle:[NSString stringWithFormat:@"Contact %@", name]
                      delegate:self
                      cancelButtonTitle:@"Cancel"
                      destructiveButtonTitle:nil
                      otherButtonTitles:(NSString *)array[0], nil];
            [actionSheet showInView:self.view];
    }
    else if ([array count] == 2)
    {
       UIActionSheet *actionSheet  = [[UIActionSheet alloc]
                       initWithTitle:[NSString stringWithFormat:@"Contact %@", name]
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                       otherButtonTitles:(NSString *)array[0], (NSString *)array[1], nil];
            [actionSheet showInView:self.view];
    }
    else if ([array count] == 3)
    {
        UIActionSheet *actionSheet  = [[UIActionSheet alloc]
                       initWithTitle:[NSString stringWithFormat:@"Contact %@", name]
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                       otherButtonTitles:(NSString *)array[0], (NSString *)array[1], (NSString *)array[2], nil];
            [actionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSDictionary *contact = self.currentContact;
    
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"Twitter"]) {
        [self showTweetSheetWithUser:contact[@"twitter"]];
    }
    if ([buttonTitle isEqualToString:@"Phone"]) {
        [self showMessageSheetWithName:contact[@"name"] withNumberString:contact[@"phone"]];
        
    }
    if ([buttonTitle isEqualToString:@"Email"]) {
        [self showEmailSheetWithName:contact[@"name"] withEmail:contact[@"email"]];
    }
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        NSLog(@"I canceled");
    }
}

#pragma mark - sending a tweet

- (void)showTweetSheetWithUser:(NSString *)userName
{
    //  Create an instance of the Tweet Sheet
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:
                                           SLServiceTypeTwitter];
    
    // Sets the completion handler.  Note that we don't know which thread the
    // block will be called on, so we need to ensure that any required UI
    // updates occur on the main queue
    tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
        switch(result) {
                //  This means the user cancelled without sending the Tweet
            case SLComposeViewControllerResultCancelled:
                break;
                //  This means the user hit 'Send'
            case SLComposeViewControllerResultDone:
                break;
        }
    };
    
    NSString *initialText = [NSString stringWithFormat:@"Hi %@, \n\n#vthacks #VT", userName];
    //  Set the initial body of the Tweet
    [tweetSheet setInitialText:initialText];
    
    //  Presents the Tweet Sheet to the user
    [self presentViewController:tweetSheet animated:NO completion:^{
        NSLog(@"Tweet sheet has been presented.");
    }];
}

#pragma mark - Sending a message 

- (void)showMessageSheetWithName:(NSString *)name withNumberString:(NSString *)number
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    [controller.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
	if([MFMessageComposeViewController canSendText])
	{
		controller.body = [NSString stringWithFormat:@"Hi %@", name];
		controller.recipients = @[number];
		controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
	}
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
        else if (result == MessageComposeResultSent)
            NSLog(@"Message sent");
            else
                NSLog(@"Message failed");
}

#pragma mark -sending email

- (void)showEmailSheetWithName: (NSString *)name withEmail:(NSString *)email
{
    
    if ([MFMailComposeViewController canSendMail]) {
        // Email Subject
        NSString *emailTitle = @"VTHacks Help!";
        // Email Content
        NSString *messageBody = [NSString stringWithFormat:@"Hey %@", name];
        // To address
        NSArray *toRecipents = @[email];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Not Supported"
                                                        message: @"Your device does not support mail or have not been setup."
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        
        
    }

}
//TODO: remove the NSLogs when shipping.
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}




#pragma mark - scroll view delegates
-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{

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
