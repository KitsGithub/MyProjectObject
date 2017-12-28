//
//  SFLoaddingResult.h
//  SFLIS
//
//  Created by kit on 2017/12/20.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReloadDataBlock)(void);

@interface SFLoaddingView : UIView

+ (void)showResultWithResuleType:(SFLoaddingResultType)type toView:(UIView *)view reloadBlock:(ReloadDataBlock)reloadBlock;
+ (void)loaddingToView:(UIView *)view;
+ (void)dismiss;

@property (nonatomic, assign) SFLoaddingResultType resultType;

@property (nonatomic, copy) ReloadDataBlock reloadBlock;

@end
