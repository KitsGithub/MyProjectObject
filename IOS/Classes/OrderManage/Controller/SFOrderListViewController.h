//
//  SFOrderListViewController.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/19.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCordvaViewController.h"
#import "SFOrderManage.h"
#import "BaseViewController.h"
#import "SFDesignableView.h"

@interface SFOrderListViewController : BaseViewController

@property (nonatomic,assign)NSInteger currentIndex;

- (instancetype)initWithIndex:(NSInteger)index;


@end
