//
//  SFHomeNavBar.h
//  SFLIS
//
//  Created by kit on 2017/10/10.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFHomeNavBar;

@protocol SFHomeNavBarDelegate <NSObject>

@required
- (void)SFHomeNavBar:(SFHomeNavBar *)navBar didClickUserIcon:(UIButton *)userIcon;

- (void)SFHomeNavBar:(SFHomeNavBar *)navBar didChangeReourceType:(NSUInteger)resouceType;

- (void)SFHomeNavBar:(SFHomeNavBar *)navBar didClickSearchIcon:(UIButton *)searchIcon;


@end

@interface SFHomeNavBar : UIView

@property (nonatomic, copy) NSString *searchImage;
@property (nonatomic, assign) NSInteger currentIndex;

- (void)setLineViewHidden:(BOOL)hidden;

@property (nonatomic, weak) id <SFHomeNavBarDelegate> delegate;

@end
