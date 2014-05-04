//
//  ViewController.h
//  boxsys
//
//  Created by chunyi.zhoucy on 14-1-7.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JuBoxSys2.h"

@interface ViewController : UIViewController <JuBoxSysDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIView *workview;

@end
