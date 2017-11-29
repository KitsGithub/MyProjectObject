//
//  BaseViewController.h
//  SFLIS
//
//  Created by kit on 2017/9/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController {
    UILabel *_titleLabel;
    UIButton *_baseCustomBackButton;
}

- (void)setCustomTitle:(NSString *)customTitle;

// 监听控制器pop事件。
// @return 是否允许pop
- (BOOL)willPopByNavigationController;

@end
