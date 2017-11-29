//
//  SFPersonalNavBar.m
//  SFLIS
//
//  Created by kit on 2017/10/20.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFPersonalNavBar.h"
#import "UIButton+SFBudge.h"

@implementation SFPersonalNavBar {
    UIButton *_backButton;
    UILabel *_titleLabel;
    UIButton *_setting;
    UIButton *_message;
    UIView *_lineView;
    
    BOOL hasSubView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    
    _backButton = [[UIButton alloc] init];
    _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_backButton];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"个人中心";
    _titleLabel.font = [UIFont systemFontOfSize:16];
    
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    _setting = [UIButton new];
    [_setting addTarget:self action:@selector(settingButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_setting];
    
    _message = [UIButton new];
    [_message addTarget:self action:@selector(messageButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_message];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = COLOR_LINE_DARK;
    _lineView.hidden = YES;
    [self addSubview:_lineView];
    
    hasSubView = YES;
}

- (void)setLineViewHidden:(BOOL)hidden {
    _lineView.hidden = hidden;
}

#pragma mark - UIAction
- (void)backButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(SFPersonalNavBar:didClickBlackButton:)]) {
        [self.delegate SFPersonalNavBar:self didClickBlackButton:sender];
    }
}

- (void)settingButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(SFPersonalNavBar:didClickSettingButton:)]) {
        [self.delegate SFPersonalNavBar:self didClickSettingButton:sender];
    }
}

- (void)messageButtonClick:(UIButton *)sender {
    [sender addBudgeView:(BudgeDirectionRight)];
    
    if ([self.delegate respondsToSelector:@selector(SFPersonalNavBar:didClickMessageButton:)]) {
        [self.delegate SFPersonalNavBar:self didClickMessageButton:sender];
    }
}


#pragma mark - open Method
- (void)setNavBarStyle:(BarStyle)barStyle {
    switch (barStyle) {
        case BarStyle_White:{
            [_backButton setImage:[UIImage imageNamed:@"Nav_Back_white"] forState:(UIControlStateNormal)];
            _titleLabel.textColor = [UIColor whiteColor];
            [_setting setImage:[UIImage imageNamed:@"Nav_Setting_White"] forState:(UIControlStateNormal)];
            [_message setImage:[UIImage imageNamed:@"Nav_Message_White"] forState:(UIControlStateNormal)];
        }
            break;
            
        case BarStyle_Black: {
            [_backButton setImage:[UIImage imageNamed:@"Nav_Back"] forState:(UIControlStateNormal)];
            _titleLabel.textColor = BLACKCOLOR;
            [_setting setImage:[UIImage imageNamed:@"Nav_Setting_Black"] forState:(UIControlStateNormal)];
            [_message setImage:[UIImage imageNamed:@"Nav_Message_Black"] forState:(UIControlStateNormal)];
        }
            break;
        default:
            break;
    }
}

#pragma mark - layout
- (void)layoutSubviews {
    if (hasSubView) {
        _titleLabel.frame = CGRectMake(0, STATUSBAR_HEIGHT, CGRectGetWidth(self.frame), 44);
        _backButton.frame = CGRectMake(12, STATUSBAR_HEIGHT, 44 , 44);
        
        _message.frame = CGRectMake(CGRectGetWidth(self.frame) - 23 - 20, STATUSBAR_HEIGHT + 12, 20, 20);
        _setting.frame = CGRectMake(CGRectGetMinX(_message.frame) - 20 - 20, CGRectGetMinY(_message.frame), 20, 20);
        
        
        _lineView.frame = CGRectMake(0, CGRectGetMaxY(self.frame) - 1, SCREEN_WIDTH, 1);
    }
}

@end
