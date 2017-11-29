//
//  SFMessageViewPlugin.h
//  SFLIS
//
//  Created by kit on 2017/11/3.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Cordova/CDVPlugin.h>

@interface SFMessageViewPlugin : CDVPlugin

- (void)showSuccessMessage:(CDVInvokedUrlCommand *)command;
- (void)showErrorMessage:(CDVInvokedUrlCommand *)command;

@end
