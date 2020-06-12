//
//  AAIAudioUtil.h
//  AAILivenessSDK
//
//  Created by Advance.ai on 2019/2/22.
//  Copyright © 2019 Advance.ai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AAILocalizationUtil : NSObject

/**
 Return `lproj` name. For example:`en`, `id`, `vi`, `zh-Hans`

 @return A string representation of device system language.
 */
+ (NSString * _Nullable)currLanguageKey;

/**
 Return a string representation of device system locale, For example: `en_US`.

 @return A string representation of device system locale.
 */
+ (NSString *)currOriginLanguageKey;

/**
 Determines whether device is in the vertical direction, this method is only a rough judgment and is not accurate.

 @return YES if device is in the vertical direction, otherwise NO.
 */
+ (BOOL)isPortraitDirection;

/**
 Stops device-motion updates.
 */
+ (void)stopMonitor;

@end

NS_ASSUME_NONNULL_END
