//
//  SFMutilBtnMenuView.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/17.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFButtonView.h"

@interface SFMutilBtnMenuView : UIView

@property (nonatomic,strong)SFButtonView *buttonView;

- (void)dismiss;

- (instancetype)initWithItems:(NSArray *)items;

+ (SFMutilBtnMenuView *)showFromView:(UIView *)view titles:(NSArray <NSString *>*)titles selectedIndex:(NSInteger)index completion:(void(^)(NSString *result,NSInteger index))completion;

@end
