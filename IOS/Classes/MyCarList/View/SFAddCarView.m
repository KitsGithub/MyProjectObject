//
//  SFAddCarCell.m
//  SFLIS
//
//  Created by kit on 2017/10/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFAddCarView.h"

@interface SFAddCarView () <UITextFieldDelegate>

@end

@implementation SFAddCarView {
    UILabel *_titleLabel;
    UIImageView *_arrowImage;
    
    UITextField *_textField;
    
    UIView *_lineView;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//    if (self.cellStyle == CellStyle_InputViewStyle) {
//        return;
//    }
//
//    if (selected) {
//        [self animation];
//    }
//}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setViewStyle:(AddCarViewStyle)viewStyle {
    _viewStyle = viewStyle;
    switch (viewStyle) {
        case ViewStyle_InputViewStyle:
            [self showInputView];
            break;
        case ViewStyle_SelectedStyle:
            [self showSelecteView];
            break;
        default:
            break;
    }
}

- (void)animation {
    //创建一个CGAffineTransform
    CGAffineTransform  transform;
    
    transform = CGAffineTransformRotate(_arrowImage.transform,M_PI);
    [UIView beginAnimations:@"rotate" context:nil];
    [UIView setAnimationDuration:0.2];
    [_arrowImage setTransform:transform];
    
    //提交动画
    [UIView commitAnimations];
}

- (void)setTitleWithStr:(NSString *)title {
    _titleLabel.text = title;
    _inputStr = title;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField.text.length) {
        _inputStr = textField.text;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}

- (void)setupView {
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
    _titleLabel.font = FONT_COMMON_16;
    [self addSubview:_titleLabel];
    
    _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow_Down"]];
    [self addSubview:_arrowImage];
    
    _textField = [UITextField new];
    _textField.textColor = COLOR_TEXT_DARK;
    _textField.font = FONT_COMMON_16;
    _textField.delegate = self;
    [self addSubview:_textField];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = COLOR_LINE_DARK;
    [self addSubview:_lineView];
}

- (void)showInputView {
    _titleLabel.hidden = _arrowImage.hidden = YES;
    _textField.hidden = NO;
}

- (void)showSelecteView {
    _textField.hidden = YES;
    _titleLabel.hidden = _arrowImage.hidden = NO;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewAction)];
    [self addGestureRecognizer:tapGesture];
    
}

- (void)viewAction {
    __weak typeof(self) weakSelf = self;
    if (self.action) {
        self.action(weakSelf);
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    _titleLabel.text = placeHolder;
    _textField.placeholder = placeHolder;
}

- (void)setShowLineView:(BOOL)showLineView {
    _showLineView = showLineView;
    _lineView.hidden = !showLineView;
}

- (void)setInputViewStr:(NSString *)inputViewStr {
    _inputViewStr = inputViewStr;
    _textField.text = inputViewStr;
}

- (void)layoutSubviews {
    
    _titleLabel.frame = CGRectMake(20, 0, SCREEN_WIDTH - 40, CGRectGetHeight(self.frame));
    _textField.frame = _titleLabel.frame;
    
    _arrowImage.frame = CGRectMake(SCREEN_WIDTH - 20 - 16, (CGRectGetHeight(self.frame) - 8) * 0.5, 16, 8);
    
    _lineView.frame = CGRectMake(20, CGRectGetHeight(self.frame) - 1, SCREEN_WIDTH - 40, 1);
}

@end
