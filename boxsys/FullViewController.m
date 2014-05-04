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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *dData = [AppDelegate getDictionaryFromFile:@"DataFullViewController"];
    if (!dData) return;
    [JuBoxSys2 loadBox:@"Today"
               withKey:@"ViewController"
              withData:dData
                 width:320 height:0 withDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *) getContainer
{
    return self.view;
}

- (void) onBoxSysEvent:(id) sender withArgs:(NSDictionary *) argsMap
{
    
}

@end
