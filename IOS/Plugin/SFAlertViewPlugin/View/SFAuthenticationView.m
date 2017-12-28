//
//  SFAuthenticationView.m
//  SFLIS
//
//  Created by kit on 2017/10/26.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFAuthenticationView.h"

@interface SFAuthenticationView ()

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *messageStr;
@property (nonatomic, copy) NSString *cancelStr;
@property (nonatomic, copy) NSString *comfirmStr;

@end

@implementation SFAuthenticationView {
    
    UIView *_contentView;
    
    UIButton *_closeButton;
    UIImageView *_confirmImageV;
    UILabel *_title;
    UILabel *_message;
    UIButton *_comfirmButton;
    UIButton *_cancelButton;
    
    BOOL hasSubView;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel confirm:(NSString *)comfirm delegate:(id<SFAlertViewProtocol>)delegate {
    
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.titleStr = title;
        self.messageStr = message;
        self.comfirmStr = comfirm;
        self.cancelStr = cancel;
        self.delegate = delegate;
        [self setupView];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    
    
    return self;
}


- (void)setupView {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 12;
    _contentView.alpha = 0.0f;
    [self addSubview:_contentView];
    
    
    _closeButton = [UIButton new];
    [_closeButton setImage:[UIImage imageNamed:@"Nav_Close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(cancelButtonDidSelected) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_closeButton];
    
    
    _confirmImageV = [[UIImageView alloc] init];
    [_confirmImageV setImage:[UIImage imageNamed:@"Authentication_Confirm"]];
    [_contentView addSubview:_confirmImageV];
    
    
    _title = [UILabel new];
    _title.textColor = BLACKCOLOR;
    _title.font = [UIFont boldSystemFontOfSize:20];
    _title.text = self.titleStr;
    _title.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_title];
    
    
    _message = [UILabel new];
    _message.numberOfLines = 0;
    _message.textColor = BLACKCOLOR;
    _message.textAlignment = NSTextAlignmentLeft;
    _message.font = FONT_COMMON_16;
    _message.text = self.messageStr;
    _message.lineBreakMode = NSLineBreakByCharWrapping;
    [_contentView addSubview:_message];
    
    _comfirmButton = [UIButton new];
    [_comfirmButton setBackgroundColor:THEMECOLOR];
    [_comfirmButton setTitle:@"去认证" forState:(UIControlStateNormal)];
    [_comfirmButton setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    _comfirmButton.titleLabel.font = FONT_COMMON_16;
    _comfirmButton.layer.cornerRadius = 2;
    [_contentView addSubview:_comfirmButton];
    
    
    _cancelButton = [[UIButton alloc] init];
    [_cancelButton setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    [_cancelButton setTitle:@"下次再认证" forState:(UIControlStateNormal)];
    [_cancelButton setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    _cancelButton.titleLabel.font = FONT_COMMON_16;
    _cancelButton.layer.cornerRadius = 2;
    [_contentView addSubview:_cancelButton];
    
    
    [_comfirmButton addTarget:self action:@selector(comfirmButtonDidClick) forControlEvents:(UIControlEventTouchUpInside)];
    [_cancelButton addTarget:self action:@selector(cancelButtonDidSelected) forControlEvents:(UIControlEventTouchUpInside)];
    
    hasSubView = YES;
}

#pragma mark - UIAction
- (void)comfirmButtonDidClick {
    if ([self.delegate respondsToSelector:@selector(SFAlertView:didSelectedIndex:)]) {
        [self.delegate SFAlertView:self didSelectedIndex:0];
    }
    [self hiddenAnimation];
}

- (void)cancelButtonDidSelected {
    if ([self.delegate respondsToSelector:@selector(SFAlertViewDidSelecetedCancel:)]) {
        [self.delegate SFAlertViewDidSelecetedCancel:self];
    }
    [self hiddenAnimation];
}


#pragma mark - animation
- (void)showAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        _contentView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hiddenAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

#pragma mark - layout
- (void)layoutSubviews {
    if (hasSubView) {
        
        CGFloat totalScale = 1;
        CGRect frame = [UIScreen mainScreen].bounds;
        if (frame.size.width == 320) {
            totalScale = 0.5;
        }
        
        CGFloat scale = 347.0 / 322.0;
        CGFloat contentWidth = SCREEN_WIDTH - 28;
        CGFloat contentHeight = contentWidth / scale;
        _contentView.frame = CGRectMake(14, (SCREEN_HEIGHT - contentHeight) * 0.5, contentWidth, contentHeight);
        
        
        CGFloat closeButtonWH = 16 + 40;
        _closeButton.frame = CGRectMake(contentWidth - closeButtonWH, 0, closeButtonWH, closeButtonWH);
        
        _confirmImageV.frame = CGRectMake((contentWidth - 80) * 0.5, 40 * totalScale, 80, 80);
        _title.frame = CGRectMake(0, CGRectGetMaxY(_confirmImageV.frame) + 20 , contentWidth, 20);
        
        
        
        CGFloat messageX = 46 * totalScale;
        CGSize messageSize = [_message.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(messageX * 2, 40)];
        _message.frame = CGRectMake(messageX, CGRectGetMaxY(_title.frame) + 20 * totalScale, contentWidth - messageX * 2, messageSize.height);
        
        
        
        CGFloat buttonWidth = 120;
        _comfirmButton.frame = CGRectMake((contentWidth - buttonWidth * 2 - 20) * 0.5 , CGRectGetMaxY(_message.frame) + 20 , buttonWidth, 40);
        
        _cancelButton.frame = CGRectMake(CGRectGetMaxX(_comfirmButton.frame) + 20, CGRectGetMinY(_comfirmButton.frame), buttonWidth, 40);
        
        hasSubView = NO;
    }
    
}

@end
