//
//  SFMoreSelectedPickerPlugin.m
//  SFLIS
//
//  Created by kit on 2017/10/19.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFMoreSelectedPickerPlugin.h"
#import "SFMoreSelectedPickerView.h"

@interface SFMoreSelectedPickerPlugin () <SFMoreSelectedPickerViewDelegate>

@property (nonatomic, strong) CDVInvokedUrlCommand *command;

@property (nonatomic, strong) NSMutableArray *resourceArray;

@property (nonatomic, copy) NSString *_h5Class;
@property (nonatomic, copy) NSString *_title;

@end

@implementation SFMoreSelectedPickerPlugin

- (void)moreSelectedPicker:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        
        NSMutableDictionary *params = command.arguments[0];
        __title = params[@"title"];
        __h5Class = params[@"class"];
        self.resourceArray = params[@"data"];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.command = command;
            [self otherPicker];
        });
    }];
}


- (void)otherPicker {
    SFMoreSelectedPickerView *picker = [[SFMoreSelectedPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withResourceArray:self.resourceArray];
    picker.delegate = self;
    picker.title = __title;
    [[UIApplication sharedApplication].keyWindow addSubview:picker];
    [picker showAnimation];
}

- (void)SFMoreSelectedPickerView:(SFMoreSelectedPickerView *)pickerView commitDidSelected:(NSArray <NSNumber *>*)indexArray {
    
    NSMutableArray *carNumberArray = [NSMutableArray array];
    for (NSNumber *number in indexArray) {
        NSInteger index = [number intValue];
        [carNumberArray addObject:self.resourceArray[index]];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"class"] = __h5Class;
    dic[@"message"] = @(indexArray.count);
    dic[@"numbers"] = [carNumberArray mj_JSONString];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:(CDVCommandStatus_OK) messageAsDictionary:dic];
    [self.commandDelegate sendPluginResult:result callbackId:self.command.callbackId];
    
}

- (void)SFMoreSelectedPickerViewDidSelectedCancel:(SFMoreSelectedPickerView *)pickerView
{
    
}

@end
