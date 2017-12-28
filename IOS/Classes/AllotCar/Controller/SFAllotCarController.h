//
//  SFAllotCarController.h
//  SFLIS
//
//  Created by kit on 2017/11/14.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ReturnBlock)(void);

@interface SFAllotCarController : BaseViewController

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, copy) ReturnBlock returnBlock;

@end
