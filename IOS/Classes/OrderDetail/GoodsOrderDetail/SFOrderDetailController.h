//
//  SFOrderDetailController.h
//  SFLIS
//
//  Created by kit on 2017/10/11.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "BaseViewController.h"

@interface SFOrderDetailController : BaseViewController

@property (nonatomic, copy) NSString *orderID;

/**
 0:可预订
 1:不可预定
 */
@property (nonatomic, assign) NSInteger showType;

- (instancetype)initWithOrderID:(NSString *)orderID;
+ (void)pushFromViewController:(UIViewController *)vc orderID:(NSString *)orderId;



@end
