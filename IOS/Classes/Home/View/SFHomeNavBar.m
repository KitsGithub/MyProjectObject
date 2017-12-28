//
//  SFHomeNavBar.m
//  SFLIS
//
//  Created by kit on 2017/10/10.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFHomeNavBar.h"
#import "SFSegmentControl.h"


@implementation SFHomeNavBar {
    UIButton *_userIcon;
    UIButton *_searchBtn;
    UIView *_lineView;
    
    SFSegmentControl *_seg;
    BOOL hasSubView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    _userIcon = [UIButton new];
    [_userIcon setImage:[UIImage imageNamed:@"Default_Head"] forState:(UIControlStateNormal)];
    _userIcon.layer.cornerRadius = 15;
    _userIcon.clipsToBounds = YES;
    [_userIcon addTarget:self action:@selector(userIconDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_userIcon];
    
    [_userIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Resource_URL,SF_USER.small_head_src]] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"Default_Head"]];
    
    
    
    _searchBtn = [UIButton new];
    [_searchBtn setImage:[UIImage imageNamed:@"Home_Search"] forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(searchDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_searchBtn];
    
    
    
    __weak typeof(self) weakSelf = self;
    _seg = [[SFSegmentControl alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 140)  * 0.5, STATUSBAR_HEIGHT + 8, 140, 28) items:@[@"货源",@"车源"]];
    _seg.selectedBlock = ^(NSInteger index) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(SFHomeNavBar:didChangeReourceType:)]) {
            [weakSelf.delegate SFHomeNavBar:weakSelf didChangeReourceType:index];
        }
        
    };
    [self addSubview:_seg];
    
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
    _lineView.hidden = YES;
    [self addSubview:_lineView];
    
    //用户资料更改通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserInfoChange) name:SF_USER_MESSAGECHANGE_N object:nil];
    
    //用户登出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserInfoChange) name:SF_LOGOUT_SUCCESS_N object:nil];
    
    //用户登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserInfoChange) name:SF_LOGIN_SUCCESS_N object:nil];
    
    hasSubView = YES;
}

- (void)UserInfoChange {
    [_userIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Resource_URL,SF_USER.small_head_src]] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"Default_Head"]];
}


- (void)setSearchImage:(NSString *)searchImage {
    _searchImage = searchImage;
    
    [_searchBtn setImage:[UIImage imageNamed:searchImage] forState:UIControlStateNormal];
}

- (void)setLineViewHidden:(BOOL)hidden {
    if (hidden != _lineView.hidden) {
        _lineView.hidden = hidden;
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    _seg.currentIndex = currentIndex;
}

#pragma mark - UI Action
- (void)userIconDidClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(SFHomeNavBar:didClickUserIcon:)]) {
        [self.delegate SFHomeNavBar:self didClickUserIcon:sender];
    }
}

- (void)searchDidClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(SFHomeNavBar:didClickSearchIcon:)]) {
        [self.delegate SFHomeNavBar:self didClickSearchIcon:sender];
    }
}




#pragma -
- (void)layoutSubviews {
    if (hasSubView) {
        
        _userIcon.frame = CGRectMake(12, STATUSBAR_HEIGHT + 7, 30, 30);
        
        _searchBtn.frame = CGRectMake(SCREEN_WIDTH-44, _userIcon.center.y - 22, 44, 44);
        
        _lineView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5);
    }
}
@end
