//
//  SFNetworkManage.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/9/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFNetworkManage.h"
#import <AFNetworking.h>
#import "LoginViewController.h"
#import "SFAccount.h"
#import "SFDataBaseHelper.h"

static SFNetworkManage *_instance;

@implementation SFNetworkManage


+ (instancetype)shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [[AFNetworkReachabilityManager manager] startMonitoring];
    });
    return _instance;
}


- (void)observeNetWorkWithBlock:(void(^)(SFNetworkStatus))block
{
    [[AFNetworkReachabilityManager manager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        block([self stateWithAFStatus:status]);
    }];

}

- (SFNetworkStatus)netWorkStatus
{
    return [self stateWithAFStatus:[[AFNetworkReachabilityManager manager] networkReachabilityStatus]];
}

- (BOOL)isAvailable
{
    return [[AFNetworkReachabilityManager manager] isReachable];
}


- (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(SFSuccessResultBlock)success fault:(SFErrorResultBlock)fault
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",Default_URL,path];
    
//    [self post:url params:[self addTokenIfNeed:params] success:success fault:fault];
    [self post:url params:params success:success fault:fault];
}

- (NSDictionary *)addTokenIfNeed:(NSDictionary *)params
{
    NSString *token   = [SFAccount currentAccount].token;
    if (![params objectForKey:@"token"] && token) {
        NSMutableDictionary *mdic = !params ? [NSMutableDictionary new] : [params mutableCopy];
        mdic[@"token"] = token;
        return mdic;
    }
    return params;
}

- (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(SFSuccessResultBlock)success fault:(SFErrorResultBlock)fault
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",Default_URL,path];
    [self get:url params:[self addTokenIfNeed:params] success:success fault:fault];
}


- (void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id))success fault:(void(^)(SFNetworkError *))fault
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSLog(@"\npost请求 url=%@\n params=%@\n",url,params);
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SFNetworkError *err = [self hasErrorWithResponseObject:responseObject];
        if (err) {
            NSLog(@"\n请求失败 url=%@\n params=%@\n  error=%@",url,params,responseObject);
            [self handleError:err];
            fault(err);
        }else{
            NSLog(@"\n 请求成功 url=%@\n params=%@\n  responseObject=%@",url,params,responseObject);
            success([self parseResponseObj:responseObject[@"Data"]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\n请求失败 rl=%@\n params=%@\n  error=%@",url,params,error);
        fault([[SFNetworkError alloc]initWithError:error]);
    }];
}

- (void)postWithPath:(NSString *)path
              params:(NSDictionary *)params
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
            progress:(nullable void (^)(double))progress
             success:(SFSuccessResultBlock _Nullable )success 
               fault:(SFErrorResultBlock)fault
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@",UploadResouce_URL,path];
    NSLog(@"\npost请求 url=%@\n params=%@\n",url,params);
    [manager POST:url parameters:[self addTokenIfNeed:params]  constructingBodyWithBlock:block progress:^(NSProgress * _Nonnull uploadProgress) {
        progress((double)(uploadProgress.completedUnitCount)/(double)(uploadProgress.totalUnitCount));
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SFNetworkError *err = [self hasErrorWithResponseObject:responseObject];
        if (!err) {
            NSLog(@"\n 请求成功 url=%@\n params=%@\n  responseObject=%@",url,params,responseObject);
            success(responseObject[@"data"]);
        }else{
            NSLog(@"\n请求失败 url=%@\n params=%@\n  error=%@",url,params,responseObject);
            [self handleError:err];
            fault(err);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\n请求失败 rl=%@\n params=%@\n  error=%@",url,params,error);
        SFNetworkError *err = [[SFNetworkError alloc] initWithDomain:error.domain code:error.code userInfo:nil];
        fault(err);
    }];
}

- (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id))success fault:(void(^)(SFNetworkError *))fault
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSLog(@"\nget请求 url=%@\n params=%@\n",url,params);
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SFNetworkError *err = [self hasErrorWithResponseObject:responseObject];
        if (err) {
            NSLog(@"\n 请求失败 url=%@\n params=%@\n  error=%@",url,params,responseObject);
            [self handleError:err];
            fault(err);
        }else{
            NSLog(@"\n 请求成功 url=%@\n params=%@\n  responseObject=%@",url,params,responseObject);
            success([self parseResponseObj:responseObject[@"Data"]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\n  请求失败 url=%@\n params=%@\n  error=%@",url,params,error);
        SFNetworkError *err = [[SFNetworkError alloc]initWithError:error];
        fault(err);
    }];
}



- (void)handleError:(SFNetworkError *)error
{
    if (error.isTokenError) {
        SFAccount *account = [[SFDataBaseHelper shared] currentAccount];
        account.token  = nil;
        [[SFDataBaseHelper shared] saveAccount:account];
        [[[[UIApplication sharedApplication].delegate window] rootViewController] presentViewController:[[LoginViewController alloc]init] animated:YES completion:^{}];
    }
}




- (id)parseResponseObj:(id)response
{
    return response;
}


- (SFNetworkError *)hasErrorWithResponseObject:(id)responseObject
{
    return [[SFNetworkError alloc] initWithDict:responseObject];
}


- (SFNetworkStatus)stateWithAFStatus:(AFNetworkReachabilityStatus)status
{
    switch ([[AFNetworkReachabilityManager manager] networkReachabilityStatus]) {
        case AFNetworkReachabilityStatusUnknown  :
            return SFNetworkStatusUnknown;
        case   AFNetworkReachabilityStatusNotReachable     :
            return SFNetworkStatusNotReachable;
        case  AFNetworkReachabilityStatusReachableViaWWAN :
            return SFNetworkStatusWWAN;
        case  AFNetworkReachabilityStatusReachableViaWiFi :
            return SFNetworkStatusWifi;
        default:
            return SFNetworkStatusUnknown;
    }
}

@end
