//
//  SFMoreSelectedPickerView.h
//  SFLIS
//
//  Created by kit on 2017/10/19.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SFMoreSelectedPickerView;

@protocol SFMoreSelectedPickerViewDelegate <NSObject>

@required
- (void)SFMoreSelectedPickerView:(SFMoreSelectedPickerView *)pickerView commitDidSelected:(NSArray <NSNumber *>*)indexArray;


- (void)SFMoreSelectedPickerViewDidSelectedCancel:(SFMoreSelectedPickerView *)pickerView;

@end

@interface SFMoreSelectedPickerView : UIView

- (instancetype)initWithFrame:(CGRect)frame withResourceArray:(NSArray <NSString *>*)resourceArray;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, weak) id <SFMoreSelectedPickerViewDelegate> delegate;


/**
 展示动画
 */
- (void)showAnimation;

@end
