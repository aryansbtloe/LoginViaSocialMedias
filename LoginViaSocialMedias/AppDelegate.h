//
//  AppDelegate.h
//  LoginViaSocialMedias
//
//  Created by Alok on 07/05/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Google Plus
 */
#import "GPPDeepLink.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate,GPPDeepLinkDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
