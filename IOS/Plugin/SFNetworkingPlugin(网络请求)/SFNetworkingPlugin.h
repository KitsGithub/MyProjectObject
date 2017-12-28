//
//  SFNetworkingPlugin.h
//  SFLIS
//
//  Created by kit on 2017/10/19.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Cordova/CDVPlugin.h>

@interface SFNetworkingPlugin : CDVPlugin

- (void)requestNetworking:(CDVInvokedUrlCommand *_Nonnull)command;

- (void)post:(CDVInvokedUrlCommand *_Nonnull)post;
- (void)get:(CDVInvokedUrlCommand *_Nonnull)get;

- (void)showSuccess:(CDVInvokedUrlCommand *_Nonnull)command;

- (void)showFault:(CDVInvokedUrlCommand *_Nonnull)command;

- (void)execFunction:(CDVInvokedUrlCommand *_Nonnull)command;

- (void)getCurrentUser:(CDVInvokedUrlCommand *_Nonnull)command;

+ (void)registWithId:(NSString * _Nonnull )fid block:(void(^_Nullable)(id _Nullable))block;

@end
