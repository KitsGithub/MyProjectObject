//
//  SFDriverSignController.h
//  SFLIS
//
//  Created by kit on 2017/11/21.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    IdentiflyType_Driver = 0,
    IdentiflyType_User,
} IdentiflyType;

@interface SFIdentflyPhoneController : BaseViewController

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, assign) IdentiflyType identiflyType;

@end
