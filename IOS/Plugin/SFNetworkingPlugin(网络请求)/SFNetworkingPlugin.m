//
//  SFNetworkingPlugin.m
//  SFLIS
//
//  Created by kit on 2017/10/19.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFNetworkingPlugin.h"
#import "BaseCordvaViewController.h"
#import "UIViewController+Extension.h"

static NSMutableDictionary *s_functionDic;

@interface SFNetworkingPlugin ()

@property (nonatomic, copy) NSString *apiName;

@property (nonatomic, strong) NSMutableDictionary *params;

@property (nonatomic, strong) CDVInvokedUrlCommand *command;

@property (nonatomic,strong)NSMutableDictionary *functionDic;

@end

@implementation SFNetworkingPlugin


+ (void)initialize
{
    [super initialize];
    s_functionDic = [[NSMutableDictionary alloc]init];
}

- (void)showSuccess:(CDVInvokedUrlCommand *)command
{
    NSString *mes = [command argumentAtIndex:0];
    [[SFTipsView shareView] showSuccessWithTitle:mes];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:(CDVCommandStatus_OK)] callbackId:command.callbackId];
}

- (void)showFault:(CDVInvokedUrlCommand *)command
{
    NSString *mes = [command argumentAtIndex:0];
    [[SFTipsView shareView] showFailureWithTitle:mes];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:(CDVCommandStatus_OK)] callbackId:command.callbackId];
}

- (void)post:(CDVInvokedUrlCommand *)command
{
    [SVProgressHUD show];
    [self.commandDelegate runInBackground:^{
        NSString *header = [command argumentAtIndex:0];
        NSMutableDictionary *params = [command argumentAtIndex:1];
        if (!header ) {
            [SVProgressHUD dismiss];
            CDVPluginResult *result = [CDVPluginResult resultWithStatus:(CDVCommandStatus_ERROR) messageAsDictionary:@{@"code":@404,@"message":@"header can not be null"}];
            [self.commandDelegate sendPluginResult:result callbackId:self.command.callbackId];
            return;
        }
        params[@"UserId"] = USER_ID;
        [[SFNetworkManage shared] postWithPath:header params:params success:^(id data) {
            [SVProgressHUD dismiss];
            CDVPluginResult *result = [CDVPluginResult resultWithStatus:(CDVCommandStatus_OK) messageAsDictionary:data];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        } fault:^(SFNetworkError *err) {
            [SVProgressHUD dismiss];
            CDVPluginResult *result = [CDVPluginResult resultWithStatus:(CDVCommandStatus_ERROR) messageAsDictionary:@{@"code":@(err.code),@"message":err.errDescription}];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }];
        
    }];
    
}
- (void)get:(CDVInvokedUrlCommand *)command
{
    [SVProgressHUD show];
    NSString *header = [command argumentAtIndex:0];
    NSDictionary *params = [command argumentAtIndex:1];
    if (!header ) {
        [SVProgressHUD dismiss];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:(CDVCommandStatus_ERROR) messageAsDictionary:@{@"code":@404,@"message":@"header can not be null"}];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    [[SFNetworkManage shared] getWithPath:header params:params success:^(id data) {
        [SVProgressHUD dismiss];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:(CDVCommandStatus_OK) messageAsDictionary:data];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    } fault:^(SFNetworkError *err) {
        [SVProgressHUD dismiss];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:(CDVCommandStatus_ERROR) messageAsDictionary:@{@"code":@(err.code),@"message":err.errDescription}];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

- (void)requestNetworking:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        self.command = command;
        for (NSMutableDictionary *dic in command.arguments) {
            if ([dic isKindOfClass:[NSDictionary class]] || [dic isKindOfClass:[NSMutableDictionary class]]) {
                self.apiName = dic[@"apiName"];
                self.params = dic[@"params"];
            }
        }
        [self request];
    }];
}

- (void)request {
    [SVProgressHUD show];
    if (!self.apiName ) {
        [SVProgressHUD dismiss];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:(CDVCommandStatus_ERROR) messageAsString:@"apiName can not be null"];
        [self.commandDelegate sendPluginResult:result callbackId:self.command.callbackId];
        return;
    }
    [[SFNetworkManage shared] post:self.apiName params:self.params success:^(id data) {
        [SVProgressHUD dismiss];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:(CDVCommandStatus_OK) messageAsDictionary:data];
        [self.commandDelegate sendPluginResult:result callbackId:self.command.callbackId];
    } fault:^(SFNetworkError *err) {
        [SVProgressHUD dismiss];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:(CDVCommandStatus_ERROR) messageAsString:err.errDescription];
        [self.commandDelegate sendPluginResult:result callbackId:self.command.callbackId];
    }];
}



- (NSMutableDictionary *)functionDic
{
    if (!_functionDic) {
        _functionDic  = [NSMutableDictionary new];
    }
    return _functionDic;
}

- (void)getCurrentUser:(CDVInvokedUrlCommand *_Nonnull)command
{
    SFUserInfo *user = SF_USER;
    NSDictionary *userDic = [user mj_keyValues];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:(CDVCommandStatus_OK) messageAsDictionary:userDic] callbackId:command.callbackId];
}

+ (void)registWithId:(NSString * _Nonnull )fid block:(void(^_Nullable)(id))block
{
    s_functionDic[fid] = block;
}

- (void)execFunction:(CDVInvokedUrlCommand *)command
{
    NSString *functionId = [command argumentAtIndex:0];
    id obj  = [command argumentAtIndex:1];
    void(^fucntion)(id)  = s_functionDic[functionId];
    if (fucntion) {
        fucntion(obj);
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:(CDVCommandStatus_OK)] callbackId:command.callbackId];
    }else{
        UIViewController *topVc = [UIViewController currentTopViewController];
        NSString *selectStr = [NSString stringWithFormat:@"%@:",functionId];
        SEL tsel = NSSelectorFromString(selectStr);
        if ([topVc respondsToSelector:tsel]) {
            [topVc performSelectorOnMainThread:tsel withObject:obj waitUntilDone:NO];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:(CDVCommandStatus_OK)] callbackId:command.callbackId];
        }else{
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:(CDVCommandStatus_ERROR)] callbackId:command.callbackId];
        }
        
    }
}


@end
