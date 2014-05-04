//
//  JuListBoxModel.m
//  boxsys
//
//  Created by chunyi.zhoucy on 14-4-30.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "JuListBoxModel.h"
#import "JuBoxSys2.h"

@implementation JuListRelativeBoxModel

@end

@implementation JuListBoxModel

- (id) init
{
    self = [super init];
    if (self) {
        self.subBoxModelList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) dealloc
{
    [self.subBoxModelList removeAllObjects]; 
}

// @Override
- (bool) load:(NSString*) name withModel:(NSDictionary *) modelMap
{
    /**
     * 调用基类里的装载函数
     */
    if (![super load:name withModel:modelMap]) return false;
    
    @try {
        NSArray* arr = [JuBoxSys2 getListFromMap:modelMap withName:@"blocks"];
        if (arr == NULL) {
            return false;
        }
        int index = 0;
        for (NSDictionary *itemMap in arr) {
            
            if (![itemMap isKindOfClass:[NSDictionary class]]) continue;
            
            JuListRelativeBoxModel *relative = [self loadItem:index withItem:itemMap];
            if (relative!=NULL) {
                [self.subBoxModelList addObject:relative];
            }
            
            index ++;
        }
    } @catch (NSException *e) {
        return false;
    }
    
    return true;
}

/**
 * 装载每条配置关系，需要子类override。
 * @param  index 子box model中的序号
 * @param itemMap 子box model的对应配置
 * @return
 */
- (JuListRelativeBoxModel*) loadItem:(int) index withItem:(NSDictionary *)itemMap
{
    return NULL;
}

@end
