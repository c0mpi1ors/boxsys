//
//  JuArrayBoxModel.m
//  boxsys
//
//  Created by chunyi.zhoucy on 14-4-30.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "JuArrayBoxModel.h"
#import "JuBoxSys2.h"

@implementation JuArrayRelativeBoxModel

- (void) dealloc
{
    self.model = NULL;
    self.map = NULL;
    
    [super dealloc];
}

@end

@implementation JuArrayBoxModel

//@Override
- (JuListRelativeBoxModel*) loadItem:(int) index withItem:(NSDictionary *)itemMap
{
    JuArrayRelativeBoxModel *relative = [[[JuArrayRelativeBoxModel alloc] init] autorelease];
    
    NSString *name = [JuBoxSys2 getStringFromMap:itemMap withName:@"name"];
    if (name == NULL) return NULL;
    
    relative.model = [JuBoxSys2 getBoxModel:name];
    if (relative.model == NULL) {
        return NULL;
    }
    
    // 如果对应的模板没有配置高度，这就不行了，array是无法自己知道高度的。
    if (relative.model.height>0.0) {
        relative.map = [JuBoxSys2 getStringFromMap:itemMap withName:@"map"];
        
        return relative;
    } else {
        return NULL;
    }
}

@end
