//
//  SFMoreDatePickerView.m
//  SFLIS
//
//  Created by kit on 2017/12/5.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFMoreDatePickerView.h"
@interface SFMoreDatePickerView () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *selectedTimeZone;

@end

@implementation SFMoreDatePickerView {
    UIButton *_bgButotn;
    
    UIView *_contentView;
    UIDatePicker *_picker;
    UIPickerView *_morePiker;
    UIView *_coverView;
}

- (instancetype)initWithFrame:(CGRect)frame dateType:(DateType)dateType{
    if (self = [super initWithFrame:frame]) {
        self.dateType = dateType;
        if (dateType == DateType_SingleTime) {
            [self setupView];
        } else {
            [self setupMoreView];
        }
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    return self;
}

#pragma mark - UIAction
- (void)bgbuttonClick {
    if ([self.delegate respondsToSelector:@selector(SFMoreDatePickerViewDidSelectedCancel)]) {
        [self.delegate SFMoreDatePickerViewDidSelectedCancel];
    }
    [self dismiss];
}

- (void)comfirmDidClick {
    
    if ([self.delegate respondsToSelector:@selector(SFMoreDatePickerView:didSelectedDateStr:date:)]) {
        if (self.dateType == DateType_SingleTime) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
            NSString *moreTime = [formatter stringFromDate:_picker.date];
            
            [self.delegate SFMoreDatePickerView:self didSelectedDateStr:moreTime date:_picker.date];
        } else {
            if (!self.selectedTimeZone.length) {
                self.selectedTimeZone = self.dataArray[0];
            }
            [self.delegate SFMoreDatePickerView:self didSelectedDateStr:self.selectedTimeZone date:nil];
        }
        
    }
    [self dismiss];
}

#pragma mark - 布局
- (void)setupView {
    
    _bgButotn = [UIButton new];
    _bgButotn.alpha = 0;
    _bgButotn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [_bgButotn addTarget:self action:@selector(bgbuttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_bgButotn];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 282)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH - 40, 20)];
    title.textColor = COLOR_TEXT_COMMON;
    title.text = @"选择时间";
    title.font = [UIFont boldSystemFontOfSize:20];
    [_contentView addSubview:title];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40 - 10, 10, 40, 40)];
    [closeButton setImage:[UIImage imageNamed:@"Nav_Close"] forState:(UIControlStateNormal)];
    [closeButton addTarget:self action:@selector(bgbuttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [_contentView addSubview:closeButton];
    
    
    _picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_contentView.frame) - 180 - 50, SCREEN_WIDTH, 180)];
    _picker.datePickerMode = UIDatePickerModeDateAndTime;
    _picker.backgroundColor = [UIColor clearColor];
    _picker.minuteInterval = 5;
    _picker.minimumDate = [NSDate date];
    [_contentView addSubview:_picker];
    
    
    UIButton *comfirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_contentView.frame) - 50, SCREEN_WIDTH, 50)];
    [comfirmBtn setBackgroundColor:THEMECOLOR];
    [comfirmBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [comfirmBtn setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
    [comfirmBtn addTarget:self action:@selector(comfirmDidClick) forControlEvents:(UIControlEventTouchUpInside)];
    [_contentView addSubview:comfirmBtn];
}

- (void)setupMoreView {
    _bgButotn = [UIButton new];
    _bgButotn.alpha = 0;
    _bgButotn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [_bgButotn addTarget:self action:@selector(bgbuttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_bgButotn];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 282)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH - 40, 20)];
    title.textColor = COLOR_TEXT_COMMON;
    title.text = @"选择时间";
    title.font = [UIFont boldSystemFontOfSize:20];
    [_contentView addSubview:title];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40 - 10, 10, 40, 40)];
    [closeButton setImage:[UIImage imageNamed:@"Nav_Close"] forState:(UIControlStateNormal)];
    [closeButton addTarget:self action:@selector(bgbuttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [_contentView addSubview:closeButton];
    
    _coverView = [[UIView alloc] init];
    _coverView.backgroundColor = THEMECOLOR;
    [_contentView addSubview:_coverView];
    
    _morePiker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_contentView.frame) - 180 - 50, SCREEN_WIDTH, 180)];
    _morePiker.delegate = self;
    _morePiker.dataSource = self;
    [_contentView addSubview:_morePiker];
    
    _coverView.frame = CGRectMake(0, _morePiker.center.y - 20, SCREEN_WIDTH, 40);
    
    UIButton *comfirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_contentView.frame) - 50, SCREEN_WIDTH, 50)];
    [comfirmBtn setBackgroundColor:THEMECOLOR];
    [comfirmBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [comfirmBtn setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
    [comfirmBtn addTarget:self action:@selector(comfirmDidClick) forControlEvents:(UIControlEventTouchUpInside)];
    [_contentView addSubview:comfirmBtn];
}

- (void)setStartDate:(NSDate *)startDate {
    if (startDate) {
        [_picker setDate:startDate animated:YES];
    }
}

- (void)show {
    [UIView animateWithDuration:0.2 animations:^{
        _bgButotn.alpha = 1;
        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT - 282, SCREEN_WIDTH, 282);
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        _bgButotn.alpha = 0;
        _contentView.alpha = 0;
        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, 216);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)layoutSubviews {
    _bgButotn.frame = self.bounds;
}

#pragma mark - UIPickerView
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedTimeZone = self.dataArray[row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (!view) {
        UIView *newView = [[UIView alloc] init];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [newView addSubview:titleLabel];
        view = newView;
    }
    for (UILabel *titleLabel in view.subviews) {
        if ([titleLabel isKindOfClass:[UILabel class]]) {
            titleLabel.text = self.dataArray[row];
        }
    }
    
    return view;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"00:00—01:00",@"01:00—02:00",@"02:00—03:00",@"03:00—04:00",@"04:00—05:00",@"05:00—06:00",@"06:00—07:00",@"07:00—08:00",@"09:00—10:00",@"10:00—11:00",@"11:00—12:00",@"12:00—13:00",@"13:00—14:00",@"14:00—15:00",@"15:00—16:00",@"16:00—17:00",@"17:00—18:00",@"18:00—19:00",@"19:00—20:00",@"20:00—21:00",@"21:00—22:00",@"22:00—23:00",@"23:00—00:00", nil];
    }
    return _dataArray;
}

@end
