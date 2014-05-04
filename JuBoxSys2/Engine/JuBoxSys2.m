//
//  JuBoxSys2.m
//  boxsys
//
//  Created by chunyi.zhoucy on 14-4-28.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "JuBoxSys2.h"
#import "JuBoxModel.h"
#import "JuBox.h"
#import "JuBoxCache.h"
#import <objc/objc.h>
#import <objc/runtime.h>

#import "JuButtonBox.h"
#import "JuGroupBox.h"
#import "JuArrayBox.h"

@interface JuBoxSys2()

// 类型名->模型类的字典
@property(nonatomic, retain) NSMutableDictionary *typeModelClass;

// 类型名->显示元素类的字典
@property(nonatomic, retain) NSMutableDictionary *typeBoxClass;

// 内部锁，防止线程间干扰
@property (nonatomic, retain) NSLock *internalLock;

// 模型库
@property (nonatomic, retain) NSMutableDictionary *namedModel;

// 元素缓存
@property (nonatomic, retain) JuBoxCache *boxCache;

// 版本号
@property (nonatomic, assign) int version;

@end


@implementation JuBoxSys2

- (id) init
{
    self = [super init];
    if (self) {
        
        self.typeModelClass = [[[NSMutableDictionary alloc] init] autorelease];
        self.typeBoxClass = [[[NSMutableDictionary alloc] init] autorelease];
        self.internalLock = [[[NSLock alloc] init] autorelease];
        self.namedModel = [[[NSMutableDictionary alloc] init] autorelease];
        self.boxCache = [[[JuBoxCache alloc] init] autorelease];
        self.version = 100; // 默认版本号
    }
    
    return self;
}

- (void) dealloc
{
    self.boxCache = nil;
    [self.typeModelClass removeAllObjects]; self.typeModelClass = nil;
    [self.typeBoxClass removeAllObjects]; self.typeBoxClass = nil;
    [self.namedModel removeAllObjects]; self.namedModel = nil;
	[self.internalLock unlock]; self.internalLock = nil;
    
    [super dealloc];
}

+ (void) clearSelf
{
    JuBoxSys2 *sys = [JuBoxSys2 sharedManager];
    [sys.internalLock lock];
    
    if (sharedJuBoxSys) {
        [sharedJuBoxSys release];
        sharedJuBoxSys = Nil;
    }
}

// 单例
static JuBoxSys2 *sharedJuBoxSys = nil;

+ (JuBoxSys2 *) sharedManager
{
    @synchronized (self)
    {
        if (sharedJuBoxSys == nil)
        {
            sharedJuBoxSys = [[JuBoxSys2 alloc] init];
        }
    }
    return sharedJuBoxSys;
}

/**
 * 获得版本号（不是Boxsys的版本号，是系统的版本号，也就是initBoxSys时设置的值
 */
+ (int) getVersion
{
    return [JuBoxSys2 sharedManager].version;
}

/**
 * 创建默认类型。
 * 即使不在model里手工配置，系统也会给每个类型分配一个同名模板，这样可以大大方便配置
 * @param type 模板类型
 */
+ (void) createDefaultBoxModel:(NSString *) type
{
    JuBoxModel *boxModel = [JuBoxSys2 generateModel:type];
    if (boxModel != NULL) {
        NSMutableDictionary *modelMap = [[[NSMutableDictionary alloc] init] autorelease];
        if ([boxModel load:type withModel:modelMap]) {
            [[JuBoxSys2 sharedManager].namedModel setObject:boxModel forKey:type];
        }
    }
}

/**
 * 注册<Box类型，模型类，元素类>
 * @param type
 * @param modelClass
 * @param boxClass
 */
+ (void) register:(NSString *)type withClass:(Class) modelClass withClass:(Class) boxClass
{
    [[JuBoxSys2 sharedManager].typeModelClass setObject:modelClass forKey:type];
    [[JuBoxSys2 sharedManager].typeBoxClass setObject:boxClass forKey:type];
    
    // 构造保留控件
    [JuBoxSys2 createDefaultBoxModel:type];
}

/**
 * 反注册
 * @param type
 */
