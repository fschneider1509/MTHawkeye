//
//  AppDelegate.m
//  MTHawkeyeDemo
//
//  Created by cqh on 18/05/2017.
//  Copyright © 2017 Meitu. All rights reserved.
//

#import "AppDelegate.h"

//#ifdef DEBUG
#import <MTHawkeye/MTHStackFrameSymbolicsRemote.h>
#import <MTHawkeye/MTRunHawkeyeInOneLine.h>
//#endif


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(__unused UIApplication *)application didFinishLaunchingWithOptions:(__unused NSDictionary *)launchOptions {
    //#ifdef DEBUG
    [self startHawkeye];
    //#endif

    return YES;
}

//#ifdef DEBUG
- (void)startHawkeye {
#if 1
    [self startDefaultHawkeye];

    // symbolics stack frames in ANR/CPU/Allocations Reports will need a remote symbolics server while the dsym is removed from app.
    // [MTHStackFrameSymbolicsRemote configureSymbolicsServerURL:@"http://xxxx:3002/parse/raw"];
#else
    [self startCustomHawkeye];

    // [MTHStackFrameSymbolicsRemote configureSymbolicsServerURL:@"http://xxxx:3002/parse/raw"];
#endif
}

- (void)startDefaultHawkeye {
    [MTRunHawkeyeInOneLine start];
}

- (void)startCustomHawkeye {
    [[MTHawkeyeClient shared]
        setPluginsSetupHandler:^(NSMutableArray<id<MTHawkeyePlugin>> *_Nonnull plugins) {
            [MTHawkeyeDefaultPlugins addDefaultClientPluginsInto:plugins];

            // add your additional plugins here.
        }
        pluginsCleanHandler:^(NSMutableArray<id<MTHawkeyePlugin>> *_Nonnull plugins) {
            // if you don't want to free plugins memory, remove this line.
            [MTHawkeyeDefaultPlugins cleanDefaultClientPluginsFrom:plugins];

            // clean your additional plugins if need.
        }];

    [[MTHawkeyeClient shared] startServer];

    [[MTHawkeyeUIClient shared]
        setPluginsSetupHandler:^(NSMutableArray<id<MTHawkeyeMainPanelPlugin>> *_Nonnull mainPanelPlugins, NSMutableArray<id<MTHawkeyeFloatingWidgetPlugin>> *_Nonnull floatingWidgetPlugins, NSMutableArray<id<MTHawkeyeSettingUIPlugin>> *_Nonnull defaultSettingUIPluginsInto) {
            [MTHawkeyeDefaultPlugins addDefaultUIClientMainPanelPluginsInto:mainPanelPlugins
                                          defaultFloatingWidgetsPluginsInto:floatingWidgetPlugins
                                                defaultSettingUIPluginsInto:defaultSettingUIPluginsInto];


            // add your additional plugins here.
        }
        pluginsCleanHandler:^(NSMutableArray<id<MTHawkeyeMainPanelPlugin>> *_Nonnull mainPanelPlugins, NSMutableArray<id<MTHawkeyeFloatingWidgetPlugin>> *_Nonnull floatingWidgetPlugins, NSMutableArray<id<MTHawkeyeSettingUIPlugin>> *_Nonnull defaultSettingUIPluginsInto) {
            // if you don't want to free plugins memory, remove this line.
            [MTHawkeyeDefaultPlugins cleanDefaultUIClientMainPanelPluginsFrom:mainPanelPlugins
                                            defaultFloatingWidgetsPluginsFrom:floatingWidgetPlugins
                                                  defaultSettingUIPluginsFrom:defaultSettingUIPluginsInto];

            // clean your additional plugins if need.
        }];

    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [[MTHawkeyeUIClient shared] startServer];
    });
}
//#endif

@end
