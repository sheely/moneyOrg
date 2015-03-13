//
//  AppDelegate.m
//  siemens_ios
//
//  Created by WSheely on 14-8-28.
//  Copyright (c) 2014年 WSheely. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface AppDelegate()
{
    
}

@end

@implementation AppDelegate

static NSString*  token = @"";
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    [ShareSDK importWeChatClass:[WXApi class]];
    [ShareSDK importQQClass:[QQApiInterface class]tencentOAuthCls:[TencentOAuth class]];
    [ShareSDK registerApp:@"api20"];
#ifdef DEBUG
    [SHTask pull:URL_HEADER newUrl:BATA_HEADER];
#endif

    return YES;
}
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    token = [NSString stringWithFormat:@"%@", deviceToken];
#ifdef DEBUG
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"您有一个新的消息." message:token delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alert show];
#endif
    NSLog(@"My token is:%@", token);
    if(SHEntironment.instance.loginName.length > 0){
        SHPostTaskM * post = [[SHPostTaskM alloc]init];
        post.URL = URL_FOR(@"loginupdate.action");
        [post.postArgs setValue:token forKey:@"appuuid"];
        [post start];
    }
    //这里应将device token发送到服务器端
}

+ (NSString*)token
{
    return token;
}
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }

    /* eg.
     key: aps, value: {
     alert = "\U8fd9\U662f\U4e00\U6761\U6d4b\U8bd5\U4fe1\U606f";
     badge = 1;
     sound = default;
     }
     */
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"您有一个新的消息." message:userInfo[@"aps"][@"alert"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alert show];
    NSString * noti = [userInfo valueForKey: @"type"];
    if(noti.length > 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:noti object:nil];
    }
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if([url description].length > 14 && [[[url description] substringToIndex:14] isEqualToString:@"car://safepay/"]){
        NSString * order =  [[url description] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if([order rangeOfString:@"\"ResultStatus\" : \"9000\""].length > 0){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功." delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"取消" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil];
            [alert show];
        }

        //[self performSelector:@selector(refreshOrder)withObject:nil afterDelay:1];
        [self performSelector:@selector(refreshOrder)withObject:nil afterDelay:3];
    }
    return YES;
}

- (void)refreshOrder
{
    [[NSNotificationCenter defaultCenter ] postNotificationName:@"notification_remain" object:@"order"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_ORDER object:nil];
}

- (void)onGetNetworkState:(int)iError
{
}

/**
 *返回授权验证错误
 *@param iError 错误号 : BMKErrorPermissionCheckFailure 验证失败
 */
- (void)onGetPermissionState:(int)iError
{
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
