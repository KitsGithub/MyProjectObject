//
//  SFPersonalNavBar.h
//  SFLIS
//
//  Created by kit on 2017/10/20.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    BarStyle_White,
    BarStyle_Black,
} BarStyle;

@class SFPersonalNavBar;
@protocol SFPersonalNavBarDelegate <NSObject>

@required
- (void)SFPersonalNavBar:(SFPersonalNavBar *)navBar didClickBlackButton:(UIButton *)backButton;

- (void)SFPersonalNavBar:(SFPersonalNavBar *)navBar didClickSettingButton:(UIButton *)settingButton;

- (void)SFPersonalNavBar:(SFPersonalNavBar *)navBar didClickMessageButton:(UIButton *)messageButton;


@end


@interface SFPersonalNavBar : UIView

- (void)setNavBarStyle:(BarStyle)barStyle;

- (void)setLineViewHidden:(BOOL)hidden;

@property (nonatomic, weak) id <SFPersonalNavBarDelegate>delegate;

@end
