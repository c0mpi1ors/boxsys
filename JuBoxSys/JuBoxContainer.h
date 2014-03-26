//
//  JuBoxContainer.h
//  boxsys
//
//  Created by chunyi.zhoucy on 14-1-7.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JuBoxSysDelegate.h"

@class JuBoxModel;
@interface JuBoxContainer : NSObject

@property (nonatomic, retain) id delegate;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) float height;
@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, retain) NSMutableArray *listBox;

- (void) close;

- (void)load:(NSArray *)arr
         map:(NSDictionary *)namedModel;

- (void)  loadBox:(NSDictionary *)dic
            model:(JuBoxModel *)model
         modelMap:(NSDictionary *)namedModel;

- (void) clean;

@end
