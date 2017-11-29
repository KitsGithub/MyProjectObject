//
//  SFTipsView.h
//  SFLIS
//
//  Created by kit on 2017/10/11.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFTipsView : UIView


/**
 单例对象
 */
+ (instancetype)shareView;


/**
 展示动画
 */
- (void)showSuccessWithTitle:(NSString *)title;
- (void)showFailureWithTitle:(NSString *)title;

@end
