//
//  SFAlertViewPlugin.h
//  SFLIS
//
//  Created by kit on 2017/10/26.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Cordova/CDVPlugin.h>

@interface SFAlertViewPlugin : CDVPlugin

- (void)showAlertView:(CDVInvokedUrlCommand *)command;

@end
