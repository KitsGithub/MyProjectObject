//
//  AddCarryDriverController.h
//  SFLIS
//
//  Created by kit on 2017/11/16.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ReturnBlock)(NSString *driverStr,NSMutableArray *driverIds);

@interface AddCarryController : BaseViewController

@property (nonatomic, strong) NSArray <NSString *>* driverArray;

@property (nonatomic, copy) ReturnBlock block;

@end
