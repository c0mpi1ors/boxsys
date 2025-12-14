//
//  JuListBoxModel.h
//  boxsys
//
//  Created by chunyi.zhoucy on 14-4-30.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JuBoxModel.h"

/**
 * 定义了于BoxModel的关系
 *
 */
@interface JuListRelativeBoxModel : NSObject

@end

/**
 * 列表元素模型定义
 * <p/>
 * 定义了一个包含子模型的列表
 * <p/>
 * Created by chunyi.zhoucy on 14-4-24.
 */
@interface JuListBoxModel : JuBoxModel

// 子类的列表
@property (nonatomic, strong) NSMutableArray *subBoxModelList;

@end
