//
//  SFSearchBarView.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/16.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, SFSearchBarViewTextFiledType) {
    SFSearchBarViewTextFiledTypeFrom,
    SFSearchBarViewTextFiledTypeTarget
};

@class SFSearchBarView;
@protocol SFSearchBarViewDelegate

- (void)searchBarViewDidClickSwitchBtn:(SFSearchBarView *)barView;
//- (void)searchBarView:(SFSearchBarView *)barView didClearWith
- (void)searchBarView:(SFSearchBarView *)barView fromTextFiledDidSelectedWithType:(SFSearchBarViewTextFiledType)textfiledType Completion:(void(^)(NSString *result))completion;

@end

@interface SFSearchBarView : UIView<UITextFieldDelegate>

@property (nonatomic,strong)UIButton *switchBtn;

@property (nonatomic,strong)UITextField  *fromTextfiled;

@property (nonatomic,strong)UITextField  *targetTextfiled;

@property (nonatomic,strong)UIView    *sepatateLine;

@property (nonatomic,copy)NSArray *switchItems;  // 左边切换选项。默认是 

@property (nonatomic,assign)NSInteger  seletedIndex;

@property (nonatomic,weak)id<SFSearchBarViewDelegate> delegate;

@end
