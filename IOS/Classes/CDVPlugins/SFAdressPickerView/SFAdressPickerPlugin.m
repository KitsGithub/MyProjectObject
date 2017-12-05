//
//  SFAdressPickerPlugin.m
//  SFLIS
//
//  Created by kit on 2017/10/12.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFAdressPickerPlugin.h"
#import "SFAdressPickerView.h"

@interface SFAdressPickerPlugin () <SFAdressPickerViewDelegate>

@property (nonatomic, strong) CDVInvokedUrlCommand *command;

@property (nonatomic, assign) NSNumber *_h5Class;

@end

@implementation SFAdressPickerPlugin


- (void)adressPicker:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        NSMutableDictionary *params = command.arguments[0];
        __h5Class = params[@"fromId"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.command = command;
            [self setupPicker];
        });
    }];
}

- (void)setupPicker {
    SFAdressPickerView *picker = [[SFAdressPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    picker.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:picker];
    [picker showAnimation];
}


- (void)SFAdressPickerView:(SFAdressPickerView *)picker commitDidSelected:(NSString *)adress {
    NSLog(@"%@",adress);
    
    //包装h5的json对象
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fromId"] = __h5Class;
    params[@"message"] = adress;
    params[@"isCheck"] = @(1);
    //回调给H5
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:params];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];
}


- (void)SFAdressPickerViewDidSelectedCancel:(SFAdressPickerView *)picker {
    //包装h5的json对象
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fromId"] = __h5Class;
    
    
    //回调给H5
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:params];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];
}

@end
