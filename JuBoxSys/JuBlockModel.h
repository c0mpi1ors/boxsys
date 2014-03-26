//
//  JuBlockModel.h
//  boxsys
//
//  Created by chunyi.zhoucy on 14-1-7.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    EXTEND_NONE = 0,
    EXTEND_WIDTH,
    EXTEND_HEIGHT,
    EXTEND_BOTH
} JuBoxExtend;

typedef enum {
    BlockModelTypeImage = 0,
    BlockModelTypeLabel,
    BlockModelTypeModel
} BlockModelType;

@interface JuBlockModel : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;
@property (nonatomic, assign) float width;
@property (nonatomic, assign) float height;
@property (nonatomic, assign) BlockModelType type;
@property (nonatomic, retain) NSString *map;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, assign) int count;

+ (JuBlockModel *)load:(NSDictionary *)dic;

- (void) close;

@end


