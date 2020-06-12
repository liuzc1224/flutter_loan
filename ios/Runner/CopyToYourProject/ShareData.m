//
//  ShareData.m
//  AppDemoPresale
//
//  Created by Xiaoyang Lin on 16/3/10.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//

#import "ShareData.h"

@interface ShareData()
@property int actionCandidateNumber;//候选动作总数
@end
@implementation ShareData


+ (instancetype)sharedInstance {
    static ShareData *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
        _sharedInstance.actionCandidateNumber = 4;
        _sharedInstance.actionCount = 3;
        _sharedInstance.inf = 100000000;
        _sharedInstance.actionTime = 10000;
        _sharedInstance.fixActionList = NO;
        _sharedInstance.model = @"release";
        _sharedInstance.fanpaiClsImageNumber = 1;
        _sharedInstance.saasUrl = @"http://staging.yitutech.com";
        _sharedInstance.testId = @"testid";
        _sharedInstance.saveRgb = NO;
        _sharedInstance.saveFanpaiCls = NO;
        _sharedInstance.saveOriginImage = NO;
        _sharedInstance.savePackage = NO;
        _sharedInstance.antiScreenThreshold = 1;
        _sharedInstance.withPrestart = YES;
        _sharedInstance.newPackage = NO;
        _sharedInstance.enableRecording = NO;
    });
    
    return _sharedInstance;
}

/*
 * 重置动作序列
 */
- (void) resetActionListArray {
    
    NSLog(@"[BEGIN] fixActionListMethod");
    self.actionListArray = [[NSMutableArray alloc] init];
    for (int i = 0;i < self.actionCandidateNumber;++i) {
        [self.actionListArray addObject:@1];
    }
    NSLog(@"[END] fixActionListMethod");
}
@end
