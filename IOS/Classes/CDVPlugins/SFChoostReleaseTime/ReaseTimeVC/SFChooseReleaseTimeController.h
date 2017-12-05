//
//  SFChooseReleaseTimeController.h
//  SFLIS
//
//  Created by kit on 2017/11/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ChooseCarReturnBlock)(NSString *timeStr);

@interface SFChooseReleaseTimeController : BaseViewController

@property (nonatomic, copy) ChooseCarReturnBlock block;

@end
