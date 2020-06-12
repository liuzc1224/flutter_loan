//
//  AAILivenessUtil.m
//  AAILivenessDemo
//
//  Created by Advance.ai on 2019/3/2.
//  Copyright © 2019 Advance.ai. All rights reserved.
//

#import "AAILivenessUtil.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AAILivenessUtil()
@property(nonatomic, assign) float volume;
@property(nonatomic, strong) AVAudioPlayer *audioPlayer;
@property(nonatomic, strong) NSOperationQueue *brightnessQueue;
@property(nonatomic, assign) CGFloat currBrightness;
@property(nonatomic, strong) MPVolumeView *volumeView;
@end

@implementation AAILivenessUtil

- (instancetype)init
{
    self = [super init];
    if (self) {
        _volume = 0.5;
        _brightnessQueue = [[NSOperationQueue alloc] init];
        _brightnessQueue.maxConcurrentOperationCount = 1;
        [self configSystemVolume:0.5];
    }
    return self;
}

+ (BOOL)isSilent
{
    return [AVAudioSession sharedInstance].outputVolume == 0;
}

- (MPVolumeView *)createVolumeView
{
    if (_volumeView == nil) {
        MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-100, -100, 5, 5)];
        [[UIApplication sharedApplication].delegate.window addSubview:volumeView];
        _volumeView = volumeView;
    }
    
    return _volumeView;
}

- (UISlider*)volumeSlider
{
    UISlider *slider =nil;
    MPVolumeView *volumeView = [self createVolumeView];
    volumeView.showsVolumeSlider = YES;
    for(UIView *view in volumeView.subviews) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
            slider = (UISlider*)view;
            break;
        }
    }
    return slider;
}

- (void)configSystemVolume:(float)volume
{
    UISlider *slider = [self volumeSlider];
    [slider setValue:volume animated:NO];
    [slider sendActionsForControlEvents:UIControlEventTouchUpInside];
    [_volumeView sizeToFit];
}

- (void)configPlayerVolume:(float)volume
{
    _volume = volume;
    if (_audioPlayer) {
        _audioPlayer.volume = volume;
    }
}

- (void)configVolume:(float)volume
{
    _volume = volume;
    [self configSystemVolume:volume];
}

- (void)removeVolumeView
{
    if (_volumeView) {
        [_volumeView removeFromSuperview];
        _volumeView = nil;
    }
}

- (void)setVolume:(float)volume
{
    _volume = volume;
    if (_audioPlayer) {
        _audioPlayer.volume = volume;
    }
}

+ (NSString *)currLanguageKey
{
    NSArray *array = [NSLocale preferredLanguages];
    if (array.count >= 1) {
        NSString *lanKey = [array objectAtIndex:0];
        NSArray *components = [lanKey componentsSeparatedByString:@"-"];
        if (components.count == 2) {
            lanKey = components.firstObject;
        } else if (components.count == 3) {
            if ([lanKey hasPrefix:@"zh-Hans"]) {
                lanKey = @"zh-Hans";
            }
        }
        
        return lanKey;
    }
    
    return @"en";
}

+ (NSString *)currLanForBundle:(NSBundle *)bundle
{
    NSString *availableLprojItems = @"en id vi zh-Hans";
    NSString *currLproj = [self currLanguageKey];
    if ([availableLprojItems containsString:currLproj]) {
        return currLproj;
    } else {
        return @"en";
    }
}

- (void)playAudio:(NSString *)audioName
{
    if (!audioName) return;
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *lan = [[self class] currLanForBundle:bundle];
    
    NSString *pathComponent = [NSString stringWithFormat:@"/AAIAudio.bundle/%@.lproj/%@", lan, audioName];
    NSString *path = [bundle.bundlePath stringByAppendingPathComponent:pathComponent];
    NSURL *url = [NSURL URLWithString:path];
    NSError *error = NULL;
    
    AVAudioPlayer *player = _audioPlayer;
    if (player) {
        [player stop];
    }
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    player.volume = _volume;
    _audioPlayer = player;
    if (!error) {
        [player play];
    }
}

+ (NSString *)localStrForKey:(NSString *)key
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *lan = [self currLanForBundle:bundle];
    NSString *pathComponent = [NSString stringWithFormat:@"/AAILanguageString.bundle/%@.lproj", lan];
    NSString *lprojPath = [bundle.bundlePath stringByAppendingPathComponent:pathComponent];
    NSString *str =  [[NSBundle bundleWithPath:lprojPath] localizedStringForKey:key value:nil table:nil];
    return str;
}

+ (UIImage *)imgWithName:(NSString *)imgName
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *imgPath = [bundle.bundlePath stringByAppendingFormat:@"/AAIImgs.bundle/%@", imgName];
    UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
    return img;
}

+ (NSArray<UIImage *> * _Nullable)stateImgWithType:(AAIDetectionType)detectionType
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = bundle.bundlePath;
    
    switch (detectionType) {
        case AAIDetectionTypeBlink: {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:4];
            for (int i = 1; i <= 4; i++) {
                NSString *imgPath = [bundlePath stringByAppendingFormat:@"/AAIImgs.bundle/blink_%d@2x.jpg", i];
                UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
                [array addObject:img];
            }
            return array;
        }
        case AAIDetectionTypeMouth: {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:4];
            for (int i = 1; i <= 5; i++) {
                NSString *imgPath = [bundlePath stringByAppendingFormat:@"/AAIImgs.bundle/open_mouth_%d@2x.jpg", i];
                UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
                [array addObject:img];
            }
            return array;
        }
        case AAIDetectionTypePosYaw: {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:4];
            for (int i = 1; i <= 4; i++) {
                NSString *imgPath = [bundlePath stringByAppendingFormat:@"/AAIImgs.bundle/turn_head_%d@2x.jpg", i];
                UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
                [array addObject:img];
            }
            return array;
        }
        default:
            break;
    }
    
    return nil;
}

#pragma mark - brightless

- (void)saveCurrBrightness
{
    _currBrightness = [UIScreen mainScreen].brightness;
}

- (void)graduallySetBrightness:(CGFloat)value
{
    [_brightnessQueue cancelAllOperations];
    
    CGFloat ratio = 0.01;
    CGFloat brightness = [UIScreen mainScreen].brightness;
    CGFloat step = ratio * ((value > brightness) ? 1 : -1);
    int times = fabs((value - brightness) / ratio);
    
    for (CGFloat i = 1; i < times + 1; i++) {
        [_brightnessQueue addOperationWithBlock:^{
            [NSThread sleepForTimeInterval:1 / 180.0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIScreen mainScreen].brightness = brightness + i * step;
            });
        }];
    }
}

- (void)graduallyResumeBrightness
{
    [self graduallySetBrightness:_currBrightness];
}

- (void)fastResumeBrightness
{
    [_brightnessQueue cancelAllOperations];
    __weak typeof(self) weakSelf = self;
    [_brightnessQueue addOperationWithBlock:^{
        if (weakSelf) {
            [UIScreen mainScreen].brightness = weakSelf.currBrightness;
        }
    }];
}

@end
