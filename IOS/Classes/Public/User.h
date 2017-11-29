//
//  User.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/9.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : SFObject

@property (nonatomic,strong)NSString *avartaUrl;


+ (instancetype)currentUser;

@end
