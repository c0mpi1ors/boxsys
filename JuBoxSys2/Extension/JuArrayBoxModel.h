//
//  JuArrayBoxModel.h
//  boxsys
//
//  Created by chunyi.zhoucy on 14-4-30.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "JuListBoxModel.h"

@interface JuArrayRelativeBoxModel : JuListRelativeBoxModel

@property(nonatomic, strong) JuBoxModel *model; // 模板

@property(nonatomic, strong) NSString *map; // 映射名，到数据的映射关系

@end

@interface JuArrayBoxModel : JuListBoxModel

@end
