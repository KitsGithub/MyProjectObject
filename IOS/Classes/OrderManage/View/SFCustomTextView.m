//
//  SFCustomTextView.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/23.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFCustomTextView.h"


@interface SFCustomTextView()<UITextViewDelegate>

@property (nonatomic,strong)UITextView  *textView;

@property (nonatomic,strong)UILabel  *placeholderLable;

@property (nonatomic,strong)UILabel  *countLable;

@end

@implementation SFCustomTextView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self  = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self  = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    
    _textView  = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, self.bounds.size.width - 10 * 2, self.bounds.size.height - 10 * 2 - 12 - 10)];
    _textView.delegate  = self;
    _textView.tintColor  = COLOR_TEXT_DARK;
    _textView.textColor  = COLOR_TEXT_COMMON;
    _textView.font       = [UIFont systemFontOfSize:14];
    _textView.textContainerInset  = UIEdgeInsetsMake(0, 0, 0, 0);
    [_textView setValue:@100 forKey:@"limit"];
    [self addSubview:_textView];
    
    _placeholderLable  = [[UILabel alloc] initWithFrame:CGRectMake(11, 10, [UIScreen mainScreen].bounds.size.width - 10 * 2, 16)];
    _placeholderLable.font  = [UIFont systemFontOfSize:14];
    _placeholderLable.textColor  = COLOR_TEXT_DARK;
    [self addSubview:_placeholderLable];
    _placeholderLable.text  = @"请输入......";
    
    _countLable  = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.textView.frame) + 10,self.textView.bounds.size.width , 12)];
    _countLable.textAlignment  = NSTextAlignmentRight;
    _countLable.font  = [UIFont systemFontOfSize:12];
    _countLable.textColor  = [UIColor colorWithHexString:@"#c3c3c3"];
    [self addSubview:_countLable];
    _countLable.text = @"0/100";
}


- (void)setText:(NSString *)text
{
    _text  = text;
    self.textView.text  = text;
}

- (NSString *)text
{
    _text  = self.textView.text;
    return _text;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.placeholderLable.text  = placeholder;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.placeholderLable.hidden  = YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    self.countLable.text  = [NSString stringWithFormat:@"%lu/100",(unsigned long)textView.text.length];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length) {
        self.placeholderLable.hidden  = YES;
    }else{
        self.placeholderLable.hidden  = NO;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _textView.frame  = CGRectMake(10, 10, self.bounds.size.width - 10 * 2, self.bounds.size.height - 10 * 2 - 12 - 10);
    _placeholderLable.frame  = CGRectMake(11, 10, [UIScreen mainScreen].bounds.size.width - 10 * 2, 16);
    _countLable.frame  = CGRectMake(0, CGRectGetMaxY(self.textView.frame) + 10,self.textView.bounds.size.width , 12);
    
}


@end
