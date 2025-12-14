//
//  JuGroupBoxModel.m
//  boxsys
//
//  Created by chunyi.zhoucy on 14-4-30.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "JuGroupBoxModel.h"
#import "JuBoxSys2.h"

@implementation JuGroupRelativeBoxModel


@end

@implementation JuGroupBoxModel

//@Override
- (bool) load:(NSString*) name withModel:(NSDictionary *) modelMap
{
    
    if (![super load:name withModel:modelMap]) return false;
    
    self.boxExtend = ExtendHeight;
    NSString *strExtend = [JuBoxSys2 getStringFromMap:modelMap withName:@"extend"];
    if (strExtend != NULL) {
        strExtend = [strExtend uppercaseString];
        if ([strExtend isEqualToString:@"none"]) {
            self.boxExtend = ExtendNone;
        } else if ([strExtend  isEqualToString:@"width"]) {
            self.boxExtend = ExtendWidth;
        } else if ([strExtend isEqualToString:@"height"]) {
            self.boxExtend = ExtendHeight;
        } else if ([strExtend isEqualToString:@"both"]) {
            self.boxExtend = ExtendBoth;
        }
    }
    
    return true;
}

/**
 * {
 *     "name":"image",
 *     "map":"1",
 *     "position":[10,10,300,220]
 * }
 *
 * @param itemMap
 * @return
 */
//@Override
- (JuListRelativeBoxModel*) loadItem:(int) index withItem:(NSDictionary *)itemMap
{
    JuGroupRelativeBoxModel *relative = [[JuGroupRelativeBoxModel alloc] init];
    
    NSString *name = [JuBoxSys2 getStringFromMap:itemMap withName:@"name"];
    relative.model = [JuBoxSys2 getBoxModel:name];
    if (relative.model == NULL) {
        return NULL;
    }
    
    relative.map = [JuBoxSys2 getStringFromMap:itemMap withName:@"map"];
    
    relative.parameters = [JuBoxSys2 getMapFromMap:itemMap withName:@"parameters"];
    
    // 判断是否设置了parameters，有的话，直接重新构造
    if (relative.parameters!=NULL) {
        JuBoxModel *itemModel = [JuBoxSys2 generateModel:relative.model.type];
        if(itemModel == NULL) {return NULL;}
        if (![itemModel load:@"temp" withModel:relative.parameters]) return NULL;
        relative.model = itemModel;
    }
    
    NSArray *arr = [JuBoxSys2 getListFromMap:itemMap withName:@"position"];
    if (arr==NULL) return NULL;
    if (arr.count!=4) return NULL;
    
    NSNumber *x = [arr objectAtIndex:0];
    if ((x==NULL)||![x isKindOfClass:[NSNumber class]]) return NULL;
    relative.x = [x doubleValue];
    
    NSNumber *y = [arr objectAtIndex:1];
    if ((y==NULL)||![y isKindOfClass:[NSNumber class]]) return NULL;
    relative.y = [y doubleValue];
    
    NSNumber *width = [arr objectAtIndex:2];
    if ((width==NULL)||![width isKindOfClass:[NSNumber class]]) return NULL;
    relative.width = [width doubleValue];
    
    NSNumber *height = [arr objectAtIndex:3];
    if ((height==NULL)||![height isKindOfClass:[NSNumber class]]) return NULL;
    relative.height = [height doubleValue];
    
    return relative;
}

@end
