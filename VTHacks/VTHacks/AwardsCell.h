//
//  AwardsCell.h
//  VTHacks
//
//  Created by Vincent Ngo on 4/4/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AwardsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *awardsTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *companyLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *prizeLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionView;

@end
