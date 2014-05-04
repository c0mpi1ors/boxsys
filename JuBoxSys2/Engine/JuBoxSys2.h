//
//  JuBoxSys.h
//  JuBoxSys
//
//  Created by chunyi.zhoucy on 14-1-8.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JuBoxSysDelegate.h"
#import "JuBoxModel.h"
#import "JuBox.h"

/**
 * BOXSYS 2.0: BOX SYSTEM的缩写，是块状显示系统。这个版本是2.0版本。从2.0版本开始，将block和box整合成一套体系里。
 * <p/>
 * BOX SYSTEM是用来提供动态化显示的系统，使用JSON作为模板和数据源，动态拼装显示
 * 模块是按照单独模块设计的。可以完整抽取出来单独运行（业务无关的）。
 * 整体代码分为：
 * （1）模板系：BoxModel
 * （2）数据系：Box
 * （3）容器：ListBoxModel
 *
 * 设计文档：http://confluence.taobao.ali.com/pages/editpage.action?pageId=215908939
 *
 * <p/>
 */

@interface JuBoxSys2 : NSObject

/**
 * 初始化系统
 * @param versionNumber 应用版本号
 */
+ (void) initBoxSys: (int)versionNumber;

/**
 * 获得版本号（不是Boxsys的版本号，是系统的版本号，也就是initBoxSys时设置的值
 */
+ (int) getVersion;

/**
 * 从字典中获取字典
 * @param dataMap
 * @param name
 * @return
 */
+ (NSDictionary *) getMapFromMap:(NSDictionary *) dataMap withName:(NSString*) name;

/**
 * 从字典中获取列表
 * @param dataMap
 * @param name
 * @return
 */
+ (NSArray *) getListFromMap:(NSDictionary *) dataMap withName:(NSString*) name;

/**
 * 从字典中获取字符串
 * @param dataMap
 * @param name
 * @return
 */
+ (NSString*) getStringFromMap:(NSDictionary*) dataMap withName:(NSString*) name;

/**
 * 从字典中获取数字
 * @param dataMap
 * @param name
 * @return
 */
+ (NSNumber*) getNumberFromMap:(NSDictionary*) dataMap withName:(NSString*) name;

/**
 * 根据名字获取模型对象
 * @param name 模板名字
 * @return 模板对象，如果是null，表示获取失败
 */
+ (JuBoxModel *)getBoxModel:(NSString *)name;

/**
 * 生成模型
 * @param type
 * @return
 */
+ (JuBoxModel*) generateModel:(NSString *) type;

/**
 * 生成显示元素
 * @param type
 * @return
 */
+ (JuBox *) generateBox:(NSString *) type;

/**
 * 装载入模型数据
 * 收到模型配置后调用，运行结果是在系统里构造出模型库
 * @param model 服务端获取到的模型数据
 */
+ (void) loadModel:(NSDictionary *)model;

/**
 * 渲染出Box
 * 收到数据配置后调用
 * @param name 入口模板名
 * @param key  存入cache的key
 * @param width 容器宽度
 * @param height 容器高度
 * @param handler 处理器
 */
+ (void) loadBox:(NSString *) name
         withKey:(NSString*)key
        withData:(NSDictionary *) dataMap
           width:(double) width
          height:(double) height
    withDelegate:(id<JuBoxSysDelegate>) handler;

/**
 * 清理自身，使得没有常驻内存的内容
 * 因为不是ARC，所以为了避免存在垃圾数据，提供这个接口，在需要释放前调用，保证所有delegate的依赖都被强制释放
 */
+ (void) clearSelf;


@end

