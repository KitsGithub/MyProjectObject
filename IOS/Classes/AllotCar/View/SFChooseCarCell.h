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

- (void)showTickImage:(BOOL)hidden;

@end
