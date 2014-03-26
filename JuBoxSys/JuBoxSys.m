//
//  JuBoxSys.m
//  JuBoxSys
//
//  Created by chunyi.zhoucy on 14-1-8.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "JuBoxSys.h"
#import "JuBox.h"
#import "JuBoxContainer.h"

@interface JuBoxSys()

@property (nonatomic, retain) NSLock *internalLock;
@property (nonatomic, retain) NSMutableDictionary * namedModel;
@property (nonatomic, retain) NSMutableDictionary * namedContainer;

@end

@implementation JuBoxSys

- (id) init
{
    self = [super init];
    if (self) {
        
        self.internalLock = [[[NSLock alloc] init] autorelease];
        self.namedModel = [[[NSMutableDictionary alloc] init] autorelease];
        self.namedContainer = [[[NSMutableDictionary alloc] init] autorelease];
    }
    
    return self;
}

- (void) dealloc
{
    [self.internalLock unlock]; self.internalLock = nil;
    [self.namedModel removeAllObjects]; self.namedModel = nil;
    [self.namedContainer removeAllObjects]; self.namedModel = nil;
    
    [super dealloc];
}

static JuBoxSys *sharedJuBoxSys = nil;

+ (JuBoxSys *) sharedManager
{
    @synchronized (self)
    {
        if (sharedJuBoxSys == nil)
        {
            sharedJuBoxSys = [[JuBoxSys alloc] init];
        }
    }
    return sharedJuBoxSys;
}

+ (void) loadModel:(NSDictionary *)model
{
    if (!model || ![model isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    JuBoxSys *sys = [JuBoxSys sharedManager];
    
    [sys.internalLock lock];
    
    for (NSString *modelName in model.allKeys) {
        
        if (modelName && [modelName isKindOfClass:[NSString class]]) {
            
            JuBoxModel *boxModel = [sys.namedModel objectForKey:modelName];
            
            if (boxModel) {
                [boxModel close];
                [sys.namedModel removeObjectForKey:modelName];
            }
            
            NSDictionary *arr = [model objectForKey:modelName];
            
            if (arr && [arr isKindOfClass:[NSDictionary class]]) {
                
                boxModel = [JuBoxModel load:arr];
                
                if (boxModel) {
                    
                    [sys.namedModel setObject:boxModel forKey:modelName];
                }
            }
        }
    }
    
    [sys.internalLock unlock];
}

// 增加容器
+ (void)  addContainer:(NSString *)name
                  size:(CGSize)containSize
              delegate:(id<JuBoxSysDelegate>) delegate
{
    JuBoxSys *sys = [JuBoxSys sharedManager];
    
    [sys.internalLock lock];
    
    JuBoxContainer *container = [sys.namedContainer objectForKey:name];
    
    if (!container) {
    	container = [[[JuBoxContainer alloc] init] autorelease];
        
        [sys.namedContainer setObject:container forKey:name];
    }
    
    container.size = containSize;
    container.delegate = delegate;
    
    [sys.internalLock unlock];
}

// 装载容器数据
+ (void)  loadContainer:(NSString *)name
                   data:(NSArray *)arr
{
    JuBoxSys *sys = [JuBoxSys sharedManager];
    
    [sys.internalLock lock];
    
    JuBoxContainer *container = [sys.namedContainer objectForKey:name];
    
    if (container) {
        
        if (!arr || ![arr isKindOfClass:[NSArray class]]) {
            
            /**
             增加清除容器功能
             */
            [container clean];
            
        } else {
        
        	[container load:arr map:sys.namedModel];
        }
    }
    
    [sys.internalLock unlock];
}

/******************************************************************************/

+ (void)  loadBox:(NSString *)name
             data:(NSDictionary *)dic
         delegate:(id<JuBoxSysDelegate>) delegate
{
    JuBoxSys *sys = [JuBoxSys sharedManager];
    
    [sys.internalLock lock];
    
    JuBoxContainer *container = [sys.namedContainer objectForKey:name];
    
    if (!container) {
        
        container = [[[JuBoxContainer alloc] init] autorelease];
        
        [sys.namedContainer setObject:container forKey:name];
        
        container.size = CGSizeMake(320, 480);
        container.delegate = delegate;
    }
    
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        
        /**
         增加清除容器功能
         */
        [container clean];
        
    } else {
        
        JuBoxModel *boxModel = [sys.namedModel objectForKey:name];
        
        if (boxModel) {
            [container loadBox:dic model:boxModel modelMap:sys.namedModel];
        }
    }
    
    [sys.internalLock unlock];
}

+ (void) clearSelf
{
    if (sharedJuBoxSys) {
        [sharedJuBoxSys release];
        sharedJuBoxSys = Nil;
    }
}

@end
