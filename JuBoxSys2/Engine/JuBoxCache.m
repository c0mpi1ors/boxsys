//
//  JuBoxCache.m
//  boxsys
//
//  Created by chunyi.zhoucy on 14-4-29.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "JuBoxCache.h"
#import "JuBox.h"

/**
 * Cache条目
 */
@interface JuBoxCacheItem : NSObject

@property (nonatomic, strong) NSMutableDictionary *boxNameCache;

@end

@implementation JuBoxCacheItem

- (id) init
{
    self = [super init];
    if (self) {
        self.boxNameCache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) dealloc
{
    [self.boxNameCache removeAllObjects]; 
}

/**
 * 加入一条数据
 * @param boxName
 * @param boxObj
 */
- (void) set:(NSString *) boxName withBox:(JuBox *) boxObj
{
    [self.boxNameCache setObject:boxObj forKey:boxName];
}

/**
 * 获得一条数据
 * @param boxName
 * @return
 */
- (JuBox*) get:(NSString *) boxName
{
    return [self.boxNameCache objectForKey:boxName];
}

/**
 * 清除一条数据
 * @param boxName
 */
- (void) clear:(NSString*) boxName
{
    [self.boxNameCache removeObjectForKey:boxName];
}

/**
 * 清除所有数据
 */
- (void) clearAll
{
    [self.boxNameCache removeAllObjects];
}

@end

@interface JuBoxCache()

@property(nonatomic, strong) NSMutableDictionary *handlerCache;

@end

@implementation JuBoxCache

- (id) init
{
    self = [super init];
    if (self) {
        self.handlerCache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) dealloc
{
    [self.handlerCache removeAllObjects]; 
}

/**
 * 存储一个Box
 * @param boxName
 * @param key
 * @param boxObj
 */
- (void) set:(NSString*) boxName  withKey:(NSString*) key withBox:(JuBox *)boxObj
{
    JuBoxCacheItem *item = [self.handlerCache objectForKey:key];
    if (item == NULL) {
        item = [[JuBoxCacheItem alloc ] init];
        [self.handlerCache setObject:item forKey:key];
    }
    [item set:boxName withBox:boxObj];
}

/**
 * 根据key和box名，获得一个Box缓存数据
 * @param boxName
 * @param key
 * @return
 */
- (JuBox*) get:(NSString*) boxName withKey:(NSString*) key
{
    JuBoxCacheItem *item = [self.handlerCache objectForKey:key];
    if (item != NULL) {
        return [item get:boxName];
    }
    return NULL;
}

/**
 * 清除一个key对应下的某个Box缓存
 * @param boxName
 * @param key
 */
- (void) clear:(NSString*) boxName withKey:(NSString*) key
{
    JuBoxCacheItem *item = [self.handlerCache objectForKey:key];
    if (item != NULL) {
        [item clear:boxName];
    }
}

/**
 * 清除一个key关联的所有缓存数据
 * @param key
 */
- (void) clearHandler:(NSString*) key
{
    JuBoxCacheItem *item = [self.handlerCache objectForKey:key];
    if (item != NULL) {
        [item clearAll];
        [self.handlerCache removeObjectForKey:item];
    }
}

/**
 * 缓存所有缓存数据
 */
- (void) clearAll
{
    [self.handlerCache removeAllObjects];
}

@end
