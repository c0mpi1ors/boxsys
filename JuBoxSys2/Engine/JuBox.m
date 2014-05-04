//
//  JuBox.m
//  boxsys
//
//  Created by chunyi.zhoucy on 14-4-29.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "JuBox.h"
#import "JuBoxSys2.h"

@interface JuBox()

@end

@implementation JuBox

/**
 * 装载入数据
 * @param dataMap 显示数据
 * @param x       显示开始位置
 * @param y       显示开始位置
 * @param width   显示宽度
 * @param height  显示高度
 * @param handler 回调处理入口
 * @param model   对应的模型
 * @return
 */
- (bool) load:(NSDictionary *) dataMap
        withX:(double) x
        withY:(double) y
    withWidth:(double) width
   withHeight:(double) height
  withHandler:(id<JuBoxSysDelegate>) handler
    withModel:(JuBoxModel *) model
{
    
    // 如果不提供外框的大小（只要有一个维度也算OK的），则直接不可显示
    if ((width<=0.1) && (height<=0.1)) return false;
    
    self.x = x;
    self.y = y;
    self.width = width;
    self.height = height;
    self.handler = handler;
    self.model = model;
    
    // 如果配置了数据map，需要进入对应的数据map做处理
    self.dataMap = dataMap;
    if (model.map!=NULL) {
        self.dataMap = [JuBoxSys2 getMapFromMap:dataMap withName:model.map];
    }
    if(self.dataMap==NULL) {
        return false;
    }
    
    return true;
}

/**
 * 在指定的容器里显示内容
 * @param container
 */
- (void) showOn:(id) container
{
    if (self.boxView == NULL) return;
    if (container == NULL) return;
    
    // 从父容器里删除
    [self.boxView removeFromSuperview];
    
    if ([container isKindOfClass:[UIView class]]) {
        
        UIView *containerView = (UIView *)container;
        
        [containerView addSubview:self.boxView];
    }
}

/**
 * 关闭对象，对于非ARC的实现，为了防止循环依赖，提供这个函数，强制释放其中的retain的对象
 * 子类里需要重新实现这个方法，这样就可以防止内存泄露。
 * 未来的ARC版本，就可以不需要这个函数了。
 */
- (void) close
{
    self.handler = NULL;
    self.model = NULL;
}

@end
