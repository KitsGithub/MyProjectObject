//
//  SFSearchBarView.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/16.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFSearchBarView.h"


#define kSwitchItem_width      74

@implementation SFSearchBarView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self  = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void)setSeletedIndex:(NSInteger)seletedIndex
{
    if (seletedIndex > self.switchItems.count) {
        seletedIndex  = 0;
    }
    
    _seletedIndex  = seletedIndex;
    
    [_switchBtn setTitle:self.switchItems[self.seletedIndex] forState:(UIControlStateNormal)];
    
}

- (void)setSwitchItems:(NSArray *)switchItems
{
    _switchItems  = switchItems;
    if (self.seletedIndex >= switchItems.count) {
        self.seletedIndex  = 0;
    }
    [_switchBtn setTitle:self.switchItems[self.seletedIndex] forState:(UIControlStateNormal)];
}

- (void)setup
{
    _switchBtn  = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _switchBtn.contentMode  = UIViewContentModeCenter;
    [self addSubview:_switchBtn];
    [_switchBtn setTitle:self.switchItems[self.seletedIndex] forState:(UIControlStateNormal)];
    [_switchBtn setImage:[UIImage arrowDown] forState:(UIControlStateNormal)];
    [_switchBtn setImage:[UIImage arrowUp] forState:(UIControlStateSelected)];
    _switchBtn.titleLabel.font  = FONT_COMMON_14;
    [_switchBtn setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
    [_switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    _fromTextfiled  =  [[UITextField alloc] init];
    _fromTextfiled.delegate  = self;
    [self addSubview:_fromTextfiled];
    _fromTextfiled.font  = FONT_COMMON_14;
    _fromTextfiled.textColor  = COLOR_TEXT_COMMON;
    _fromTextfiled.placeholder  = @"出发地";
    _fromTextfiled.clearButtonMode  = UITextFieldViewModeAlways;
    
    _targetTextfiled  = [[UITextField alloc] init];
    _targetTextfiled.delegate  = self;
    [self addSubview:_targetTextfiled];
    _targetTextfiled.font   = FONT_COMMON_14;
    _targetTextfiled.textColor  = COLOR_TEXT_COMMON;
    _targetTextfiled.placeholder  = @"目的地";
    _targetTextfiled.clearButtonMode  = UITextFieldViewModeAlways;
    
    _sepatateLine  = [[UIView alloc] init];
    [self addSubview:_sepatateLine];
    _sepatateLine.backgroundColor  =  COLOR_LINE_BLACK;
    
    self.backgroundColor   = [UIColor colorWithHexString:@"#ebebed"];
    self.layer.cornerRadius   = 10.0f;
    self.clipsToBounds  = YES;
    

}

- (void)switchAction:(UIButton *)sender
{
     sender.selected  = !sender.isSelected;
     [self.delegate searchBarViewDidClickSwitchBtn:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat  sWidth = self.bounds.size.width;
    CGFloat  sHeight = self.bounds.size.height;
    
    _switchBtn.frame  = CGRectMake(0, 0, kSwitchItem_width, sHeight);
    
    _switchBtn.titleEdgeInsets  = UIEdgeInsetsMake(0, -(_switchBtn.titleLabel.frame.origin.x  + _switchBtn.imageView.bounds.size.width + 10), 0, 0);
    _switchBtn.imageEdgeInsets  = UIEdgeInsetsMake(0, kSwitchItem_width - _switchBtn.imageView.bounds.size.width - 10, 0, 0);
    
    CGFloat  fw  = (sWidth  - kSwitchItem_width - 1 - 10) / 2;
    
    _fromTextfiled .frame  = CGRectMake(CGRectGetMaxX(_switchBtn.frame), 0, fw, sHeight);
    
    _sepatateLine.frame  = CGRectMake(CGRectGetMaxX(_fromTextfiled.frame) ,(sHeight - 20)/2, 1, 20);
    
    _targetTextfiled.frame  = CGRectMake(CGRectGetMaxX(_sepatateLine.frame) + 10, 0, fw, sHeight);
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    SFSearchBarViewTextFiledType type = textField == self.fromTextfiled  ?  SFSearchBarViewTextFiledTypeFrom : SFSearchBarViewTextFiledTypeTarget;
    [self.delegate searchBarView:self fromTextFiledDidSelectedWithType:type Completion:^(NSString *result) {
        textField.text  = result;
    }];
    return NO;
    
}



@end
