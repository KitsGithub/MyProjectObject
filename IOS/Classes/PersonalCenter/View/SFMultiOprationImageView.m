//
//  SFMultiOprationImageView.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/11/2.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFMultiOprationImageView.h"

@implementation SFMultiOprationImageView

- (void)reset
{
    self.numberOfItem = 0;
    for (SFOprationImageView *imgView in self.subviews) {
        if ([imgView isKindOfClass:[SFOprationImageView class]]) {
            [imgView removeFromSuperview];
        }
    }
}
- (void)setUrls:(NSArray <NSString *>*_Nullable)urls placeHolds:(NSArray <UIImage *>*)images
{
    for (int i = 0; i < images.count; i++) {
        SFOprationImageView *imgView = [[SFOprationImageView alloc] initWithFrame:CGRectZero];
        if (urls.count > i) {
            [imgView.imgView sd_setImageWithURL:[NSURL URLWithString:urls[i]] placeholderImage:images[i]];
        }else{
            imgView.image  = images[i];
        }
        imgView.descLable.hidden  = YES;
        imgView.tag  = i;
        [self addSubview:imgView];
    }
    self.numberOfItem = images.count;
}

- (void)addItemsWithDesc:(NSString *_Nullable)desc image:(UIImage *_Nullable)image url:(NSString
                                                                                         *)url action:(SFOprationImageViewResultBlock _Nullable )action
{
    SFOprationImageView *imgView = [[SFOprationImageView alloc] initWithFrame:CGRectZero];
    imgView.descLable.text  = desc;
    imgView.image  = image;
    imgView.clickAction = action;
    imgView.tag  = self.numberOfItem;
    [self addSubview:imgView];
    self.numberOfItem++;
    if (url) {
        [imgView.imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:image];
    }
}

- (CGFloat)itemWidth
{
    CGFloat  spacing  = 20;
    return  ([UIScreen mainScreen].bounds.size.width - 3 * spacing) / 2;
//    CGFloat  w = 142;

//    if ((w * 2 + spacing * 3) > [UIScreen mainScreen].bounds.size.width ) {
//        return  ([UIScreen mainScreen].bounds.size.width - 3 * spacing) / 2;
//    }
//    return w;
}

- (CGFloat)itemHeigt
{
    return [self itemWidth] * 88 / 142;
}

- (CGFloat)calculateHeihgt
{
    CGFloat maxY = self.bounds.size.height;
    NSInteger index = [self numberOfItem] - 1;
    CGFloat y  = (int)(index / 2) * ([self itemHeigt] + 20);
    maxY  = y + [self itemHeigt];
    return maxY;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat maxY = self.bounds.size.height;
    for (SFOprationImageView *imgView in self.subviews) {
        if ([imgView isKindOfClass:[SFOprationImageView class]]) {
            NSInteger index = imgView.tag;
            CGFloat y  = (int)(index / 2) * ([self itemHeigt] + 20);
            CGFloat x = (index % 2) * ([self itemWidth] + 20 );
            if (x < 0) {
                x = 0;
            }
            imgView.frame  = CGRectMake(x, y, [self itemWidth], [self itemHeigt]);
            maxY  = CGRectGetMaxY(imgView.frame);
        }
    }
    self.frame  = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, maxY);
}


@end
