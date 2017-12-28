//
//  SFChooseReleaseTimeController.m
//  SFLIS
//
//  Created by kit on 2017/11/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFChooseReleaseTimeController.h"

static NSString *CHOOSERELEASEID = @"CHOOSERELEASEID";

@interface SFChooseReleaseTimeController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray <NSString *>*titleArray;

@end

@implementation SFChooseReleaseTimeController {
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNav];
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.block) {
        self.block(self.titleArray[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupNav {
    self.title = @"发布周期";
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(saveAction)];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)setupView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + 44, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_HEIGHT - 44) style:(UITableViewStylePlain)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CHOOSERELEASEID];
    
    
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
#endif
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CHOOSERELEASEID forIndexPath:indexPath];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"666666"];
    return cell;
}



- (NSMutableArray<NSString *> *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"只发布一次",@"发布一个月",@"发布半年",@"发布一年",@"长期有效", nil];
    }
    return _titleArray;
}

@end
