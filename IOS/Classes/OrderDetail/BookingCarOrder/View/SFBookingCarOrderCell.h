//
//  SFBookingCarOrderCell.h
//  SFLIS
//
//  Created by kit on 2017/12/1.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFBookingCarModel.h"
@class SFBookingCarOrderCell;
@protocol SFBookingCarOrderCellDelegate <NSObject>

- (void)SFBookingCarOrderCellDidClickDelButton:(SFBookingCarOrderCell *)cell;

@end

@interface SFBookingCarOrderCell : UITableViewCell

@property (nonatomic, weak) SFBookingCarModel *model;

@property (nonatomic, weak) id <SFBookingCarOrderCellDelegate> delegate;

@end
