//
//  UIImage+Extension.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/16.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, UIImageDirection) {
    UIImageDirectionUp,
    UIImageDirectionDown,
    UIImageDirectionLeft,
    UIImageDirectionRight
};

@interface UIImage (Extension)

+ (instancetype)arrowDown;

+ (instancetype)arrowUp;

+ (instancetype)soidArrowDown;

+ (instancetype)soidArrowUp;

+ (instancetype)backImage;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 绘制并生成箭头图片

 @param size 图片的大小
 @param color 图片主题内容颜色
 @param isSoid 是否是实心的
 @param direction 箭头方向
 @return 绘制出的图片
 */
+ (instancetype)arrowWithSize:(CGSize)size color:(UIColor *)color isSoid:(BOOL)isSoid dirrection:(UIImageDirection)direction;


@end
