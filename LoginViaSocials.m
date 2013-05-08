//  LoginViaSocialMedias
//
//  Created by Alok on 08/05/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import "LoginViaSocials.h"

/**
 
 LoginViaSocials:-
 
 LoginViaSocials class will allow various logins vai social networking sites.
 
 */


static LoginViaSocials *loginViaSocials_ = nil;


@implementation LoginViaSocials

@synthesize caller;

#pragma mark - Methods for allocate and initialise the object of this class

+(LoginViaSocials*)sharedController
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
		if (loginViaSocials_==nil) {
			loginViaSocials_ = [[LoginViaSocials alloc]init];
		}
    });
	return loginViaSocials_;
}

+(id)alloc
{
	NSAssert(loginViaSocials_ == nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}


-(void)setDelegate:(id)caller_
{
    caller = caller_;
}




























#pragma mark---
#pragma mark---FaceBook Implementation

-(void)loginViaFacebook
{
    if (FBSession.activeSession.isOpen)
        [loginViaSocials_ getData];
    else
    {
        [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:YES completionHandler:^(FBSession *session,
                                                                                                 FBSessionState status, NSError *error)
         {
             if (error)
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
                 
                 if (caller && [caller conformsToProtocol:@protocol(LoginViaSocialsOperationDelegate)] && [caller respondsToSelector:@selector(didFailLoginViaSocialsWithError)])
                 {
                     [caller didFailLoginViaSocialsWithError];
                 }

             }
             else if (FB_ISSESSIONOPENWITHSTATE(status))
             {
                 [loginViaSocials_ getData];
             }
         }];
    }
}


-(void)getData
{
    if ([FBSession.activeSession.permissions indexOfObject:@"read_stream"]== NSNotFound)
    {
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"read_stream",nil];
        [FBSession.activeSession reauthorizeWithReadPermissions:permissions completionHandler:^(FBSession *session, NSError *error)
         {
             if (!error)
                 [self request];
             else
             {
                 if (loginViaSocials_.caller && [loginViaSocials_.caller conformsToProtocol:@protocol(LoginViaSocialsOperationDelegate)] && [loginViaSocials_.caller respondsToSelector:@selector(didFailLoginViaSocialsWithError)])
                 {
                     [loginViaSocials_.caller didFailLoginViaSocialsWithError];
                 }
             }
         }];
    }
    else
        [self request];
}

-(void)request
{
    [FBRequestConnection startWithGraphPath:@"me" parameters:[NSDictionary dictionaryWithObject:@"picture,id,birthday,email,name,gender,username" forKey:@"fields"] HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         [self meRequestResult:result WithError:error];
     }];
}

- (void)meRequestResult:(id)result WithError:(NSError *)error
{
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dictionary = nil;
        
        if([result objectForKey:@"data"])
            dictionary = (NSDictionary *)[(NSArray *)[result objectForKey:@"data"] objectAtIndex:0];
        else
            dictionary = (NSDictionary *)result;
        
        
        
        if (caller && [caller conformsToProtocol:@protocol(LoginViaSocialsOperationDelegate)] && [caller respondsToSelector:@selector(didFinishedLoginViaSocials:)])
        {
            
            NSMutableDictionary * info = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
            [info setObject:@"Facebook" forKey:@"LoginType"];
            
            [caller didFinishedLoginViaSocials:[[NSMutableDictionary alloc]initWithDictionary:info]];
        }
    }
}





























#pragma mark---
#pragma mark---Twitter Implementation

-(void)loginViaTwitter
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType   = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error)
     {
         if(!granted)
         {
             if (loginViaSocials_.caller && [loginViaSocials_.caller conformsToProtocol:@protocol(LoginViaSocialsOperationDelegate)] && [loginViaSocials_.caller respondsToSelector:@selector(didFailLoginViaSocialsWithError)])
             {
                 [loginViaSocials_.caller didFailLoginViaSocialsWithError];
             }

             return;
         }
         
         NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
         if ([accountsArray count] > 0)
         {
             ACAccount * twitterAccount = [accountsArray objectAtIndex:0];
             NSString  * username       = [twitterAccount username];
             NSURL     * url            = [NSURL URLWithString:[@"https://api.twitter.com/1/" stringByAppendingString:@"users/show.json"]];
             
             NSDictionary *parameters = @{
                                          @"screen_name": username
                                          };
             
             TWRequest *request = [[TWRequest alloc] initWithURL:url parameters:parameters requestMethod:TWRequestMethodGET];
             [request setAccount:twitterAccount];
             
             [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
              {
                  NSDictionary * infoDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
                  
                  
                  if (caller && [caller conformsToProtocol:@protocol(LoginViaSocialsOperationDelegate)] && [caller respondsToSelector:@selector(didFinishedLoginViaSocials:)])
                  {
                      
                      NSMutableDictionary * info = [[NSMutableDictionary alloc]initWithDictionary:infoDictionary];
                      [info setObject:@"Twitter" forKey:@"LoginType"];
                      
                      [caller didFinishedLoginViaSocials:[[NSMutableDictionary alloc]initWithDictionary:info]];
                  }
              }];
         }
     }];
    
}
































#pragma mark---
#pragma mark---Google Plus Implementation

