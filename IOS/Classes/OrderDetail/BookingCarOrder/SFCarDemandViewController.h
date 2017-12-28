//
//  SFCarDemandViewController.h
//  SFLIS
//
//  Created by kit on 2017/12/1.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "BaseViewController.h"
#import "SFBookingCarModel.h"

typedef void(^addCarComfirmBlock)(SFBookingCarModel *model);

@interface SFCarDemandViewController : BaseViewController

@property (nonatomic, weak) SFBookingCarModel *bookingModel;
@property (nonatomic, strong) NSMutableArray <NSString *>*carTypeArray;
@property (nonatomic, copy) addCarComfirmBlock returnBlock;

@end
