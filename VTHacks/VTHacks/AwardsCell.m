//
//  AwardsCell.m
//  VTHacks
//
//  Created by Vincent Ngo on 4/4/14.
//  Copyright (c) 2014 Vincent Ngo. All rights reserved.
//

#import "AwardsCell.h"

@implementation AwardsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
