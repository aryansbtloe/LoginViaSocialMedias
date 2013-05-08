//
//  AppDelegate.m
//  LoginViaSocialMedias
//
//  Created by Alok on 07/05/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"


/**
 Facebook
 */
NSString *const FBSessionStateChangedNotification = @"com.example.Login:FBSessionStateChangedNotification";


/**
 Google Plus
 */
#import "GPPSignIn.h"
#import "GPPURLHandler.h"
#import "GPPDeepLink.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self.window setRootViewController:[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil]];
    
    [self initializeGooglePlus];
    
    return YES;
}








#pragma mark---
#pragma mark---Google Plus Implementation


-(void)initializeGooglePlus
{
    [GPPSignIn sharedInstance].clientID = @"763637970149.apps.googleusercontent.com";
    [GPPDeepLink setDelegate:self];
    [GPPDeepLink readDeepLinkAfterInstall];
}






#pragma mark---
#pragma mark---FaceBook Implementation

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    switch (state)
    {
        case FBSessionStateOpen:
            if (!error)
                NSLog(@"User session found");
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:FBSessionStateChangedNotification object:session];
    
    if (error)
       [[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
}

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
{
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"email",@"user_likes",@"user_birthday",nil];
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}

- (void)didReceiveDeepLink:(GPPDeepLink *)deepLink
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    if (FBSession.activeSession)
        [FBSession.activeSession close];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if (FBSession.activeSession)
        [FBSession.activeSession handleOpenURL:url];
    return [GPPURLHandler handleURL:url
                  sourceApplication:sourceApplication
                         annotation:annotation];
}


@end
