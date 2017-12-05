//
//  SFPasswordInputViewCell.m
//  SFLIS
//
//  Created by kit on 2017/11/13.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFInputViewCell.h"

@implementation SFInputViewCell {
    UIView *_conterView;
    UITextField *_textField;
    
    UIButton *_button;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _conterView = [[UIView alloc] init];
    _conterView.backgroundColor = [UIColor colorWithHexString:@"f1f1f3"];
    _conterView.layer.cornerRadius = 10;
    _conterView.clipsToBounds = YES;
    [self addSubview:_conterView];
    
    _textField = [[UITextField alloc] init];
    [_conterView addSubview:_textField];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.textColor = COLOR_TEXT_COMMON;
    _textField.clearsOnBeginEditing = YES;
    _textField.delegate = self;
    
    _button = [UIButton new];
    [self addSubview:_button];
    _button.backgroundColor = THEMECOLOR;
    _button.layer.cornerRadius = 4;
    _button.clipsToBounds = YES;
    _button.hidden = YES;
    [_button setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
    _button.titleLabel.font = FONT_COMMON_16;
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    if (placeHolder.length) {
        _textField.placeholder = placeHolder;
    }
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    _textField.secureTextEntry = secureTextEntry;
}

- (void)setButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action; {
    _button.hidden = NO;
    
    [_button setTitle:title forState:(UIControlStateNormal)];
    [_button addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    _value = textField.text;
    if (self.endEdittingBlock) {
        self.endEdittingBlock();
    }
    return YES;
}

- (void)layoutSubviews {
    
    CGFloat padding = 10;
    if (_button.hidden) {
        _conterView.frame = CGRectMake(20, padding, SCREEN_WIDTH - 40, 48);
        _textField.frame = CGRectMake(padding, 0, _conterView.frame.size.width - 20, 48);
    } else {
        
        _button.frame = CGRectMake(SCREEN_WIDTH - 20 - 120, padding, 120, 48);
        
        _conterView.frame = CGRectMake(20, padding, SCREEN_WIDTH - 40 - CGRectGetWidth(_button.frame) - 10, 48);
        _textField.frame = CGRectMake(padding, 0, _conterView.frame.size.width - 20, 48);
    }
}


@end
