//
//  SFChooseReleaerTimePlugin.m
//  SFLIS
//
//  Created by kit on 2017/11/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFChooseReleaerTimePlugin.h"
#import "SFChooseReleaseTimeController.h"

@implementation SFChooseReleaerTimePlugin {
    CDVInvokedUrlCommand *_command;
    NSString *_fromId;
}

- (void)chooseReleaseTime:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        _command = command;
        
        NSMutableDictionary *params = command.arguments[0];
        _fromId = params[@"fromId"];
        
        NSArray *dataArray = [NSArray array];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self jumToVc:dataArray];
        });
        
    }];
}

- (void)jumToVc:(NSArray *)dataArray {
    SFChooseReleaseTimeController *release = [[SFChooseReleaseTimeController alloc] init];
    [release setBlock:^(NSString *timeStr) {
        [self sendMessageToH5:timeStr];
    }];
    [self.viewController.navigationController pushViewController:release animated:YES];
}

- (void)sendMessageToH5:(NSString *)time {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"message"] = time;
    params[@"fromId"] = _fromId;
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:(CDVCommandStatus_OK) messageAsDictionary:params];
    [self.commandDelegate sendPluginResult:result callbackId:_command.callbackId];
}

@end
