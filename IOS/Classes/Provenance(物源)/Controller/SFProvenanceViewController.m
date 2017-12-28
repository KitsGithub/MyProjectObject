//
//  SFProvenanceViewController.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFProvenanceViewController.h"
#import "SFSegmentView.h"
#import "SFProvenanceCell.h"
#import "SFOrderListTableViewDelegate.h"
#import "SFOrderManage.h"

//跳转
#import "SFEvalViewController.h"
#import "SFDetailViewController.h"
#import "SFCarDetailController.h"
#import "SFReleaseViewController.h"
#import "SFOrderDetailController.h" //货源详情

@interface SFProvenanceViewController ()


@property (nonatomic,strong)SFSegmentView *segment;

@property (nonatomic,strong)SFSegmentView *segmentToolBar;

@property (nonatomic,strong)UITableView  *tableView;

@property (nonatomic,strong)SFOrderListTableViewDelegate *orderDelegate;

@end

@implementation SFProvenanceViewController {
    BOOL _isChangSegment;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self  = [super initWithCoder:aDecoder];
    
    [self setup];
    
    return self;
}

- (instancetype)init
{
    self  = [super init];
    [self setup];
    return self;
}

- (void)setup
{
    self.currentprovenanceType  = SFTakingStatusUnkown;
}

- (NSArray *)titleItems
{
    if(SF_USER.role  == SFUserRoleCarownner){
        return @[@"我发的车",@"我接的单"];
    }else{
        return @[@"我发的货",@"我订的车",];
    }
}

- (void)backAction {
    if (self.isPopToRootVc) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor  = COLOR_BG;
    
    [(BaseNavigationController *)self.navigationController  SetBottomLineViewHiden:NO];
    
    self.navigationController.navigationItem.backBarButtonItem.action = @selector(backAction);
    
    __weak typeof(self) wself = self;
    _segment   = [[SFSegmentView alloc] initWithFrame:CGRectMake(0, 0, 30 + 64 + 64 + 15*2, 44) items:[self titleItems] font:FONT_COMMON_16];
    _segment.lineWidth  = 80;
    _segment.selectedBlock = ^(NSInteger index) {
        _isChangSegment = YES;
        wself.currentDirection  = index;
        [wself.orderDelegate loadNewData];
    };
    self.navigationItem.titleView  = _segment;
    
    CGFloat bary  = 44 + [UIApplication sharedApplication].statusBarFrame.size.height;
    UIView *line1   = [[UIView alloc] initWithFrame:CGRectMake(0, bary, [UIScreen mainScreen].bounds.size.width, 1)];
    line1.backgroundColor  = COLOR_BG;
    [self.view addSubview:line1];
    
    _segmentToolBar = [[SFSegmentView alloc] initWithFrame:CGRectMake(0, bary, [UIScreen mainScreen].bounds.size.width, 44) items:[self items] font:[UIFont systemFontOfSize:14]];
    _segmentToolBar.items = [self items];
    _segmentToolBar.selectedBlock = ^(NSInteger idx) {
        wself.currentProvenanceIndex   = idx;
        [wself.orderDelegate loadNewData];
    };
    
    [self.view addSubview:_segmentToolBar];
    
    _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segmentToolBar.frame) + 1, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(_segmentToolBar.frame)) style:(UITableViewStylePlain)];
    _tableView.backgroundColor  = COLOR_BG;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[SFProvenanceCell class] forCellReuseIdentifier:@"SFProvenanceCell"];
    [self.view addSubview:_tableView];
    
    self.orderDelegate  = [[SFOrderListTableViewDelegate alloc] initWithViewController:self tableView:self.tableView];
    
    self.orderDelegate.loadNewDataCommond = ^(SFOrderResultBlock suc, SFErrorResultBlock err) {
        [SFOrderManage getProvenanceListWithDirection:wself.currentDirection Type:[wself statusStr] page:1 Success:suc fault:err];
    };
    
    self.orderDelegate.loadMoreDataCommond = ^(NSInteger page,SFOrderResultBlock suc, SFErrorResultBlock err) {
        [SFOrderManage getProvenanceListWithDirection:wself.currentDirection Type:[wself statusStr] page:page Success:suc fault:err];
    };
    
    self.orderDelegate.comondWithStatus = ^NSArray<SFCommond *> *(SFOrderType orderStatus, SFTakingStatus takingStatus) {
        return [wself commondsWithTakingStaus:takingStatus];
    };
    
    [self.orderDelegate setSetTableViewCell:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        SFProvenanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SFProvenanceCell"];
        cell.currentDirection = wself.currentDirection;
        
        id<SFProvenanceProtocol> model = wself.orderDelegate.dataArray[indexPath.row];
        cell.model  = model;
        
        cell.commonds  = [wself commondsWithTakingStaus:model.takingStatus];
        
        return cell;
    }];
    
    [self.orderDelegate setSelectedCellWithModle:^(id<SFProvenanceProtocol> model) {
        if ([model.stateStr isEqualToString:@"待发布"]) {
            SFReleaseViewController *release = [[SFReleaseViewController alloc] init];
            if (SF_USER.role == SFUserRoleCarownner) {
                release.startPage = @"release_car.html";
                release.title = @"发布车源";
            } else {
                release.startPage = @"release_Goods.html";
                release.title = @"发布货源";
            }
            
            release.orderId = model.guid;
            [wself.navigationController pushViewController:release animated:YES];
            return ;
        }
        SFDetailViewController *detail = [[SFDetailViewController alloc] init];
        detail.wwwFolderName = SFWL_H5_PATH;
        detail.isCloseHistory = [model.usercount intValue];
        if (SF_USER.role == SFUserRoleGoodsownner) {
            if (wself.currentDirection == SFProvenanceDirectionPublish) {
                //我发的货
                detail.startPage = @"wuyuanDetail.html";
                detail.title = @"货源详情";
                detail.orderID = model.guid;
                detail.BatchId = @"";
                detail.ismyCarOrd = YES;
            } else {
                //我预订的车
                detail.startPage = @"wuyuanCarDetail.html";
                detail.title = @"车源详情";
                detail.orderID = model.guid;
                detail.BatchId = model.gdid;
                detail.isCloseHistory = NO;
                detail.isBooking = YES;
            }
            [wself.navigationController pushViewController:detail animated:YES];
        } else if (SF_USER.role == SFUserRoleCarownner) {
            if (wself.currentDirection == SFProvenanceDirectionPublish) {
                //我发的车
                detail.startPage = @"wuyuanCarDetail.html";
                detail.title = @"车源详情";
                detail.orderID = model.guid;
                detail.BatchId = @"";
                
            } else {
                //我接的单
                detail.startPage = @"wuyuanDetail.html";
                detail.title = @"货源详情";
                detail.orderID = model.goodsId;
                detail.BatchId = model.guid;
                detail.isCloseHistory = NO;
                detail.isBooking = YES;
            }
            [wself.navigationController pushViewController:detail animated:YES];
        }
    }];
    [self.orderDelegate loadNewData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setCurrentDirection:_currentDirection];
    [self setCurrentProvenanceIndex:_currentProvenanceIndex];
    
}


