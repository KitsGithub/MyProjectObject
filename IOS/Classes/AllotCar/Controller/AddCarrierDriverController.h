//
//  AddCarrierDriverController.h
//  SFLIS
//
//  Created by kit on 2017/11/16.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^AddDriverReturnBlock)(NSString *driversStr);

@interface AddCarrierDriverController : BaseViewController

@property (nonatomic, copy) AddDriverReturnBlock returnBlock;

@end
