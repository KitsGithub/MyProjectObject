//
//  SFChangePswFooterView.h
//  SFLIS
//
//  Created by kit on 2017/11/13.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionBlock)();

@interface SFChangePswFooterView : UIView

@property (nonatomic, assign) BOOL buttonTouchEnable;

- (void)setButtonActionWithTarget:(id)target action:(SEL)action;

@end
