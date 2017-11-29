//
//  SFFiltrateBar.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/16.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, SFFiltrateBarType) {
    SFFiltrateBarTypeCar,
    SFFiltrateBarTypeGoods
};

@interface SFFiltrateBar : UIView
{
    
    
}

@property (nonatomic,strong)UIButton  *cartypeBtn;

@property (nonatomic,strong)UIButton  *goodstypeBtn;

@property (nonatomic,strong)UIView  *line;

@property (nonatomic,strong)UIView *bottonLine;

@property (nonatomic,strong)UIView *topLine;

@property (nonatomic,copy)NSArray <NSString *>*carTypeArray;

@property (nonatomic,copy)NSArray <NSString *>*goodsTypeArry;

@property (nonatomic,copy)void(^seletedCompletion)(SFFiltrateBarType type,NSInteger seletedIndex,NSString *reusult);


- (void)setGoodstypeBtnHidden:(BOOL)isHidden;

@end
