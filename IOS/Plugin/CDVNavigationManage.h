//
//  CDVNavigationManage.h
//  TestHybird
//
//  Created by chaocaiwei on 2017/9/29.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <CDVPlugin.h>

@interface CDVNavigationManage : CDVPlugin

/**
 跳转到网页
 */
- (void)push:(CDVInvokedUrlCommand *)commond;
/**
 跳转到原生界面
 */
- (void)pushToViewController:(CDVInvokedUrlCommand *)commond;


- (void)pop:(CDVInvokedUrlCommand *)commond;

- (void)setTitle:(CDVInvokedUrlCommand *)command;

- (void)present:(CDVInvokedUrlCommand *)command;
- (void)dismiss:(CDVInvokedUrlCommand *)command;

- (void)addRightItem:(CDVInvokedUrlCommand *)commond;
- (void)modifiyRightItem:(CDVInvokedUrlCommand *)commond;

- (void)setNavgationTitle:(CDVInvokedUrlCommand *)commond;

@end
