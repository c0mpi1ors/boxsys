//
//  JuGroupBox.m
//  boxsys
//
//  Created by chunyi.zhoucy on 14-4-30.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JuGroupBox.h"
#import "JuBoxSys2.h"

@implementation JuGroupBox

//@Override
- (bool) load:(NSDictionary *) dataMap
        withX:(double) x
        withY:(double) y
    withWidth:(double) width
   withHeight:(double) height
  withHandler:(id<JuBoxSysDelegate>) handler
    withModel:(JuBoxModel *) model
{
    if (![super load:dataMap withX:x withY:y withWidth:width withHeight:height withHandler:handler withModel:model]) return false;
    
    JuGroupBoxModel *groupModel = (JuGroupBoxModel *)model;
    
    // 根据扩展，计算缩放
    if (groupModel.boxExtend == ExtendHeight) {
        
        self.width = width;
        self.height = groupModel.height * self.width / groupModel.width;
        
    } else if (groupModel.boxExtend == ExtendNone) {
        
        self.width = groupModel.width;
        self.height = groupModel.height;
        
    } else if (groupModel.boxExtend == ExtendWidth) {
        
        self.height = height;
        self.width = groupModel.width * self.height / groupModel.height;
        
    } else if (groupModel.boxExtend == ExtendBoth) {
        
        self.height = height;
        self.width = width;
    }
    
    // 初始化布局
    self.boxView = [[UIView alloc] initWithFrame:CGRectMake(self.x, self.y, self.width, self.height)];
    
    for (JuListRelativeBoxModel *r in groupModel.subBoxModelList) {
        
        JuGroupRelativeBoxModel *relative = (JuGroupRelativeBoxModel *)r;
        
        if (relative.model==NULL) {
            continue;
        }
        
        // 如果配置了数据map，需要进入对应的数据map做处理
        NSDictionary *itemData = NULL;
        if (relative.map!=NULL) {
            itemData = [JuBoxSys2 getMapFromMap:self.dataMap withName:relative.map];
        }
        if (itemData == NULL) { // 找不到对应的数据，只好不显示了
            continue;
        }
        
        // 获取对应的模型定义,Box实例
        JuBox *itemBox = [JuBoxSys2 generateBox:relative.model.type];
        if (itemBox == NULL) {
            continue;
        }
        
        // 计算相对坐标
        double itemX = relative.x * self.width/groupModel.width;
        double itemY = relative.y * self.height/groupModel.height;
        double itemWidth = relative.width * self.width/groupModel.width;
        double itemHeight = relative.height * self.height/groupModel.height;
        
        // 初始化Box
        
        if (![itemBox load:itemData withX:itemX withY:itemY withWidth:itemWidth withHeight:itemHeight withHandler:handler withModel:relative.model]) continue;
        
        // 显示Box
        [itemBox showOn:self.boxView];
        
        // 保存
        [self.subBoxList addObject:itemBox];
    }
    
    return true;
}

@end
