//
//  SFRatingView.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/23.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFRatingView.h"

@implementation SFRatingView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor  = [UIColor whiteColor];
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [self btnWithIndex:i];
        [self addSubview:btn];
    }
    
}

- (UIButton *)btnWithIndex:(NSInteger)index
{
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setImage:[UIImage imageNamed:@"start_dark"] forState:(UIControlStateNormal)];
    [btn setImage:[UIImage imageNamed:@"start"] forState:(UIControlStateSelected)];
    btn.tag  = index;
    CGFloat itemWidth = self.bounds.size.width  / 5;
    btn.frame  = CGRectMake(itemWidth * index, 0, itemWidth, self.bounds.size.height);
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    return btn;
}




- (IBAction)btnClick:(UIButton *)sender {
    [self setupWithValue:sender.tag];
}

- (void)setupWithValue:(NSInteger)value
{
    self.startValue  = value + 1;
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn.tag  > value) {
                btn.selected  = NO;
            }else{
                btn.selected  = YES;
            }
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            CGFloat itemWidth = self.bounds.size.width  / 5;
            btn.frame  = CGRectMake(itemWidth * btn.tag, 0, itemWidth, self.bounds.size.height);
        }
    }
}


@end
