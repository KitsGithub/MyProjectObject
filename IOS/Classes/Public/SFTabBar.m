//
//  SFTabBar.m
//  SFLIS
//
//  Created by kit on 2017/10/9.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFTabBar.h"

@interface SFTabBar ()

@property(nonatomic, strong) UIButton *centerButton;
@property(nonatomic, strong) UILabel *centerTitle;

@end

@implementation SFTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}


- (void)setupView {
    self.translucent = NO;
    
    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.centerButton = plusBtn;
    [plusBtn addTarget:self action:@selector(plusBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:plusBtn];
    
    UILabel *lblTitle = [[UILabel alloc] init];
    self.centerTitle = lblTitle;
    lblTitle.font = [UIFont systemFontOfSize:10];
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lblTitle];
    
}

-(void)plusBtnDidClick{
    if (self.tabDelegate && [self.tabDelegate respondsToSelector:@selector(tabBar:clickCenterButton:)]) {
        [self.tabDelegate tabBar:self clickCenterButton:self.centerButton];
    }
}

// 调整子视图的布局
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.frame.size.width / 3;
    Class class = NSClassFromString(@"UITabBarButton");
    for (UIView *view in self.subviews) {
        if ([view isEqual:self.centerTitle]) {//self.centerButton
            view.frame = CGRectMake(CGRectGetMinX(self.centerButton.frame), CGRectGetMaxY(self.centerButton.frame) , CGRectGetWidth(self.centerButton.frame), 10);
            
        }else if ([view isEqual:self.centerButton]) {//self.centerButton
            view.frame = CGRectMake(0, 0, width, self.frame.size.height);
            [view sizeToFit];
            view.center = CGPointMake(self.frame.size.width/2, 9);
        }else if ([view isKindOfClass:class]){//system button
            CGRect frame = view.frame;
            int indexFromOrign = view.frame.origin.x/width;//防止UIView *view in self.subviews 获取到的不是有序的
            if (indexFromOrign >= (3 - 1) / 2) {
                indexFromOrign++;
            }
            CGFloat x = indexFromOrign * width;
            //如果是系统的UITabBarButton，那么就调整子控件位置，空出中间位置
            view.frame = CGRectMake(x, view.frame.origin.y, width, frame.size.height);
            
            //调整badge postion
            for (UIView *badgeView in view.subviews){
                NSString *className = NSStringFromClass([badgeView class]);
                // Looking for _UIBadgeView
                if ([className rangeOfString:@"BadgeView"].location != NSNotFound){
                    badgeView.layer.transform = CATransform3DIdentity;
                    badgeView.layer.transform = CATransform3DMakeTranslation(-17.0, 1.0, 1.0);
                    break;
                }
            }
        }
    }
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isHidden == NO) {
        //将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
        CGPoint newP = [self convertPoint:point toView:self.centerButton];
        
        //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
        if ( [self.centerButton pointInside:newP withEvent:event]) {
            return self.centerButton;
        }else{//如果点不在发布按钮身上，直接让系统处理就可以了
            return [super hitTest:point withEvent:event];
        }
    }
    else {//tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}

-(void)setCenterBtnIcon:(NSString *)centerBtnIcon{
    _centerBtnIcon = centerBtnIcon;
    [self.centerButton setBackgroundImage:[UIImage imageNamed:self.centerBtnIcon] forState:UIControlStateNormal];
    [self.centerButton setBackgroundImage:[UIImage imageNamed:self.centerBtnIcon] forState:UIControlStateHighlighted];
}

-(void)setCenterBtnTitle:(NSString *)centerBtnTitle{
    _centerBtnTitle = centerBtnTitle;
    self.centerTitle.text = centerBtnTitle;
}


@end
