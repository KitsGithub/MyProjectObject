//
//  SFCarListCell.h
//  SFLIS
//
//  Created by kit on 2017/10/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFCarListModel.h"

@class SFCarListCell;
@protocol SFCarListCellDelegate <NSObject>

- (void)SFCarListCell:(SFCarListCell *)cell didSelectedOptionsWithIndex:(NSInteger)index;

@end

@interface SFCarListCell : UITableViewCell

@property (nonatomic, weak) SFCarListModel *model;
@property (nonatomic, weak) id <SFCarListCellDelegate> delegate;

@end
