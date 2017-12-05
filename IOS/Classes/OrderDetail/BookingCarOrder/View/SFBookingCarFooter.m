//
//  SFBookingCarFooter.m
//  SFLIS
//
//  Created by kit on 2017/12/1.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFBookingCarFooter.h"

@implementation SFBookingCarFooter {
    UIView *_contentView;
    
    UIButton *_addButton;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    
    _contentView = [UIView new];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    _addButton = [UIButton new];
    _addButton.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    [_addButton setTitle:@"添加车辆需求" forState:(UIControlStateNormal)];
    [_addButton setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
    [_addButton setImage:[UIImage imageNamed:@"SFAdd_Image"] forState:(UIControlStateNormal)];
    [_addButton addTarget:self action:@selector(addButtonDidClick) forControlEvents:(UIControlEventTouchUpInside)];
    _addButton.titleLabel.font = [UIFont systemFontOfSize:18];
    _addButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5.5, 0, 5.5);
    
    [self addSubview:_addButton];
}

- (void)addButtonDidClick {
    if (self.addAction) {
        self.addAction();
    }
}

- (void)layoutSubviews {
    _contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.frame) - 10);
    _addButton.frame = CGRectMake(20, (CGRectGetHeight(_contentView.frame) - 50) * 0.5, SCREEN_WIDTH - 40, 50);
}

@end
