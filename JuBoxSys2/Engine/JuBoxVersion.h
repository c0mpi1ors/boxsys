//
//  JuBoxVersion.h
//  boxsys
//
//  Created by chunyi.zhoucy on 14-4-29.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * [name] 版本控制
 * <p/>
 * [description] 用于版本控制。从目前的情况看，不同的app版本，需要有版本控制，才能保证正常的显示。否则无法保证向下和向上兼容。
 * <p/>
 * Created by chunyi.zhoucy on 14-4-10.
 */
@interface JuBoxVersion : NSObject

/**
 * 验证数据是否是符合版本要求的
 * @param dic 字典数据
 * @return
 */
+ (bool) verify:(NSDictionary*) dic;

@end
