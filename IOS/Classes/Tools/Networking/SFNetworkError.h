//
//  SFNetworkError.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/9/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFNetworkError : NSError


- (instancetype)initWithDict:(NSDictionary *)dict;

- (instancetype)initWithError:(NSError *)error;

- (NSString *)errDescription;

- (BOOL)isTokenError;


@end
