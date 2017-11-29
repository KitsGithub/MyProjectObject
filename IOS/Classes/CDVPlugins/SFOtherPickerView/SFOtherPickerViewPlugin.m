//
//  SFOtherPickerViewPlugin.m
//  SFLIS
//
//  Created by kit on 2017/10/16.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFOtherPickerViewPlugin.h"
#import "SFOtherPickerView.h"
#import "SFSinglePickerView.h"

@interface SFOtherPickerViewPlugin () <SFSinglePickerProtocol>

@property (nonatomic, strong) CDVInvokedUrlCommand *command;

@property (nonatomic, strong) NSMutableArray *resourceArray;

@property (nonatomic, copy) NSString *_h5Class;
@property (nonatomic, copy) NSString *_title;

@end

@implementation SFOtherPickerViewPlugin

#pragma mark - 样式一
/**
 单选picker 样式一
 */
- (void)otherSelectePicker:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        
        NSMutableDictionary *params = command.arguments[0];
        __title = params[@"title"];
        __h5Class = params[@"class"];
        self.resourceArray = params[@"data"];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.command = command;
            SFOtherPickerView *picker = [[SFOtherPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withResourceArray:self.resourceArray];
            picker.delegate = self;
            picker.title = __title;
            [[UIApplication sharedApplication].keyWindow addSubview:picker];
            [picker showAnimation];
        });
    }];
}

#pragma mark - 样式二
/**
 单选picker 样式二
 */
- (void)singleTablePicker:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{
        NSMutableDictionary *params = command.arguments[0];
        __title = params[@"title"];
        __h5Class = params[@"class"];
        self.resourceArray = params[@"data"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.command = command;
            SFSinglePickerView *picker = [[SFSinglePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withResourceArray:self.resourceArray];
            picker.delegate = self;
            picker.title = __title;
            [[UIApplication sharedApplication].keyWindow addSubview:picker];
            [picker showAnimation];
        });
    }];
    
}




#pragma mark - publicMethod
- (void)pickerView:(SFOtherPickerView *)pickerView commitDidSelected:(NSInteger)index resourceArray:(NSArray *)resouceArray{
    NSLog(@"%@",self.resourceArray[index]);
    
    [self callBackHtmlWithStatus:(CDVCommandStatus_OK) andParams:@{
                                                                   @"class" :__h5Class,
                                                                   @"message":self.resourceArray[index]
                                                                   }];
}

- (void)pickerViewDidSelectedCancel:(SFOtherPickerView *)pickerView {
    //包装h5的json对象
    [self callBackHtmlWithStatus:(CDVCommandStatus_ERROR) andParams:@{
                                                                      @"class" : __h5Class
                                                                      }];
}


//回调给H5
- (void)callBackHtmlWithStatus:(CDVCommandStatus)status andParams:(NSDictionary *)params {
    //回调给H5
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:status messageAsDictionary:params];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];
}

@end
