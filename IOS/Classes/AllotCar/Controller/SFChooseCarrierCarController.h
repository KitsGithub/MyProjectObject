//
//  SFChooseCarrierCarController.h
//  SFLIS
//
//  Created by kit on 2017/11/27.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ResultReturnBlock)(NSString *carId,NSString *carNum);

@interface SFChooseCarrierCarController : BaseViewController

@property (nonatomic, copy) NSString *selectedNum;

@property (nonatomic, copy) ResultReturnBlock resultReturnBlock;


@end
