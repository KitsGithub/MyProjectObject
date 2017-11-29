//
//  SFChangeNickNameController.h
//  SFLIS
//
//  Created by kit on 2017/11/13.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "BaseViewController.h"

@interface SFChangeNickNameController : BaseViewController

- (instancetype)initWithNickName:(NSString *)nickName;

@property (nonatomic, copy) NSString *nickName;

@end
