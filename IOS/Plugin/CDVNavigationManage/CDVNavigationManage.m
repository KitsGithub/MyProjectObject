                 //
//  CDVNavigationManage.m
//  TestHybird
//
//  Created by chaocaiwei on 2017/9/29.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "CDVNavigationManage.h"
#import "AppDelegate.h"

#import "SFProvenanceViewController.h"
#import "SFCarrierMessageController.h"


UIViewController *topVcIn(UIViewController* vc){
    UIViewController *presentedVc = [vc presentedViewController];
    if (presentedVc) {
        return topVcIn(presentedVc);
    }
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UIViewController *tvc = [(UITabBarController *)vc selectedViewController];
        return topVcIn(tvc);
    }
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UIViewController *nav = [(UINavigationController *)vc topViewController];
        return topVcIn(nav);
    }
    return vc;
}

UIViewController *currnetTopVc(){
    UIViewController *rootVc = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    return  topVcIn(rootVc);
}

UIViewController *fineVcIn(UIViewController *vc,NSString *url) 
{
    if (![vc isKindOfClass:[CDVViewController class]]) {
        return nil;
    }
    if ([[(CDVViewController *)vc startPage] isEqualToString:url]) {
        return vc;
    }
    if (vc.childViewControllers.count) {
        for (UIViewController *subvc in vc.childViewControllers) {
            if (fineVcIn(subvc, url)) {
                return subvc;
            }
        }
    }
    UIViewController *presentdVc = vc.presentedViewController;
    if (presentdVc) {
        return fineVcIn(presentdVc, url);
    }
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UIViewController *presentdVc = [(UINavigationController *)vc topViewController].presentedViewController;
        return fineVcIn(presentdVc, url);
    }
    return nil;
}
UIViewController *fineVc(NSString *url)
{
    UIViewController *rootVc = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    return fineVcIn(rootVc, url);
}

@interface CDVNavigationManage()

@property (nonatomic,strong)NSMutableArray *itemIds;

@end


@implementation CDVNavigationManage


- (NSMutableArray *)itemIds
{
    if (!_itemIds) {
        _itemIds  = [NSMutableArray new];
    }
    return _itemIds;
}

- (UINavigationController *)currentNavigationController
{
    return self.viewController.navigationController;
}

- (UIViewController *)viewControllerWithUrl:(NSString *)url
{
    if (!url || [url isEqualToString:@""]) {
        return currnetTopVc();
    }
    return fineVc(url);
}



/**
 跳转到网页
 */
- (void)push:(CDVInvokedUrlCommand *)commond
{
    NSString *target = [commond argumentAtIndex:0];
    NSString *title  = [commond argumentAtIndex:1];
    CDVViewController *vc = [[CDVViewController alloc] init];
    vc.startPage = target;
    if (title.length) {
        vc.title  = title;
    }
    vc.hidesBottomBarWhenPushed = YES;
    [[self currentNavigationController] pushViewController:vc animated:YES];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES] callbackId:commond.callbackId];
    
}

/**
 跳转到原生界面
 */
- (void)pushToViewController:(CDVInvokedUrlCommand *)commond {
    [self.commandDelegate runInBackground:^{
        
        NSString *className  = [commond argumentAtIndex:0];
        Class targetClass = NSClassFromString(className);
        id targetVC = [[targetClass alloc] init];
        if ([targetVC isKindOfClass:[SFProvenanceViewController class]]) {
            SFProvenanceViewController *proVc = (SFProvenanceViewController *)targetVC;
            proVc.currentDirection = SFProvenanceDirectionReceive;
            proVc.currentProvenanceIndex = 1;
            proVc.isPopToRootVc = YES;
        } else if ([targetVC isKindOfClass:[SFCarrierMessageController class]]) {
            SFCarrierMessageController *allot = (SFCarrierMessageController *)targetVC;
            allot.wwwFolderName = SFWL_H5_PATH;
            allot.startPage = @"carrierDetail.html";
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.viewController.navigationController pushViewController:targetVC animated:YES];
        });
        
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:(CDVCommandStatus_OK)];
        [self.commandDelegate sendPluginResult:result callbackId:commond.callbackId];
        
    }];
}

