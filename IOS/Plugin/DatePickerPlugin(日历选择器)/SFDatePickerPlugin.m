//
//  SFDatePickerPlugin.m
//  SFLIS
//
//  Created by kit on 2017/10/17.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFDatePickerPlugin.h"
#import "RMCalendarController.h"
#import "SFMoreDatePickerView.h"
@interface SFDatePickerPlugin () <SFMoreDatePickerDelegate>

@property (nonatomic, strong) CDVInvokedUrlCommand *command;

@property (nonatomic, copy) NSString *_h5Class;

@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *day;

@property (nonatomic, copy) NSString *selectedDayStr;
@property (nonatomic, copy) NSString *cycle;

@end

@implementation SFDatePickerPlugin

- (void)datePicker:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        NSMutableDictionary *params = command.arguments[0];
        if ([params isKindOfClass:[NSMutableDictionary class]] || [params isKindOfClass:[NSDictionary class]]) {
            __h5Class = params[@"fromId"];
            self.selectedDayStr = params[@"time"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.command = command;
            [self setupPicker];
        });
    }];
}

- (void)sheetTypePicker:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        
        NSMutableDictionary *params = command.arguments[0];
        __h5Class = params[@"fromId"];
        self.cycle = params[@"cycle"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.command = command;
            [self setupSheetTypePicker:params[@"time"]];
        });
    }];
}

- (void)setupPicker {
    
    __weak typeof(self) weakSelf = self;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *selectedDate = [formatter dateFromString:self.selectedDayStr];
    
    
    RMCalendarController *c = [RMCalendarController calendarWithDays:365 showType:CalendarShowTypeMultiple];
    c.hidesBottomBarWhenPushed = YES;
    c.isEnable = YES;
    c.title = @"日历";
    c.selectedDate = selectedDate;
    c.calendarBlock = ^(RMCalendarModel *model) {
        self.year = [NSString stringWithFormat:@"%lu",(unsigned long)model.year];
        self.month = [NSString stringWithFormat:@"%lu",(unsigned long)model.month];
        self.day = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
        
        [self returnToH5];
        [weakSelf.viewController.navigationController popViewControllerAnimated:YES];
        
    };
    [self.viewController.navigationController pushViewController:c animated:YES];
}


- (void)setupSheetTypePicker:(NSString *)timeStr {
    NSDate *selectedDate = [NSDate date];
    if (timeStr.length) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY.MM.dd HH:mm"];
        selectedDate = [formatter dateFromString:timeStr];
    }
    
    DateType dateType = DateType_SingleTime;
    if (![self.cycle isEqualToString:@"只发布一次"]) {
        dateType = DateType_MoreTime;
    }
    
    SFMoreDatePickerView *pick = [[SFMoreDatePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) dateType:dateType];
    pick.delegate = self;
    pick.startDate = selectedDate;
    [pick show];
}


- (void)SFMoreDatePickerView:(SFMoreDatePickerView *)picker didSelectedDateStr:(NSString *)dateStr date:(NSDate *)date {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fromId"] = __h5Class;
    params[@"message"] = dateStr;
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:(CDVCommandStatus_OK) messageAsDictionary:params];
    [self.commandDelegate sendPluginResult:result callbackId:self.command.callbackId];
}

- (void)SFMoreDatePickerViewDidSelectedCancel {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fromId"] = __h5Class;
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:(CDVCommandStatus_ERROR) messageAsDictionary:params];
    [self.commandDelegate sendPluginResult:result callbackId:self.command.callbackId];
}

/**
 把用户选择的年月日返回给h5渲染
 */
- (void)returnToH5 {
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",self.year ,self.month ,self.day];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fromId"] = __h5Class;
    params[@"message"] = dateStr;
    
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:(CDVCommandStatus_OK) messageAsDictionary:params];
    [self.commandDelegate sendPluginResult:result callbackId:self.command.callbackId];
}

@end
