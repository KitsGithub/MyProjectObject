//
//  BaseCordvaViewController.h
//  SFLIS
//
//  Created by kit on 2017/9/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Cordova/CDVViewController.h>
#import <Cordova/CDVCommandDelegateImpl.h>
#import <Cordova/CDVCommandQueue.h>

@interface BaseCordvaViewController : CDVViewController{
    UIButton *_baseCustomBackButton;
}


@property (nonatomic,strong)id startObj;



@end
