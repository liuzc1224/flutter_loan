//
//  ShareData.h
//  AppDemoPresale
//
//  Created by Xiaoyang Lin on 16/3/10.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareData : NSObject
@property (strong, nonatomic) NSString * model;
@property NSUInteger actionCount; //动作个数
@property NSUInteger actionTime; //活检超时时间
@property NSUInteger fanpaiClsImageNumber; //用于比对的翻拍照数量
@property BOOL fixActionList; //固定动作序列按钮
@property BOOL saveRgb; //是否存rgb图
@property BOOL saveOriginImage; //是否存原图
@property BOOL savePackage; //是否存大礼包
@property BOOL saveFanpaiCls; //是否存翻拍照
@property BOOL saveJPEG; //是否存JPEG
@property BOOL newPackage; // 是否开启信息收集
@property BOOL withPrestart; //是否预检
@property BOOL padLandscape; //Pad是否横屏
@property NSUInteger darkLevel; // 昏暗检测阈值，0无，1低，2中，3高
@property (strong,nonatomic) NSMutableArray * actionListArray; //动作序列
@property (strong, nonatomic) NSString * saasUrl;
@property (strong, nonatomic) NSString * testId;
@property int inf;

@property BOOL enableRecording; // 是否录制视频

//后台阈值相关参数
@property NSUInteger antiScreenThreshold;
/**
 *  单例模式
 *
 *  @return 单例
 */
+ (instancetype) sharedInstance;

/**
 *  重置动作序列
 */
- (void) resetActionListArray;

@end
