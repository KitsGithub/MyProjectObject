//
//  SFMoreSelectedButtonView.m
//  SFLIS
//
//  Created by kit on 2017/10/19.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFMoreSelectedButtonView.h"

@interface SFMoreSelectedButtonView ()

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) NSMutableSet *selectedIndexArray;

@end

@implementation SFMoreSelectedButtonView{
    BOOL hasSubView;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    
    for (NSInteger index = 0; index < self.titleArray.count; index++) {
        
        UIButton *button = [UIButton new];
        [button setTitle:self.titleArray[index] forState:UIControlStateNormal];
        [button setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"MoreButton_Selected"] forState:(UIControlStateSelected)];
        [button addTarget:self action:@selector(buttonDidSelected:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.tag = index;
        [self addSubview:button];
        
        [self.buttonArray addObject:button];
        
    }
    
    hasSubView = YES;
}

#pragma open Method
- (void)setTitleViewWithArray:(NSArray<NSString *> *)titleArray {
    self.titleArray = [titleArray mutableCopy];
    [self setupView];
}

- (NSArray <NSNumber *>*)getSelectedIndex {
    return [self.selectedIndexArray allObjects];
}


#pragma mark - UI Action
- (void)buttonDidSelected:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [self.selectedIndexArray addObject:@(sender.tag)];
    } else {
        [self.selectedIndexArray removeObject:@(sender.tag)];
    }
}


- (void)layoutSubviews {
    if (hasSubView) {
        
        UIView *lastView;
        CGFloat buttonW = 76;
        CGFloat buttonH = 36;
        
        for (NSInteger index = 0; index < self.buttonArray.count; index++) {
            UIButton *button = self.buttonArray[index];
            CGFloat x = (CGRectGetMaxX(lastView.frame) + buttonW + self.buttonPadding) > CGRectGetWidth(self.frame) ? self.buttonPadding : CGRectGetMaxX(lastView.frame) + self.buttonPadding;
            
            
            CGFloat y = (CGRectGetMaxX(lastView.frame) + buttonW + 14) > CGRectGetWidth(self.frame) ? CGRectGetMaxY(lastView.frame) + 14 : CGRectGetMinY(lastView.frame);
            
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

- (NSSet *)selectedIndexArray {
    if (!_selectedIndexArray) {
        _selectedIndexArray = [NSMutableSet set];
    }
    return _selectedIndexArray;
}

@end
