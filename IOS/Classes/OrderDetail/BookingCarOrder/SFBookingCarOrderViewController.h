//
//  SFBookingCarOrderViewController.h
//  SFLIS
//
//  Created by kit on 2017/12/1.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "BaseViewController.h"
#import "SFCarListModel.h"

@interface SFBookingCarOrderViewController : BaseViewController

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, strong) NSArray <SFCarListModel *>*carListArray;
@end
