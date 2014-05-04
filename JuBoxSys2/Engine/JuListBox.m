//
//  JuListBox.m
//  boxsys
//
//  Created by chunyi.zhoucy on 14-5-4.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "JuListBox.h"

@implementation JuListBox

- (id) init
{
    self = [super init];
    if (self) {
        self.subBoxList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) dealloc
{
    [self.subBoxList removeAllObjects]; 
}

@end
