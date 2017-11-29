//
//  SFPasswordInputViewCell.h
//  SFLIS
//
//  Created by kit on 2017/11/13.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EndEdittingBlock)();

@interface SFInputViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, copy,readonly) NSString *value;

@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, assign) BOOL secureTextEntry;

@property (nonatomic, copy) EndEdittingBlock endEdittingBlock;

- (void)setButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