-(void)loginViaGooglePlus
{
    [GPPSignInButton class];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.clientID = kClientID;
    signIn.delegate = self;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.shouldFetchGoogleUserID = YES;
    signIn.shouldGroupAccessibilityChildren = YES;
    signIn.actions = [NSArray arrayWithObjects:
                      @"http://schemas.google.com/AddActivity",
                      @"http://schemas.google.com/BuyActivity",
                      @"http://schemas.google.com/CheckInActivity",
                      @"http://schemas.google.com/CommentActivity",
                      @"http://schemas.google.com/CreateActivity",
                      @"http://schemas.google.com/ListenActivity",
                      @"http://schemas.google.com/ReserveActivity",
                      @"http://schemas.google.com/ReviewActivity",
                      nil];
    
    [signIn authenticate];
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth error: (NSError *) error
{
    GTLServicePlus* plusService = [[GTLServicePlus alloc]init] ;
    plusService.retryEnabled = YES;
    [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
    
    GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
    
    [plusService executeQuery:query completionHandler:^(GTLServiceTicket *ticket,GTLPlusPerson *person,NSError *error)
     {
         if (!error)
         {
             NSDictionary *infoDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[GPPSignIn sharedInstance].authentication.userEmail,@"email",person.identifier,@"googleID",[person.name.givenName stringByAppendingFormat:@" %@",person.name.familyName],@"name",[person.name.givenName stringByAppendingFormat:@" %@",person.name.familyName],@"username",person.gender,@"gender", nil];
             
             
             if (caller && [caller conformsToProtocol:@protocol(LoginViaSocialsOperationDelegate)] && [caller respondsToSelector:@selector(didFinishedLoginViaSocials:)])
             {
                 
                 NSMutableDictionary * info = [[NSMutableDictionary alloc]initWithDictionary:infoDictionary];
                 [info setObject:@"GooglePlus" forKey:@"LoginType"];
                 
                 [caller didFinishedLoginViaSocials:[[NSMutableDictionary alloc]initWithDictionary:info]];
             }

         }
     }];
}































#pragma mark -----
#pragma mark FourSquareDelegate

-(void)loginViaFourSquare
{
    if ([Foursquare2 isAuthorized])
    {
        [Foursquare2  getDetailForUser:@"self" callback:^(BOOL success, id result)
         {
             if (success)
             {
                 NSDictionary *infoDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[[result valueForKeyPath:@"response.user.contact"] objectForKey:@"email"],@"email",[result valueForKeyPath:@"response.user.id"],@"fourSquareID",[[result valueForKeyPath:@"response.user.firstName"] stringByAppendingFormat:@" %@",[result valueForKeyPath:@"response.user.lastName"]],@"name",[[result valueForKeyPath:@"response.user.firstName"] stringByAppendingFormat:@" %@",[result valueForKeyPath:@"response.user.lastName"]],@"username",[result valueForKeyPath:@"response.user.gender"],@"gender", nil];
                 
                 if (caller && [caller conformsToProtocol:@protocol(LoginViaSocialsOperationDelegate)] && [caller respondsToSelector:@selector(didFinishedLoginViaSocials:)])
                 {
                     
                     NSMutableDictionary * info = [[NSMutableDictionary alloc]initWithDictionary:infoDictionary];
                     [info setObject:@"FourSquare" forKey:@"LoginType"];
                     
                     [caller didFinishedLoginViaSocials:[[NSMutableDictionary alloc]initWithDictionary:info]];
                 }

             }
         }];
	}
    else
    {
        [Foursquare2 authorizeWithCallback:^(BOOL success, id result)
         {
             if (success)
             {
                 [Foursquare2  getDetailForUser:@"self" callback:^(BOOL success, id result)
                  {
                      if (success)
                      {
                          NSDictionary *infoDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[[result valueForKeyPath:@"response.user.contact"] objectForKey:@"email"],@"email",[result valueForKeyPath:@"response.user.id"],@"fourSquareID",[[result valueForKeyPath:@"response.user.firstName"] stringByAppendingFormat:@" %@",[result valueForKeyPath:@"response.user.lastName"]],@"name",[[result valueForKeyPath:@"response.user.firstName"] stringByAppendingFormat:@" %@",[result valueForKeyPath:@"response.user.lastName"]],@"username",[result valueForKeyPath:@"response.user.gender"],@"gender", nil];
                           
                          if (caller && [caller conformsToProtocol:@protocol(LoginViaSocialsOperationDelegate)] && [caller respondsToSelector:@selector(didFinishedLoginViaSocials:)])
                          {
                              
                              NSMutableDictionary * info = [[NSMutableDictionary alloc]initWithDictionary:infoDictionary];
                              [info setObject:@"FourSquare" forKey:@"LoginType"];
                              
                              [caller didFinishedLoginViaSocials:[[NSMutableDictionary alloc]initWithDictionary:info]];
                          }

                      }
                      else
                      {
                          if (loginViaSocials_.caller && [loginViaSocials_.caller conformsToProtocol:@protocol(LoginViaSocialsOperationDelegate)] && [loginViaSocials_.caller respondsToSelector:@selector(didFailLoginViaSocialsWithError)])
                          {
                              [loginViaSocials_.caller didFailLoginViaSocialsWithError];
                          }
                      }

                  }];
             }
             else
             {
                 if (loginViaSocials_.caller && [loginViaSocials_.caller conformsToProtocol:@protocol(LoginViaSocialsOperationDelegate)] && [loginViaSocials_.caller respondsToSelector:@selector(didFailLoginViaSocialsWithError)])
                 {
                     [loginViaSocials_.caller didFailLoginViaSocialsWithError];
                 }
             }

         }];
    }
    
}

-(void)logOut
{
    //log out from four square
    [Foursquare2 removeAccessToken];
    
    //log out from facebook
    if (FBSession.activeSession)
        [FBSession.activeSession close];
    
    //log out from google plus
    [[GPPSignIn sharedInstance]signOut];

}

@end
