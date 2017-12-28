//
//  SFLoaddingResult.m
//  SFLIS
//
//  Created by kit on 2017/12/20.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFLoaddingView.h"
#import <UIImage+GIF.h>
static SFLoaddingView *result;
@implementation SFLoaddingView {
    UIImageView *_tipsImageV;
    UIImageView *_animationImageV;
    UILabel *_tipsLabel;
    
    UIButton *_actionButton;
}

+ (void)showResultWithResuleType:(SFLoaddingResultType)type toView:(UIView *)view reloadBlock:(ReloadDataBlock)reloadBlock {
    
    if (!result) {
        result = [[SFLoaddingView alloc] initWithFrame:view.bounds];
    }
    result.frame = view.bounds;
    result.resultType = type;
    result.reloadBlock = reloadBlock;
    result.backgroundColor = [UIColor whiteColor];
    [view addSubview:result];
    [view bringSubviewToFront:result];
}

+ (void)loaddingToView:(UIView *)view {
    if (!result) {
        result = [[SFLoaddingView alloc] initWithFrame:view.bounds];
    }
    result.frame = view.bounds;
    result.resultType = SFLoaddingResultType_Loadding;
    result.reloadBlock = nil;
    result.backgroundColor = [UIColor whiteColor];
    [view addSubview:result];
    
    [result setNeedsLayout];
}

+ (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        result.alpha = 0;
    } completion:^(BOOL finished) {
        if (result) {
            [result removeFromSuperview];
            result = nil;
        }
    }];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    
    _actionButton = [UIButton new];
    [_actionButton addTarget:self action:@selector(reloadAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_actionButton];
    
    _tipsImageV = [UIImageView new];
    [self addSubview:_tipsImageV];
    
    _animationImageV = [UIImageView new];
    [self addSubview:_animationImageV];
    
    _tipsLabel = [UILabel new];
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    _tipsLabel.font = FONT_COMMON_14;
    _tipsLabel.textColor = COLOR_TEXT_DARK;
    [self addSubview:_tipsLabel];
}

- (void)reloadAction {
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}

- (void)setResultType:(SFLoaddingResultType)resultType {
    _resultType = resultType;
    _animationImageV.hidden = YES;
    NSString *imageName = @"";
    NSString *tipStr = @"";
    switch (resultType) {
        case SFLoaddingResultType_NoSearchResult:
            imageName = @"NoSearchResult";
            tipStr = @"未搜索到结果";
            break;
        case SFLoaddingResultType_NetworkingFail:
            imageName = @"NeworkingFail";
            tipStr = @"网络错误，点击屏幕重新加载";
            break;
        case SFLoaddingResultType_LoaddingFail:
            imageName = @"LoaddingFail";
            tipStr = @"加载不成功，点击屏幕重新加载";
            break;
        case SFLoaddingResultType_NoCommonResult:
            imageName = @"NoCommonResult";
            tipStr = @"还没有评论";
            break;
        case SFLoaddingResultType_WebViewNoFondFail:
            imageName = @"404Fail";
            tipStr = @"404，页面的丢失";
            break;
        case SFLoaddingResultType_NoMoreData:
            imageName = @"NoMoreData";
            tipStr = @"暂无数据";
            break;
        case SFLoaddingResultType_Loadding: {
            _animationImageV.hidden = NO;
            _animationImageV.animationImages = @[[UIImage imageNamed:@"Loadding_1"],[UIImage imageNamed:@"Loadding_2"],[UIImage imageNamed:@"Loadding_3"]];
            _animationImageV.animationDuration = 0.5;
            _animationImageV.animationRepeatCount = 0;
            [_animationImageV startAnimating];
            break;
        }
        default:
            break;
    }
    _tipsImageV.image = [UIImage imageNamed:imageName];
    _tipsLabel.text = tipStr;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    _actionButton.frame = self.bounds;

    _tipsImageV.frame = CGRectMake((SCREEN_WIDTH - 120) * 0.5, (SCREEN_HEIGHT - 100 - 44 - 64) * 0.5, 120, 100);
    
    _animationImageV.frame = CGRectMake((SCREEN_WIDTH - 162) * 0.5, (SCREEN_HEIGHT - 80 - 44 - 64) * 0.5, 162, 80);
    
    _tipsLabel.frame = CGRectMake(0, CGRectGetMaxY(_tipsImageV.frame) + 30, SCREEN_WIDTH, 14);
}

@end
