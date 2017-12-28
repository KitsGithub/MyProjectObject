//
//  SFSegmentScrollView.m
//  SFLIS
//
//  Created by kit on 2017/12/18.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFSegmentScrollView.h"

@interface SFSegmentScrollView ()

@property (nonatomic, strong) NSMutableArray <UIButton *> *buttonArray;

@end

@implementation SFSegmentScrollView

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray<NSString *> *)items font:(UIFont *)font {
    if (self = [super initWithFrame:frame]) {
        self.font = font;
        self.items = items;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
}


- (NSMutableArray<UIButton *> *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}
@end
