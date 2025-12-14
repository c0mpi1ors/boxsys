//
//  JuBox.h
//  boxsys
//
//  Created by chunyi.zhoucy on 14-4-29.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JuBoxSysDelegate.h"
#import "JuBoxModel.h"

/**
 * Box
 * <p/>
 * 显示元素类，所有显示元素都需要从这个类继承。
 * 与BoxModel存放配置信息不同，Box存放实际用于显示的内容。
 * <p/>
 * Created by chunyi.zhoucy on 14-4-24.
 */
@interface JuBox : NSObject

// Box相对与外部容器的x
@property (nonatomic, assign) float x;

// Box相对与外部容器的y
@property (nonatomic, assign) float y;

// Box相对与外部容器的宽度
@property (nonatomic, assign) float width;

// Box相对与外部容器的高度
@property (nonatomic, assign) float height;

// Box对应的处理句柄
@property (nonatomic, strong) id<JuBoxSysDelegate> handler;

// Box对应的Model
@property (nonatomic, strong) JuBoxModel *model;

// Box对应的数据
@property (nonatomic, strong) NSDictionary *dataMap;

// View对象，需要子类里实现
@property (nonatomic, strong) UIView *boxView;

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
    withModel:(JuBoxModel *) model;

/**
 * 在指定的容器里显示内容
 * @param container
 */
- (void) showOn:(id) container;

/**
 * 关闭对象，对于非ARC的实现，为了防止循环依赖，提供这个函数，强制释放其中的retain的对象
 * 子类里需要重新实现这个方法，这样就可以防止内存泄露。
 * 未来的ARC版本，就可以不需要这个函数了。
 */
- (void) close;

@end
