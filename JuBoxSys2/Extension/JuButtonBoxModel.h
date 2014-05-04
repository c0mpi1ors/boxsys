//
//  JuButtonBoxModel.h
//  boxsys
//
//  Created by chunyi.zhoucy on 14-4-29.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JuBoxModel.h"

@interface JuButtonBoxModel : JuBoxModel

// 按钮图片的字段名
@property (nonatomic, strong) NSString *imageURL;

// 配置HTML的URL的字段名。如果设置了，则会跳转到HTML。
@property (nonatomic, strong) NSString *htmlURL;

// 配置native跳转的URL的字段名。如果设置了，则会跳转到native页面。
@property (nonatomic, strong) NSString *nativeURL;

// 埋点的ID，这个是仅有的定义值
@property (nonatomic, strong) NSString *trackId;

// 埋点的值的字段名
@property (nonatomic, strong) NSString *trackName;

@end
