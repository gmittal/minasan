//
//  WelcomeViewController.m
//  Firechat
//
//  Created by Kevin Frans on 7/5/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import "WelcomeViewController.h"
#import "ViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

@synthesize handle;
@synthesize handleLabel;


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [[NSUserDefaults standardUserDefaults] setValue:handle.text forKey:@"name"];
    ViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"chat"];
    [self presentViewController:view animated:true completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    NSLog(@"%f",screenHeight);
    
    handle.delegate = self;
    handle.frame = CGRectMake(handle.frame.origin.x, screenHeight - 200,handle.frame.size.width,handle.frame.size.height);
    handleLabel.frame = CGRectMake(handle.frame.origin.x, screenHeight - 300,handle.frame.size.width,handle.frame.size.height);
    
    [self.view frame];
    
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
