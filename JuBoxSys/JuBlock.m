//
//  JuBlock.m
//  boxsys
//
//  Created by chunyi.zhoucy on 14-1-7.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "JuBlock.h"

@implementation JuBlock

- (void) dealloc
{
    [self.button removeFromSuperview]; self.button = nil;
    self.name = nil;
    self.data = nil;
    self.delegate = nil;
    
    [super dealloc];
}

- (void) close
{
    [self.button removeFromSuperview]; self.button = nil;
    self.name = nil;
    self.data = nil;
    self.delegate = nil;
}

- (void)clicked:(id)sender
{
    if (self.delegate) {
        
        [self.delegate clickBlock:self.data];
    }
}

+ (JuBlock *)load:(NSDictionary *)dic
			 size:(CGSize)size
         delegate:(id<JuBoxSysDelegate>)delegate
        fromModel:(JuBoxModel *)model
{
    JuBlock *block = [[[JuBlock alloc] init] autorelease];
    
    block.name = [dic objectForKey:@"name"];
    
    if (!block.name || ![block.name isKindOfClass:[NSString class]]) {
        
        return nil;
    }
    
    NSString *image = [dic objectForKey:@"image"];
    
    if (!image || ![image isKindOfClass:[NSString class]]) {
        
        return nil;
    }
    
    NSString *imageClicked = [dic objectForKey:@"imageClicked"];
    
    block.data = [dic objectForKey:@"clicked"];
    
    block.delegate = delegate;
    
    JuBlockModel *blockModel = [model.namedBlocks objectForKey:block.name];
    if (blockModel) {
        CGRect rect;
        rect.origin.x = blockModel.x * size.width/model.width;
        rect.origin.y = blockModel.y * size.height/model.height;
        rect.size.width = blockModel.width * size.width/model.width;
        rect.size.height = blockModel.height * size.height/model.height;
        
        block.button = [block.delegate getButtonWithImage:image clickedImage:imageClicked];
        block.button.frame = rect;
        
        [block.button addTarget:block action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return block;
}

+ (JuBlock *)loadBlock:(NSDictionary *)dic
                size:(CGSize)size
            delegate:(id<JuBoxSysDelegate>)delegate
           fromModel:(JuBoxModel *)model
           fromBlockModel:(JuBlockModel *)blockModel
{
    JuBlock *block = [[[JuBlock alloc] init] autorelease];
    
    NSString *image = [dic objectForKey:blockModel.map];
    
    if (!image || ![image isKindOfClass:[NSString class]]) {
        
        return nil;
    }
    
#warning 点击不知道如何处理

    block.data = nil;
    
    block.delegate = delegate;
    
    CGRect rect;
    rect.origin.x = blockModel.x * size.width/model.width;
    rect.origin.y = blockModel.y * size.height/model.height;
    rect.size.width = blockModel.width * size.width/model.width;
    rect.size.height = blockModel.height * size.height/model.height;
    
    block.button = [block.delegate getButtonWithImage:image clickedImage:image];
    block.button.frame = rect;
    
    [block.button addTarget:block action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return block;
}

@end