- (NSArray<SFCommond *>*)commondsWithTakingStaus:(SFTakingStatus)status
{
    __weak typeof(self) wSelf = self;
    if (self.currentDirection  == SFProvenanceDirectionPublish) {
        if (status  == SFTakingStatusCancel || status == SFTakingStatusFinish || status == SFTakingStatusRefuse) {
            return nil;
        }else if (status == SFTakingStatusPublished) {
            SFCommond *cmd = [SFCommond new];
            cmd.name  = @"编辑";
            cmd.commond = ^(id<SfOrderProtocol> model) {
                SFReleaseViewController *release = [[SFReleaseViewController alloc] init];
                if (SF_USER.role == SFUserRoleCarownner) {
                    release.startPage = @"release_car.html";
                    release.title = @"发布车源";
                } else {
                    release.startPage = @"release_Goods.html";
                    release.title = @"发布货源";
                }
                
                release.orderId = model.guid;
                [wSelf.navigationController pushViewController:release animated:YES];
            };
            
            SFCommond *cmd2 = [SFCommond new];
            cmd2.name = @"删除";
            cmd2.commond = ^(id<SfOrderProtocol> model) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认删除" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认删除" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    params[@"UserId"] = USER_ID;
                    NSString *url;
                    if (SF_USER.role == SFUserRoleCarownner) {
                        url = @"Cars/DeleteCarOrder";
                        params[@"OrderId"] = model.guid;
                    } else {
                        url = @"Goods/DeleteGoods";
                        params[@"GoodsId"] = model.guid;
                    }
                    
                    [[SFNetworkManage shared] postWithPath:url
                                                    params:params
                                                   success:^(id result)
                     {
                         
                         if (result) {
                             [[SFTipsView shareView] showSuccessWithTitle:@"删除成功"];
                             NSInteger count = 0;
                             for (id targetObj in wSelf.orderDelegate.dataArray) {
                                 if (targetObj == model) {
                                     break;
                                 }
                                 count++;
                             }
                             
                             [wSelf.orderDelegate.dataArray removeObject:model];
                             [wSelf.orderDelegate.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:count inSection:0]] withRowAnimation:(UITableViewRowAnimationFade)];
                         } else {
                             [[SFTipsView shareView] showFailureWithTitle:@"删除失败"];
                         }
                         
                     } fault:^(SFNetworkError *err) {
                         [[SFTipsView shareView] showFailureWithTitle:@"删除失败"];
                     }];
                }];
                [alert addAction:action1];
                [alert addAction:action2];
                [self presentViewController:alert animated:YES completion:nil];
                
            };
            
            return @[cmd,cmd2];
        } else {
            //车主身份   我发的车
            //货主身份   我发的货
            SFCommond *cmd = [SFCommond new];
            cmd.name  = @"撤回";
            __weak typeof(self)wself = self;
            cmd.commond = ^(id<SfOrderProtocol> model) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认撤回" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认撤回" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
                    [SFOrderManage recallCarOrderWithId:[model guid] Success:^(BOOL isSuc) {
                        if (isSuc) {
                            [[SFTipsView shareView] showSuccessWithTitle:@"撤回成功"];
                            [wself.orderDelegate loadNewData];
                        }else{
                            [[SFTipsView shareView] showFailureWithTitle:@"撤回失败"];
                        }
                        
                    } fault:^(SFNetworkError *err) {
                        [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
                    }];
                }];
                [alert addAction:action1];
                [alert addAction:action2];
                [self presentViewController:alert animated:YES completion:nil];
                
                
            };
            
            SFCommond *cmd2 = [SFCommond new];
            if (SF_USER.role == SFUserRoleCarownner) {
                //我发的车的详情
                cmd2.name = @"查看预定";
                cmd2.commond = ^(id<SFProvenanceProtocol> model) {
                    NSLog(@"查看预定");
                    SFDetailViewController *detail = [[SFDetailViewController alloc] init];
                    detail.wwwFolderName = SFWL_H5_PATH;
                    detail.startPage = @"wuyuanCarDetail.html";
                    detail.title = @"车源详情";
                    detail.orderID = model.guid;
                    detail.isCloseHistory = [model.usercount intValue];
                    [wself.navigationController pushViewController:detail animated:YES];
                };
            } else {
                // 我发的货 的详情
                cmd2.name = @"查看预定";
                cmd2.commond = ^(id<SFProvenanceProtocol> model) {
                    SFDetailViewController *detail = [[SFDetailViewController alloc] init];
                    detail.wwwFolderName = SFWL_H5_PATH;
                    detail.startPage = @"wuyuanDetail.html";
                    detail.title = @"货源详情";
                    detail.orderID = model.guid;
                    detail.isCloseHistory = [model.usercount intValue];
                    [wself.navigationController pushViewController:detail animated:YES];
                };
            }
            
            return @[cmd2,cmd];
        }
    }else{
        if (status  == SFTakingStatusPublished) {
            SFCommond *cmd = [SFCommond new];
            cmd.name  = @"撤回";
            __weak typeof(self)wself = self;
            cmd.commond = ^(id<SFProvenanceProtocol> model) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认撤回" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认撤回" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
                    NSString *requestId;
                    if (SF_USER.role == SFUserRoleCarownner) {
                        requestId = model.guid;
                    } else {
                        requestId = model.gdid;
                    }
                    [SFOrderManage cancelGoodOrderWithId:requestId Success:^(BOOL isSuc) {
                        if (isSuc) {
                            [[SFTipsView shareView] showSuccessWithTitle:@"撤回成功"];
                            [wself.orderDelegate loadNewData];
                        }else{
                            [[SFTipsView shareView] showFailureWithTitle:@"撤回失败"];
                        }
                        
                    } fault:^(SFNetworkError *err) {
                        [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
                    }];
                }];
                [alert addAction:action1];
                [alert addAction:action2];
                [self presentViewController:alert animated:YES completion:nil];
                
            };
            return @[cmd];
        }
        return nil;
    }
}

