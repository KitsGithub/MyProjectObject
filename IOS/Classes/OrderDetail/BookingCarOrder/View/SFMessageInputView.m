//
//  SFInputView.m
//  SFLIS
//
//  Created by kit on 2017/12/1.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFMessageInputView.h"

@implementation SFMessageInputView {
    UITextField *_textField;
    UILabel *_tipsLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor colorWithHexString:@"#f1f1f3"];
    self.layer.cornerRadius = 10;
    
    _textField = [UITextField new];
    _textField.font = FONT_COMMON_16;
    _textField.textColor = COLOR_TEXT_COMMON;
    _textField.delegate = self;
    [self addSubview:_textField];
    
    _tipsLabel = [UILabel new];
    _tipsLabel.font = FONT_COMMON_16;
    _tipsLabel.textColor = COLOR_TEXT_COMMON;
    [self addSubview:_tipsLabel];
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _textField.placeholder = placeHolder;
}

- (void)setKeyBoardType:(MessageKeyBoardType)keyBoardType {
    _keyBoardType = keyBoardType;
    switch (keyBoardType) {
        case MessageKeyBoardType_NumberOnly:
            _textField.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
            break;
        case MessageKeyBoardType_FloatOnly:
            _textField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        default:
            break;
    }
}

- (void)setTitleStr:(NSString *)title {
    _textField.text = title;
    _inputStr = title;
}


- (void)setTipsStr:(NSString *)tipsStr {
    _tipsLabel.text = tipsStr;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    _inputStr = textField.text;
    if ([self.delegate respondsToSelector:@selector(sfMessageInputViewDidFinishedEditting:)]) {
        [self.delegate sfMessageInputViewDidFinishedEditting:textField.text];
    }
    return YES;
}

- (void)layoutSubviews {
    CGSize tipSize = [_tipsLabel.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _tipsLabel.frame = CGRectMake(CGRectGetWidth(self.frame) - 21 - tipSize.width, (CGRectGetHeight(self.frame) - tipSize.height) * 0.5, tipSize.width, tipSize.height);
    
    _textField.frame = CGRectMake(10, 0, CGRectGetWidth(self.frame) - CGRectGetWidth(_tipsLabel.frame) - 41, CGRectGetHeight(self.frame));
}

@end
