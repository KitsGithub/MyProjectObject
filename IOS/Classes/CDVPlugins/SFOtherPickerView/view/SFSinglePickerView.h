//
//  SFSinglePickerView.h
//  SFLIS
//
//  Created by kit on 2017/10/26.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFSinglePickerProtocol.h"

@interface SFSinglePickerView : UIView <SFSinglePickerProtocol>

@property (nonatomic, weak) id <SFSinglePickerProtocol>delegate;

@property (nonatomic, copy) NSString *title;

- (void)showAnimation;
- (instancetype)initWithFrame:(CGRect)frame withResourceArray:(NSArray <NSString *> *)array;

@end
