//
//  UIButton+SFBudge.m
//  SFLIS
//
//  Created by kit on 2017/10/23.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "UIButton+SFBudge.h"
#import <objc/runtime.h>

static NSString *strKey = @"SFBudge";

@implementation UIButton (SFBudge)

- (void)setBudgeLabel:(UILabel *)budgeLabel {
    objc_setAssociatedObject(self, &strKey, budgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)budgeLabel {
    return objc_getAssociatedObject(self, &strKey);
}


- (void)addBudgeView:(BudgeDirection)direction {
    if (self.budgeLabel) {
        return;
    }
    UILabel *budgeView = [UILabel new];
    budgeView.backgroundColor = [UIColor colorWithHexString:@"#ff5656"];
    budgeView.textColor = [UIColor whiteColor];
    budgeView.font = [UIFont systemFontOfSize:9];
    budgeView.frame = CGRectMake(0, 0, 8, 8);
    budgeView.layer.cornerRadius = 4;
    budgeView.clipsToBounds = YES;
    self.budgeLabel = budgeView;
    [self addSubview:budgeView];
    switch (direction) {
        case BudgeDirectionLeft:
            budgeView.center = CGPointMake(0, 4);
            break;
        case BudgeDirectionRight:
             budgeView.center = CGPointMake(CGRectGetWidth(self.frame), 4);
            break;
        default:
            break;
    }
}

- (void)removeBudgeView {
    [self.budgeLabel removeFromSuperview];
}


@end
