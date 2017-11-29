//
//  BaseNavigationController.m
//  SFLIS
//
//  Created by kit on 2017/9/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "BaseNavigationController.h"
#import "SFSegmentControl.h"
#import "BaseViewController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController{
    UIView *_lineView;
}


+ (void)initialize
{
    [self setupNavBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //隐藏导航栏底线
    UIImageView *navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationBar];
    navBarHairlineImageView.hidden = YES;
    CGRect frame = navBarHairlineImageView.frame;
    
    _lineView = [[UIView alloc] initWithFrame:frame];
    _lineView.backgroundColor = COLOR_LINE_DARK;
    [self.navigationBar addSubview:_lineView];
    
    
}


+ (void)setupNavBar
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.barTintColor  = [UIColor whiteColor];
//    navBar.backIndicatorImage = [[UIImage imageNamed:@"Nav_Back"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
//    navBar.backIndicatorTransitionMaskImage = [[UIImage imageNamed:@"Nav_Back"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    
    [navBar setTintColor:COLOR_TEXT_COMMON];
    
    
    // 设置标题文字颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    [navBar setTitleTextAttributes:attrs];
    
    //设置BarButtonItem的主题
    UIBarButtonItem *item=[UIBarButtonItem appearance];
    
    //设置文字颜色
    NSMutableDictionary *itemAttrs=[NSMutableDictionary dictionary];
    itemAttrs[NSFontAttributeName]=[UIFont systemFontOfSize:14];
    itemAttrs[NSForegroundColorAttributeName]  =  BLACKCOLOR;
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    
    
    [item setBackgroundImage:[UIImage imageNamed:@"NavButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [item setBackgroundImage:[UIImage imageNamed:@"NavButtonPressed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    
    
    //设置返回按钮的背景
//    [item setBackButtonBackgroundImage:[UIImage imageNamed:@"leftMenu_back"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [item setBackButtonBackgroundImage:[UIImage imageNamed:@"leftMenu_back"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    
}

//通过一个方法来找到这个黑线(findHairlineImageViewUnder):
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)SetBottomLineViewHiden:(BOOL)hiden {
    [self.navigationBar bringSubviewToFront:_lineView];
    _lineView.hidden = hiden;
}



//- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item
//{
//    return YES;
//}


//- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
//{
//    BaseViewController *bvc = (BaseViewController *)self.topViewController;
//    if ([bvc willPopByNavigationController]) {
//        return  YES;
//    }else{
//        // do nothing
//        return NO;
//    }
//}


//- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
//{
//    BaseViewController *bvc = (BaseViewController *)self.topViewController;
//    if ([bvc willPopByNavigationController]) {
//        return  YES;
//    }else{
//        // do nothing
//        return NO;
//    }
//}


@end
