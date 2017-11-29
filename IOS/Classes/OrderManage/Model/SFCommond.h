//
//  SFCommond.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/11/1.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFCommond : NSObject

@property (nonatomic,copy)NSString * _Nullable name;

@property (nonatomic,copy)void(^ _Nonnull commond)(id _Nullable obj);


@end
