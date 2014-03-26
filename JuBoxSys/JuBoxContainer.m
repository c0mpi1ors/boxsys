//
//  JuBoxContainer.m
//  boxsys
//
//  Created by chunyi.zhoucy on 14-1-7.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "JuBoxContainer.h"
#import "JuBox.h"

#define MAGIC_TAG 20101122

@implementation JuBoxContainer

- (id) init
{
    self = [super init];
    if (self) {
        
        self.listBox = [[[NSMutableArray alloc] init] autorelease];
    }
    
    return self;
}

- (void) dealloc
{
    self.delegate = nil;
    [self.containerView removeFromSuperview]; self.containerView = nil;
    [self.listBox removeAllObjects]; self.listBox = nil;
    
    [super dealloc];
}

- (void)close
{
    [self clearContainer];
    
    [self.delegate flush];
    
    for (JuBox *box in self.listBox) {
        
        [box close];
    }
    
    [self.listBox removeAllObjects]; self.listBox = nil;

    [self.containerView removeFromSuperview]; self.containerView = nil;
    
    self.delegate = nil;
}

- (UIView *) clearContainer
{
    UIView * workview = [self.delegate getContainer];
    
    if (workview) {
        workview.frame = CGRectMake(0, 0, 0, 0);
        
        for (UIView *subview in workview.subviews) {
            if (subview.tag == MAGIC_TAG) {
                [subview removeFromSuperview];
            }
        }
    }
    
    return workview;
}

- (void)  loadBox:(NSDictionary *)dic
              model:(JuBoxModel *)model
         modelMap:(NSDictionary *)namedModel
{
    // 清除已有的BOX
    for (JuBox *box in self.listBox) {
        
        [box close];
    }
    
    [self.listBox removeAllObjects];
    
    // 重新载入新的view
    
    UIView * workview = [self clearContainer];
    if (!workview) {
        return;
    }
    workview.frame = CGRectMake(0, 0, 320, 480);
    self.height = 480.0f;
    
    JuBox *box = [JuBox loadBox:dic
                        size:CGSizeMake(200000, 200000) // 全屏
                    delegate:self.delegate
                   fromModel:model
                    modelMap:namedModel];
    
    box.boxView.tag = MAGIC_TAG;
    [workview addSubview:box.boxView];
    
    [self.listBox addObject:box];
    
    if (self.height>0) {
        
        CGRect containerRect = CGRectMake(0, 0, self.size.width, self.height);
        
        workview.frame = containerRect;
        
        [self.delegate flush];
        
        // 保存到以后使用
        self.containerView = workview;
    }
}

// 目前只适合等宽
- (void)load:(NSArray *)arr
         map:(NSDictionary *)namedModel
{
    // bugfix by evanjoe, 2014.1.9
    if (arr.count<=0) {
        return;
    }
    
    // 清除已有的BOX
    for (JuBox *box in self.listBox) {
        
        [box close];
    }
    
    [self.listBox removeAllObjects];
    
    // 重新载入新的view
    
    UIView * workview = [self clearContainer];
    if (!workview) {
        return;
    }
    
    self.height = 0.0f;
    
    CGSize boxsize = self.size;
    boxsize.height = boxsize.height / arr.count;
    
    for (NSDictionary *boxdic in arr) {
        
        NSString *name = [boxdic objectForKey:@"model"];
        
        if (name && [name isKindOfClass:[NSString class]]) {
            
            NSArray *blocks = [boxdic objectForKey:@"blocks"];
            
            if (blocks && [blocks isKindOfClass:[NSArray class]]) {
                
                JuBoxModel *boxModel = [namedModel objectForKey:name];
                
                if (boxModel && [boxModel isKindOfClass:[JuBoxModel class]]) {
                    
                    JuBox *box = [JuBox load:blocks
                                        size:boxsize
                                    delegate:self.delegate
                                   fromModel:boxModel];
                    
                    CGRect boxrect = box.boxView.frame;
                    
                    boxrect.origin.y = self.height;
                    
                    box.boxView.frame = boxrect;
                    
                    self.height += boxrect.size.height;
                    
                    box.boxView.tag = MAGIC_TAG;
                    [workview addSubview:box.boxView];
                    
                    [self.listBox addObject:box];
                    
                }
            }
        }
    }
    
    if (self.height>0) {
        
        CGRect containerRect = CGRectMake(0, 0, self.size.width, self.height);
        
        workview.frame = containerRect;
        
        [self.delegate flush];
        
        // 保存到以后使用
        self.containerView = workview;
    }
}

- (void) clean
{
    [self clearContainer];
    
    [self.delegate flush];
}

@end
