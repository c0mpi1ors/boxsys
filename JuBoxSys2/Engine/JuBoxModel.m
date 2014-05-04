//
//  JuBoxModel.m
//  boxsys
//
//  Created by chunyi.zhoucy on 14-4-28.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "JuBoxModel.h"
#import "JuBoxVersion.h"
#import "JuBoxSys2.h"

@implementation JuBoxModel

/**
 * 装载模型信息
 * 基本信息：
 * {
 *     "type":"xxx",
 *     "name":"xxx"
 * }
 * @param name 模板名字
 * @param modelMap 模板数据
 * @return 成功或失败
 */
- (bool) load:(NSString *) name withModel:(NSDictionary *) modelMap
{
    @try {
        // 增加版本管理
        if (![JuBoxVersion verify:modelMap]) {
            return false;
        }
        
        self.name = name;
        
        self.map = [JuBoxSys2 getStringFromMap:modelMap withName:@"map"];
        
        NSNumber *nw = [JuBoxSys2 getNumberFromMap:modelMap withName:@"width"];
        if (nw!=NULL) {
            self.width = [nw floatValue];
        }
        
        NSNumber *nh = [JuBoxSys2 getNumberFromMap:modelMap withName:@"height"];
        if (nh!=NULL) {
            self.height = [nh floatValue];
        }
        
        return true;
        
    } @catch (NSException *e) {
        
        return false;
    }
}

/**
 * 关闭对象，对于非ARC的实现，为了防止循环依赖，提供这个函数，强制释放其中的retain的对象
 * 子类里需要重新实现这个方法，这样就可以防止内存泄露。
 * 未来的ARC版本，就可以不需要这个函数了。
 */
- (void) close
{
}

@end
