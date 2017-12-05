//
//  SFChooseCarCell.h
//  SFLIS
//
//  Created by kit on 2017/11/27.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFCarListModel.h"

@interface SFChooseCarCell : UITableViewCell

@property (nonatomic, weak) SFCarListModel *model;

/**
 0->单选  1->多选
 */
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign, readonly) BOOL SFSelected;
- (void)showTickImage:(BOOL)hidden;
- (void)setTickChoose;

@end
