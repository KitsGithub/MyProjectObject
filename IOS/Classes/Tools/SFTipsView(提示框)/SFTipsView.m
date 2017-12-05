//
//  SFTipsView.m
//  SFLIS
//
//  Created by kit on 2017/10/11.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFTipsView.h"

#define SuccessColor [UIColor colorWithHexString:@"7bd066"]
#define FailureColor [UIColor colorWithHexString:@"e65c5c"]

static SFTipsView *tipsView;

@interface SFTipsView ()

@property (nonatomic, assign) BOOL animating;

@end

@implementation SFTipsView {
    UILabel *_tipsLabel;
    
    BOOL hasSubView;
}


+ (instancetype)shareView {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tipsView = [[SFTipsView alloc] init];
    });
    return tipsView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, 64)]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _tipsLabel = [UILabel new];
    _tipsLabel.font = FONT_COMMON_16;
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    _tipsLabel.textColor = [UIColor whiteColor];
    [self addSubview:_tipsLabel];
    
    
    UISwipeGestureRecognizer *swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipeUpGesture];
    
    hasSubView = YES;
}

- (void)layoutSubviews {
    if (hasSubView) {
        
        _tipsLabel.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
        hasSubView = NO;
    }
}

- (BOOL)isAnimation {
    
    for (UIView *view in self.window.subviews) {
        if ([view isKindOfClass:[self class]]) {
            self.animating = YES;
        }
    }
    
    if (self.animating) {
        return YES;
    }
    return NO;
}


- (void)swipeUp:(UISwipeGestureRecognizer *)gesture {
    NSLog(@"往上滑动了");
    [self hiddenAnimation];
}

/**
 展示动画
 
 @param title 标题
 */
- (void)showSuccessWithTitle:(NSString *)title {
    if ([self isAnimation]) {
        NSLog(@"上次动画未结束");
        return;
    }
    
    self.backgroundColor = SuccessColor;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    _tipsLabel.text = title;
    
    [self showAnimation];
}

/**
 失败动画

 @param title 标题
 */
- (void)showFailureWithTitle:(NSString *)title {
    if ([self isAnimation]) {
        NSLog(@"上次动画未结束");
        return;
    }
    
    self.backgroundColor = FailureColor;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    _tipsLabel.text = title;
    
    [self showAnimation];
}


/**
 统一展示动画
 */
- (void)showAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self isAnimation]) {
                [self hiddenAnimation];
            }
        });
    }];
}


/**
 统一失败动画
 */
- (void)hiddenAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, -64, SCREEN_WIDTH, 64);
    } completion:^(BOOL finished) {
        self.animating = NO;
        [self removeFromSuperview];
    }];
}




@end