- (void)setCurrentDirection:(SFProvenanceDirection)currentDirection {
    _currentDirection  = currentDirection;
    
    if (self.segment.currentIndex  != currentDirection) {
        self.segment.currentIndex  = currentDirection;
    }
    if (!_isChangSegment) {
        if (!self.currentProvenanceIndex) {
            self.currentProvenanceIndex  = 0;
        }
    } else {
        _segmentToolBar.items = [self items];
        self.currentProvenanceIndex  = 0;
        _isChangSegment = NO;
    }
}

- (void)setCurrentProvenanceIndex:(NSInteger)currentProvenanceIndex
{
    _currentProvenanceIndex  = currentProvenanceIndex;
    if (self.segmentToolBar.currentIndex  != currentProvenanceIndex) {
        self.segmentToolBar.currentIndex = currentProvenanceIndex;
    }
}

- (void)setCurrentprovenanceType:(SFTakingStatus)currentprovenanceType
{
    _currentprovenanceType   = currentprovenanceType;
}

- (NSString *)statusStr
{
    return [self codeArr][self.currentProvenanceIndex];
}

- (NSArray *)codeArr
{
    SFProvenanceType type = SFProvenanceTypeCreate(SF_USER.role, self.currentDirection);
    NSArray *arr = SFProvenanceTypeGetCodeArr(type);
    return [@[@""] arrayByAddingObjectsFromArray:arr];
}

- (NSArray *)items
{
    SFProvenanceType type = SFProvenanceTypeCreate(SF_USER.role, self.currentDirection);
    NSArray *arr = SFProvenanceTypeGetDescArr(type);
    return [@[@"全部"] arrayByAddingObjectsFromArray:arr];
}





@end

