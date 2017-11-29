//
//  SFOprationImageView.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/11/2.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFOprationImageView;
typedef void(^SFOprationImageViewResultBlock)(SFOprationImageView *);

@interface SFOprationImageView : UIView
{
    UIImage *_image;
}

@property (nonatomic,strong)UIImageView  *imgView;


@property (nonatomic,strong)UILabel   *descLable;


@property (nonatomic,strong)UIButton  *deleteBtn;


@property (nonatomic,strong)UIImage  *image;


@property (nonatomic,copy)void(^clickAction)(SFOprationImageView *imgView);


@end
