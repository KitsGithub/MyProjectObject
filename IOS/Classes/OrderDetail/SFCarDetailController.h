//
//  SFCarDetailController.h
//  SFLIS
//
//  Created by kit on 2017/11/2.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "BaseCordvaViewController.h"

@interface SFCarDetailController : BaseCordvaViewController

@property (nonatomic, copy) NSString *orderID;
- (instancetype)initWithOrderID:(NSString *)orderID;

/**
 0 不展示报价  1展示报价
 */
@property (nonatomic, assign) BOOL showType;
@end
