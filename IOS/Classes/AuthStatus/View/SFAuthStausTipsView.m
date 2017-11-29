//
//  SFAuthStausTipsView.m
//  SFLIS
//
//  Created by kit on 2017/11/20.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFAuthStausTipsView.h"

@implementation SFAuthStausTipsView {
    UILabel *_tipsLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _tipsLabel = [UILabel new];
    _tipsLabel.numberOfLines = 0;
    _tipsLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _tipsLabel.font = [UIFont systemFontOfSize:14];
    _tipsLabel.text = @"• 您可以通过上传能表明您身份的证件照进行实名认证。\n• 审审核通过后，您将成为实名用户，并可以正常使用接单、发货等功能。\n• 审核通过后，您可以通过上传其他证件进一步升级为认证用户，享受更多特权。\n• 审核通过后，用户角色将不能自行修改。如需要修改，请联系客服。\n• 如需任何帮助，请拨打010-62966788联系客服（工作时间：每周一至周日8:00-20:00）。";
    [self addSubview:_tipsLabel];
    
    CGSize tipsSize = [_tipsLabel.text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT)];
    _tipsHeight = tipsSize.height;
    _tipsLabel.frame = CGRectMake(20, 0, SCREEN_WIDTH - 40, tipsSize.height);
    
}



@end
