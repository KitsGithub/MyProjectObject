//
//  SFTransportCell.h
//  SFLIS
//
//  Created by kit on 2017/11/22.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SFTransportCell;
typedef enum : NSUInteger {
    DataType_Transprot = 0,
    DataType_Finished,
} DataType;

@protocol SFTransportCellDelegate <NSObject>

/**
 点击了cell的功能按钮
 @param index 0:详情  1:到达 2:签到
 */
- (void)SFTransportCell:(SFTransportCell *)cell didSelectedButtonAtIndex:(NSInteger)index;

@end

@interface SFTransportCell : UITableViewCell

@property (nonatomic, assign) DataType dataType;

@property (nonatomic, weak) id <SFTransportCellDelegate> delegate;

@end
