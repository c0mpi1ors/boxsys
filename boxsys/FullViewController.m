//
//  FullViewController.m
//  boxsys
//
//  Created by chunyi.zhoucy on 14-3-6.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "FullViewController.h"
#import "AppDelegate.h"

@interface FullViewController ()

@end

@implementation FullViewController

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
    self.entryName = @"M_VIEW_001";
    
    NSDictionary *ddata = [AppDelegate getDictionaryFromFile:@"DataFullViewController"];
    if (!ddata) {
        return;
    }
    self.data = ddata;
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
