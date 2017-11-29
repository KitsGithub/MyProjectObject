//
//  UIViewController+Extension.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/27.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "UIViewController+Extension.h"
#import "BaseCordvaViewController.h"

@implementation UIViewController(Extension)

+ (UIViewController *)currentTopViewController
{
    return [[[UIApplication sharedApplication].delegate window].rootViewController currentTopViewController];
}

- (UIViewController *)currentTopViewController
{
    UIViewController *presentedVc = [self presentedViewController];
    if (presentedVc) {
        [presentedVc currentTopViewController];
    }
    if ([self isKindOfClass:[UITabBarController class]]) {
        UITabBarController *vc = (UITabBarController *)self;
        return [[vc selectedViewController] currentTopViewController];
    }
    
    if ([self isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)self;
        return [[nav topViewController] currentTopViewController];
    }
    
    return self;
}

+ (UIViewController *)viewControllerWithUrl:(NSString *)url
{
    return [[[UIApplication sharedApplication].delegate window].rootViewController viewControllerWithUrl:url];
}

- (UIViewController *)viewControllerWithUrl:(NSString *)url
{
    if (![self isKindOfClass:[CDVViewController class]]) {
        return nil;
    }
    if ([[(CDVViewController *)self startPage] isEqualToString:url]) {
        return self;
    }
    
    
    if (self.childViewControllers.count) {
        for (UIViewController *subvc in self.childViewControllers) {
            if ([subvc viewControllerWithUrl:url]) {
                return subvc;
            }
        }
    }
    
    UIViewController *presentdVc = self.presentedViewController;
    if (presentdVc) {
        return [presentdVc viewControllerWithUrl:url];
    }
    
    if ([self isKindOfClass:[UINavigationController class]]) {
        UIViewController *presentdVc = [(UINavigationController *)self topViewController].presentedViewController;
        return [presentdVc viewControllerWithUrl:url];
    }
    
    return nil;
}

@end

