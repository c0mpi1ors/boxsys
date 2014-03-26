//
//  JuBoxSysDelegate.h
//  boxsys
//
//  Created by chunyi.zhoucy on 14-1-7.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 * 对应的设计文档：http://confluence.taobao.ali.com/pages/createpage.action?spaceKey=juwl&fromPageId=195700544
 */

@protocol JuBoxSysDelegate <NSObject>

// 要求分配容器所在的UIView
// 比如需要在一个UIView里显示，就返回这个UIView
// Boxsys会根据计算大小重新设置这个UIView的frame，
// 然后调用delegate的flush方法，见下面
- (UIView *) getContainer;

// 获得一个包含指定图片的按钮
// 因为不同系统有不同的图片缓存和按钮生成方式
// 所以按钮生成需要由外面系统自定义来完成
- (UIButton *) getButtonWithImage:(NSString *)imageUrl
                     clickedImage:(NSString *)clickedImageUrl;

// 通知Container刷新显示
// 一般的工作就是根据新的大小刷新显示
- (void) flush;

// 按下通知
// 所有块在被按下时，都有通知消息发送出来，这个函数就被调用到
- (void) clickBlock:(NSDictionary *)data;

@end
