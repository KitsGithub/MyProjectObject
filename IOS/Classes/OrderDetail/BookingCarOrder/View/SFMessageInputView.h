//
//  SFInputView.h
//  SFLIS
//
//  Created by kit on 2017/12/1.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MessageKeyBoardType_ALLLetter,
    MessageKeyBoardType_NumberOnly,
    MessageKeyBoardType_FloatOnly,
} MessageKeyBoardType;

@protocol SFMessageInputViewDelegate <NSObject>

- (void)sfMessageInputViewDidFinishedEditting:(NSString *)str;

@end

@interface SFMessageInputView : UIView <UITextFieldDelegate>

@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, copy) NSString *tipsStr;
@property (nonatomic, assign) MessageKeyBoardType keyBoardType;
@property (nonatomic, copy, readonly) NSString *inputStr;

@property (nonatomic, weak) id <SFMessageInputViewDelegate> delegate;

- (void)setTitleStr:(NSString *)title;

@end
