//
//  SFChooseCarrierCarController.h
//  SFLIS
//
//  Created by kit on 2017/11/27.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "BaseViewController.h"
@class SFCarListModel;

typedef enum : NSUInteger {
    TypeMode_SingleChooser = 0,
    TypeMode_MoreChooser,
    TypeMode_H5MoreChooser
} TypeMode;

typedef void(^ResultReturnBlock)(NSArray <SFCarListModel *> *modelArray);

@interface SFChooseCarrierCarController : BaseViewController


/**
 多个车牌
 */
@property (nonatomic, strong) NSMutableArray *selectedCarArray;

@property (nonatomic, copy) ResultReturnBlock resultReturnBlock;

//指定某种类型的车型与车长
@property (nonatomic, copy) NSString *carType;
@property (nonatomic, copy) NSString *carLong;

@property (nonatomic, assign) TypeMode typeMode;

@end
