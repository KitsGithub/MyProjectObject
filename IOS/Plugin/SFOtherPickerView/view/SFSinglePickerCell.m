//
//  SFSinglePickerCell.m
//  SFLIS
//
//  Created by kit on 2017/10/26.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFSinglePickerCell.h"

@implementation SFSinglePickerCell {
    UILabel *_titleLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        self.backgroundColor = THEMECOLOR;
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = BLACKCOLOR;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_titleLabel];
}

- (void)setTitle:(NSString *)title {
    
    _titleLabel.text = _title = title;
}

- (void)layoutSubviews {
    CGSize titleSize = [_titleLabel.text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _titleLabel.frame = CGRectMake(12, (CGRectGetHeight(self.frame) - titleSize.height) * 0.5, titleSize.width, titleSize.height);
}

@end
