//
//  SFAddCarCell.h
//  SFLIS
//
//  Created by kit on 2017/10/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SFAddCarView;
typedef enum : NSUInteger {
    ViewStyle_InputViewStyle,
    ViewStyle_SelectedStyle
} AddCarViewStyle;

typedef void(^ViewAction)(SFAddCarView *view);

@interface SFAddCarView : UIView

@property (nonatomic, assign) AddCarViewStyle viewStyle;
@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, copy) NSString *inputViewStr;
@property (nonatomic, assign) BOOL showLineView;
@property (nonatomic, copy) ViewAction action;

@property (nonatomic, copy, readonly) NSString *inputStr;


- (void)setTitleWithStr:(NSString *)title;

- (void)animation;

@end
