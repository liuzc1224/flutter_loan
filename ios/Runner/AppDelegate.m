#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "MainViewController.h"
#import <AAILivenessSDK/AAILivenessSDK.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  MainViewController * VC = [[MainViewController alloc]init];
      UINavigationController * NVC = [[UINavigationController alloc]initWithRootViewController:VC];
      [self.window setRootViewController:NVC];
      /** flutter插件通道代理*/
    [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    
    
    
     [AAILivenessSDK initWithAccessKey:@"b3f22c15ef6045b5" secretKey:@"faaa6ec93d55c5b8" market:    AAILivenessMarketIndonesia];
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end

