//
//  JuBoxCache.h
//  boxsys
//
//  Created by chunyi.zhoucy on 14-4-29.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JuBox.h"

/**
 * BoxCache
 * <p/>
 * Box缓存管理类
 * BoxCache是两层的，是这样的结构：
 * BoxCache->BoxCacheItem->String
 * <p/>
 * Created by chunyi.zhoucy on 14-4-25.
 */
@interface JuBoxCache : NSObject

/**
 * 存储一个Box
 * @param boxName
 * @param key
 * @param boxObj
 */
- (void) set:(NSString*) boxName  withKey:(NSString*) key withBox:(JuBox *)boxObj;

/**
 * 根据key和box名，获得一个Box缓存数据
 * @param boxName
 * @param key
 * @return
 */
- (JuBox*) get:(NSString*) boxName withKey:(NSString*) key;

/**
 * 清除一个key对应下的某个Box缓存
 * @param boxName
 * @param key
 */
- (void) clear:(NSString*) boxName withKey:(NSString*) key;

/**
 * 清除一个key关联的所有缓存数据
 * @param key
 */
- (void) clearHandler:(NSString*) key;

/**
 * 缓存所有缓存数据
 */
- (void) clearAll;

@end
