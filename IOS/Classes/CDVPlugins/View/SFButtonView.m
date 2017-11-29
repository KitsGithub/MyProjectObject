//
//  SFButtonView.m
//  SFLIS
//
//  Created by kit on 2017/10/13.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFButtonView.h"

@interface SFButtonView ()

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@end

@implementation SFButtonView {
    BOOL hasSubView;
}



- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    
    for (NSInteger index = 0; index < self.titleArray.count; index++) {
        
        UIButton *button = [UIButton new];
        [button setTitle:self.titleArray[index] forState:UIControlStateNormal];
        [button setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
//        [button setBackgroundColor:THEMECOLOR];
        [button addTarget:self action:@selector(buttonDidSelected:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.tag = index;
        [self addSubview:button];
        
        [self.buttonArray addObject:button];
        
    }
    
    hasSubView = YES;
}

- (void)setTitleViewWithArray:(NSArray<NSString *> *)titleArray {
    self.titleArray = [titleArray mutableCopy];
    [self setupView];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex  = selectedIndex;
    for (UIButton *button in self.buttonArray) {
        if (button.tag != selectedIndex) {
            [button setBackgroundColor:[UIColor whiteColor]];
        }else{
            [button setBackgroundColor:THEMECOLOR];
        }
    }
}

#pragma mark - UI Action
- (void)buttonDidSelected:(UIButton *)sender {
    [sender setBackgroundColor:THEMECOLOR];
    for (UIButton *button in self.buttonArray) {
        if (button != sender) {
            [button setBackgroundColor:[UIColor whiteColor]];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(SFButtonView:didSelectedButtonIndex:)]) {
        [self.delegate SFButtonView:self didSelectedButtonIndex:sender.tag];
    }
    
}


- (void)layoutSubviews {
    if (hasSubView) {
        
        UIView *lastView;
        CGFloat buttonW = 76;
        CGFloat buttonH = 36;
//        for (UIButton *button in self.buttonArray) {
//            CGFloat x = (CGRectGetMaxX(lastView.frame) + buttonW + self.buttonPadding) > CGRectGetWidth(self.frame) ? 0 : CGRectGetMaxX(lastView.frame);
//            CGFloat y = (CGRectGetMaxX(lastView.frame) + buttonW) > CGRectGetWidth(self.frame) ? CGRectGetMaxY(lastView.frame) : CGRectGetMinY(lastView.frame);
//            
//            button.frame = CGRectMake(x, y, buttonW, buttonH);
//            lastView = button;
//        }
        
        for (NSInteger index = 0; index < self.buttonArray.count; index++) {
            UIButton *button = self.buttonArray[index];
            CGFloat x = (CGRectGetMaxX(lastView.frame) + buttonW + self.buttonPadding) > CGRectGetWidth(self.frame) ? self.buttonPadding : CGRectGetMaxX(lastView.frame) + self.buttonPadding;
            
            
            CGFloat y = (CGRectGetMaxX(lastView.frame) + buttonW + self.buttonPadding) > CGRectGetWidth(self.frame) ? CGRectGetMaxY(lastView.frame) + self.buttonPadding : CGRectGetMinY(lastView.frame);
            
            button.frame = CGRectMake(x, y, buttonW, buttonH);
            lastView = button;
            button.tag   = index;
        }
        
    }
}


#pragma mark - lazyLoad
- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

@end
