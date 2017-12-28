//
//  SFMoreSelectedButtonView.h
//  SFLIS
//
//  Created by kit on 2017/10/19.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFMoreSelectedButtonView : UIView

- (void)setTitleViewWithArray:(NSArray <NSString *>*)titleArray;


- (NSArray <NSNumber *>*)getSelectedIndex;

@property (nonatomic, assign) CGFloat buttonPadding;


@end
