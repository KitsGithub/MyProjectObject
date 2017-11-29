//
//  SFChangePswFooterView.m
//  SFLIS
//
//  Created by kit on 2017/11/13.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFChangePswFooterView.h"

@implementation SFChangePswFooterView {
    UIButton *_button;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _button = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 40, 48)];
    _button.backgroundColor = [UIColor colorWithHexString:@"ffe794"];
    _button.layer.cornerRadius = 4;
    _button.clipsToBounds = YES;
    [_button setTitle:@"确认提交" forState:(UIControlStateNormal)];
    [_button setTitleColor:[UIColor colorWithHexString:@"988c66"] forState:(UIControlStateNormal)];
    [self addSubview:_button];
}

- (void)setButtonActionWithTarget:(id)target action:(SEL)action {
    [_button addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)setButtonTouchEnable:(BOOL)buttonTouchEnable {
    _buttonTouchEnable = buttonTouchEnable;
    
    _button.userInteractionEnabled = buttonTouchEnable;
    if (buttonTouchEnable) {
        [_button setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
        _button.backgroundColor = THEMECOLOR;
    } else {
        [_button setTitleColor:[UIColor colorWithHexString:@"988c66"] forState:(UIControlStateNormal)];
        _button.backgroundColor = [UIColor colorWithHexString:@"ffe794"];
    }
    
}


@end
