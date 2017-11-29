//
//  PersonalSettingCell.h
//  SFLIS
//
//  Created by kit on 2017/11/2.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalSettingCell : UITableViewCell

@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, copy) NSString *detailStr;

@property (nonatomic, assign) BOOL showHeaderView;
@property (nonatomic, assign) BOOL showArrowImage;

@end
