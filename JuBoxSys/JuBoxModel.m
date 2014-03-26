//
//  JuBoxModel.m
//  boxsys
//
//  Created by chunyi.zhoucy on 14-1-7.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "JuBoxModel.h"

@implementation JuBoxModel

- (id) init
{
    self = [super init];
    if (self) {
        
        self.namedBlocks = [[[NSMutableDictionary alloc] init] autorelease];
        self.listBlocks = [[[NSMutableArray alloc] init] autorelease];
    }
    
    return self;
}

- (void) dealloc
{
    [self.namedBlocks removeAllObjects]; self.namedBlocks = nil;
    [self.listBlocks removeAllObjects]; self.listBlocks = nil;
    
    [super dealloc];
}

- (void) close
{
    for (JuBlockModel *block in self.listBlocks) {
        
        [block close];
    }
    
    [self.namedBlocks removeAllObjects]; self.namedBlocks = nil;
    
    [self.listBlocks removeAllObjects]; self.listBlocks = nil;
}

+ (JuBoxModel *)load:(NSDictionary *)dic
{
    JuBoxModel *model = [[[JuBoxModel alloc] init] autorelease];
    
    NSString *t = [dic objectForKey:@"type"];
    if (!t) {
        model.type = ModelTypeView;
    } else {
        if ([t isEqualToString:@"view"]) {
            model.type = ModelTypeView;
        } else if ([t isEqualToString:@"table"]) {
            model.type = ModelTypeTable;
        } else if ([t isEqualToString:@"banner"]) {
            model.type = ModelTypeBanner;
        } else {
            
            // format error!
            return nil;
        }
    }
    
    NSNumber *nw = [dic objectForKey:@"width"];
    if (!nw) {
        return nil;
    }
    if ([nw isKindOfClass:[NSString class]]) {
        NSString *tmp = (NSString *)nw;
        model.width = tmp.intValue;
    }
    if (![nw isKindOfClass:[NSNumber class]]) {
        return nil;
    } else {
    	model.width = nw.floatValue;
    }
    
    NSNumber *wh = [dic objectForKey:@"height"];
    if (!wh) {
        return nil;
    }
    if ([wh isKindOfClass:[NSString class]]) {
        NSString *tmp = (NSString *)wh;
        model.height = tmp.intValue;
    }
    if (![wh isKindOfClass:[NSNumber class]]) {
        return nil;
    } else {
    	model.height = wh.floatValue;
    }
    
    NSArray *arr = [dic objectForKey:@"blocks"];
    if (!arr || ![arr isKindOfClass:[NSArray class]]) {
        return nil;
    }
    for (NSDictionary *block in arr) {
        
        JuBlockModel *blockModel = [JuBlockModel load:block];
        if (blockModel) {
            [model.namedBlocks setObject:blockModel forKey:blockModel.name];
            [model.listBlocks addObject:blockModel];
        }
    }
    
    return model;
}

@end
