//
//  UIViewController+Extension.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/27.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIViewController(Extension)

+ (UIViewController *)currentTopViewController;

+ (UIViewController *)viewControllerWithUrl:(NSString *)url;


@end
