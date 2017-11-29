//
//  SFOtherPickerView.m
//  SFLIS
//
//  Created by kit on 2017/10/13.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFOtherPickerView.h"
#import "SFButtonView.h"

@interface SFOtherPickerView () <SFButtonViewDelegate>

@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, strong) NSArray<NSString *> *resourceArray;
/**
 当前选中index
 */
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation SFOtherPickerView {
    UIButton *_bjButton;
    UIView *_contentView;
    
    UIButton *_commitButton;
    UILabel *_titleLabe;
    UIButton *_closeButton;
    SFButtonView *_buttonView;
    
    BOOL hasSubView;
}


- (instancetype)initWithFrame:(CGRect)frame withResourceArray:(NSArray <NSString *>*)resourceArray {
    if (self = [super initWithFrame:frame]) {
        [self setResourceArray:resourceArray];
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setupView {
    _bjButton = [UIButton new];
    _bjButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [_bjButton addTarget:self action:@selector(bjButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bjButton];
    
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, self.contentHeight)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    
    _titleLabe = [UILabel new];
    _titleLabe.font = [UIFont boldSystemFontOfSize:20];
    _titleLabe.text = @"请设置标题";
    [_contentView addSubview:_titleLabe];
    
    
    _closeButton = [UIButton new];
    [_closeButton setImage:[UIImage imageNamed:@"Nav_Close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(bjButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_closeButton];
    
    
    _buttonView = [[SFButtonView alloc] init];
    _buttonView.delegate = self;
    _buttonView.buttonPadding = 14;
    [_buttonView setTitleViewWithArray:self.resourceArray];
    [_contentView addSubview:_buttonView];
    
    
    _commitButton = [UIButton new];
    [_commitButton setBackgroundColor:THEMECOLOR];
    [_commitButton setTitle:@"确定" forState:UIControlStateNormal];
    [_commitButton setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
    _commitButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [_commitButton addTarget:self action:@selector(commitButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_commitButton];
    
    hasSubView = YES;
}

- (void)SFButtonView:(SFButtonView *)buttonView didSelectedButtonIndex:(NSInteger)index {
    _selectedIndex = index;
}


#pragma mark - animation 
/**
 展示动画
 */
- (void)showAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT - self.contentHeight, SCREEN_WIDTH, self.contentHeight);
        _bjButton.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hiddenAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, self.contentHeight);
        _bjButton.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - UI Action
- (void)bjButtonDidClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(pickerViewDidSelectedCancel:)]) {
        [self.delegate pickerViewDidSelectedCancel:self];
    }
    [self hiddenAnimation];
}
- (void)commitButtonDidClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(pickerView:commitDidSelected:resourceArray:)]) {
        [self.delegate pickerView:self commitDidSelected:_selectedIndex resourceArray:[self.resourceArray copy]];
    }
    [self hiddenAnimation];
}

#pragma mark - property
- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabe.text = title;
}

- (void)setResourceArray:(NSArray<NSString *> *)resourceArray {
    _resourceArray = resourceArray;
    CGFloat buttonViewHieght = ceilf(_resourceArray.count / 4.0) * (36 + 14);
    self.contentHeight = buttonViewHieght + 50 + 62;
    
}

- (CGFloat)contentHeight {
    if (_contentHeight == 0) {
        return 300;
    }
    return _contentHeight;
}


- (void)layoutSubviews {
    if (hasSubView) {
        
        _bjButton.frame = self.bounds;
        
        CGSize titleSize = [_titleLabe.text sizeWithFont:[UIFont boldSystemFontOfSize:20] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        _titleLabe.frame = CGRectMake(20, 20, titleSize.width, titleSize.height);
        
        CGFloat closeButtonWH = 16;
        _closeButton.frame = CGRectMake(SCREEN_WIDTH - 20 - closeButtonWH, 20, closeButtonWH, closeButtonWH);
        
        
        CGFloat buttonViewHieght = ceilf(self.resourceArray.count / 4.0) * (36 + 14);
        
//        CGFloat contentHeight = buttonViewHieght + 50 + 62;
//        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT - contentHeight, SCREEN_WIDTH, contentHeight);
        
        _commitButton.frame = CGRectMake(0, CGRectGetHeight(_contentView.frame) - 50, SCREEN_WIDTH, 50);
        _buttonView.frame = CGRectMake(0, CGRectGetHeight(_contentView.frame) - CGRectGetHeight(_commitButton.frame) - buttonViewHieght, SCREEN_WIDTH, buttonViewHieght);
        
        
        hasSubView = NO;
    }
}

@end
