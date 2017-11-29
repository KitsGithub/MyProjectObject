//
//  SFSearchResultProtocol.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/17.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol  SFSearchResultProtocol


- (NSString *_Nonnull)guid;

- (NSString *_Nonnull)from_province;

- (NSString *_Nonnull)from_city;
- (NSString *_Nonnull)from_district;

- (NSString *_Nonnull)to_province;

- (NSString *_Nonnull)to_city;

- (NSString *_Nonnull)to_district;

- (NSString *_Nonnull)name;

- (NSString *_Nonnull)issueCount;

- (NSString *_Nonnull)goods_weight;

- (NSString *_Nonnull)weight_unit;

- (NSString *_Nonnull)car_long;

- (NSString *_Nonnull)car_count;

- (NSString *_Nonnull)car_type;


@optional
// 货物信息
- (NSString *_Nonnull)goods_type;

- (NSString *_Nonnull)goods_name;


@optional

@end
