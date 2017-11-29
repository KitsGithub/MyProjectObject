//
//  SFSegmentControl.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/9.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFSegmentControl.h"

@implementation SFSegmentControl


- (instancetype)initWithFrame:(CGRect)frame items:(NSArray <NSString *>*)items
{
    if (self = [super initWithFrame:frame]) {
        _items  = items;
        _bgColor = [UIColor colorWithHexString:@"#332D30"];
        _itemColor  = _bgColor;
        _selectedColor  = THEMECOLOR;
        _itemWidth   = 70;
        _titleColor  = [UIColor whiteColor];
        _selectedTitleColor = [UIColor colorWithHexString:@"#42432A"];
        _font  = [UIFont systemFontOfSize:16];
        [self setup];
    }
    return self;
}


- (void)setup
{
    self.backgroundColor  = _bgColor;
    self.layer.cornerRadius  = self.bounds.size.height  * 0.5;
    self.clipsToBounds  = YES;
    for (int i = 0;i < _items.count;i++) {
        [self addItemWithStr:_items[i] index:i];
    }
}


- (void)addItemWithStr:(NSString *)str index:(NSInteger)index
{
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.tag   = index;
    [btn setTitle:str forState:(UIControlStateNormal)];
    btn.titleLabel.font  = self.font;
    [btn setTitleColor:_titleColor forState:(UIControlStateNormal)];
    [btn setTitleColor:_selectedTitleColor forState:(UIControlStateSelected)];
    [btn addTarget:self action:@selector(btnSelected:) forControlEvents:(UIControlEventTouchUpInside)];
    btn.layer.cornerRadius  = self.layer.cornerRadius;
    btn.clipsToBounds  = YES;
    [self addSubview:btn];
    [self updateBtnState:btn];
}


- (void)updateBtnState:(UIButton *)btn
{
    if (btn.tag  == self.currentIndex) {
        btn.selected  = YES;
        btn.backgroundColor  = _selectedColor;
    }else{
        btn.selected  = NO;
        btn.backgroundColor  = _itemColor;
    }
}


- (void)btnSelected:(UIButton *)sender
{
    _currentIndex  = sender.tag;
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [self updateBtnState:btn];
        }
    }
    if (self.selectedBlock) {
        self.selectedBlock(sender.tag);
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
           [self updateBtnState:btn];
        }
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.cornerRadius  = self.bounds.size.height  * 0.5;
    
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.layer.cornerRadius  = self.layer.cornerRadius;
            [self updateBtnState:btn];
            btn.frame  = CGRectMake(btn.tag * _itemWidth, 0, _itemWidth, self.bounds.size.height);
        }
    }
    
}




@end
