//
//  SFOrderListTableViewDelegate.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/23.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFCommond.h"
#import "SFCarProvenance.h"


typedef void(^SFOrderResultBlock)(NSArray *results);


@interface SFOrderListTableViewDelegate : NSObject<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,weak)UIViewController *sourceVc;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UITableView    *tableView;
@property (nonatomic,copy)void (^loadNewDataCommond)(SFOrderResultBlock,SFErrorResultBlock);
@property (nonatomic,copy)void (^loadMoreDataCommond)(NSInteger page,SFOrderResultBlock,SFErrorResultBlock);
@property (nonatomic,copy)NSArray <SFCommond *>*(^comondWithStatus)(SFOrderType orderStatus,SFTakingStatus takingStatus);

@property (nonatomic,copy)void(^selectedCellWithModle)(id<SfOrderProtocol>);

@property (nonatomic,strong)NSArray *codeArr;
@property (nonatomic,strong)NSArray *descArr;

@property (nonatomic,strong)NSDictionary *dic;


- (instancetype)initWithViewController:(UIViewController *)vc tableView:(UITableView *)tableView;

- (void)loadNewData;

@end

