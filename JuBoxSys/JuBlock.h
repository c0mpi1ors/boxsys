//
//  JuBlock.h
//  boxsys
//
//  Created by chunyi.zhoucy on 14-1-7.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JuBoxModel.h"
#import "JuBoxSysDelegate.h"

@interface JuBlock : NSObject

@property (retain, nonatomic) UIButton *button;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) id<JuBoxSysDelegate> delegate;
@property (retain, nonatomic) NSDictionary *data;

+ (JuBlock *)load:(NSDictionary *)dic
             size:(CGSize)size
         delegate:(id<JuBoxSysDelegate>)delegate
        fromModel:(JuBoxModel *)model;

+ (JuBlock *)loadBlock:(NSDictionary *)dic
                size:(CGSize)size
            delegate:(id<JuBoxSysDelegate>)delegate
           fromModel:(JuBoxModel *)model
           fromBlockModel:(JuBlockModel *)blockModel;

- (void) close;

@end
