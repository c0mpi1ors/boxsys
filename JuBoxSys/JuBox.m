//
//  JuBox.m
//  boxsys
//
//  Created by chunyi.zhoucy on 14-1-7.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "JuBox.h"
#import "JuBoxSys.h"
#import "JuBoxTableView.h"

@implementation JuBox

#define MAGIC_TAG 20101122

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
    [self.boxView removeFromSuperview]; self.boxView = nil;
    [self.namedBlocks removeAllObjects]; self.namedBlocks = nil;
    [self.listBlocks removeAllObjects]; self.listBlocks = nil;
    self.data = nil;
    self.model = nil;
    self.modelMap = nil;
    self.delegate = nil;
    
    [super dealloc];
}

- (void) close
{
    [self.boxView removeFromSuperview]; self.boxView = nil;
    
    for (JuBlock *block in self.listBlocks) {
        
        [block close];
    }
    
    [self.namedBlocks removeAllObjects]; self.namedBlocks = nil;
    [self.listBlocks removeAllObjects]; self.listBlocks = nil;
    self.data = nil;
    self.model = nil;
    self.modelMap = nil;
    self.delegate = nil;
}

+ (JuBox *)load:(NSArray *)arr
           size:(CGSize)containSize
       delegate:(id<JuBoxSysDelegate>)delegate
      fromModel:(JuBoxModel *)model
{
    JuBox *box = [[[JuBox alloc] init] autorelease];
    
    if (containSize.width>10000) {
        
        if (containSize.height>10000) {
            
            box.extend = EXTEND_NONE;
            box.width = model.width;
            box.height = model.height;
            
        } else {
            
            box.extend = EXTEND_HEIGHT;
            box.height = containSize.height;
            box.width = model.width * box.height/model.height;
        }
        
    } else {
        
        if (containSize.height>10000) {
            
            box.extend = EXTEND_WIDTH;
            box.width = containSize.width;
            box.height = model.height * box.width/model.width;
            
        } else {
            
            box.extend = EXTEND_BOTH;
            box.width = containSize.width;
            box.height = containSize.height;
        }
        
    }
    
    box.boxView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, box.width, box.height)] autorelease];
    
    CGSize realsize;
    realsize.width = box.width;
    realsize.height = box.height;
    
    for (NSDictionary *dic in arr) {
        
        JuBlock *block = [JuBlock load:dic
                                  size:realsize
                              delegate:delegate
                             fromModel:model];
        
        if (block) {
            [box.namedBlocks setObject:block forKey:block.name];
            [box.listBlocks addObject:block];
            
            [box.boxView addSubview:block.button];
        }
    }
    
    return box;
}

+ (JuBox *)loadBox:(NSDictionary *)dic
              size:(CGSize)containSize
          delegate:(id<JuBoxSysDelegate>)delegate
         fromModel:(JuBoxModel *)model
          modelMap:(NSDictionary *)models
{
    JuBox *box = NULL;
    
    if (model.type == ModelTypeTable) {
        
        box = [[[JuBoxTableView alloc] init] autorelease];
        
    } else {
        
        box = [[[JuBox alloc] init] autorelease];
    }

    box.data = dic;
    box.model = model;
    box.modelMap = models;
    box.delegate = delegate;
    
    if (containSize.width>10000) {
        
        if (containSize.height>10000) {
            
            box.extend = EXTEND_NONE;
            box.width = model.width;
            box.height = model.height;
            
        } else {
            
            box.extend = EXTEND_HEIGHT;
            box.height = containSize.height;
            box.width = model.width * box.height/model.height;
        }
        
    } else {
        
        if (containSize.height>10000) {
            
            box.extend = EXTEND_WIDTH;
            box.width = containSize.width;
            box.height = model.height * box.width/model.width;
            
        } else {
            
            box.extend = EXTEND_BOTH;
            box.width = containSize.width;
            box.height = containSize.height;
        }
        
    }
    
    if (model.type == ModelTypeTable) {
        
        [(JuBoxTableView *)box load];
        
    } else {
        
        box.boxView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, box.width, box.height)] autorelease];
        
        CGSize realsize;
        realsize.width = box.width;
        realsize.height = box.height;
        
        for (JuBlockModel *blockModel in model.listBlocks) {
            
            JuBlock *block = [JuBlock loadBlock:dic
                                         size:realsize
                                  delegate:delegate
                                 fromModel:model
                              fromBlockModel:blockModel];
            
            if (block) {
                [box.namedBlocks setObject:block forKey:blockModel.name];
                [box.listBlocks addObject:block];
                
                [box.boxView addSubview:block.button];
            }
        }
    }

    return box;
}

@end
