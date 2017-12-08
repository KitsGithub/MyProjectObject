//
//  SFSearchViewController.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/16.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFSearchViewController.h"
#import "SFSearchBarView.h"
//#import "SFAdressPickerPlugin.h"
#import "SFAdressPickerView.h"
#import "SFOtherPickerView.h"
#import "SFFiltrateBar.h"
#import "HomeRequestHelper.h"
#import "HomeViewCell.h"
#import "SFSearchResultProtocol.h"
#import "SFMutilBtnMenuView.h"
#import "SFMenuView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SFOrderDetailController.h"

@interface SFSearchViewController ()<SFSearchBarViewDelegate,SFAdressPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,HomeViewCellDelegate,UIWebViewDelegate>

@property (nonatomic,copy)void((^textfileCompletion)(NSString *));

@property (nonatomic,strong)SFSearchBarView *searchTextfiled;

@property (nonatomic,strong)SFFiltrateBar *filtrateBar;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray <SFSearchResultProtocol>*dataArray;

@property (nonatomic,assign)SFSearchType  searchType;

@property (nonatomic,assign)NSInteger  carsType;

@property (nonatomic,assign)NSInteger  goodsType;

@property (nonatomic,strong)UIWebView *webView;

@property (nonatomic,copy)void (^fetchTypesCompletion)(NSDictionary *dic);

@property (nonatomic,strong)NSArray *carTypeArray;

@property (nonatomic,strong)NSArray *goodsTypeArry;

@property (nonatomic,strong)NSDictionary *typeDic;

@property (nonatomic,strong)SFMenuView *menu;

//@property (nonatomic,copy)NSString *fromAddress;
//@property (nonatomic,copy)NSString *toAddress;

@end

@implementation SFSearchViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"%@",self.navigationController.navigationBar.backItem);

   
    
}

- (NSArray *)carTypeArray
{
    if (!_carTypeArray) {
        _carTypeArray = @[@"全部",@"保温车", @"平板车", @"飞翼车", @"半封闭车", @"危险品车", @"集装车", @"敞篷车", @"金杯车", @"自卸货车", @"高低板车", @"高栏车", @"冷藏车", @"厢式车"];
    }
    return _carTypeArray;
}

- (NSArray *)goodsTypeArry
{
    if (!_goodsTypeArry) {
        _goodsTypeArry  =  @[@"全部",@"木材", @"食品", @"蔬菜", @"矿产", @"电子电器", @"农副产品", @"生鲜", @"纺织品", @"药品", @"日用品", @"建材", @"化工", @"设备", @"其他", @"家畜"];
    }
    return _goodsTypeArry;
}






- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fabu.html" ofType:nil inDirectory:SFWL_H5_PATH];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
    self.webView = webView;
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupNav];
        __weak typeof(self)wself = self;
        
        
        _filtrateBar  = [[SFFiltrateBar alloc] init];
        [self.view addSubview:_filtrateBar];
        self.filtrateBar.carTypeArray  = self.carTypeArray;
        self.filtrateBar.goodsTypeArry = self.goodsTypeArry;
        [self.filtrateBar setGoodstypeBtnHidden:[SFUserInfo defaultInfo].role  == SFUserRoleCarownner];
        self.filtrateBar.seletedCompletion = ^(SFFiltrateBarType type, NSInteger seletedIndex, NSString *result) {
            if (result) {
                if (type == SFFiltrateBarTypeGoods) {
                    wself.goodsType  = seletedIndex;
                }else{
                    wself.carsType  = seletedIndex;
                }
                [wself refreshWithIsMore:NO];
            }
        };
        
        self.view.backgroundColor  = COLOR_LINE_DARK;
        _tableView  = [[UITableView alloc] initWithFrame:(CGRectZero) style:(UITableViewStylePlain)];
        _tableView.delegate  = self;
        _tableView.dataSource  = self;
        _tableView.backgroundColor = COLOR_LINE_DARK;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HomeViewCell class] forCellReuseIdentifier:@"HomeViewCell"];
        
        
        [self.view addSubview:_tableView];
        
        [self.filtrateBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset([[UIApplication sharedApplication] statusBarFrame].size.height + 44);
            make.height.equalTo(@1);
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.filtrateBar.mas_bottom);
            make.bottom.equalTo(self.view);
        }];
        
        if ([SFUserInfo defaultInfo].role  == SFUserRoleCarownner) {
            self.searchType  = SFSearchTypeCars;
            self.searchTextfiled.seletedIndex  = 1;
        }else{
            self.searchType  = SFSearchTypeGoods;
            self.searchTextfiled.seletedIndex  = 0;
        }
        
        [self setFiltrateBarHidden:NO];
        
    });
    
    
   
    
}

