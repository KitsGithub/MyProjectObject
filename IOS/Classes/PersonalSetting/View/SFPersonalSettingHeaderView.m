//
//  SFPersonalSettingHeaderView.m
//  SFLIS
//
//  Created by kit on 2017/11/1.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFPersonalSettingHeaderView.h"

@implementation SFPersonalSettingHeaderView {
    UILabel *_titleLabel;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = BLACKCOLOR;
    _titleLabel.font = [UIFont boldSystemFontOfSize:21];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_titleLabel];
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    CGSize titleSize = [_titleLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:21] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _titleLabel.frame = CGRectMake(20, CGRectGetHeight(self.frame) - titleSize.height, titleSize.width, titleSize.height);
    
}

@end