- (void)pop:(CDVInvokedUrlCommand *)commond
{
    NSString *url  = [commond argumentAtIndex:0];
    if (url) {
        CDVViewController *vc = (CDVViewController *)[self viewControllerWithUrl:url];
        [[self currentNavigationController] popToViewController:vc animated:YES];
    }else{
        [[self currentNavigationController] popViewControllerAnimated:YES];
    }
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES] callbackId:commond.callbackId];
}


- (void)present:(CDVInvokedUrlCommand *)command
{
    NSString *url = [command argumentAtIndex:0];
    NSString *title = [command argumentAtIndex:1];
    CDVViewController *vc = [[CDVViewController alloc] init];
    vc.startPage  = url;
    if (title.length) {
        vc.title  = title;
    }
    [[self viewControllerWithUrl:nil] presentViewController:vc animated:YES completion:NULL];
}
- (void)setTitle:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        NSString *title = [command argumentAtIndex:0];
        if (title.length) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIViewController *vc = self.viewController;
                vc.navigationItem.title = title;
            });
        }
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:(CDVCommandStatus_OK)] callbackId:command.callbackId];
    }];
}

- (void)dismiss:(CDVInvokedUrlCommand *)command
{
    NSString *url = [command argumentAtIndex:0];
    CDVViewController *vc = (CDVViewController *)[self viewControllerWithUrl:url];
    [vc dismissViewControllerAnimated:YES completion:NULL];
}

- (void)addRightItem:(CDVInvokedUrlCommand *)commond
{
    NSString *itemId   = [commond argumentAtIndex:0];
    NSString *title = [commond argumentAtIndex:1];
    NSString *img   = [commond argumentAtIndex:2];
    
    if(![self.itemIds containsObject:itemId]){
        [self.itemIds addObject:itemId];
    }else{
        return;
    }
    
    UIViewController *vc = self.viewController.navigationController;
    
    UIBarButtonItem *item = nil;
    if (title) {
        item = [[UIBarButtonItem alloc] initWithTitle:title style:(UIBarButtonItemStylePlain) target:self action:@selector(didClickItem:)];
    }else if(img){
        item = [[UIBarButtonItem alloc] initWithImage:[self imgaeWithString:img] style:(UIBarButtonItemStylePlain) target:self action:@selector(didClickItem:)];
    }
    item.tag  = [itemId hash];
    
    NSMutableArray *arr = [[vc.navigationItem rightBarButtonItems] mutableCopy];
    if (arr.count) {
        [arr addObject:item];
        vc.navigationItem.rightBarButtonItems  = arr;
    }else{
        vc.navigationItem.rightBarButtonItem  = item;
    }
    
}


- (void)modifiyRightItem:(CDVInvokedUrlCommand *)commond
{
    NSString *itemId   = [commond argumentAtIndex:0];
    NSString *title = [commond argumentAtIndex:1];
    NSString *img   = [commond argumentAtIndex:2];
    
    for (UIBarButtonItem *item in self.viewController.navigationController.navigationItem.rightBarButtonItems) {
        if (item.tag == [itemId hash]) {
            item.title  = title;
            item.image  = [self imgaeWithString:img];
        }
    }
    
}

- (void)setNavgationTitle:(CDVInvokedUrlCommand *)commond
{
//    NSString *url = [commond argumentAtIndex:0];
    NSString *title = [commond argumentAtIndex:0];
    
    UIViewController *vc = [self viewControllerWithUrl:NULL];
    vc.navigationItem.title  = title;
    
}

- (void)didClickItem:(UIBarButtonItem *)item
{
    for (NSString *itemID in self.itemIds) {
        if ([itemID hash] == item.tag) {
            NSString* js = [NSString stringWithFormat:@"navigation.itemAction(\"%@\")", itemID];
            [self.commandDelegate performSelector:@selector(evalJsHelper:) withObject:js];
        }
    }
}

- (UIImage *)imgaeWithString:(NSString *)str
{
    NSString *path  = [[NSBundle mainBundle] pathForResource:str ofType:nil inDirectory:@"www"];
    UIImage *img = [UIImage imageWithContentsOfFile:path];
    if (img) {
        return img;
    }
    return [UIImage imageNamed:str];
}




@end
