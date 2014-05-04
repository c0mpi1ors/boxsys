//
//  ViewController.m
//  boxsys
//
//  Created by chunyi.zhoucy on 14-1-7.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "ViewController.h"
#import "SBJson/SBJson.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSDictionary *dData = [AppDelegate getDictionaryFromFile:@"JuToday"];
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

static int modelStatus = 0;

- (IBAction)changeModel:(id)sender
{
    switch (modelStatus) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        default:
            modelStatus = 0;
            break;
    }
    modelStatus += 1;
    
    // 测试删除对象，看释放情况
    [JuBoxSys2 clearSelf];
}

static int dataStatus = 0;

- (IBAction)changeData:(id)sender
{
    switch (dataStatus) {
        case 0:
            break;
        case 1:
            break;
        default:
            dataStatus = 0;
            break;
    }
    dataStatus += 1;
    
}

//=============================================================================//

- (UIView *) getContainer
{
    if(!self.workview) {
        self.workview = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
        [self.scrollView addSubview:self.workview];
    }
    return self.workview;
}

- (void) onBoxSysEvent:(id) sender withArgs:(NSDictionary *) argsMap
{
    
}

@end
