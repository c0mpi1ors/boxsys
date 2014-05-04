//
//  JuArrayBox.m
//  boxsys
//
//  Created by chunyi.zhoucy on 14-4-30.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "JuArrayBox.h"
#import "JuBoxSys2.h"

@implementation JuArrayBox

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

    JuArrayBoxModel *arrayModel  = (JuArrayBoxModel *)model;
    
    // 初始化布局
    self.boxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
    self.height = 0.0;
    
    for (JuListRelativeBoxModel *r in arrayModel.subBoxModelList) {
        
        JuArrayRelativeBoxModel *relative = (JuArrayRelativeBoxModel *)r;
        
        if (relative.model==NULL) {
            continue;
        }
        
        // 如果配置了数据map，需要进入对应的数据map做处理
        NSDictionary *itemData = dataMap;
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
        
        // 初始化Box
        if (![itemBox load:itemData withX:0 withY:self.height withWidth:width withHeight:height withHandler:handler withModel:relative.model]) continue;
        
        // 显示Box
        [itemBox showOn:self.boxView];
        
        // 高度等比变高
        self.height += itemBox.height;
        
        // 保存
        [self.subBoxList addObject:itemBox];
    }
    
    if (self.height>0) {
        
        CGRect rect  = CGRectMake(0, 0, self.width, self.height);
        self.boxView.frame = rect;
    }
    
    return true;
}

@end
