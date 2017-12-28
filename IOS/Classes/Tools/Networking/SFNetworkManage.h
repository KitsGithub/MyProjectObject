//
//  SFNetworkManage.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/9/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "SFNetworkError.h"

typedef NS_ENUM(NSUInteger, SFNetworkStatus) {
    SFNetworkStatusUnknown,
    SFNetworkStatusNotReachable,
    SFNetworkStatusWifi,
    SFNetworkStatusWWAN
};

typedef void(^SFBoolResultBlock)(BOOL);
typedef void(^SFEmptyResultBlock)(void);
typedef void(^SFErrorResultBlock)(SFNetworkError *err);
typedef void(^SFSuccessResultBlock)(id result);

@interface SFNetworkManage : NSObject

+ (instancetype)shared;
- (void)observeNetWorkWithBlock:(void(^)(SFNetworkStatus))block;
- (SFNetworkStatus)netWorkStatus;

- (BOOL)isAvailable;



- (void)uploadImageWithImageData:(NSData *)data;

/**
 简单封装的请求

 @param path 请求所在的子路径
 @param params 请求参数
 @param success 成功回调
 @param fault 失败回调
 */
- (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(SFSuccessResultBlock)success fault:(SFErrorResultBlock)fault;

- (void)postWithPath:(NSString *)URLString params:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block progress:(nullable void (^)(double))uploadProgress success:(SFSuccessResultBlock _Nullable )success fault:(SFErrorResultBlock)fault;


- (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(SFSuccessResultBlock _Nonnull)success fault:(SFErrorResultBlock)fault;

/**
 基础的网络请求调用方法

 @param url 完整的url
 @param params 请求参数
 @param success 成功回调
 @param fault 失败回调
 */
- (void)post:(NSString *)url params:(NSDictionary *)params success:(SFSuccessResultBlock)success fault:(SFErrorResultBlock)fault;
- (void)get:(NSString *)url params:(NSDictionary *)params success:(SFSuccessResultBlock)success fault:(SFErrorResultBlock)fault;

@end