+ (void) unregister:(NSString *) type
{
    [[JuBoxSys2 sharedManager].typeModelClass removeObjectForKey:type];
    [[JuBoxSys2 sharedManager].typeBoxClass removeObjectForKey:type];
}

/**
 * 生成模型
 * @param type
 * @return
 */
+ (JuBoxModel*) generateModel:(NSString *) type
{
    Class clazz = [[JuBoxSys2 sharedManager].typeModelClass objectForKey:type];
    if (clazz) {
    	JuBoxModel *model = (JuBoxModel *) class_createInstance(clazz, 0);
    	[[model init] autorelease];
    	model.type = type;
    	return model;
    } else {
        return NULL;
    }
}

/**
 * 生成显示元素
 * @param type
 * @return
 */
+ (JuBox *) generateBox:(NSString *) type
{
    if (type == NULL) { return NULL; }
    
    Class clazz = [[JuBoxSys2 sharedManager].typeBoxClass objectForKey:type];
    JuBox *box = (JuBox *) class_createInstance(clazz, 0);
    [[box init] autorelease];
    return box;
    
}

/**
 * 从字典中获取字典
 * @param dataMap
 * @param name
 * @return
 */
+ (NSDictionary *) getMapFromMap:(NSDictionary *) dataMap withName:(NSString*) name
{
    if ((dataMap == NULL) || (![dataMap isKindOfClass:[NSDictionary class]])) {
        return NULL;
    }
    if ((name == NULL)||(![name isKindOfClass:[NSString class]])) {
        return NULL;
    }
    NSDictionary* map = [dataMap objectForKey:name];
    if ((map == NULL)||!([map isKindOfClass:[NSDictionary class]])) {
        
        return NULL;
    }
    return map;
}

/**
 * 从字典中获取列表
 * @param dataMap
 * @param name
 * @return
 */
+ (NSArray *) getListFromMap:(NSDictionary *) dataMap withName:(NSString*) name
{
    if ((dataMap == NULL) || (![dataMap isKindOfClass:[NSDictionary class]])) {
        return NULL;
    }
    if ((name == NULL)||(![name isKindOfClass:[NSString class]])) {
        return NULL;
    }
    NSArray* lst = [dataMap objectForKey:name];
    if ((lst == NULL)||!([lst isKindOfClass:[NSArray class]])) {
        
        return NULL;
    }
    return lst;
}

/**
 * 从字典中获取字符串
 * @param dataMap
 * @param name
 * @return
 */
+ (NSString*) getStringFromMap:(NSDictionary*) dataMap withName:(NSString*) name
{
    if ((dataMap == NULL) || (![dataMap isKindOfClass:[NSDictionary class]])) {
        return NULL;
    }
    if ((name == NULL)||(![name isKindOfClass:[NSString class]])) {
        return NULL;
    }
    NSString* str = [dataMap objectForKey:name];
    if ((str == NULL)||!([str isKindOfClass:[NSString class]])) {
        
        return NULL;
    }
    return str;
}

/**
 * 从字典中获取数字
 * @param dataMap
 * @param name
 * @return
 */
+ (NSNumber*) getNumberFromMap:(NSDictionary*) dataMap withName:(NSString*) name
{
    if ((dataMap == NULL) || (![dataMap isKindOfClass:[NSDictionary class]])) {
        return NULL;
    }
    if ((name == NULL)||(![name isKindOfClass:[NSString class]])) {
        return NULL;
    }
    NSNumber* num = [dataMap objectForKey:name];
    if ((num == NULL)||!([num isKindOfClass:[NSNumber class]])) {
        
        return NULL;
    }
    return num;
}

/**
 * 初始化系统
 * @param application 应用
 * @param versionNumber 应用版本号
 */
+ (void) initBoxSys:(int) versionNumber
{
    [JuBoxSys2 sharedManager].version = versionNumber;
    
    // 注册控件
    
    [JuBoxSys2 register:@"button" withClass:[JuButtonBoxModel class] withClass:[JuButtonBox class]];
    [JuBoxSys2 register:@"group" withClass:[JuGroupBoxModel class] withClass:[JuGroupBox class]];
    [JuBoxSys2 register:@"array" withClass:[JuArrayBoxModel class] withClass:[JuArrayBox class]];
//    [JuBoxSys2 register:@"zdq" withClass:ZdqBoxModel.class withClass:ZdqBox.class];
}



