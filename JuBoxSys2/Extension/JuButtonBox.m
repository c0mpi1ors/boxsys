//
//  JuButtonBox.m
//  boxsys
//
//  Created by chunyi.zhoucy on 14-4-29.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "JuButtonBox.h"
#import "JuButtonBoxModel.h"
#import "JuBoxSys2.h"

@interface JuButtonBox()

// 跳转用的url
@property (nonatomic, strong) NSString *internalUrl;

// 按下时的埋点ID
@property (nonatomic, strong) NSString *trackId;

// 按下时的埋点值
@property (nonatomic, strong) NSString *trackName;

@end

@implementation JuButtonBox

//@Override
- (bool) load:(NSDictionary *) dataMap
        withX:(double) x
        withY:(double) y
    withWidth:(double) width
   withHeight:(double) height
  withHandler:(id<JuBoxSysDelegate>) handler
    withModel:(JuBoxModel *) model
{
    if (![super load:dataMap withX:x withY:y withWidth:width withHeight:height withHandler:handler withModel:model]) return false;
    
    JuButtonBoxModel *buttonModel = (JuButtonBoxModel *)model;
    
    NSString *imageUrl = [JuBoxSys2 getStringFromMap:dataMap withName:buttonModel.imageURL];
    if (imageUrl==NULL) {
        return false;
    }
    
    NSURL *nsurl = [NSURL URLWithString:imageUrl];
    NSData* data = [NSData dataWithContentsOfURL:nsurl];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.x, self.y, self.width, self.height);
    [button setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.boxView = button;
    
    if (buttonModel.htmlURL!=NULL) {
        self.internalUrl = [JuBoxSys2 getStringFromMap:dataMap withName:buttonModel.htmlURL];
    } else if (buttonModel.nativeURL!=NULL) {
        self.internalUrl = [JuBoxSys2 getStringFromMap:dataMap withName:buttonModel.nativeURL];
    }
    self.trackId = buttonModel.trackId;
    self.trackName = [JuBoxSys2 getStringFromMap:dataMap withName:buttonModel.trackName];
    
    return true;
}

//@Override
- (void) onClick: (id)sender
{
    if (self.handler!=NULL) {
        [self.handler onBoxSysEvent:self withArgs:NULL];
    }
    
    /**
     * 统一埋点
     */
    if (self.trackId != NULL && self.trackName != NULL) {
        if ((self.trackId != NULL) && (self.trackName != NULL)) {
//            TBS.Page.buttonClicked("BOXSYS_" + trackId + "_" + trackName);
        }
    }
    
    /**
     * 统一跳转HTML
     */
    if (self.internalUrl != NULL) {
//        JuUtils.startActivityByUri(this.handler.getContext(), internalUrl);
    }
}

@end
