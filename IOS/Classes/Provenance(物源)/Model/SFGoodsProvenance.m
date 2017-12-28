//
//  SFGoodsProvenance.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/11/3.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFGoodsProvenance.h"

@implementation SFGoodsProvenance

- (NSString *)guid {
    return _guid;
}

- (NSString *)from
{
    return [self toAddr:self.from_province city:self.from_city dis:self.from_district addr:self.from_address];
    
}

- (NSString *)to
{
    return [self toAddr:self.to_province city:self.to_city dis:self.to_district addr:self.to_address];
}

- (NSString *)toAddr:(NSString *)pro city:(NSString *)city dis:(NSString *)dis addr:(NSString *)addr{
    if (pro && city) {
        return [NSString stringWithFormat:@"%@-%@-%@",pro,city,dis];
    }else{
        return addr;
    }
}


- (NSString *)timeMessage {
    return [NSString stringWithFormat:@"订单创建时间：%@",_created_date];
}


- (NSString *)name {
    return _nick_name;
}


- (NSString *)status {
    return self.order_status;
}


- (NSNumber *)usercount {
    return _usercount;
}


- (NSString *)stateStr {
    return [self statusDescArr][self.takingStatus];
}

- (SFOrderType)orderType {
    return  orderType_initWithStr(self.order_status);
}

- (SFTakingStatus)takingStatus { 
    NSArray *arr = [self statusCodeArr];
    for (int i = 0;i < arr.count ;i++) {
        NSString *code = arr[i];
        if ([code isEqualToString:self.taking_status ? self.taking_status : self.order_status]) {
            return i;
        }
    }
    return 0;
}

- (NSArray *)statusCodeArr {
    return @[@"B",@"A",@"C"];
}

- (NSArray *)statusDescArr {
    return @[@"待发布",@"已发布",@"已接单"];
}




@end
