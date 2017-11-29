//
//  SFOprationImageView.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/11/2.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFOprationImageView.h"

@implementation SFOprationImageView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self  = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self  = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _imgView  = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_imgView];
    _imgView.userInteractionEnabled  = YES;
    _imgView.contentMode  = UIViewContentModeScaleAspectFill;
    _imgView.clipsToBounds  = YES;
    
    
    _descLable  = [[UILabel alloc] initWithFrame:CGRectZero];
    _descLable.textColor  = [UIColor whiteColor];
    _descLable.font      = FONT_COMMON_14;
    _descLable.textAlignment  = NSTextAlignmentCenter;
    [self addSubview:_descLable];
    _descLable.userInteractionEnabled = YES;
    
    _deleteBtn  = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self addSubview:_deleteBtn];
    
    
//    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnAction:)]];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.clickAction) {
        self.clickAction(self);
    }
}

//- (void)btnAction:(id)sender
//{
//    
//}

- (void)setImage:(UIImage *)image
{
    _image  = image;
    self.imgView.image  = image;
}


- (UIImage *)image
{
    _image  = self.imgView.image;
    return _image;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imgView.frame  = self.bounds;
    
    self.descLable.frame   = self.bounds;
    
    
}





@end
