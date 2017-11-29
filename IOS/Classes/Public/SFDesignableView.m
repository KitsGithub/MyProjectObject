//
//  SFDisignableView.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/11.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFDesignableView.h"

@implementation SFDesignableView

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius  = cornerRadius;
    self.layer.cornerRadius  = cornerRadius;
}

- (void)setShadowColor:(UIColor *)shadowColor
{
    _shadowColor  = shadowColor;
        self.layer.shadowColor  = shadowColor.CGColor;
}


- (void)setShadowOffset:(CGSize)shadowOffset
{
    _shadowOffset  = shadowOffset;
        self.layer.shadowOffset  = shadowOffset;
}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    _shadowRadius  = shadowRadius;
        self.layer.shadowRadius  = shadowRadius;
}


- (void)setShadowOpacity:(CGFloat)shadowOpacity
{
    _shadowOpacity = shadowOpacity;
        self.layer.shadowOpacity  = shadowOpacity;
}


- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth  = borderWidth;
    self.layer.borderWidth  = borderWidth;
}


- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor  = borderColor;
    self.layer.borderColor  = borderColor.CGColor;
}


@end
