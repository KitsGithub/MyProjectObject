//
//  AuthcodeView.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/12.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthcodeView : UIView

@property (strong, nonatomic) NSArray *dataArray;//字符素材数组

@property (strong, nonatomic) NSMutableString *authCodeStr;//验证码字符串

@end
