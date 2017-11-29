//
//  UIImage+Extension.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/16.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "UIImage+Extension.h"
#import <QuartzCore/QuartzCore.h>
@implementation UIImage (Extension)


+ (instancetype)arrowDown
{
    return [self arrowWithSize:CGSizeMake(11, 6) color:[UIColor colorWithHexString:@"#3d3d3d"] isSoid:NO dirrection:(UIImageDirectionDown)];
}

+ (instancetype)arrowUp
{
    return [self arrowWithSize:CGSizeMake(11, 6) color:[UIColor colorWithHexString:@"#3d3d3d"] isSoid:NO dirrection:(UIImageDirectionUp)];
}

+ (instancetype)soidArrowDown
{
    return [self arrowWithSize:CGSizeMake(11, 6) color:[UIColor colorWithHexString:@"#3d3d3d"] isSoid:YES dirrection:(UIImageDirectionDown)];
}

+ (instancetype)soidArrowUp
{
    return [self arrowWithSize:CGSizeMake(11, 6) color:[UIColor colorWithHexString:@"#3d3d3d"] isSoid:YES dirrection:(UIImageDirectionUp)];
}
+ (instancetype)backImage
{
    return [self arrowWithSize:CGSizeMake(8, 16) color:COLOR_TEXT_COMMON isSoid:NO dirrection:(UIImageDirectionLeft)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
    return UIGraphicsGetImageFromCurrentImageContext();
}

+ (instancetype)arrowWithSize:(CGSize)size color:(UIColor *)color isSoid:(BOOL)isSoid dirrection:(UIImageDirection)direction
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    switch (direction) {
        case UIImageDirectionDown:
            CGContextMoveToPoint(context, 0, 0);
            CGContextAddLineToPoint(context, size.width * 0.5, size.height);
            CGContextAddLineToPoint(context, size.width, 0);
            break;
        case UIImageDirectionUp:
            CGContextMoveToPoint(context, 0, size.height);
            CGContextAddLineToPoint(context, size.width * 0.5, 0);
            CGContextAddLineToPoint(context, size.width, size.height);
            break;
        case UIImageDirectionLeft:
            CGContextMoveToPoint(context, size.width, 0);
            CGContextAddLineToPoint(context, 0, size.height * 0.5);
            CGContextAddLineToPoint(context, size.width, size.height);
            break;
        case UIImageDirectionRight:
            CGContextMoveToPoint(context, 0, 0);
            CGContextAddLineToPoint(context, size.width, size.height * 0.5);
            CGContextAddLineToPoint(context, 0, size.height);
            break;
        default:
            break;
    }
    if (isSoid) {
        CGContextFillPath(context);
    }else{
        CGContextStrokePath(context);
    }
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    return img;
}


@end
