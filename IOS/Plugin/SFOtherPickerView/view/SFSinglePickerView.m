//
//  SFSinglePickerView.m
//  SFLIS
//
//  Created by kit on 2017/10/26.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFSinglePickerView.h"
#import "SFSinglePickerCell.h"

@interface SFSinglePickerView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray <NSString *>*resourceArray;

@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation SFSinglePickerView {
    UIButton *_bjView;
    UIView *_contentView;
    
    UILabel *_titleLabel;
    UIButton *_closeButton;
    UITableView *_tableView;
    UIButton *_commitButton;
}

- (instancetype)initWithFrame:(CGRect)frame withResourceArray:(NSArray <NSString *> *)array {
    if (self = [super initWithFrame:frame]) {
        self.resourceArray = [array copy];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _bjView = [UIButton new];
    _bjView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [_bjView addTarget:self action:@selector(bjButtonDidClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_bjView];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.contentHeight)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.text = @"选择";
    _titleLabel.textColor = BLACKCOLOR;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_titleLabel];
    
    
    _closeButton = [UIButton new];
    [_closeButton setImage:[UIImage imageNamed:@"Nav_Close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(bjButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_closeButton];
    
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[SFSinglePickerCell class] forCellReuseIdentifier:@"SFSinlePickerCell"];
    [_contentView addSubview:_tableView];
    
    _commitButton = [UIButton new];
    [_commitButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [_commitButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_commitButton setBackgroundColor:THEMECOLOR];
    [_commitButton setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    [_commitButton addTarget:self action:@selector(commitButtonDidClick) forControlEvents:(UIControlEventTouchUpInside)];
    [_contentView addSubview:_commitButton];
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}


#pragma mark - animation
/**
 展示动画
 */
- (void)showAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT - self.contentHeight, SCREEN_WIDTH, self.contentHeight);
        _bjView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hiddenAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, self.contentHeight);
        _bjView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - UIAction
- (void)bjButtonDidClick {
    if ([self.delegate respondsToSelector:@selector(pickerViewDidSelectedCancel:)]) {
        [self.delegate pickerViewDidSelectedCancel:self];
    }
    [self hiddenAnimation];
}

- (void)commitButtonDidClick {
    NSArray *array = _tableView.indexPathsForSelectedRows;
    if (!array.count) {
        [[[SFTipsView alloc] init] showFailureWithTitle:@"请选择类型"];
        return;
    }
    NSIndexPath *indexPath = [array firstObject];
    
    if ([self.delegate respondsToSelector:@selector(pickerView:commitDidSelected:resourceArray:)]) {
        [self.delegate pickerView:self commitDidSelected:indexPath.row resourceArray:[self.resourceArray copy]];
    }
    [self hiddenAnimation];
}

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFSinglePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SFSinlePickerCell" forIndexPath:indexPath];
    cell.title = self.resourceArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)layoutSubviews {
    _bjView.frame = self.bounds;
    
    CGSize titleSize = [_titleLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:20] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _titleLabel.frame = CGRectMake(20, 20, titleSize.width, titleSize.height);
    
    CGFloat closeButtonWH = 16;
    _closeButton.frame = CGRectMake(SCREEN_WIDTH - 20 - closeButtonWH, 20, closeButtonWH, closeButtonWH);
    
    CGFloat tableViewY = CGRectGetMaxY(_titleLabel.frame) + 20;
    _tableView.frame = CGRectMake(0, tableViewY, SCREEN_HEIGHT, self.contentHeight - tableViewY - 50);
    
    _commitButton.frame = CGRectMake(0, self.contentHeight - 50, SCREEN_WIDTH, 50);
}

#pragma mark - lazyLoad
- (CGFloat)contentHeight {
    if (!_contentHeight) {
        CGFloat scale = 431.0 / 667.0;
        _contentHeight = SCREEN_HEIGHT * scale;
    }
    return _contentHeight;
}


@end
