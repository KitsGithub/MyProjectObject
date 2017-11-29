//
//  LGTabBarViewController.m
//  TestHybird
//
//  Created by chaocaiwei on 2017/9/29.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFTabBarViewController.h"

#import "SFTabBar.h"
//根控制器
#import "SFHomeViewController.h"        //首页
#import "SFReleaseViewController.h"     //发布
#import "SFOrderManageController.h"     //订单管理
#import "SFPersonalCenterController.h"  //个人中心
#import "LoginViewController.h"         //登录界面

#import "SFAuthStatuViewController.h"   //认证信息


@interface SFTabBarViewController () <SFTabBarDelegate,UITabBarControllerDelegate,UIAlertViewDelegate>

@end

@implementation SFTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate  = self;
    
    SFTabBar *tab = [[SFTabBar alloc] init];
    tab.centerBtnTitle = @"发布";
    tab.tabDelegate = self;
    tab.centerBtnIcon = @"TabBar_3";
    [self setValue:tab forKey:@"tabBar"];
    
    //去除顶部很丑的border
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    
    //自定义分割线颜色
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(self.tabBar.bounds.origin.x, self.tabBar.bounds.origin.y, self.tabBar.bounds.size.width, 0.5)];
    bgView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
    bgView.layer.borderWidth = 0.5;
    bgView.alpha = 0.6;
    bgView.layer.shadowPath = [UIBezierPath bezierPathWithRect:bgView.layer.bounds].CGPath;
    bgView.layer.shadowColor = [[UIColor blackColor] CGColor];//阴影的颜色
    bgView.layer.shadowOpacity = 0.15f;   // 阴影透明度
    bgView.layer.shadowOffset =CGSizeMake(0.0,-0.7f); // 阴影的范围
    bgView.layer.shadowRadius = .7;  // 阴影扩散的范围控制
    [tab insertSubview:bgView atIndex:0];
    
    tab.opaque = YES;
    
    
    [self creatTabWithTitle:@"首页" image:[UIImage imageNamed:@"TabBar_1"] hightlightImage:[UIImage imageNamed:@"TabBar_1_Selected"] tag:0 withRootViewController:[[SFHomeViewController alloc] init]];
    [self creatTabWithTitle:@"订单" image:[UIImage imageNamed:@"TabBar_2"] hightlightImage:[UIImage imageNamed:@"TabBar_2_Selected"] tag:2 withRootViewController:[[SFOrderManageController alloc] init]];
    
//    [self creatTabWithTitle:@"发布" image:[UIImage imageNamed:@"TabBar_2"] hightlightImage:[UIImage imageNamed:@"TabBar_2_Selected"] tag:1 withRootViewController:[[SFReleaseViewController alloc] init]];
    
}

- (void)creatTabWithTitle:(NSString *)title image:(UIImage *)image hightlightImage:(UIImage *)selectedImage tag:(NSUInteger)tag withRootViewController:(UIViewController *)rootVC {
    
    // 设置子控制器的tabBarItem图片
    rootVC.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 禁用图片渲染
    rootVC.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    rootVC.hidesBottomBarWhenPushed = YES;
    // 设置文字的样式
    [rootVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    [rootVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
    rootVC.tabBarItem.title = title;
    
    
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:rootVC];
    
    [self addChildViewController:nav];
    
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]  && [[(UINavigationController *)viewController viewControllers].firstObject isKindOfClass:[SFOrderManageController class]]) {
        if (![SFAccount currentAccount].user_id) {
            LoginViewController *vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:^{}];
            return NO;
        }
    }
    return YES;
}

- (void)tabBar:(SFTabBar *)tabBar clickCenterButton:(UIButton *)sender {
    NSLog(@"点击了中间的按钮");
    SFAccount *account = [SFAccount currentAccount];
    if (![SFAccount currentAccount].user_id) {
        LoginViewController *vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:^{}];
        
    }else {
        
        if ([[SFAccount currentAccount].verify_status isEqualToString:@"D"]) {
            SFReleaseViewController *release = [[SFReleaseViewController alloc] init];
            release.wwwFolderName = SFWL_H5_PATH;
            if ([SFAccount currentAccount].role == SFUserRoleCarownner) {
                release.startPage = @"release_car.html";
                release.title = @"发布车源";
            } else {
                release.startPage = @"release_good.html";
                release.title = @"发布货源";
            }
            
            release.completion = ^(BOOL isSuc) {
                
            };
            BaseNavigationController *navVc = [[BaseNavigationController alloc] initWithRootViewController:release];
            [self presentViewController:navVc animated:YES completion:nil];
            
        } else {
            
            UIAlertController *alertVc;
            UIAlertAction *action1;
            UIAlertAction *action2;
            if ([[SFAccount currentAccount].verify_status isEqualToString:@"B"]) {
                alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您提交的认证资料正在审核，请耐心等待" preferredStyle:(UIAlertControllerStyleAlert)];
                action1 = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleCancel) handler:nil];
            } else {
                alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未进行身份认证，请先去认证" preferredStyle:(UIAlertControllerStyleAlert)];
                action1 = [UIAlertAction actionWithTitle:@"下次再说" style:(UIAlertActionStyleCancel) handler:nil];
                action2 = [UIAlertAction actionWithTitle:@"去认证" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
                    SFAuthStatuViewController *auth = [[SFAuthStatuViewController alloc] initWithType:(SFAuthTypeUser) Status:account.authStatus];
                    auth.hidesBottomBarWhenPushed = YES;
                    [self.selectedViewController pushViewController:auth animated:YES];
                }];
            }
            
            [alertVc addAction:action1];
            if (action2) {
                [alertVc addAction:action2];
            }
            
            
            [self presentViewController:alertVc animated:YES completion:nil];
            
        }
    }
}







@end
