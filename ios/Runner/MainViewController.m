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
#import "OliveappLivenessDetectionViewController.h"
#import "ShareData.h"


/** 信号通道，须与flutter里一致*/
#define flutterMethodChannel  @"Flutterplugin3Plugin"
/** 交互方法字段名，须与flutter里一致*/
#define flutterMethodPush  @"flutter_push_to_ios"
#define flutterMethodPresent  @"flutter_present_to_ios"
#define flutterMethodPushYiTu  @"flutter_push_to_ios_yiTu"

@interface MainViewController ()

@property(nonatomic,strong) FlutterMethodChannel* methodChannel;
@property (nonatomic, copy)FlutterEventSink eventSink;
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
           //[self.navigationController pushViewController:vc animated:YES];
          [self presentViewController:vc animated:YES completion:^{
                     
            }];

      
            [vc setResult:^(NSDictionary * info) {


                     [vc dismissViewControllerAnimated:YES completion:nil];

               NSString *livenessId =   info[@"livenessId"];
                   UIImage *bestImg = info[@"img"];
                NSString *base64Str = [UIImagePNGRepresentation(bestImg) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    result([NSString stringWithFormat:@"%@,%@",livenessId,base64Str]);


            }];
         
        
        }
        else if ([method isEqualToString:flutterMethodPushYiTu]) {
            NSLog(@"开始活体检测");
            UIStoryboard * board = [UIStoryboard storyboardWithName:@"LivenessDetection" bundle:nil];
            OliveappLivenessDetectionViewController * livenessDetectionViewController;

                livenessDetectionViewController = (OliveappLivenessDetectionViewController *)[board instantiateViewControllerWithIdentifier:@"LivenessDetectionStoryboard"];
                //以下样例代码展示了如何初始化活体检测
            __weak typeof(self) weakSelf = self;
                NSError *error;
                BOOL isSuccess;
                isSuccess = [livenessDetectionViewController setConfigLivenessDetection: weakSelf
                withError: &error];
                //弹出活体检测界面，可用show,push
            [self presentViewController:livenessDetectionViewController animated:YES completion:^{
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }];
            [livenessDetectionViewController setResult:^(NSDictionary * info) {
                [livenessDetectionViewController dismissViewControllerAnimated:YES completion:nil];
                //NSLog(@"检测信息%@",info);
                result([NSString stringWithFormat:@"%@",info]);
           }];
        }
//        else if ([method isEqualToString:flutterMethodPresent]) {
//            TestViewController *vc = [[TestViewController alloc] init];
//            [self presentViewController:vc animated:NO completion:nil];
//            //此方法只能调用一次
//            result(@"present返回到flutter");
//        }
        
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

- (IBAction)gotoFlutter:(id)sender {
    FlutterViewController *flvc = [[FlutterViewController alloc] init];
    //单项通信管道，Flutter向原生发送消息
    FlutterMethodChannel *messageChannel = [FlutterMethodChannel methodChannelWithName:@"com.nativeToFlutter" binaryMessenger:flvc];
    __weak typeof(self) weakSelf = self;
    [messageChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([@"backToNative" isEqualToString:call.method]) {
            [weakSelf dismissViewControllerAnimated:true completion:nil];
        }
    }];
    
    //单项通信管道，原生向Flutter发送消息
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"com.nativeToFlutter" binaryMessenger:flvc];
    [eventChannel setStreamHandler:self];
    
    [self presentViewController:flvc animated:true completion:nil];
}



#pragma --mark FlutterStreamHandler代理
- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(FlutterEventSink)events {
    if (events) {
        self.eventSink  = events;
        self.eventSink(@"从原生传递过来的消息。。。。。。。");
    }
    return nil;
}
// 不再需要向Flutter传递消息
- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    return nil;
}
/**
 *  活体检测成功的回调
 *
 *  @param detectedFrame 返回检测到的图像
 */
- (void) onLivenessSuccess: (OliveappDetectedFrame*) detectedFrame {
  NSLog(@"活体检测成功");
}
/**
 *  活体检测失败的回调
 *
 *  @param sessionState  活体检测的返回状态(只有超时)
 *  @param detectedFrame 返回检测到的图像(暂时未nil)
 */
- (void) onLivenessFail: (int)sessionState withDetectedFrame: (OliveappDetectedFrame*)detectedFrame {
    NSLog(@"活体检测失败");
}
/**
 取消活体检测
 */
- (void)onLivenessCancel {
    NSLog(@"活体检测取消");
//    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