- (void)setFiltrateBarHidden:(BOOL)hidden
{
    if (hidden) {
        [self.filtrateBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
        }];
    }else{
        [self.filtrateBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@44);
        }];
    }
}


- (void)setSearchType:(SFSearchType)searchType
{
    _searchType  = searchType;
    NSArray *titles = [self searchTypeDecs];
    [self.searchTextfiled.switchBtn setTitle:titles[searchType] forState:(UIControlStateNormal)];
    [self.filtrateBar setGoodstypeBtnHidden:searchType  == SFSearchTypeCars];
    [self resetFilter];
}

- (NSArray *)searchTypeDecs
{
    return  @[@"货源",@"车源"];
}


- (SFSearchBarView *)searchTextfiled
{
    if (!_searchTextfiled) {
        SFSearchBarView *bar = [[SFSearchBarView alloc] initWithFrame:CGRectMake(-30, 0,[UIScreen mainScreen].bounds.size.width - 30 - 71, 36)];
        bar.delegate  = self;
        bar.switchItems  = [self searchTypeDecs];
        
        _searchTextfiled = bar;
    }
    return _searchTextfiled;
}

- (void)setupNav
{
  
    self.navigationItem.titleView  = self.searchTextfiled;
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    btn.frame  = CGRectMake(0, 0, 44, 44);
    btn.contentMode  = UIViewContentModeRight;
    btn.titleLabel.textAlignment  = NSTextAlignmentRight;
    btn.titleEdgeInsets  = UIEdgeInsetsMake(0, 0, 0, -20);
    [btn setTitle:@"搜索" forState:(UIControlStateNormal)];
    btn.titleLabel.font  = FONT_COMMON_16;
    [btn setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(searchAction:) forControlEvents:(UIControlEventTouchUpInside)];
     self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [(BaseNavigationController *)self.navigationController SetBottomLineViewHiden:YES];
    
    
    [self resetFilter];
}

- (void)searchAction:(UIButton *)sender
{
    [self searchWithIsForce:YES];
}

- (SFMenuView *)menu
{
    if (!_menu) {
        NSArray *titles = [self searchTypeDecs];
        _menu = [[SFMenuView alloc] initWithTitles:titles icons:@[[UIImage imageNamed:@"goods_white"],[UIImage imageNamed:@"cars_white"]]];
    }
    return _menu;
}

#pragma mark SFSearchBarViewDelegate
- (void)searchBarViewDidClickSwitchBtn:(SFSearchBarView *)barView
{
    NSArray *titles = [self searchTypeDecs];
    __weak typeof(self)wself = self;
    self.menu = [SFMenuView showWithTitles:titles icons:@[[UIImage imageNamed:@"goods_white"],[UIImage imageNamed:@"cars_white"]] fromView:barView completion:^(NSInteger selectedIndex) {
        barView.switchBtn.selected  = NO;
        if (selectedIndex != -1) {
            wself.searchType  = selectedIndex;
            [self refreshWithIsMore:NO];
            [self.tableView reloadData];
        }
    }];
}



// 重制筛选条件 车源货源
- (void)resetFilter
{
    self.carsType = 0;
    self.goodsType = 0;
}

- (void)searchBarView:(SFSearchBarView *)barView fromTextFiledDidSelectedWithType:(SFSearchBarViewTextFiledType)textfiledType Completion:(void(^)(NSString *result))completion
{
    __weak typeof(self)wself = self;
    NSString *address = textfiledType == SFSearchBarViewTextFiledTypeFrom ?  barView.fromTextfiled.text :  barView.targetTextfiled.text;
    [SFAdressPickerView showWithAddress:address completion:^(NSString * _Nullable address) {
        if(address){
            [wself searchWithIsForce:NO];
            completion(address);
        }
    }];
}




- (void)SFAdressPickerViewDidSelectedCancel:(SFAdressPickerView *)picker { 
    
}



