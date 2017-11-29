//
//  SFAuthImageView.m
//  SFLIS
//
//  Created by kit on 2017/11/21.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFAuthImageView.h"

@implementation SFAuthImageView {
    UIView *_holderView;
    UILabel *_placeHoder;
}

- (instancetype)initWithImage:(UIImage *)image placeHolderText:(NSString *)str {
    if (self = [super initWithImage:image]) {
        [self setupView:str];
    }
    return self;
}

- (void)setupView:(NSString *)placeHolderStr {
    self.userInteractionEnabled = YES;
    
    self.backgroundColor = COLOR_LINE_DARK;
    self.layer.cornerRadius = 3;
    self.clipsToBounds = YES;
    
    _holderView = [UIView new];
    _holderView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self addSubview:_holderView];
    
    _placeHoder = [UILabel new];
    _placeHoder.textAlignment = NSTextAlignmentCenter;
    _placeHoder.font = [UIFont systemFontOfSize:14];
    _placeHoder.textColor = [UIColor whiteColor];
    _placeHoder.text = placeHolderStr;
    [self addSubview:_placeHoder];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)imageClick:(UIGestureRecognizer *)gesture {
    if (self.tapAction) {
        self.tapAction(self);
    }
}




- (void)layoutSubviews {
    [super layoutSubviews];
    
    _holderView.frame = self.bounds;
    _placeHoder.frame = self.bounds;
}


@end
