//
//  SFTransportDetailCell.h
//  SFLIS
//
//  Created by kit on 2017/11/23.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFSignInfoModel.h"

@interface SFTransportDetailCell : UITableViewCell

@property (nonatomic, weak) SFSignInfoModel *model;

@property (nonatomic, assign) BOOL currentLoacted;
@property (nonatomic, assign) BOOL showLineView;

@end