- (void)searchWithIsForce:(BOOL)force
{
    NSString *from = [self.searchTextfiled.fromTextfiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *target = [self.searchTextfiled.targetTextfiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ((from.length && target.length) || force) {
        [self refreshWithIsMore:NO];
    }
    
}


- (NSString *)toCityStr:(NSString *)str
{
    NSArray *arr = [str componentsSeparatedByString:@"-"];
    NSMutableString *mstr = [NSMutableString new];
    for (int i = 0; i < arr.count; i++) {
        if (i == 0) {
            [mstr appendString:arr[i]];
        }else{
            [mstr appendFormat:@"/%@",arr[i]];
        }
    }
    return mstr;
}

- (void)refreshWithIsMore:(BOOL)isMore
{
    NSInteger page = isMore ? ceil(self.dataArray.count / kdefult_numberofpage) + 1 :  1;
    NSString *from  = self.searchTextfiled.fromTextfiled.text;
    NSString *to    = self.searchTextfiled.targetTextfiled.text;
    to   = [self toCityStr:to];
    from = [self toCityStr:from];
    
    
    
    if (self.searchType == SFSearchTypeCars) {
        [SVProgressHUD show];
        [HomeRequestHelper searchCarsSupplyWithcarType:[self currentCarType]
                                                  from:from
                                                    to:to
                                                  page:page
                                               Success:^(NSArray<SFSearchResultProtocol> *result) {
                                                   [SVProgressHUD dismiss];
                                                   [self handleSearchResult:result isMore:isMore];
                                               } fault:^(SFNetworkError *err) {
                                                   [SVProgressHUD dismiss];
                                                   if (isMore) {
                                                       if ([self.tableView.mj_footer isRefreshing]) {
                                                           [self.tableView.mj_footer endRefreshing];
                                                       }
                                                   }
                                                   [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
                                               }];
    }else{
        [SVProgressHUD show];
        [HomeRequestHelper searchGoodsSupplyWithcarType:[self currentCarType] 
                                              goodsType:[self currentGoodsType]  
                                                   from:from
                                                     to:to
                                                   page:page
                                                Success:^(NSArray<SFSearchResultProtocol> *result) {
                                                    [SVProgressHUD dismiss];
                                                    [self handleSearchResult:result isMore:isMore];
                                                } fault:^(SFNetworkError *err) {
                                                    [SVProgressHUD dismiss];
                                                    if (isMore) {
                                                        if ([self.tableView.mj_footer isRefreshing]) {
                                                            [self.tableView.mj_footer endRefreshing];
                                                        }
                                                    }
                                                    [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
                                                }];
    }
}


- (NSString *)currentCarType
{
    NSString *str = [self carTypeArray][self.carsType];
    if ([str isEqualToString:@"全部"]) {
        return @"";
    }
    return str;
}

- (NSString *)currentGoodsType
{
    NSString *str = [self goodsTypeArry][self.goodsType];
    if ([str isEqualToString:@"全部"]) {
        return @"";
    }
    return str;
}

- (void)handleSearchResult:(NSArray <SFSearchResultProtocol>*)result isMore:(BOOL)isMore
{
    if (isMore) {
        if ([self.tableView.mj_footer isRefreshing]) {
            if (result.count) {
                [self.tableView.mj_footer endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.dataArray addObjectsFromArray:result];
        [self.tableView reloadData];
    }else{
        self.dataArray  = [result mutableCopy];
        BOOL isShowFilterBar  = self.dataArray.count  ||  self.currentCarType.length || self.currentCarType.length;
        [self.tableView reloadData];
        if (self.dataArray.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:NO];
            });
        }
        if (self.tableView.mj_footer == nil && self.dataArray.count > 4) {
            __weak typeof(self) wself = self;
            self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [wself refreshWithIsMore:YES];
            }];
        }
    }
    
    
    
    
}


#pragma  mark   uitableView delegate and datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeViewCell" forIndexPath:indexPath];
    cell.delegate      = self;
    ResourceType  resourceType  = self.searchType == SFSearchTypeCars ? Resource_Car : Resource_Order;
    [cell setModel:self.dataArray[indexPath.section] withResourceType:resourceType];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 138;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFUserInfo *account = [SFUserInfo defaultInfo];
    if (self.searchType == SFSearchTypeGoods && account.role == SFUserRoleGoodsownner) {
        [[[SFTipsView alloc] init] showFailureWithTitle:@"货主不能预订货物"];
        return;
    } else if (self.searchType == SFSearchTypeCars && account.role == SFUserRoleCarownner) {
        [[[SFTipsView alloc] init] showFailureWithTitle:@"车主不能预订车辆"];
        return;
    }
    id<SFSearchResultProtocol>model  = self.dataArray[indexPath.row]; 
    [SFOrderDetailController pushFromViewController:self orderID:model.guid];
}


#pragma mark  HomeViewCellDelegate
- (void)HomeViewCell:(HomeViewCell *)cell didClickOptionButton:(UIButton *)button
{
    id<SFSearchResultProtocol>model  = cell.model; 
    [SFOrderDetailController pushFromViewController:self orderID:model.guid];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView

{
    // tableViewHeader 跟随滚动
    CGFloat sectionHeaderHeight = 10;
    
    if (scrollView == _tableView) {
        
        //去掉UItableview的section的headerview黏性
        
        if (scrollView.contentOffset.y<=sectionHeaderHeight && scrollView.contentOffset.y>=0) {
            
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            
        }
        
    }
    
}




@end
