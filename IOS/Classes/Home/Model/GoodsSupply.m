//
//  GoodsSupply.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/9.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "GoodsSupply.h"

@implementation GoodsSupply

- (NSArray <SFOpration *>*)operations {
    return nil;
}

- (NSString *)from
{
    return  [NSString stringWithFormat:@"%@-%@-%@",self.from_province,self.from_city,self.from_address];
}

- (NSString *)to
{
    return  [NSString stringWithFormat:@"%@-%@-%@",self.to_province,self.to_city,self.to_address];
}

- (NSString *)goodsType
{
    return self.goods_name;
}

- (NSString *)goods_name {
    if (_goods_name.length) {
        return _goods_name;
    }
    return _goods_type;
}

- (NSString *)goodsCount
{
    return [NSString stringWithFormat:@"%@%@",self.goods_weight,self.weight_unit];
}

- (NSString *)cost
{
    return self.price;
}

- (NSString *)transportState
{
    return self.order_status;
}

- (NSString *)name
{
    if (_name.length) {
        return _name;
    }
    return @"未命名";
}

- (NSString *)carownnerName
{
    return self.name;
}

- (NSString *)carNumber
{
    return @"粤B54585852";
}

- (SFOrderType)orderType
{
    //    if ([self.order_status  isEqualToString:@"A"]) {
    //        return SFOrderTypeWaiteForSent;
    //    }
    return arc4random()%6;
}



@end
