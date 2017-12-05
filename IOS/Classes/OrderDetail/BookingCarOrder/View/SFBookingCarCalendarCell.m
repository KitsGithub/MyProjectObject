//
//  SFBookingCarCalendarCell.m
//  SFLIS
//
//  Created by kit on 2017/12/1.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFBookingCarCalendarCell.h"
#import "RMCalendarController.h"
#import "SFMoreDatePickerView.h"

@implementation SFBookingCarCalendarCell {
    UIImageView *_calendarImage;
    UILabel *_tipsLabel;
    UILabel *_time;
    UILabel *_moreTime;
    
    
    UIView *_remarkContentView;
    UILabel *_placeHolder;
    UITextView *_remark;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    [formatter setDateFormat:@"HH:mm"];
    NSString *hour = [formatter stringFromDate:date];
    
    
    _calendarImage = [UIImageView new];
    _calendarImage.userInteractionEnabled = YES;
    _calendarImage.image = [UIImage imageNamed:@"Calendar_Image"];
    [self addSubview:_calendarImage];
    
    UITapGestureRecognizer *calendarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calendarClick)];
    [_calendarImage addGestureRecognizer:calendarTap];
    
    
    _tipsLabel = [UILabel new];
    _tipsLabel.text = @"发车时间";
    _tipsLabel.font = FONT_COMMON_14;
    _tipsLabel.textColor = [UIColor whiteColor];
    [_calendarImage addSubview:_tipsLabel];
    
    _time = [UILabel new];
    _time.text = hour;
    _time.font = [UIFont systemFontOfSize:28];
    _time.textColor = [UIColor whiteColor];
    [_calendarImage addSubview:_time];
    
    _moreTime = [UILabel new];
    _moreTime.text = DateTime;
    _moreTime.font = FONT_COMMON_14;
    _moreTime.textColor = [UIColor whiteColor];
    [_calendarImage addSubview:_moreTime];
    
    
    _remarkContentView = [UIView new];
    _remarkContentView.layer.cornerRadius = 10;
    _remarkContentView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f3"];
    [self addSubview:_remarkContentView];
    
    _remark = [UITextView new];
    _remark.backgroundColor = [UIColor clearColor];
    _remark.font = FONT_COMMON_16;
    _remark.delegate = self;
    _remark.textColor = COLOR_TEXT_COMMON;
    [_remarkContentView addSubview:_remark];
    
    _placeHolder = [UILabel new];
    _placeHolder.text = @"填写备注";
    _placeHolder.textColor = [UIColor colorWithHexString:@"#999999"];
    _placeHolder.font = [UIFont systemFontOfSize:16];
    [_remark addSubview:_placeHolder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remarkBeginEdditting) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remarkEndEdditting) name:UITextViewTextDidEndEditingNotification object:nil];
}


- (void)remarkBeginEdditting {
    _placeHolder.hidden = YES;
}

- (void)remarkEndEdditting {
    if (_remark.text.length) {
        return;
    } else {
        _placeHolder.hidden = NO;
    }
}

- (void)calendarClick {
    NSLog(@"点击选择日历");
    
    SFMoreDatePickerView *pick = [[SFMoreDatePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [[UIApplication sharedApplication].keyWindow addSubview:pick];
    
    
//    RMCalendarController *c = [RMCalendarController calendarWithDays:365 showType:CalendarShowTypeMultiple];
//    c.hidesBottomBarWhenPushed = YES;
//    c.isEnable = YES;
//    c.title = @"日历";
////    c.selectedDate = selectedDate;
//    c.calendarBlock = ^(RMCalendarModel *model) {
//        NSString *year = [NSString stringWithFormat:@"%lu",(unsigned long)model.year];
//        NSString *month = [NSString stringWithFormat:@"%lu",(unsigned long)model.month];
//        NSString *day = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
//        NSLog(@"year-%@ month-%@ day-%@",year,month,day);
////        [weakSelf.viewController.navigationController popViewControllerAnimated:YES];
//
//    };
//
//    UIViewController *vc = [self getVc];
//    [vc.navigationController pushViewController:c animated:YES];
}

//- (UIViewController *)getVc {
//    for (UIView* next = [self superview]; next; next = next.superview) {
//        UIResponder* nextResponder = [next nextResponder];
//        if ([nextResponder isKindOfClass:[UIViewController class]]) {
//            return (UIViewController*)nextResponder;
//        }
//    }
//    return nil;
//}


- (void)layoutSubviews {
    _calendarImage.frame = CGRectMake(20, (CGRectGetHeight(self.frame) - 100) * 0.5, 100, 100);
    
    _remarkContentView.frame = CGRectMake(CGRectGetMaxX(_calendarImage.frame) + 10, CGRectGetMinY(_calendarImage.frame), CGRectGetWidth(self.frame) - CGRectGetMaxX(_calendarImage.frame) - 30, 100);
    
    _remark.frame = CGRectMake(10, 10, CGRectGetWidth(_remarkContentView.frame) - 20, CGRectGetHeight(_remarkContentView.frame) - 20);
    _placeHolder.frame = CGRectMake(3, 10, 80, 16);
    
    
    _tipsLabel.frame = CGRectMake(8, 9, 70, 14);
    
    CGSize moreTimeSize = [_moreTime.text sizeWithFont:FONT_COMMON_14 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _moreTime.frame = CGRectMake(8, CGRectGetHeight(_calendarImage.frame) - 8 - moreTimeSize.height, moreTimeSize.width, moreTimeSize.height);
    
    CGSize timeSize = [_time.text sizeWithFont:[UIFont systemFontOfSize:28] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _time.frame = CGRectMake(8, CGRectGetMinY(_moreTime.frame) - 5 - timeSize.height, timeSize.width, timeSize.height);
    
    
}

@end
