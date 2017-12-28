//
//  SFAdressPickerCell.m
//  SFLIS
//
//  Created by kit on 2017/10/13.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFAdressPickerCell.h"

@implementation SFAdressPickerCell {
    UILabel *_titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
//    self.backgroundColor = THEMECOLOR;
    
    _titleLabel = [UILabel new];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = BLACKCOLOR;
    [self addSubview:_titleLabel];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    _titleLabel.text = titleStr;
}


- (void)layoutSubviews {
    _titleLabel.frame = self.bounds;
}

@end
