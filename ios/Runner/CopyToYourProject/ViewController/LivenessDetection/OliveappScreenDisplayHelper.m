//
//  OliveappScreenDisplayHelper.m
//  AppSampleYitu
//
//  Created by kychen on 17/1/13.
//  Copyright © 2017年 Oliveapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OliveappScreenDisplayHelper.h"

//NSString * const IPHONE = @"iPhone";
//NSString * const IPOD = @"touch";

@interface OliveappScreenDisplayHelper()

@end

@implementation OliveappScreenDisplayHelper

+ (OliveappDeviceOrientation)getFixedOrientation {
    
    OliveappDeviceOrientation orientation;
    if (![OliveappScreenDisplayHelper deviceIsIPAD]) {
        orientation = PORTRAIT;
    } else {
        //如果不是iphone或者ipod那就是ipad
        //我们推荐返回portrait
        orientation = PORTRAIT;
        //也可以返回landscape 有 landscapeleft 或者 landscaperight
//        orientation = LANDSCAPE_LEFT;
//        orientation = LANDSCAPE_RIGHT;
    }
    return orientation;
}

+ (BOOL)deviceIsIPAD {
    return NO;
//    NSString * deviceType = [UIDevice currentDevice].model;
//    if ([deviceType rangeOfString:IPHONE].location != NSNotFound || [deviceType rangeOfString:IPOD].location != NSNotFound) {
//        return NO;
//    } else {
//        return YES;
//   }
}

@end
