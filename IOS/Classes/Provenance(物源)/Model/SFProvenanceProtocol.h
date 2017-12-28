//
//  SFProvenanceProtocol.h
//  SFLIS
//
//  Created by kit on 2017/12/15.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFProvenanceProtocol <NSObject>

/**
 车源单ID
 */
- (NSString *)guid;
- (NSString *)gdid;
- (NSString *)goodsId;

/**
 出发地址信息
 */
- (NSString *)from;

/**
 到达地址信息
 */
- (NSString *)to;

/**
 物源单的时间信息
 */
- (NSString *)timeMessage;

/**
 物源单的用户信息
 */
- (NSString *)name;

/**
 物源单状态
 */
- (NSString *)status;

/**
 待确认订单数
 */
- (NSNumber *)usercount;


- (NSString *)stateStr;

- (SFTakingStatus)takingStatus;

- (SFOrderType)orderType;
@end
