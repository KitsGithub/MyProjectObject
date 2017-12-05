//
//  SFMoreDatePickerView.m
//  SFLIS
//
//  Created by kit on 2017/12/5.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFMoreDatePickerView.h"
#import "RMCalendarLogic.h"

@interface SFMoreDatePickerView ()

@property (nonatomic, strong) RMCalendarLogic *calendarLogic;

@property (nonatomic, strong) NSMutableArray <RMCalendarModel *>*dataSorce;

@end

@implementation SFMoreDatePickerView {
    UIButton *_bgButotn;
    
    UIDatePicker *_picker;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

#pragma mark - UIAction
- (void)bgbuttonClick {
    [self removeFromSuperview];
}


#pragma mark - 布局
- (void)setupView {
    
    _bgButotn = [UIButton new];
    _bgButotn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [_bgButotn addTarget:self action:@selector(bgbuttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_bgButotn];
    
    _picker = [[UIDatePicker alloc] init];
    _picker.datePickerMode = UIDatePickerModeDateAndTime;
    _picker.backgroundColor = [UIColor whiteColor];
    _picker.minuteInterval = 30;
    [self addSubview:_picker];
    
//    NSMutableArray *dataSource = [self getMonthArrayOfDays:365 showType:CalendarShowTypeMultiple isEnable:NO modelArr:nil];
//    NSLog(@"%@",dataSource);
}

/**
 *  获取Days天数内的数组
 *
 *  @param days 天数
 *  @param type 显示类型
 *  @param arr  模型数组
 *  @return 数组
 */
- (NSMutableArray *)getMonthArrayOfDays:(int)days showType:(CalendarShowType)type isEnable:(BOOL)isEnable modelArr:(NSArray *)arr
{
    NSDate *date = [NSDate date];
    
    //返回数据模型数组
    return [self.calendarLogic reloadCalendarView:date selectDate:date needDays:days showType:type isEnable:isEnable priceModelArr:arr isChineseCalendar:YES];
}

- (void)layoutSubviews {
    _bgButotn.frame = self.bounds;
    
    _picker.frame = CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216);
}

#pragma mark - lazyLoad
- (RMCalendarLogic *)calendarLogic {
    if (!_calendarLogic) {
        _calendarLogic = [[RMCalendarLogic alloc] init];
    }
    return _calendarLogic;
}

- (NSMutableArray<RMCalendarModel *> *)dataSorce {
    if (!_dataSorce) {
        _dataSorce = [NSMutableArray array];
    }
    return _dataSorce;
}
@end
