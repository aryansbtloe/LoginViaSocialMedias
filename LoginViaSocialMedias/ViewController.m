//
//  ViewController.m
//  LoginViaSocialMedias
//
//  Created by Alok on 07/05/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(IBAction)loginViaFacebook:(id)sender
{
    [[LoginViaSocials sharedController] setDelegate:self];
    [[LoginViaSocials sharedController] loginViaFacebook];
}

-(IBAction)loginViaTwitter:(id)sender
{
    [[LoginViaSocials sharedController] setDelegate:self];
    [[LoginViaSocials sharedController] loginViaTwitter];
}

-(IBAction)loginViaGooglePlus:(id)sender
{
    [[LoginViaSocials sharedController] setDelegate:self];
    [[LoginViaSocials sharedController] loginViaGooglePlus];
}

-(IBAction)loginViaFourSquare:(id)sender
{
    [[LoginViaSocials sharedController] setDelegate:self];
    [[LoginViaSocials sharedController] loginViaFourSquare];
}


-(void)didFinishedLoginViaSocials:(NSMutableDictionary *)results
{
    if ([[results objectForKey:@"LoginType"] isEqualToString:@"Facebook"])
    {
        NSString * facebookId = [results valueForKey:@"id"];
        NSString * emailId=[results valueForKey:@"email"];
        NSString * name =[results valueForKey:@"name"];
        NSString * username =[results valueForKey:@"username"];
        NSString * gender =[results valueForKey:@"gender"];
        
        NSLog(@"facebookId :  %@",facebookId);
        NSLog(@"emailId    :  %@",emailId);
        NSLog(@"name       :  %@",name);
        NSLog(@"username   :  %@",username);
        NSLog(@"gender     :  %@",gender);
    }
    else if ([[results objectForKey:@"LoginType"] isEqualToString:@"GooglePlus"])
    {
        NSString *googleID = [results valueForKey:@"googleID"];
        NSString *name     = [results valueForKey:@"name"];
        NSString *username = [results valueForKey:@"username"];
        NSString *emailId  = [results valueForKey:@"email"];
        NSString *gender   = [results valueForKey:@"gender"];
        
        NSLog(@"googleID          :  %@",googleID);
        NSLog(@"emailId           :  %@",emailId);
        NSLog(@"name              :  %@",name);
        NSLog(@"username          :  %@",username);
        NSLog(@"gender            :  %@",gender);
    }
    else if ([[results objectForKey:@"LoginType"] isEqualToString:@"Twitter"])
    {
        NSString *twitterID       = [results valueForKey:@"id"];
        NSString *name            = [results valueForKey:@"name"];
        NSString *username        = [results valueForKey:@"screen_name"];
        NSString *emailId         = [results valueForKey:@"email"];
        NSString *gender          = [results valueForKey:@"gender"];
        NSString *location        = [results valueForKey:@"location"];
        NSString *profilePicUrl   = [results valueForKey:@"profile_image_url"];
        
        NSLog(@"twitterID         :  %@",twitterID);
        NSLog(@"emailId           :  %@",emailId);
        NSLog(@"name              :  %@",name);
        NSLog(@"username          :  %@",username);
        NSLog(@"gender            :  %@",gender);
        NSLog(@"location          :  %@",location);
        NSLog(@"profilePicUrl     :  %@",profilePicUrl);
    }
    else if ([[results objectForKey:@"LoginType"] isEqualToString:@"FourSquare"])
    {
        NSString *fourSquareID = [results valueForKey:@"fourSquareID"];
        NSString *name         = [results valueForKey:@"name"];
        NSString *username     = [results valueForKey:@"username"];
        NSString *emailId      = [results valueForKey:@"email"];
        NSString *gender       = [results valueForKey:@"gender"];
        
        NSLog(@"fourSquareID      :  %@",fourSquareID);
        NSLog(@"emailId           :  %@",emailId);
        NSLog(@"name              :  %@",name);
        NSLog(@"username          :  %@",username);
        NSLog(@"gender            :  %@",gender);
    }
}

-(void)didFailLoginViaSocialsWithError
{
    NSLog(@"Last Login Trail Failed");
}

@end
