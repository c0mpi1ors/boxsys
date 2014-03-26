//
//  JuBlockModel.m
//  boxsys
//
//  Created by chunyi.zhoucy on 14-1-7.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "JuBlockModel.h"

@implementation JuBlockModel

- (id) init
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void) dealloc
{
    self.name = nil;
    
    [super dealloc];
}

- (void) close
{
    self.name = nil;
}

+ (JuBlockModel *)load:(NSDictionary *)dic
{
    JuBlockModel *model = [[[JuBlockModel alloc] init] autorelease];
    
    NSString *t = [dic objectForKey:@"type"];
    if (!t) {
        model.type = BlockModelTypeImage;
    } else {
        if ([t isEqualToString:@"image"]) {
            model.type = BlockModelTypeImage;
        } else if ([t isEqualToString:@"label"]) {
            model.type = BlockModelTypeLabel;
        } else if ([t isEqualToString:@"model"]) {
            model.type = BlockModelTypeModel;
        } else {
            
            // format error!
            return nil;
        }
    }
    
    model.name = [dic objectForKey:@"name"];
    model.map = [dic objectForKey:@"map"];
    
    if (model.type == BlockModelTypeModel) {
        
        model.count = ((NSNumber *)[dic objectForKey:@"count"]).intValue;
        
    } else {
    
        NSArray *arr = [dic objectForKey:@"position"];
    	model.x = ((NSNumber *)[arr objectAtIndex:0]).floatValue;
    	model.y = ((NSNumber *)[arr objectAtIndex:1]).floatValue;
    	model.width = ((NSNumber *)[arr objectAtIndex:2]).floatValue;
    	model.height = ((NSNumber *)[arr objectAtIndex:3]).floatValue;
    
    }
    
    return model;
}

@end
