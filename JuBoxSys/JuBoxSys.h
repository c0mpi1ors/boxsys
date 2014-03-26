//
//  JuBoxSys.h
//  JuBoxSys
//
//  Created by chunyi.zhoucy on 14-1-8.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JuBoxSysDelegate.h"

/*
 * 对应的设计文档：http://confluence.taobao.ali.com/pages/createpage.action?spaceKey=juwl&fromPageId=195700544
 */

@interface JuBoxSys : NSObject

// 装载入模型
// 收到模型配置后调用
+ (void) loadModel:(NSDictionary *)model;

// 增加容器
// 必须先于loadContainer调用
+ (void)  addContainer:(NSString *)name
                  size:(CGSize)containSize
              delegate:(id<JuBoxSysDelegate>) delegate;

// 装载容器数据
// 收到数据配置后调用
+ (void)  loadContainer:(NSString *)name
                   data:(NSArray *)arr;

+ (void)  loadBox:(NSString *)name
             data:(NSDictionary *)dic
         delegate:(id<JuBoxSysDelegate>) delegate;

// 清理自身，使得没有常驻内存的内容
+ (void) clearSelf;

@end
