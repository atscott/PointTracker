//
//  MySignUpViewController.m
//
//  Created by Mattieu Gamache-Asselin on 6/15/12.
//  Copyright (c) 2012 Parse. All rights reserved.
//
//  Modifications by Andrew Moore on 5/1/13


#import "MySignUpViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MySignUpViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;
@end

@implementation MySignUpViewController

@synthesize fieldsBackground;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.signUpView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"loginBack.png"]]];
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo2.png"]]];
    
    // Change button apperance
    [self.signUpView.dismissButton setImage:[UIImage imageNamed:@"Exit.png"] forState:UIControlStateNormal];
    [self.signUpView.dismissButton setImage:[UIImage imageNamed:@"ExitDown.png"] forState:UIControlStateHighlighted];
    
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"SignUp.png"] forState:UIControlStateNormal];
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"SignUpDown.png"] forState:UIControlStateHighlighted];
    [self.signUpView.signUpButton setTitle:@"" forState:UIControlStateNormal];
    [self.signUpView.signUpButton setTitle:@"" forState:UIControlStateHighlighted];
    
    // Add background for fields
    [self setFieldsBackground:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SignUpFieldBG.png"]]];
    [self.signUpView insertSubview:fieldsBackground atIndex:1];
    
    // Remove text shadow
    CALayer *layer = self.signUpView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.passwordField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.emailField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.additionalField.layer;
    layer.shadowOpacity = 0.0f;
    
    // Set text color
    [self.signUpView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.emailField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.additionalField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    
    // Change "Additional" to match our use
    [self.signUpView.additionalField setPlaceholder:@"Phone number"];
    
    
}

- (void)viewDidLayoutSubviews {
    // Set frame for elements
    [self.signUpView.dismissButton setFrame:CGRectMake(10.0f, 20.0f, 87.5f, 45.5f)];
    [self.signUpView.logo setFrame:CGRectMake(100.0f, 20.0f, 125.0f, 125.0f)];
    [self.signUpView.signUpButton setFrame:CGRectMake(35.0f, 365.0f, 250.0f, 40.0f)];
    [self.fieldsBackground setFrame:CGRectMake(35.0f, 175.0f, 250.0f, 174.0f)];
    [self.signUpView.usernameField setFrame: CGRectMake(85.0f, 150.0f, 150.0f, 40.0f)];
    [self.signUpView.passwordField setFrame: CGRectMake(85.0f, 190.0f, 150.0f, 40.0f)];
    [self.signUpView.emailField setFrame: CGRectMake(85.0f, 250.0f, 150.0f, 40.0f)];
    [self.signUpView.additionalField setFrame: CGRectMake(85.0f, 290.0f, 150.0f, 40.0f)];
    
    // Move all fields down
    float yOffset = 0.0f;
    CGRect fieldFrame = self.signUpView.usernameField.frame;
    [self.signUpView.usernameField setFrame:CGRectMake(fieldFrame.origin.x+5.0f, 
                                                       fieldFrame.origin.y+30.0f+yOffset, 
                                                       fieldFrame.size.width-10.0f, 
                                                       fieldFrame.size.height)];
    yOffset += fieldFrame.size.height;
    
    [self.signUpView.passwordField setFrame:CGRectMake(fieldFrame.origin.x+5.0f, 
                                                       fieldFrame.origin.y+30.0f+yOffset, 
                                                       fieldFrame.size.width-10.0f, 
                                                       fieldFrame.size.height)];
    yOffset += fieldFrame.size.height;
    
    [self.signUpView.emailField setFrame:CGRectMake(fieldFrame.origin.x+5.0f, 
                                                    fieldFrame.origin.y+30.0f+yOffset, 
                                                    fieldFrame.size.width-10.0f, 
                                                    fieldFrame.size.height)];
    yOffset += fieldFrame.size.height;
    
    [self.signUpView.additionalField setFrame:CGRectMake(fieldFrame.origin.x+5.0f, 
                                                         fieldFrame.origin.y+30.0f+yOffset, 
                                                         fieldFrame.size.width-10.0f, 
                                                         fieldFrame.size.height)];
}

@end
