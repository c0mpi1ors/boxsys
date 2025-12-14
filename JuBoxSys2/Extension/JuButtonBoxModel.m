//
//  JuButtonBoxModel.m
//  boxsys
//
//  Created by chunyi.zhoucy on 14-4-29.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "JuButtonBoxModel.h"
#import "JuBoxSys2.h"

@implementation JuButtonBoxModel

//@Override
- (bool) load:(NSString *) name withModel:(NSDictionary *) modelMap
{
    if (![super load:name withModel:modelMap]) return false;
    
    self.imageURL = [JuBoxSys2 getStringFromMap:modelMap withName:@"imageURL"];
    
    self.htmlURL = [JuBoxSys2 getStringFromMap:modelMap withName:@"htmlURL"];
    
    self.nativeURL = [JuBoxSys2 getStringFromMap:modelMap withName:@"androidURL"];
    
    self.trackId = [JuBoxSys2 getStringFromMap:modelMap withName:@"trackId"];
    
    self.trackName = [JuBoxSys2 getStringFromMap:modelMap withName:@"trackName"];
    
    return true;
}

@end
