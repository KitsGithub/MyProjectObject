//
//  RMCalendarMonthHeaderView.m
//  RMCalendar
//
//  Created by 迟浩东 on 15/7/15.
//  Copyright © 2015年 迟浩东(http://www.ruanman.net). All rights reserved.
//

#import "RMCalendarMonthHeaderView.h"

#define CATDayLabelWidth  ([UIScreen mainScreen].bounds.size.width/7)
#define CATDayLabelHeight 20.0f

#define COLOR_THEME1 ([UIColor redColor])
#define COLOR_THEME ([UIColor colorWithRed:26/256.0  green:168/256.0 blue:186/256.0 alpha:1])

@interface RMCalendarMonthHeaderView()

@property (weak, nonatomic) UILabel *day1OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day2OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day3OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day4OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day5OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day6OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day7OfTheWeekLabel;

@end

@implementation RMCalendarMonthHeaderView {
    UIView *_lineView;
    UIView *_topView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initWithHeader];
    }
    return self;
}

- (void)initWithHeader
{
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    CGFloat headerWidth = [UIScreen mainScreen].bounds.size.width;
    //月份
    UILabel *masterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.0f, headerWidth, 30.f)];
    [masterLabel setTextAlignment:NSTextAlignmentCenter];
    [masterLabel setFont:[UIFont systemFontOfSize:14]];
    masterLabel.backgroundColor = [UIColor colorWithHexString:@"F2F2F2"];
    self.masterLabel = masterLabel;
    self.masterLabel.textColor = BLACKCOLOR;
    [self addSubview:self.masterLabel];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    _topView.backgroundColor = COLOR_LINE_DARK;
    [self addSubview:_topView];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 29, SCREEN_WIDTH, 1)];
    _lineView.backgroundColor = COLOR_LINE_DARK;
    [self addSubview:_lineView];
    
//    CGFloat yOffset = .0f;
//    NSArray *textArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
//    for (int i = 0; i < textArray.count; i++) {
//        [self initHeaderWeekText:textArray[i] titleColor:BLACKCOLOR x:CATDayLabelWidth * i y:yOffset];
//    }
    
}

// 初始化数据
- (void)initHeaderWeekText:(NSString *)text titleColor:(UIColor *)color x:(CGFloat)x y:(CGFloat)y {
    UILabel *titleText = [[UILabel alloc]initWithFrame:CGRectMake(x, y, CATDayLabelWidth, CATDayLabelHeight)];
    [titleText setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.textColor = color;
    titleText.text = text;
    [self addSubview:titleText];
}

@end

