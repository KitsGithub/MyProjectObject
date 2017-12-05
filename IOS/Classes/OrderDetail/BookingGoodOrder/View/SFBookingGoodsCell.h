//
//  SFBookingGoodsCell.h
//  SFLIS
//
//  Created by kit on 2017/12/4.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFCarListModel.h"
@class SFBookingGoodsCell;
@protocol SFBookingGoodsCellDelegate <NSObject>

- (void)SFBookingGoodsCellDidSelectedDel:(SFBookingGoodsCell *)cell;

@end

@interface SFBookingGoodsCell : UITableViewCell

@property (nonatomic, strong) SFCarListModel *model;

@property (nonatomic, weak) id <SFBookingGoodsCellDelegate> delegate;

@end
