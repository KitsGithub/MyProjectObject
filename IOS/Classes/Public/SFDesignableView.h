//
//  SFDisignableView.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/11.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>


IB_DESIGNABLE
@interface SFDesignableView : UIView


@property (nonatomic,assign)IBInspectable CGFloat cornerRadius;
@property (nonatomic,assign)IBInspectable CGFloat borderWidth;
@property (nonatomic,strong)IBInspectable UIColor *borderColor;

@property (nonatomic,strong)IBInspectable UIColor *shadowColor;

@property (nonatomic,assign)IBInspectable CGSize shadowOffset;

@property (nonatomic,assign)IBInspectable CGFloat shadowRadius;

@property (nonatomic,assign)IBInspectable CGFloat shadowOpacity;

@end
