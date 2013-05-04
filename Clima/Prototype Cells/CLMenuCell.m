//
//  CLMenuCell.m
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/3/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CLMenuCell.h"

@implementation CLMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage *bgImage = [UIImage imageNamed:@"menu_separator_line"];
    _separator.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    
    _titleLabel.textColor = UIColorFromRGB(0xdededc);
    _titleLabel.shadowColor = [UIColor blackColor];
    _titleLabel.shadowOffset = CGSizeMake(0, 1);
}

@end
