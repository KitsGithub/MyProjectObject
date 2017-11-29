//
//  SFOpration.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/20.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFOpration : NSObject


@property (nonatomic,strong)NSString *title;

@property (nonatomic,copy)void(^oprationBlock)(id);


@end
