//
//  SFOtherPickerViewPlugin.h
//  SFLIS
//
//  Created by kit on 2017/10/16.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Cordova/CDVPlugin.h>

@interface SFOtherPickerViewPlugin : CDVPlugin

/**
 单选picker 样式一
 */
- (void)otherSelectePicker:(CDVInvokedUrlCommand *)command;


/**
 单选picker 样式二
 */
- (void)singleTablePicker:(CDVInvokedUrlCommand *)command;

@end
