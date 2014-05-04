//
//  JuGroupBoxModel.h
//  boxsys
//
//  Created by chunyi.zhoucy on 14-4-30.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "JuListBoxModel.h"


@interface JuGroupRelativeBoxModel : JuListRelativeBoxModel

@property(nonatomic, retain) JuBoxModel *model; // 模板

@property(nonatomic, retain) NSString *map; // 映射名，到数据的映射关系

@property(nonatomic, assign) double x; // x坐标

@property(nonatomic, assign) double y; // y坐标

@property(nonatomic, assign) double width; // 宽度

@property(nonatomic, assign) double height; // 高度

@property(nonatomic, retain) NSDictionary *parameters; // 设置值

@end

/**
 * 组显示元素模型定义
 * <p/>
 * 定义了一组相对位置布局的元素关系
 * <p/>
 * Created by chunyi.zhoucy on 14-4-24.
 */
@interface JuGroupBoxModel : JuListBoxModel

@property (nonatomic, assign) JuEBoxExtend boxExtend;

@end
