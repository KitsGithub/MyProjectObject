//
//  SFFiltrateBar.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/16.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFFiltrateBar.h"
#import "SFMutilBtnMenuView.h"

@interface SFFiltrateBar()
{
    BOOL _goodstypeBtnHidden;
}
@property (nonatomic,assign)NSInteger goodsType;

@property (nonatomic,assign)NSInteger carType;

@property (nonatomic,strong)SFMutilBtnMenuView *currentMenu;

@end

@implementation SFFiltrateBar


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self  = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void)setup
{
    self.backgroundColor  = [UIColor whiteColor];
    
    _cartypeBtn  = [self btnWithTitle:@"选择车型"];
    [self addSubview:_cartypeBtn];
   
    _goodstypeBtn = [self btnWithTitle:@"选择货物类型"];
    [self addSubview:_goodstypeBtn];
   
    
    
    _line  = [[UIView alloc] init];
    _line.backgroundColor  = COLOR_LINE_DARK;
    [self addSubview:_line];
    
    _bottonLine  = [[UIView alloc] init];
    _bottonLine.backgroundColor  = COLOR_LINE_DARK;
    [self addSubview:_bottonLine];
    
    _topLine  = [[UIView alloc] init];
    _topLine.backgroundColor  = COLOR_LINE_DARK;
    [self addSubview:_topLine];
    
    _carType  = -1;
    _goodsType = -1;
    
}

- (UIButton *)btnWithTitle:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:title forState:(UIControlStateNormal)];
    [btn setImage:[UIImage arrowWithSize:CGSizeMake(10, 6) color:COLOR_TEXT_COMMON isSoid:YES dirrection:(UIImageDirectionDown)] forState:(UIControlStateNormal)];
    [btn setImage:[UIImage arrowWithSize:CGSizeMake(10, 6) color:COLOR_TEXT_COMMON isSoid:YES dirrection:(UIImageDirectionUp)] forState:(UIControlStateSelected)];
    [btn setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
    btn.titleLabel.font  = FONT_COMMON_14;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    return btn;
}


- (void)btnClick:(UIButton *)sender
{
    if (sender == self.goodstypeBtn) {
        [self actionWithBtn:self.goodstypeBtn other:self.cartypeBtn type:&_goodsType];
    }else{
        [self actionWithBtn:self.cartypeBtn other:self.goodstypeBtn type:&_carType];
    }
}


- (void)actionWithBtn:(UIButton *)sender other:(UIButton *)other type:(NSInteger *)type
{
    SFFiltrateBarType btntype = sender == self.cartypeBtn ? SFFiltrateBarTypeCar : SFFiltrateBarTypeGoods;
    other.selected = NO;
    sender.selected  = YES;
    [self.currentMenu dismiss];
    NSArray *titles = btntype == SFFiltrateBarTypeCar ? self.carTypeArray : self.goodsTypeArry;
    __weak typeof(self)wself = self;
    self.currentMenu = [SFMutilBtnMenuView showFromView:self titles:titles selectedIndex:*type completion:^(NSString *result,NSInteger index) {
        sender.selected  = NO;
        wself.currentMenu = nil;
        if (result) {
            [sender setTitle:result forState:(UIControlStateNormal)];
            [wself adjustBtn:sender];
            *type = index;
            if (wself.seletedCompletion) {
                wself.seletedCompletion(btntype, index, result);
            }
        }
    }];
}


- (void)adjustBtn:(UIButton *)btn
{
    [btn interconvertImageAndTitleWithMargin:4];
}

- (void)setGoodstypeBtnHidden:(BOOL)isHidden
{
    _goodstypeBtnHidden  = isHidden;
    self.goodstypeBtn.hidden  = isHidden;
    self.line.hidden   = isHidden;
    
    self.cartypeBtn.hidden  = !isHidden;
    
    [self.goodstypeBtn setTitle:@"请选择货物类型" forState:UIControlStateNormal];
    [self.cartypeBtn setTitle:@"请选择车型" forState:UIControlStateNormal];
    
    self.carType  = -1;
    self.goodsType = -1;
    
    [self layoutSubviews];
   
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat itemWith = (self.bounds.size.width - 1) / 2;
    CGFloat itemHeight = self.bounds.size.height;
    
    
    if (_goodstypeBtnHidden) {
        
        _cartypeBtn.frame  = CGRectMake(0, 0, self.bounds.size.width, itemHeight);
        
    }else{
        
        _goodstypeBtn.frame  = CGRectMake(0, 0, self.bounds.size.width, itemHeight);
        
//        _line.frame  = CGRectMake(CGRectGetMaxX(self.goodstypeBtn.frame), (itemHeight - 22) * 0.5, 1, 22);
//        
//        _cartypeBtn.frame  = CGRectMake(CGRectGetMaxX(self.line.frame) + 1, 0, itemWith, itemHeight);
        
    }
    
    
    _bottonLine.frame  = CGRectMake(0, itemHeight - 1, self.bounds.size.width, 1);
    _topLine.frame  = CGRectMake(0, 0, self.bounds.size.width, 1);
    
    [self adjustBtn:self.cartypeBtn];
    [self adjustBtn:self.goodstypeBtn];
    
    
}


@end
