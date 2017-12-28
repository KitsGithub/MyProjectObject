//
//  SFOtherPickerView.h
//  SFLIS
//
//  Created by kit on 2017/10/13.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFSinglePickerProtocol.h"

@interface SFOtherPickerView : UIView <SFSinglePickerProtocol>

- (instancetype)initWithFrame:(CGRect)frame withResourceArray:(NSArray <NSString *>*)resourceArray;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, weak) id <SFSinglePickerProtocol> delegate;


/**
 展示动画
 */
- (void)showAnimation;


@end
