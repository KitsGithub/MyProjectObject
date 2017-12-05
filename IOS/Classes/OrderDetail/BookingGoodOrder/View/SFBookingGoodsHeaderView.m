//
//  SFBookingGoodsHeaderView.m
//  SFLIS
//
//  Created by kit on 2017/12/4.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFBookingGoodsHeaderView.h"

@implementation SFBookingGoodsHeaderView {
    UILabel *_titleLabel;
    UIImageView *_arrowImg;
    UIButton *_bjButton;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = FONT_COMMON_16;
    _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _titleLabel.text = @"选择车辆";
    [self addSubview:_titleLabel];
    
    _arrowImg = [UIImageView new];
    _arrowImg.image = [UIImage imageNamed:@"PersonalCenter_arrow"];
    [self addSubview:_arrowImg];
    
    _bjButton = [UIButton new];
    [self addSubview:_bjButton];
}

- (void)setActionSelector:(SEL)sel withTarget:(id)target {
    [_bjButton addTarget:target action:sel forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)layoutSubviews {
    CGSize titleSize = [_titleLabel.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _titleLabel.frame = CGRectMake(20, (CGRectGetHeight(self.frame) - titleSize.height) * 0.5, titleSize.width, titleSize.height);
    
    _arrowImg.frame = CGRectMake(CGRectGetWidth(self.frame) - 20 - 8, (CGRectGetHeight(self.frame) - 16) * 0.5, 8, 16);
    
    _bjButton.frame = self.bounds;
    
}

    

@end
