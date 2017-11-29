//
//  SFSegmentView.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFSegmentView : UIView

@property (nonatomic,assign)NSInteger  currentIndex;
@property (nonatomic,strong)UIFont *font;

@property (nonatomic,copy)NSArray *items;

@property (nonatomic,assign)CGFloat  lineWidth;

@property (nonatomic,copy)void(^selectedBlock)(NSInteger);

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray <NSString *>*)items font:(UIFont *)font;

@end