/**
 * 根据名字获取模型对象
 * @param name 模板名字
 * @return 模板对象，如果是null，表示获取失败
 */
+  (JuBoxModel *) getBoxModel:(NSString *) name
{
    return [[JuBoxSys2 sharedManager].namedModel objectForKey:name];
}

/**
 * 装载入模型数据
 * 收到模型配置后调用，运行结果是在系统里构造出模型库
 * @param model 服务端获取到的模型数据
 */
+ (void) loadModel:(NSDictionary *) model
{
    JuBoxSys2 *sys = [JuBoxSys2 sharedManager];
    
    [sys.internalLock lock];
    
    @try {
        
        // 必须加以排序，否则Dictionary里的是乱序的。
        // 这块代码和android里的是没有的。
        NSArray * sortedKey = [model.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2){
            
            if (obj1 > obj2 ) {
                return NSOrderedDescending;
            }
            if (obj1 < obj2) {
                return NSOrderedAscending;
            }
            return NSOrderedSame;
        }];
        
        // 逐一处理Boxsys模型
        for (NSString *modelName in sortedKey) {
            
            // 判断是否已经存在，如果有重复存在，就以最后那个为准
            JuBoxModel *boxModel = [sys.namedModel objectForKey:modelName];
            
            if (boxModel!=NULL) {
                [boxModel close];
                [sys.namedModel removeObjectForKey:modelName];
            }
            
            NSDictionary *m = [model objectForKey:modelName];
            
            if (m && [m isKindOfClass:[NSDictionary class]]) {
                
                // 生成模型对象，然后初始化他
                NSString *modelType = (NSString *)[m objectForKey:@"type"];
                if (modelType == NULL) {
                    continue;
                }
                boxModel = [JuBoxSys2 generateModel:modelType];
                if (boxModel == NULL) {
                    continue;
                }
                
                // 如果初始化正确，就放入模形库里
                if ([boxModel load:modelName withModel:m]) {
                    
                    [sys.namedModel setObject:boxModel forKey:modelName];
                }
            }
        }
        
    } @finally {
        [sys.internalLock unlock];
    }
}

/**
 * 渲染出Box
 * 收到数据配置后调用
 * @param name 入口模板名
 * @param key  存入cache的key
 * @param width 容器宽度
 * @param height 容器高度
 * @param handler 处理器
 */
+ (void) loadBox:(NSString *) name
         withKey:(NSString *) key
        withData:(NSDictionary *)dataMap
           width:(double)width
          height:(double)height
    withDelegate:(id<JuBoxSysDelegate>)handler
{
    
    // 判断是否已经存在显示元素，如果已经存在，就用已有的，如果没有，就构造一个
    if (key == NULL) {
        return;
    }
    
    JuBoxSys2 *sys = [JuBoxSys2 sharedManager];
    
    [sys.internalLock lock];
    
    @try {
        
        JuBox *box = [sys.boxCache get:name withKey:key];
        if (box==NULL) {
            
            // 根据模板名找到模板
            JuBoxModel *boxModel = [sys.namedModel objectForKey:name];
            if (boxModel==NULL) { return; }
            
            // 根据模板类型构造对象
            box = [JuBoxSys2 generateBox:boxModel.type];
            if (box==NULL) { return; }
            
            // 初始化元素
            if ([box load:dataMap withX:0 withY:0 withWidth:width withHeight:height withHandler:handler withModel:boxModel])  {
                
                [sys.boxCache set:name withKey:key withBox:box];
            }
        }
        
        [box showOn:[handler getContainer]];
        
    } @finally {
        
        [sys.internalLock unlock];
    }
}

/**
 * 删除该handler关联的某模板对应的Box
 * @param name 模板名
 * @param key Cache中的键名
 */
+ (void) removeBox:(NSString*) name withKey:(NSString *)key
{
    JuBoxSys2 *sys = [JuBoxSys2 sharedManager];
    
    [sys.internalLock lock];
    
    @try {
        [sys.boxCache clear:name withKey:key];
    } @finally {
        [sys.internalLock unlock];
    }
}

@end
