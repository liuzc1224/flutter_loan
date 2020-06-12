//
//  AAIConstant.h
//  AAILivenessDemo
//
//  Created by Advance.ai on 2019/2/18.
//  Copyright © 2019 Advance.ai. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef AAIDetectionConstant_h
#define AAIDetectionConstant_h

typedef enum : NSUInteger {
    ///Not detect
    AAIDetectionTypeNone = 0,
    ///Blink
    AAIDetectionTypeBlink = 1,
    ///Open mouth
    AAIDetectionTypeMouth = 2,
    ///Turn head
    AAIDetectionTypePosYaw = 3,
} AAIDetectionType;

typedef enum : NSInteger {
    AAIDetectionResultTimeout,
    AAIDetectionResultUnknown,
    
    AAIDetectionResultFaceMissing,
    AAIDetectionResultFaceLarge,
    AAIDetectionResultFaceSmall,
    AAIDetectionResultFaceNotCenter,
    AAIDetectionResultFaceNotFrontal,
    AAIDetectionResultFaceNotStill,
    
    AAIDetectionResultWarnMutipleFaces,
    AAIDetectionResultWarnEyeOcclusion,
    AAIDetectionResultWarnMouthOcclusion,
    
    AAIDetectionResultFaceCapture,
    AAIDetectionResultFaceInAction,
    AAIDetectionResultOkActionDone,
    
    AAIDetectionResultErrorMutipleFaces,
    AAIDetectionResultErrorFaceMissing,
    AAIDetectionResultErrorMuchMotion,
    
    AAIDetectionResultOkCounting,
    
    AAIDetectionResultWarnMotion,
    AAIDetectionResultWarnLargeYaw,
} AAIDetectionResult;

typedef enum : NSInteger {
    AAIActionStatusUnknown,
    AAIActionStatusNoFace,
    AAIActionStatusFaceCheckSize,
    AAIActionStatusFaceSizeReady,
    AAIActionStatusFaceCenterReady,
    AAIActionStatusFaceFrontalReady,
    AAIActionStatusFaceCaptureReady,
    AAIActionStatusFaceMotionReady,
    AAIActionStatusFaceBlink,
    AAIActionStatusFaceMouth,
    AAIActionStatusFaceYaw
} AAIActionStatus;

typedef enum : NSUInteger {
    AAILivenessMarketIndonesia = 0,
    AAILivenessMarketIndia = 1,
    AAILivenessMarketPhilippines = 2,
    AAILivenessMarketVietnam = 3
} AAILivenessMarket;

///Detection timeout inteval
FOUNDATION_EXPORT int const aai_timeout_interval;

///Notification name when the network status changes.
FOUNDATION_EXPORT NSString * const AAINetworkDidChangedNotification;

///The key for current network status value in 'userInfo' object of NSNotification object
FOUNDATION_EXPORT NSString * const AAINetworkNotificationResultItem;

#endif /* AAIDetectionConstant_h */
