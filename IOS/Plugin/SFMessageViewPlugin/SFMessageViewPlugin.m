//
//  SFMessageViewPlugin.m
//  SFLIS
//
//  Created by kit on 2017/11/3.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFMessageViewPlugin.h"

@implementation SFMessageViewPlugin

- (void)showSuccessMessage:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        
        NSString *message = [command argumentAtIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[SFTipsView alloc] init] showSuccessWithTitle:message];
        });
    }];
}


- (void)showErrorMessage:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        
        NSString *message = [command argumentAtIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[SFTipsView alloc] init] showFailureWithTitle:message];
        });
    }];
}

@end
