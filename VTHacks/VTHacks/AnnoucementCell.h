//
//  annoucementCell.h
//  VTHacks
//
//  Created by Vincent Ngo on 3/2/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnoucementCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *annoucementTitle;
@property (strong, nonatomic) IBOutlet UILabel *annoucementTime;//start time.
@property (strong, nonatomic) IBOutlet UILabel *annoucementLocation;

@property (strong, nonatomic) IBOutlet UILabel *annoucementMonth;

//@property (strong, nonatomic) IBOutlet UITextView *subDescription;
@property (strong, nonatomic) IBOutlet UILabel *subDescription;

@end
