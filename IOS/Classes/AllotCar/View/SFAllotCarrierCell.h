//
//  SFAllotCarrierCell.h
//  SFLIS
//
//  Created by kit on 2017/11/15.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFCarrierProtocol.h"
@class SFAllotCarrierCell;
@protocol SFAllotCarrierCellDelegate <NSObject>

@optional
- (void)SFAllotCarrierCell:(SFAllotCarrierCell *)cell didSelectedButtonWithIndex:(NSInteger)index;


/**
 点击了功能按钮
 @param index 0:首发  1:删除
 */
- (void)SFAllotCarrierCell:(SFAllotCarrierCell *)cell didSelectedOptionsWithIndex:(NSInteger)index;

@end

@interface SFAllotCarrierCell : UITableViewCell

@property (nonatomic, weak) id <SFCarrierProtocol> model;

@property (nonatomic, weak) id <SFAllotCarrierCellDelegate> delegate;

@property (nonatomic, assign) BOOL enableEdditting;

@end
