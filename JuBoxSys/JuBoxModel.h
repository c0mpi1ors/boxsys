//
//  JuBoxModel.h
//  boxsys
//
//  Created by chunyi.zhoucy on 14-1-7.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JuBlockModel.h"

typedef enum {
    ModelTypeView = 0,
    ModelTypeTable,
    ModelTypeBanner
} ModelType;

@interface JuBoxModel : NSObject

@property (nonatomic, assign) float width;
@property (nonatomic, assign) float height;
@property (nonatomic, assign) JuBoxExtend extend;
@property (nonatomic, retain) NSMutableDictionary *namedBlocks;
@property (nonatomic, retain) NSMutableArray *listBlocks;
@property (nonatomic, assign) ModelType type;

+ (JuBoxModel *)load:(NSDictionary *)dic;

- (void) close;

@end
