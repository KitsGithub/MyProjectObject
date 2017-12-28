//
//  SFOrderListTableViewDelegate.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/23.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFCommond.h"


typedef void(^SFOrderResultBlock)(NSArray *results);


@interface SFOrderListTableViewDelegate : NSObject<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,weak)UIViewController *sourceVc;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UITableView    *tableView;

/**
 下拉加载最新
 */
@property (nonatomic,copy)void (^loadNewDataCommond)(SFOrderResultBlock,SFErrorResultBlock);

/**
 上拉加载更多
 */
@property (nonatomic,copy)void (^loadMoreDataCommond)(NSInteger page,SFOrderResultBlock,SFErrorResultBlock);

/**
 自定义cell
 */
@property (nonatomic, copy) UITableViewCell *(^setTableViewCell)(UITableView *tableView, NSIndexPath *indexPath);

/**
 选中cell的方法
 */
@property (nonatomic,copy)void(^selectedCellWithModle)(id model);

/**
 控制可选按钮
 */
@property (nonatomic,copy)NSArray <SFCommond *>*(^comondWithStatus)(SFOrderType orderStatus,SFTakingStatus takingStatus);



@property (nonatomic,strong)NSArray *codeArr;
@property (nonatomic,strong)NSArray *descArr;

@property (nonatomic,strong)NSDictionary *dic;


- (instancetype)initWithViewController:(UIViewController *)vc tableView:(UITableView *)tableView;

- (void)loadNewData;

@end

