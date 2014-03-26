//
//  ViewController.m
//  boxsys
//
//  Created by chunyi.zhoucy on 14-1-7.
//  Copyright (c) 2014年 chunyi.zhoucy. All rights reserved.
//

#import "ViewController.h"
#import "SBJson/SBJson.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [JuBoxSys addContainer:@"test" size:CGSizeMake(320, 1000000) delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static int modelStatus = 0;

- (IBAction)changeModel:(id)sender
{
    NSString *smodel;
    
    switch (modelStatus) {
        case 0:
            smodel = @" \
            {                     \
            \"A001\": {         \
            \"width\":320,  \
            \"height\":100, \
            \"blocks\":[        \
            {                 \
            \"name\":\"1\", \
            \"position\":[10,10,300,50] \
            },\
            { \
            \"name\":\"2\", \
            \"position\":[10,10,20,20] \
            } \
            ] \
            }   \
            }     \
            ";
            break;
        case 1:
            smodel = @" \
            {                     \
            \"A001\": {         \
            \"width\":320,  \
            \"height\":100, \
            \"blocks\":[        \
            {                 \
            \"name\":\"1\", \
            \"position\":[10,10,300,100] \
            },\
            { \
            \"name\":\"2\", \
            \"position\":[10,10,20,20] \
            } \
            ] \
            }   \
            }     \
            ";
            break;
        case 2:
            smodel = @" \
            {                     \
            \"A001\": {         \
            \"width\":320,  \
            \"height\":100, \
            \"blocks\":[        \
            {                 \
            \"name\":\"1\", \
            \"position\":[10,10,300,100] \
            },\
            { \
            \"name\":\"2\", \
            \"position\":[10,10,20,20] \
            } \
            ] \
            }   \
            }     \
            ";
            break;
        default:
            smodel = @" \
            {                     \
            \"M_BANNER_001\": {         \
            \"width\":320,  \
            \"height\":100, \
            \"blocks\":[        \
            {                 \
            \"name\":\"1\", \
            \"position\":[10,10,300,50] \
            },\
            { \
            \"name\":\"2\", \
            \"position\":[10,10,20,20] \
            } \
            ] \
            },   \
            \"M_VIEW_001\": { \
            \"type\": \"table\", \
            \"width\": \"320\", \
            \"height\": \"480\", \
            \"blocks\": [ \
               { \
                  \"type\": \"model\", \
                  \"name\": \"M_BANNER_001\", \
                  \"map\": \"Banner\", \
                  \"count\": 1 \
               }, \
               {  \
                  \"type\": \"model\", \
                  \"name\": \"M_CELL_001\", \
                  \"map\": \"Data\", \
                  \"count\": -1 \
                } \
            ] \
            } \
            } \
            ";
            modelStatus = 0;
            break;
    }
    modelStatus += 1;
    
    SBJsonParser *jsonParser = [[[SBJsonParser alloc] init] autorelease];
    
    NSDictionary *dmodel = [jsonParser objectWithString:smodel];
    
    [JuBoxSys loadModel:dmodel];
}

static int dataStatus = 0;

