//
//  JuBoxTableView.h
//  boxsys
//
//  Created by chunyi.zhoucy on 14-3-26.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "juBox.h"

@interface JuBoxTableView : JuBox <UITableViewDelegate, UITableViewDataSource>

- (void) load;

@end
