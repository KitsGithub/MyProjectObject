//
//  SFCarrierProtocol.h
//  SFLIS
//
//  Created by kit on 2017/11/15.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFCarrierProtocol <NSObject>
@optional
/**
 车牌号码
 */
- (NSString *)carNum;

- (NSString *)car_id;

- (NSArray <NSString *>*)driverNameArray;



@end
