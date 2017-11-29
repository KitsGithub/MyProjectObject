//
//  SFDatePickerPlugin.m
//  SFLIS
//
//  Created by kit on 2017/10/17.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFDatePickerPlugin.h"
#import "RMCalendarController.h"

@interface SFDatePickerPlugin ()

@property (nonatomic, strong) CDVInvokedUrlCommand *command;

@property (nonatomic, copy) NSString *_h5Class;

@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *day;

@property (nonatomic, copy) NSString *selectedDayStr;

@end

@implementation SFDatePickerPlugin

- (void)datePicker:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        
        
        NSMutableDictionary *params = command.arguments[0];
        if ([params isKindOfClass:[NSMutableDictionary class]] || [params isKindOfClass:[NSDictionary class]]) {
            __h5Class = params[@"class"];
            self.selectedDayStr = params[@"data"];
        }
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.command = command;
            [self setupPicker];
        });
    }];
}

- (void)setupPicker {
    
    __weak typeof(self) weakSelf = self;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY年MM月dd"];
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


/**
 把用户选择的年月日返回给h5渲染
 */
- (void)returnToH5 {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"class"] = __h5Class;
    params[@"year"] = [self.year stringByAppendingString:@"年"];
    params[@"month"] = [self.month stringByAppendingString:@"月"];
    params[@"day"] = self.day;
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:(CDVCommandStatus_OK) messageAsDictionary:params];
    [self.commandDelegate sendPluginResult:result callbackId:self.command.callbackId];
}

@end
