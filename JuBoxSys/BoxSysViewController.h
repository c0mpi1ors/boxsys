//
//  BoxSysViewController.h
//  boxsys
//
//  Created by chunyi.zhoucy on 14-3-18.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuBoxSys.h"

@interface BoxSysViewController : UIViewController <JuBoxSysDelegate>

// 对应的模板名
@property (retain, nonatomic) NSString *entryName;

// 对应的显示数据
@property (nonatomic, retain) NSDictionary *data;

@end
