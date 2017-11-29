//
//  SFCarListCell.h
//  SFLIS
//
//  Created by kit on 2017/10/27.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFDriverModel.h"
@class SFDriverListCell;
@protocol SFDriverListCellDelegate <NSObject>

@optional
- (void)SFDriverListCell:(SFDriverListCell *)cell didSelectedOptionsAtIndex:(NSInteger)index ;

@end

@interface SFDriverListCell : UITableViewCell

@property (nonatomic, weak) SFDriverModel *model;

@property (nonatomic, weak) id <SFDriverListCellDelegate>delegate;

@end
