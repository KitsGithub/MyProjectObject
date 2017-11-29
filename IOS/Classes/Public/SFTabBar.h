//
//  SFTabBar.h
//  SFLIS
//
//  Created by kit on 2017/10/9.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFTabBar;

@protocol SFTabBarDelegate <NSObject>

- (void)tabBar:(SFTabBar *)tabBar clickCenterButton:(UIButton *)sender;

@end

@interface SFTabBar : UITabBar

@property (nonatomic, weak) id<SFTabBarDelegate> tabDelegate;
@property (nonatomic, strong) NSString *centerBtnTitle;
@property (nonatomic, strong) NSString *centerBtnIcon;


@end
