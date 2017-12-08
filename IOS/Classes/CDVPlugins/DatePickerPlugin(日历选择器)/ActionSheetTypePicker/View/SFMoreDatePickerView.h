//
//  SFMoreDatePickerView.h
//  SFLIS
//
//  Created by kit on 2017/12/5.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DateType_SingleTime = 0, //选择单个 日期 + 时间
    DateType_MoreTime        //选择时间区间
} DateType;

@class SFMoreDatePickerView;
@protocol SFMoreDatePickerDelegate <NSObject>

@optional
- (void)SFMoreDatePickerView:(SFMoreDatePickerView *)picker didSelectedDateStr:(NSString *)dateStr date:(NSDate *)date;
- (void)SFMoreDatePickerViewDidSelectedCancel;
@end

@interface SFMoreDatePickerView : UIView

- (instancetype)initWithFrame:(CGRect)frame dateType:(DateType)dateType;

@property (nonatomic, weak) id <SFMoreDatePickerDelegate> delegate;

@property (nonatomic, assign) DateType dateType;

/**
 起始时间
 */
@property (nonatomic, weak) NSDate *startDate;

- (void)show;
- (void)dismiss;

@end
