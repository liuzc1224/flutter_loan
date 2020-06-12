//
//  OliveappScreenDisplayHelper.h
//  AppSampleYitu
//
//  Created by kychen on 17/1/13.
//  Copyright © 2017年 Oliveapp. All rights reserved.
//

@interface OliveappScreenDisplayHelper : NSObject

typedef NS_ENUM(int,OliveappDeviceOrientation) {
    PORTRAIT = 0,
    LANDSCAPE_LEFT = 1,
    LANDSCAPE_RIGHT = 2
};



+ (OliveappDeviceOrientation)getFixedOrientation;
+ (BOOL)deviceIsIPAD;

@end
