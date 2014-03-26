//
//  BoxSysViewController.m
//  boxsys
//
//  Created by chunyi.zhoucy on 14-3-18.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "BoxSysViewController.h"

@interface BoxSysViewController ()

@property (retain, nonatomic) UIView *workview;

@end

@implementation BoxSysViewController

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
	// Do any additional setup after loading the view.
    
    if (self.data) {
        [JuBoxSys loadBox:self.entryName data:self.data delegate:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//=============================================================================//

- (UIView *) getContainer
{
    if(!self.workview) {
        self.workview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        [self.view addSubview:self.workview];
    }
    return self.workview;
}

- (UIButton *) getButtonWithImage:(NSString *)imageUrl
                     clickedImage:(NSString *)clickedImageUrl
{
    NSURL *nsurl = [NSURL URLWithString:imageUrl];
    NSData* data = [NSData dataWithContentsOfURL:nsurl];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    
    if (clickedImageUrl) {
        nsurl = [NSURL URLWithString:clickedImageUrl];
        data = [NSData dataWithContentsOfURL:nsurl];
        
        [button setImage:[UIImage imageWithData:data] forState:UIControlStateSelected];
    }
    
    return button;
}

- (void) flush
{
    
}

- (void) clickBlock:(NSDictionary *)data
{
    NSLog(@"clicked");
}

@end
