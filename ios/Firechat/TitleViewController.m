//
//  TitleViewController.m
//  Firechat
//
//  Created by Kevin Frans on 7/28/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import "TitleViewController.h"
#import "WelcomeViewController.h"

@interface TitleViewController ()

@end




@implementation TitleViewController

@synthesize login;
@synthesize signup;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    // Do any additional setup after loading the view.
    
    
    
    [login addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];

    
}



-(void) loginAction
{
    NSLog(@"thing");
    WelcomeViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    [self presentViewController:view animated:true completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
