//
//  SFSegmentControl.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/9.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFSegmentControl : UIView


@property (nonatomic,strong)UIColor *bgColor;
@property (nonatomic,strong)UIColor *itemColor;
@property (nonatomic,strong)UIColor *selectedColor;
@property (nonatomic,strong)UIColor *titleColor;
@property (nonatomic,strong)UIColor *selectedTitleColor;
@property (nonatomic,strong)UIFont  *font;

@property (nonatomic,assign)CGFloat itemWidth;

@property (nonatomic,assign)NSInteger currentIndex;

@property (nonatomic,strong,readonly)NSArray *items;

@property (nonatomic,strong)void(^selectedBlock)(NSInteger index);


- (instancetype)initWithFrame:(CGRect)frame items:(NSArray <NSString *>*)items;

@end
