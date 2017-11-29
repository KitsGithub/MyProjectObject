//
//  SFMutilBtnMenuView.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/17.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFMutilBtnMenuView.h"

@interface SFMutilBtnMenuView()<SFButtonViewDelegate>

@property (nonatomic,assign)NSInteger selectedIndex;

@property (nonatomic,copy)void(^completion)(NSString *reuslt,NSInteger index);

@property (nonatomic,strong)NSArray *resourceArray;

@property (nonatomic,strong)UIView  *contentView;

@property (nonatomic,weak)UIView *sourceView;

@end

@implementation SFMutilBtnMenuView

- (instancetype)initWithItems:(NSArray *)items
{
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 204)]) {
        _resourceArray  = items;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    self.backgroundColor  = [UIColor colorWithWhite:0.0 alpha:0.2];
    
    _contentView  = [[UIView alloc] initWithFrame:self.bounds];
    _contentView.backgroundColor  = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    
    _buttonView = [[SFButtonView alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, [self buttonViewHieght])];
    [_buttonView setTitleViewWithArray:self.resourceArray];
    _buttonView.delegate = self;
    _buttonView.buttonPadding = 14;
    [self.contentView addSubview:_buttonView];
    
}

- (void)showWithSourceView:(UIView *)sourceView Completion:(void(^)(NSString *result,NSInteger index))completion
{
    self.completion = completion;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *overView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    overView.backgroundColor  = [UIColor clearColor];
    [window addSubview:overView];
    
    CGRect from   = [sourceView convertRect:sourceView.superview.bounds toView:overView];
    from.size.width = sourceView.bounds.size.width;
    from.size.height = sourceView.bounds.size.height;
    CGFloat height = overView.bounds.size.height  - CGRectGetMaxY(from) + [self buttonViewHieght];
    self.frame = (CGRect){{from.origin.x,CGRectGetMaxY(from)},{self.bounds.size.width - from.origin.x,height}};
    
   
    [overView addSubview:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBg:)];
    [overView addGestureRecognizer:tap];
    
    
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    self.buttonView.selectedIndex  = selectedIndex;
}


- (void)tapBg:(UIButton *)sender
{
    if (self.completion) {
        self.completion(nil,-1);
    }
    [self dismiss];
}

- (void)dismiss
{
    UIView *overView = self.superview;
    [self removeFromSuperview];
    [overView removeFromSuperview];
}


- (CGFloat)buttonViewHieght
{
    return  ceilf(self.resourceArray.count / 4.0) * (36 + 14);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame  = CGRectMake(0, 0, SCREEN_WIDTH, [self buttonViewHieght] + 10);
}

+ (SFMutilBtnMenuView *)showFromView:(UIView *)view titles:(NSArray <NSString *>*)titles selectedIndex:(NSInteger)index completion:(void(^)(NSString *result,NSInteger index))completion
{
    SFMutilBtnMenuView *menu = [[SFMutilBtnMenuView alloc] initWithItems:titles];
    if (index >= 0) {
        menu.selectedIndex  = index;
    }
    [menu showWithSourceView:view Completion:completion];
    return menu;
}

- (void)SFButtonView:(SFButtonView *)buttonView didSelectedButtonIndex:(NSInteger)index
{
    _selectedIndex = index;
    if (self.completion) {
        NSAssert(index < self.resourceArray.count, @"SFButtonView didSelectedButtonIndex index mast more than resourceArray's count");
        self.completion(self.resourceArray[index],index);
    }
     [self dismiss];
}

@end
