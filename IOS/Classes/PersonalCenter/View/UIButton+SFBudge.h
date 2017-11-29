//
//  UIButton+SFBudge.h
//  SFLIS
//
//  Created by kit on 2017/10/23.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    BudgeDirectionLeft,
    BudgeDirectionRight,
} BudgeDirection;

@interface UIButton (SFBudge)

@property (nonatomic, weak) UILabel *budgeLabel;

- (void)addBudgeView:(BudgeDirection)direction;
- (void)removeBudgeView;

@end
