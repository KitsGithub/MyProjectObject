//
//  SFAddCarrierDriverCell.h
//  SFLIS
//
//  Created by kit on 2017/11/27.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFDriverModel.h"

@interface SFAddCarrierDriverCell : UITableViewCell

@property (nonatomic, weak) SFDriverModel *driverModel;
@property (nonatomic, assign, readonly) BOOL selectedDriver;

@end
