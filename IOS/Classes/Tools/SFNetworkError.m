//
//  SFNetworkError.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/9/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFNetworkError.h"


@interface SFNetworkError()

@property (nonatomic,strong)NSString *desc;

@end

@implementation SFNetworkError

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    if (![dict[@"Code"] integerValue]) {
        return nil;
    }
    
    self = [super initWithDomain:dict[@"Error"] code:[dict[@"Code"] integerValue] userInfo:dict[@"Data"]];
    _desc = dict[@"Error"];
    return self;
}

- (instancetype)initWithError:(NSError *)error
{
    self = [super initWithDomain:error.domain code:error.code userInfo:error.userInfo];
    return self;
}

- (NSString *)errDescription
{
    if (_desc) {
        return _desc;
    }else{
        return self.localizedDescription;
    }
}


- (BOOL)isTokenError
{
    return self.code == 0;
}

@end
