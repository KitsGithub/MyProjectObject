//
//  SFCarDetailController.h
//  SFLIS
//
//  Created by kit on 2017/11/2.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

//#import "BaseCordvaViewController.h"
#import "BaseViewController.h"

@interface SFCarDetailController : BaseViewController

@property (nonatomic, copy) NSString *orderID;
- (instancetype)initWithOrderID:(NSString *)orderID;

/**
 0:可预订
 1:不可预定
 */
@property (nonatomic, assign) NSInteger showType;
@end
