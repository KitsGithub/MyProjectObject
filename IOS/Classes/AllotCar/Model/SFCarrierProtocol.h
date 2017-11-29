//
//  SFCarrierProtocol.h
//  SFLIS
//
//  Created by kit on 2017/11/15.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFCarrierProtocol <NSObject>
@required

/**
 车牌号码
 */
- (NSString *)carNum;

- (NSString *)car_id;

- (void)setCarNum:(NSString *)carNum;

- (NSArray <NSString *>*)driverNameArray;



@end
