//
//  JuBoxModel.h
//  boxsys
//
//  Created by chunyi.zhoucy on 14-4-28.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * EBoxExtend
 * <p/>
 * 枚举类型，列出了图像的各种缩放模式
 * <p/>
 * Created by chunyi.zhoucy on 14-1-9.
 */
typedef enum {
    ExtendNone = 0, // 以模板中定义的像素1：1显示，不做任何等比扩展
    ExtendWidth,    // 以屏幕高度做等比依据，宽度任意扩展
    ExtendHeight,   // 以屏幕宽度做等比依据，高度任意扩展，目前大部分都是以这个为主
    ExtendBoth      // 长和高都以外部框大小扩展，这意味着不是等比缩放
} JuEBoxExtend;

@interface JuBoxModel : NSObject

// Box的名字，唯一区分一个BoxModel
@property (nonatomic, strong) NSString *name;

// Box的类型
@property (nonatomic, strong) NSString *type;

// Box对应数据里的相对位置
@property (nonatomic, strong) NSString *map;

// Box的宽度
@property (nonatomic, assign) float width;

// Box的高度
@property (nonatomic, assign) float height;

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
- (bool) load:(NSString *) name withModel:(NSDictionary *) modelMap;

/**
 * 关闭对象，对于非ARC的实现，为了防止循环依赖，提供这个函数，强制释放其中的retain的对象
 * 子类里需要重新实现这个方法，这样就可以防止内存泄露。
 * 未来的ARC版本，就可以不需要这个函数了。
 */
- (void) close;

@end
