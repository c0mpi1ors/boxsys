//
//  JuBoxVersion.m
//  boxsys
//
//  Created by chunyi.zhoucy on 14-4-29.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "JuBoxVersion.h"
#import "JuBoxSys2.h"

@implementation JuBoxVersion

/**
 * 验证数据是否是符合版本要求的
 * @param dic 字典数据
 * @return
 */
+ (bool) verify:(NSDictionary*) dic
{
    int version = [JuBoxSys2 getVersion];
    
    @try {
        
        NSDictionary* map = [JuBoxSys2 getMapFromMap:dic withName:@"version"];
        if (map == NULL) {
            // 如果没有指定版本，就是表示版本OK的
            return true;
        }
        
        NSNumber *min = [JuBoxSys2 getNumberFromMap:dic withName:@"min"];
        if (min != NULL) {
            // 如果最小版本大于当前版本，表示版本不可用
            if([min intValue] >version) {
                return false;
            }
        }
        
        NSNumber *max = [JuBoxSys2 getNumberFromMap:dic withName:@"max"];
        if (max != NULL) {
            // 如果最大版本小于当前版本，表示版本不可用
            if([max intValue]<version) {
                return false;
            }
        }
        
    } @catch (NSException *e) {
        
        return false;
    }
    
    return true;
}

@end
