//
//  LivenessDetectionViewController.h
//  LivenessDetectionViewSDK
//
//  Created by Jiteng Hao on 16/1/11.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OliveappViewUpdateEventDelegate.h"
#import "LivenessResultDelegate.h"
#import "OliveappUserInfo.h"
#import "OliveappSessionManagerConfig.h"

@interface LivenessDetectionViewController : UIViewController <OliveappViewUpdateEventDelegate>

- (BOOL) initLivenessDetection: (id<LivenessResultDelegate>) delegate
                      withMode: (int) mode
               withFanPaiCheck: (BOOL) needFanPaiCheck
      withSessionManagerConfig: (OliveappSessionManagerConfig*) config
                     withError: (NSError **) error;

@end
