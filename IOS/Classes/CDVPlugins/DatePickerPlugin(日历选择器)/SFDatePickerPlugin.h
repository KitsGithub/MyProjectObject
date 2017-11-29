//
//  SFDatePickerPlugin.h
//  SFLIS
//
//  Created by kit on 2017/10/17.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Cordova/CDVPlugin.h>

@interface SFDatePickerPlugin : CDVPlugin

- (void)datePicker:(CDVInvokedUrlCommand *)command;

@end
