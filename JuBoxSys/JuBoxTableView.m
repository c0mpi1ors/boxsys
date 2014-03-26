//
//  JuBoxTableView.m
//  boxsys
//
//  Created by chunyi.zhoucy on 14-3-26.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "JuBoxTableView.h"
#import "JuBlockModel.h"
#import "JuBoxModel.h"

@interface JuBoxTableView()

// 内部使用的Box数组
@property(nonatomic, retain) NSMutableArray *boxArray; // 对应模板
@property(nonatomic, retain) NSMutableArray *dataArray; // 对应数据
@property(nonatomic, retain) NSMutableArray *viewArray; // 显示缓存

@end

@implementation JuBoxTableView

- (void) load
{
    self.boxArray = [[[NSMutableArray alloc]init]autorelease];
    self.dataArray = [[[NSMutableArray alloc]init]autorelease];
    self.viewArray = [[[NSMutableArray alloc]init]autorelease];
    
    self.boxView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)] autorelease];
    [((UITableView *)self.boxView) setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [((UITableView *)self.boxView) setDelegate:self];
    [((UITableView *)self.boxView) setDataSource:self];
    
    [self prepareBoxArray: self.data];
}

- (void) prepareBoxArray:(NSDictionary *)data
{
    for (JuBlockModel *blockModel in self.model.listBlocks) {
        
        id v = [data objectForKey:blockModel.map];
        if (v) {
            if ([v isKindOfClass:[NSArray class]]) {
                NSArray *va = (NSArray *)v;
                
                int count = MIN(blockModel.count, va.count);
                if (count<0) {
                    count = va.count;
                }
                
                for (int i=0; i<count; i++) {
                    
                    [self.boxArray addObject: blockModel];
                    [self.dataArray addObject: [va objectAtIndex:i]];
                }
                
            } else {
                
                [self.boxArray addObject: blockModel];
                [self.dataArray addObject: v];
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    long index = indexPath.row;
    
    JuBlockModel *blockModel = [self.boxArray objectAtIndex:index];
    
    JuBoxModel *cellModel = [self.modelMap objectForKey:blockModel.name];
    
    if (cellModel) {
        
        float height = self.width * cellModel.height / cellModel.width;
        
        return height;
    }
    
    return 0.0f;
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    long index = indexPath.row;
    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BOXSYS"] autorelease];

	if (self.viewArray.count > index) {
        
        JuBox *box = [self.viewArray objectAtIndex:index];
        
        cell.frame = CGRectMake(0, 0, box.width, box.height);
        [cell.contentView addSubview:box.boxView];
        
    } else {
        
        JuBlockModel *blockModel = [self.boxArray objectAtIndex:index];
        
        JuBoxModel *cellModel = [self.modelMap objectForKey:blockModel.name];
        
        if (cellModel) {
            
            float width = self.width;
            float height = self.width * cellModel.height / cellModel.width;
            
#warning 未想好如何处理点击事件
            
            NSDictionary *data = [self.dataArray objectAtIndex:index];
            
            JuBox *box = [JuBox loadBox:data
                                   size:CGSizeMake(width,height)
                               delegate:self.delegate
                              fromModel:cellModel
                               modelMap:self.modelMap];
            
            if (box) {
                
                cell.frame = CGRectMake(0, 0, box.width, box.height);
                
                [cell.contentView addSubview:box.boxView];
                
                [self.viewArray addObject:box];
            }
        }
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
