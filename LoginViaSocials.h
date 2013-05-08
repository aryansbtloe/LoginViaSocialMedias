//  LoginViaSocialMedias
//
//  Created by Alok on 08/05/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>



/**
 Facebook
 */
#import "FaceBook/FacebookSDK.framework/Headers/FacebookSDK.h"


/**
 Twitter
 */
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>


/**
 Google Plus
 */
#import "GPPSignIn.h"
#import "GPPSignInButton.h"
#import "GTLPlus.h"
#import "GTMLogger.h"
#import "GTMOAuth2Authentication.h"
#import "GTLServicePlus.h"

#error "please put your google plus client id here"
#define kClientID  @"123456789.apps.googleusercontent.com";


/**
 Four Square
 */
#import "Foursquare2.h"

/**
 
 LoginViaSocials:-
 
 LoginViaSocials class will allow various logins vai social networking sites.
 
 */

@protocol LoginViaSocialsOperationDelegate <NSObject>
@optional
-(void)didFinishedLoginViaSocials:(NSMutableDictionary *)results;
-(void)didFailLoginViaSocialsWithError;
@end


@interface LoginViaSocials : NSObject
{
    id caller;
}

@property(nonatomic,retain)id caller;

+(LoginViaSocials*)sharedController;
-(void)setDelegate:(id)caller;

-(void)loginViaFacebook;
-(void)loginViaTwitter;
-(void)loginViaGooglePlus;
-(void)loginViaFourSquare;
-(void)logOut;

@end
