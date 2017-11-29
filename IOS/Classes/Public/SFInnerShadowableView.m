//
//  SFShadowableView.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/11.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFInnerShadowableView.h"

@implementation SFInnerShadowableView


 - (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius  = cornerRadius;
    self.layer.cornerRadius  = cornerRadius;
}

- (void)setShadowColor:(UIColor *)shadowColor
{
    _shadowColor  = shadowColor;
//    self.layer.shadowColor  = shadowColor.CGColor; 
}


- (void)setShadowOffset:(CGSize)shadowOffset
{
    _shadowOffset  = shadowOffset;
//    self.layer.shadowOffset  = shadowOffset;
}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    _shadowRadius  = shadowRadius;
//    self.layer.shadowRadius  = shadowRadius;
}


- (void)setShadowOpacity:(CGFloat)shadowOpacity
{
    _shadowOpacity = shadowOpacity;
//    self.layer.shadowOpacity  = shadowOpacity;
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



- (void)drawRect:(CGRect)rect
{
    
    CGRect bounds = [self bounds];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat radius = self.cornerRadius;
    
    
    // Create the "visible" path, which will be the shape that gets the inner shadow
    // In this case it's just a rounded rect, but could be as complex as your want
    CGMutablePathRef visiblePath = CGPathCreateMutable();
    CGRect innerRect = CGRectInset(bounds, radius, radius);
    CGPathMoveToPoint(visiblePath, NULL, innerRect.origin.x, bounds.origin.y);
    CGPathAddLineToPoint(visiblePath, NULL, innerRect.origin.x + innerRect.size.width, bounds.origin.y);
    CGPathAddArcToPoint(visiblePath, NULL, bounds.origin.x + bounds.size.width, bounds.origin.y, bounds.origin.x + bounds.size.width, innerRect.origin.y, radius);
    CGPathAddLineToPoint(visiblePath, NULL, bounds.origin.x + bounds.size.width, innerRect.origin.y + innerRect.size.height);
    CGPathAddArcToPoint(visiblePath, NULL,  bounds.origin.x + bounds.size.width, bounds.origin.y + bounds.size.height, innerRect.origin.x + innerRect.size.width, bounds.origin.y + bounds.size.height, radius);
    CGPathAddLineToPoint(visiblePath, NULL, innerRect.origin.x, bounds.origin.y + bounds.size.height);
    CGPathAddArcToPoint(visiblePath, NULL,  bounds.origin.x, bounds.origin.y + bounds.size.height, bounds.origin.x, innerRect.origin.y + innerRect.size.height, radius);
    CGPathAddLineToPoint(visiblePath, NULL, bounds.origin.x, innerRect.origin.y);
    CGPathAddArcToPoint(visiblePath, NULL,  bounds.origin.x, bounds.origin.y, innerRect.origin.x, bounds.origin.y, radius);
    CGPathCloseSubpath(visiblePath);
    
    // Fill this path
    UIColor *aColor = self.backgroundColor;
    [aColor setFill];
    CGContextAddPath(context, visiblePath);
    CGContextFillPath(context);
    
    
    // Now create a larger rectangle, which we're going to subtract the visible path from
    // and apply a shadow
    CGMutablePathRef path = CGPathCreateMutable();
    //(when drawing the shadow for a path whichs bounding box is not known pass "CGPathGetPathBoundingBox(visiblePath)" instead of "bounds" in the following line:)
    //-42 cuould just be any offset > 0
    CGPathAddRect(path, NULL, CGRectInset(bounds, self.shadowOpacity, self.shadowOpacity));
    
    // Add the visible path (so that it gets subtracted for the shadow)
    CGPathAddPath(path, NULL, visiblePath);
    CGPathCloseSubpath(path);
    
    // Add the visible paths as the clipping path to the context
    CGContextAddPath(context, visiblePath);
    CGContextClip(context);
    
    
    // Now setup the shadow properties on the context
    aColor =self.shadowColor;
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, self.shadowOffset, self.shadowRadius, [aColor CGColor]);
    
    // Now fill the rectangle, so the shadow gets drawn
    [aColor setFill];
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextEOFillPath(context);
    
    // Release the paths
    CGPathRelease(path);
    CGPathRelease(visiblePath);
    
    

}





@end
