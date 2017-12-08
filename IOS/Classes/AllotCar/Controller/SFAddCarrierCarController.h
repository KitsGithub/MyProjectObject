//
//  SFAddCarrierCarController.h
//  SFLIS
//
//  Created by kit on 2017/11/15.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "BaseViewController.h"
#import "SFCarrierModel.h"

typedef void(^SuccessReturn)();

@interface SFAddCarrierCarController : BaseViewController

@property (nonatomic, strong) SFCarrierModel *model;

@property (nonatomic, copy) SuccessReturn successRetrun;

@property (nonatomic, copy) NSString *orderId;

@end
