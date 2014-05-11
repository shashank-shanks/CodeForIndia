//
//  CFISignInViewController.m
//  FCSK
//
//  Created by shashank on 10/05/14.
//  Copyright (c) 2014 Mahesh. All rights reserved.
//

#import "CFISignInViewController.h"
#import "CFIRegion.h"
#import "CFIBooth.h"
#import "CFICurrentBooth.h"
#import "CFIShareRegionInfo.h"

@interface CFISignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)signIN:(id)sender;

@end

@implementation CFISignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void) loginWithUsername:(NSString *)username withPassword:(NSString *)password
{
    // Send API from here
    
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signIN:(id)sender {
    [self setupData];
    [self loginWithUsername:self.usernameField.text withPassword:self.passwordField.text];
}

- (void)setupData
{
    CFIRegion *region = [[CFIRegion alloc]init];
    region.name = @"Kedarnath region";
    
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:3];
    
    CFICurrentBooth *booth = [[CFICurrentBooth alloc]init];
    booth.name = @"Kedarnath";
    booth.latitude = @30.73;
    booth.longitude = @79.07;
    booth.ID = @"1";
    [array addObject:booth];
    
    CFICurrentBooth *booth1= [[CFICurrentBooth alloc]init];
    booth1.name = @"Badrinath";
    booth1.latitude = @30.74;
    booth1.longitude = @79.49;
    booth.ID = @"2";
    [array addObject:booth1];
    
    CFICurrentBooth *booth2 = [[CFICurrentBooth alloc]init];
    booth2.name = @"JoshiMath";
    booth2.latitude = @30.57;
    booth2.longitude = @79.57;
    booth.ID = @"3";
    [array addObject:booth2];
    
    region.booths = array;
    
    [[CFIShareRegionInfo sharedInstance]setCurrentRegion:region];
    [[CFIShareRegionInfo sharedInstance]setCurrentBooth:booth1];
    
}

@end
