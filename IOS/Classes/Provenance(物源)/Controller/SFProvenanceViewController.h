//
//  SFProvenanceViewController.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SFProvenanceViewController : BaseViewController
{
    SFTakingStatus _currentprovenanceType;
}

// 当前主选择卡。发的／订的
@property (nonatomic,assign)SFProvenanceDirection currentDirection;

// 当前子选择卡  具体的类型
@property (nonatomic,assign)NSInteger  currentProvenanceIndex;

@property (nonatomic, assign) BOOL isPopToRootVc;

@end
