//
//  SFSegmentView.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFSegmentView.h"

@interface SFSegmentView()

@property (nonatomic,strong)UIView *line;



@end

@implementation SFSegmentView

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray <NSString *>*)items font:(UIFont *)font
{
    if (self  = [super initWithFrame:frame]) {
        _items  = items;
        _font   = font;
        [self _setup];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self  = [super initWithCoder:aDecoder]) {
        [self _setup];
    }
    return self;
}

- (void)_setup
{
    for (int i = 0;i < self.items.count;i++) {
        [self addBtnWithIdx:i text:self.items[i]];
    }
    _line  = [[UIView alloc] init];
    _line.backgroundColor  = THEMECOLOR;
    [self addSubview:_line];
    self.backgroundColor  = [UIColor whiteColor];
}


- (void)addBtnWithIdx:(NSInteger)idx text:(NSString *)text
{
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:text forState:(UIControlStateNormal)];
    [btn setTitleColor:COLOR_TEXT_DARK forState:(UIControlStateNormal)];
    [btn setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateSelected)];
    btn.titleLabel.font  = self.font;
    btn.tag  = idx;
    [btn addTarget:self action:@selector(changeItem:) forControlEvents:(UIControlEventTouchUpInside)];
    btn.selected  = idx == 0;
    btn.frame  = CGRectMake([self itemWidth] * btn.tag, 0, [self itemWidth], [self itemHeight]);
    [self addSubview:btn];
}


- (void)setItems:(NSArray *)items
{
    _items  = items;
    NSInteger index = 0;
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.frame  = CGRectMake([self itemWidth] * btn.tag, 0, [self itemWidth], [self itemHeight]);
            if (btn.tag  == 0) {
                [self changeLineWithBtn:btn isAnimotion:NO];
            }
            if (index < items.count) {
                btn.hidden  = NO;
                [btn setTitle:items[index] forState:(UIControlStateNormal)];
            }else{
                btn.hidden = YES;
            }
            index++;
        }
    }
    
    while (index < items.count) {
        [self addBtnWithIdx:index text:items[index]];
        index++;
    }
    [self layoutIfNeeded];
}

- (void)changeItem:(UIButton *)sender
{
    _currentIndex  = sender.tag;
    if (self.selectedBlock) {
        self.selectedBlock(sender.tag);
    }
    [self updateAnimotion];
}


- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex  = currentIndex;
    if (self.selectedBlock) {
        self.selectedBlock(currentIndex);
    }
    [self updateAnimotion];
}

- (void)updateAnimotion
{
    UIButton *selBtn =  [self changeBtnStates];
    if (selBtn) {
        [self changeLineWithBtn:selBtn isAnimotion:YES];
    }
}

- (CGFloat)itemWidth
{
    CGFloat w = self.bounds.size.width  / self.items.count;
    return w;
}

- (CGFloat)itemHeight
{
    return self.bounds.size.height;
}

- (UIButton *)changeBtnStates
{
    UIButton *selBtn = nil;
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn.tag == self.currentIndex) {
                btn.selected  = YES;
                selBtn  = btn;
            }else{
                btn.selected  = NO;
            }
        }
    }
    return selBtn;
}

- (void)changeLineWithBtn:(UIButton *)selectedBtn isAnimotion:(BOOL)isAnimotion 
{
    double duration  = isAnimotion ? 0.5 : 0;
    [UIView animateWithDuration:duration animations:^{
        CGFloat  lw   = self.lineWidth ? self.lineWidth : 28;
        CGFloat  lx   = selectedBtn.center.x - lw/2;
        self.line.frame  = CGRectMake(lx, self.bounds.size.height - 3, lw, 3);
    }];
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.frame  = CGRectMake([self itemWidth] * btn.tag, 0, [self itemWidth], [self itemHeight]);
            if (btn.tag  == self.currentIndex) {
                [self changeLineWithBtn:btn isAnimotion:NO];
            }
        }
    }
    
}



@end

