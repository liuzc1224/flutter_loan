//
//  MainViewController.m
//  Runner
//
//  Created by xujinzheng on 2020/4/30.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "MainViewController.h"
#include "GeneratedPluginRegistrant.h"
#import "TestViewController.h"
#import "AAILivenessViewController.h"

/** 信号通道，须与flutter里一致*/
#define flutterMethodChannel  @"Flutterplugin3Plugin"
/** 交互方法字段名，须与flutter里一致*/
#define flutterMethodPush  @"flutter_push_to_ios"
#define flutterMethodPresent  @"flutter_present_to_ios"

@interface MainViewController ()

@property(nonatomic,strong) FlutterMethodChannel* methodChannel;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self methodChannelFunction];
}
- (void)methodChannelFunction {
    //创建 FlutterMethodChannel
    self.methodChannel = [FlutterMethodChannel
                          methodChannelWithName:flutterMethodChannel binaryMessenger:self];
    //设置监听
    [self.methodChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        // TODO
        NSString *method=call.method;
        if ([method isEqualToString:flutterMethodPush]) {
           AAILivenessViewController *vc = [[AAILivenessViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            //此方法只能调用一次
            result(@"push返回到flutter");
        }else if ([method isEqualToString:flutterMethodPresent]) {
            TestViewController *vc = [[TestViewController alloc] init];
            [self presentViewController:vc animated:NO completion:nil];
            //此方法只能调用一次
            result(@"present返回到flutter");
        }
        
    }];
    [GeneratedPluginRegistrant registerWithRegistry:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