- (IBAction)changeData:(id)sender
{
    NSString *sdata;
    
    switch (dataStatus) {
        case 0:
            sdata = @"    \
            {                       \
            \"test\":[            \
            {                     \
            \"model\":\"A001\", \
            \"blocks\":[        \
            {                 \
            \"name\":\"1\", \
            \"image\":\"http://pic20.nipic.com/20120421/9895204_155804468138_2.jpg\", \
            \"imageClicked\":\"http://www.petdogs.cn/file/upload/201209/22/10-46-32-32-1.jpg\", \
            \"clicked\": {  \
            \"test\":\"test\" \
            }               \
            }                 \
            ]                   \
            },                  \
            {                     \
            \"model\":\"A001\", \
            \"blocks\":[        \
            {                 \
            \"name\":\"1\", \
            \"image\":\"http://pic20.nipic.com/20120421/9895204_155804468138_2.jpg\", \
            \"imageClicked\":\"http://www.petdogs.cn/file/upload/201209/22/10-46-32-32-1.jpg\", \
            \"clicked\": {  \
            \"test\":\"test\" \
            }               \
            }                 \
            ]                   \
            }                     \
            ]                     \
            }";
            break;
        case 1:
            sdata = @"    \
            {                       \
            \"test\":[            \
            {                     \
            \"model\":\"A001\", \
            \"blocks\":[        \
            {                 \
            \"name\":\"1\", \
            \"image\":\"http://pic20.nipic.com/20120421/9895204_155804468138_2.jpg\", \
            \"imageClicked\":\"http://www.petdogs.cn/file/upload/201209/22/10-46-32-32-1.jpg\", \
            \"clicked\": {  \
            \"test\":\"test\" \
            }               \
            },                 \
            {                 \
            \"name\":\"2\", \
            \"image\":\"http://www.petdogs.cn/file/upload/201209/22/10-46-32-32-1.jpg\", \
            \"imageClicked\":\"http://pic20.nipic.com/20120421/9895204_155804468138_2.jpg\", \
            \"clicked\": {  \
            \"test\":\"test\" \
            }               \
            }                 \
            ]                   \
            }                    \
            ]                     \
            }";
            break;
        default:
            sdata = @"    \
            {                       \
            \"test\":[            \
            {                     \
            \"model\":\"A001\", \
            \"blocks\":[        \
            {                 \
            \"name\":\"1\", \
            \"image\":\"http://pic20.nipic.com/20120421/9895204_155804468138_2.jpg\", \
            \"imageClicked\":\"http://www.petdogs.cn/file/upload/201209/22/10-46-32-32-1.jpg\", \
            \"clicked\": {  \
            \"test\":\"test\" \
            }               \
            }                 \
            ]                   \
            },                  \
            {                     \
            \"model\":\"A001\", \
            \"blocks\":[        \
            {                 \
            \"name\":\"1\", \
            \"image\":\"http://pic20.nipic.com/20120421/9895204_155804468138_2.jpg\", \
            \"imageClicked\":\"http://www.petdogs.cn/file/upload/201209/22/10-46-32-32-1.jpg\", \
            \"clicked\": {  \
            \"test\":\"test\" \
            }               \
            }                 \
            ]                   \
            }                     \
            ]                     \
            }";
            dataStatus = 0;
            break;
    }
    dataStatus += 1;
    
    SBJsonParser *jsonParser = [[[SBJsonParser alloc] init] autorelease];
    
    NSDictionary *ddata = [jsonParser objectWithString:sdata];
    
    [JuBoxSys loadContainer:@"test" data:[ddata objectForKey:@"test"]];
}

//=============================================================================//

- (UIView *) getContainer
{
    if(!self.workview) {
        self.workview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        [self.scrollView addSubview:self.workview];
    }
    return self.workview;
}

- (UIButton *) getButtonWithImage:(NSString *)imageUrl
                     clickedImage:(NSString *)clickedImageUrl
{
    NSURL *nsurl = [NSURL URLWithString:imageUrl];
    NSData* data = [NSData dataWithContentsOfURL:nsurl];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    
    if (clickedImageUrl) {
        nsurl = [NSURL URLWithString:clickedImageUrl];
        data = [NSData dataWithContentsOfURL:nsurl];
        
        [button setImage:[UIImage imageWithData:data] forState:UIControlStateSelected];
    }
    
    return button;
}

- (void) flush
{
    
}



//- (void) setContainer:(UIView *)newview
//{
//    [self.workview removeFromSuperview];
//    self.workview = newview;
//    [self.scrollView addSubview:newview];
//}

//- (void) setButtonImage:(UIButton *)button
//                  image:(NSString *)imageUrl
//           clickedImage:(NSString *)clickedImageUrl
//{
//    NSURL *nsurl = [NSURL URLWithString:imageUrl];
//    NSData* data = [NSData dataWithContentsOfURL:nsurl];
//    
//    [button setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
//    
//    if (clickedImageUrl) {
//        nsurl = [NSURL URLWithString:clickedImageUrl];
//        data = [NSData dataWithContentsOfURL:nsurl];
//        
//        [button setImage:[UIImage imageWithData:data] forState:UIControlStateSelected];
//    }
//}

- (void) clickBlock:(NSDictionary *)data
{
    NSLog(@"clicked");
}

@end
