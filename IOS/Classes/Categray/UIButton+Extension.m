//
//  UIButton+Extension.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/17.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)


- (void)interconvertImageAndTitleWithMargin:(CGFloat)margin
{
    CGFloat imageWidth = self.imageView.bounds.size.width + margin / 2.0f;
    CGFloat labelWidth = self.titleLabel.bounds.size.width + margin / 2.0f;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
}

@end
