//
//  JuBox.h
//  boxsys
//
//  Created by chunyi.zhoucy on 14-1-7.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JuBoxModel.h"
#import "JuBlock.h"
#import "JuBoxSysDelegate.h"

@interface JuBox : NSObject<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UIView *boxView;
@property (nonatomic, assign) float width;
@property (nonatomic, assign) float height;
@property (nonatomic, assign) JuBoxExtend extend;
@property (nonatomic, retain) NSMutableDictionary *namedBlocks;
@property (nonatomic, retain) NSMutableArray *listBlocks;

@property (nonatomic, retain) NSDictionary *data;
@property (nonatomic, retain) JuBoxModel *model;
@property (nonatomic, retain) NSDictionary *modelMap;
@property (nonatomic, retain) id<JuBoxSysDelegate> delegate;

+ (JuBox *)load:(NSArray *)arr
           size:(CGSize)containSize
       delegate:(id<JuBoxSysDelegate>)delegate
      fromModel:(JuBoxModel *)model;

+ (JuBox *)loadBox:(NSDictionary *)dic
              size:(CGSize)containSize
          delegate:(id<JuBoxSysDelegate>)delegate
         fromModel:(JuBoxModel *)model
          modelMap:(NSDictionary *)models;

- (void) close;

@end
