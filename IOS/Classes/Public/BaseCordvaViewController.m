//
//  BaseCordvaViewController.m
//  SFLIS
//
//  Created by kit on 2017/10/11.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "BaseCordvaViewController.h"

@interface BaseCordvaViewController ()

@property (nonatomic,assign)BOOL  didLoad;

@end

@implementation BaseCordvaViewController


- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setup];
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self setup];
    return self;
}

- (id)init
{
    self = [super init];
    [self setup];
    return self;
}

- (void)setup
{
    self.wwwFolderName = SFWL_H5_PATH;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLoad) name:CDVPageDidLoadNotification object:nil];
    
    if ([self respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.didLoad) {
        [self performSelector:@selector(showhud) withObject:nil afterDelay:0.1];
    }
}

- (void)showhud
{
    [SVProgressHUD show];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)dealloc
{
    [SVProgressHUD dismiss];
    NSLog(@"%@ 销毁了",NSStringFromClass(self.class));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)finishLoad
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showhud) object:nil];
    self.didLoad  = YES;
    [SVProgressHUD dismiss];
}



@end
