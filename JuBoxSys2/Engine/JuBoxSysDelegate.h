//
//  JuBoxSysDelegate.h
//  boxsys
//
//  Created by chunyi.zhoucy on 14-4-29.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * BoxSys处理器接口
 * <p/>
 * BoxSys回调处理句柄
 *
 * 设计文档：http://confluence.taobao.ali.com/pages/editpage.action?pageId=215908939
 *
 * <p/>
 * Created by chunyi.zhoucy on 14-1-9.
 */
@protocol JuBoxSysDelegate <NSObject>

/**
 * 用于预先分配占位
 * @return
 */
- (UIView *) getContainer;

/**
 * 消息事件
 * @param sender   发送事件的对象
 * @param argsMap  事件参数
 */
- (void) onBoxSysEvent:(id) sender withArgs:(NSDictionary *) argsMap;

@end
