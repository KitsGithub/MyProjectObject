//
//  HomeViewCell.h
//  SFLIS
//
//  Created by kit on 2017/10/9.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsSupply.h"
#import "CarsSupply.h"

@class HomeViewCell;
@protocol HomeViewCellDelegate <NSObject>

- (void)HomeViewCell:(HomeViewCell *)cell didClickOptionButton:(UIButton *)button;

@end

@interface HomeViewCell : UITableViewCell

- (void)setModel:(GoodsSupply *)model withResourceType:(ResourceType)resourceType;

@property (nonatomic, weak) GoodsSupply *model;
@property (nonatomic, assign) ResourceType resourceType;
@property (nonatomic, weak) id <HomeViewCellDelegate> delegate;

@end
