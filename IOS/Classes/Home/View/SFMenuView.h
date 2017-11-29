//
//  SFMenuView.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/17.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFMenuView : UIView <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>


@property (nonatomic,strong)UIImageView *bgImageView;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,copy)NSArray <NSString *>*titles;

@property (nonatomic,copy)NSArray <UIImage *>*icons;

@property (nonatomic,copy)void(^completion)(NSInteger selectedIndex);

- (void)showWithSourceView:(UIView *)sourceView Completion:(void(^)(NSInteger index))completion;
- (instancetype)initWithTitles:(NSArray <NSString *>*)titles icons:(NSArray <UIImage *>*)icons;
+ (SFMenuView *)showWithTitles:(NSArray <NSString *>*)titles icons:(NSArray <UIImage *>*)icons fromView:(UIView *)view completion:(void(^)(NSInteger selectedIndex))completion;

@end
