//
//  SFMenuView.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/17.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFMenuView.h"



@interface SFMenuCell : UITableViewCell

@property (nonatomic,strong)UIButton *cellBtn;

@property (nonatomic,strong)NSString *title;

@property (nonatomic,strong)UIImage *image;

@end

@implementation SFMenuCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _cellBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _cellBtn.frame = self.bounds;
        _cellBtn.userInteractionEnabled  = NO;
        [_cellBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _cellBtn.tintColor  = [UIColor whiteColor];
        [_cellBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
        [_cellBtn setTitleEdgeInsets:(UIEdgeInsetsMake(0, 5, 0, -5))];
        [self addSubview:_cellBtn];
    }
    return self;
}


- (void)setTitle:(NSString *)title
{
    _title  = title;
    [self.cellBtn setTitle:title forState:(UIControlStateNormal)];
    [self adjustIfNeed];
}

- (void)setImage:(UIImage *)image
{
    _image  = image;
    [self.cellBtn setImage:image forState:(UIControlStateNormal)];
    [self adjustIfNeed];
}

- (void)adjustIfNeed
{
//    if (self.cellBtn.titleLabel.text.length && self.cellBtn.imageView.image) {
//        [[self cellBtn] interconvertImageAndTitleWithMargin:10];
//    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.cellBtn.frame  = self.bounds;
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *ciew = [super hitTest:point withEvent:event];
    
    return ciew;
}


@end

@implementation SFMenuView


- (instancetype)initWithTitles:(NSArray <NSString *>*)titles icons:(NSArray <UIImage *>*)icons
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 102, 4 + 44 * titles.count)]) {
        _titles  = titles;
        _icons   = icons;
        [self setup];
    }
    return self;
}

- (void)setup
{
    _bgImageView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu"]];
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    self.bgImageView.frame  = self.bounds;
    self.bgImageView.clipsToBounds  = YES;
    _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0,4,self.bounds.size.width,self.bounds.size.height-4) style:(UITableViewStylePlain)];
    _tableView.delegate  = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[SFMenuCell class] forCellReuseIdentifier:@"SFMenuCell"];
    _tableView.backgroundColor  = [UIColor clearColor];
    _tableView.separatorInset   = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.bgImageView addSubview:self.tableView];
}

- (void)showWithSourceView:(UIView *)sourceView Completion:(void(^)(NSInteger index))completion
{
    self.completion  = completion;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *overView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    overView.backgroundColor  = [UIColor clearColor];
    [window addSubview:overView];
    
    CGRect from   = [sourceView convertRect:sourceView.superview.bounds toView:overView];
    from.size.width = sourceView.bounds.size.width;
    from.size.height = sourceView.bounds.size.height;

    self.frame = (CGRect){{from.origin.x,CGRectGetMaxY(from)},{self.bounds.size.width - from.origin.x,self.bounds.size.height}};
   
    
    [overView addSubview:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBg:)];
    tap.delegate  = self;
    [overView addGestureRecognizer:tap];
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.superview];
    CGRect rect = [self extentWithRect:self.frame redius:20];
    if (CGRectContainsPoint(rect, point)) {
        return NO;
    }
    return YES;
}

- (CGRect)extentWithRect:(CGRect)rect redius:(CGFloat)redius
{
//    rect.origin.x  = (rect.origin.x - redius) > 0 ? rect.origin.x - redius : 0;
//    rect.origin.y  = (rect.origin.y - redius) > 0 ? rect.origin.y - redius : 0;
    rect.size.width = rect.size.width + redius * 2;
    rect.size.height = rect.size.height + redius * 2;
    return rect;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        return [self.tableView hitTest:point withEvent:event];
    }
    return view;
}


- (void)tapBg:(UITapGestureRecognizer *)sender
{
    if (self.completion) {
        self.completion(-1);
    }
    [self dismiss];
}

- (void)dismiss
{
    UIView *overView = self.superview;
    [self removeFromSuperview];
    [overView removeFromSuperview];
}

+ (SFMenuView *)showWithTitles:(NSArray <NSString *>*)titles icons:(NSArray <UIImage *>*)icons fromView:(UIView *)view completion:(void(^)(NSInteger selectedIndex))completion
{
    SFMenuView *menu = [[SFMenuView alloc] initWithTitles:titles icons:icons];
    [menu showWithSourceView:view Completion:completion];
    return menu;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SFMenuCell" forIndexPath:indexPath];
    cell.title = self.titles[indexPath.row];
    cell.image  = self.icons[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.completion) {
        self.completion(indexPath.row);
    }
    [self dismiss];
}


@end
