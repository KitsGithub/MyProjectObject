//
//  SFAuthStatuViewController.h
//  SFLIS
//
//  Created by kit on 2017/11/20.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "BaseViewController.h"
#import "SFAuthStatusModle.h"
#import "SFDriverModel.h"

typedef void(^RetrunBlock)();

@interface SFAuthStatuViewController : BaseViewController

@property (nonatomic,strong)SFAuthStatusModle *statusModel;
@property (nonatomic,assign)SFAuthType  type;

@property (nonatomic, copy) NSString *guid;
@property (nonatomic, copy) RetrunBlock returnBlock;

- (instancetype)initWithType:(SFAuthType)type Status:(SFAuthStatusModle*)statusModel;

@end
