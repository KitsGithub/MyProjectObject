//
//  SFOrderListTableViewDelegate.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/23.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFOrderListTableViewDelegate.h"
#import "SFOrderTableViewCell.h"
#import "SFOrderManage.h"
#import "SFEvalViewController.h"
@interface SFOrderListTableViewDelegate()


@end

@implementation SFOrderListTableViewDelegate


- (instancetype)initWithViewController:(UIViewController *)vc tableView:(UITableView *)tableView
{
    if(self = [super init]){
        self.sourceVc  = vc;
        self.tableView  = tableView;
        self.tableView.delegate  = self;
        self.tableView.dataSource  = self;
        [tableView registerNib:[UINib nibWithNibName:@"SFOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"SFOrderTableViewCell"];
        __weak typeof(self)wself = self;
        [self.tableView registerNib:[UINib nibWithNibName:@"SFOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"SFOrderTableViewCell"];
        self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [wself loadNewData];
        }];
        self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [wself loadMoreData]; 
        }];
    }
    return self;
}


- (void (^)(SFOrderResultBlock, SFErrorResultBlock))loadNewDataCommond
{
    if (!_loadNewDataCommond) {
        _loadNewDataCommond = ^(SFOrderResultBlock success, SFErrorResultBlock errBlock){
            [SFOrderManage getOrderListWithType:SFOrderTypeAll page:1 Success:success fault:errBlock];
        };
    }
    return _loadNewDataCommond;
}

- (void)loadNewData
{
    __weak typeof(self)wself = self;
    if (self.loadNewDataCommond) {
        [SVProgressHUD show];
        self.loadNewDataCommond(^(NSArray<SfOrderProtocol> *results) {
            [wself.tableView.mj_header endRefreshing];
            [SVProgressHUD dismiss];
            wself.dataArray  = [results mutableCopy];
            [wself.tableView reloadData];
            if (results.count) {
                [wself.tableView.mj_footer resetNoMoreData];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:NO];
            }
        }, ^(SFNetworkError *err) {
            [wself.tableView.mj_header endRefreshing];
            [SVProgressHUD dismiss];
            [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
        });
    }
}

- (void)loadMoreData
{
    if (self.loadMoreDataCommond) {
        __weak typeof(self)wself = self;
        [SVProgressHUD show];
        
        NSInteger count = self.dataArray.count;
        double  adj  =  (count % 10) > 0 ? 1 : 0;
        NSInteger page = self.dataArray.count / 10  + 1 + adj;
        
        self.loadMoreDataCommond(page, ^(NSArray<SfOrderProtocol> *results) {
            if (results.count) {
                [wself.tableView.mj_footer endRefreshing];
            }else{
                [wself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [SVProgressHUD dismiss];
            [wself.dataArray addObjectsFromArray:results];
            [wself.tableView reloadData];
        }, ^(SFNetworkError *err) {
            [SVProgressHUD dismiss];
            [wself.tableView.mj_footer endRefreshing];
            [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
        });
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.setTableViewCell) {
        return self.setTableViewCell(tableView, indexPath);
    }
    SFOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SFOrderTableViewCell" forIndexPath:indexPath];
    id<SfOrderProtocol> model = self.dataArray[indexPath.row];
    cell.model  = model;
    if (self.comondWithStatus) {
        if ([model respondsToSelector:@selector(takingStatus)]) {
            cell.commonds  = self.comondWithStatus(model.orderType,[model takingStatus]);
        }else{
            cell.commonds  = self.comondWithStatus(model.orderType,SFTakingStatusUnkown);
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<SfOrderProtocol> model = self.dataArray[indexPath.row];
    NSArray *commonds  = nil;
    if ([model respondsToSelector:@selector(takingStatus)]) {
        commonds  = self.comondWithStatus(model.orderType,[model takingStatus]);
    }else{
        commonds  = self.comondWithStatus(model.orderType,SFTakingStatusUnkown);
    }
    if (!commonds.count) {
        return 118 + 20;
    }
    return 180;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<SfOrderProtocol> model = self.dataArray[indexPath.row];
    if (self.selectedCellWithModle) {
        self.selectedCellWithModle(model);
    }
}



@end

