//
//  SFDriversView.m
//  SFLIS
//
//  Created by kit on 2017/11/15.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFDriversView.h"

@implementation SFDriversView {
    NSMutableArray *_buttonArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        [self setupView];
    }
    return self;
}

- (void)setDriverList:(NSMutableArray<NSString *> *)driverList {
    _driverList = driverList;
    
    for (UIButton *button in _buttonArray) {
        [button removeFromSuperview];
    }
    
    [self setupView];
}

/**
 布局
 */
- (void)setupView {
    _buttonArray = [NSMutableArray array];
    for (NSString *driverName in _driverList) {
        UIButton *button = [UIButton new];
        [_buttonArray addObject:button];
        [button setTitle:driverName forState:(UIControlStateNormal)];
        [button setBackgroundColor:THEMECOLOR];
        [button setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
        button.layer.cornerRadius = 15;
        button.clipsToBounds = YES;
        button.titleLabel.font = FONT_COMMON_16;
        [self addSubview:button];
        
    }
}

- (void)layoutSubviews {
    
    UIButton *lastButton;
    CGFloat padding = 10;
    for (NSInteger index = 0; index < _buttonArray.count; index++) {
        UIButton *button = _buttonArray[index];
        
        CGSize titleSize = [button.titleLabel.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        
        if (index == 0) {
            button.frame = CGRectMake(0, 0, titleSize.width + 30, 30);
        } else if ((CGRectGetMaxX(lastButton.frame) + titleSize.width + 30 + padding) > SCREEN_WIDTH) {
            UIButton *firstBtn = _buttonArray[0];
            button.frame = CGRectMake(0 , CGRectGetMaxY(firstBtn.frame) + padding, titleSize.width + 30, 30);
        } else {
            button.frame = CGRectMake(CGRectGetMaxX(lastButton.frame) + padding, 0, titleSize.width + 30, 30);
        }
        
        lastButton = button;
    }
}

@end
