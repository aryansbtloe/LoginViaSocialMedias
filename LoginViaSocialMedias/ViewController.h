//
//  ViewController.h
//  LoginViaSocialMedias
//
//  Created by Alok on 07/05/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViaSocials.h"

@interface ViewController : UIViewController<LoginViaSocialsOperationDelegate>

-(IBAction)loginViaFacebook:(id)sender;
-(IBAction)loginViaTwitter:(id)sender;
-(IBAction)loginViaGooglePlus:(id)sender;
-(IBAction)loginViaFourSquare:(id)sender;

@end

