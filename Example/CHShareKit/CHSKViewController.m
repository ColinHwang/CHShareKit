//
//  CHSKViewController.m
//  CHShareKit
//
//  Created by ColinHwang on 03/07/2020.
//  Copyright (c) 2020 ColinHwang. All rights reserved.
//

#import "CHSKViewController.h"
#import <CHShareKit/CHShareKit.h>

@interface CHSKViewController ()

@end

@implementation CHSKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)onClickShare:(id)sender {
    // 创建文本分享类信息
    CHSKShareMessage *shareMessage = [CHSKShareMessage shareMessageWithTitle:@"title"];
    // 创建图片分享类信息
    //    CHSKShareMessage *shareMessage = [CHSKShareMessage shareMessageWithTitle:@"title" image:@"picture/pictureURL"];
    // 创建图片分享类信息
    //    CHSKShareMessage *shareMessage = [CHSKShareMessage shareMessageWithTitle:@"title" image:@"picture/pictureURL" thumbali:@"picture/pictureURL"];
    // 创建网页类分享信息
    //    CHSKShareMessage *shareMessage = [CHSKShareMessage shareMessageWithTitle:@"title" description:@"description" image:@"picture/pictureURL" url:[NSURL URLWithString:@"URLString"]];
    
    // Share
    [CHSKShare shareTo:CHSKPlatformTypeWX message:shareMessage shareHandler:^(CHSKResponseState state, CHSKShareMessage *message, NSDictionary *extraData, NSError *error) {
        switch (state) {
            case CHSKResponseStateBegin:
            {
                // 开始分享
            }
                break;
            case CHSKResponseStateSuccess:
            {
                // 分享成功
            }
                break;
            case CHSKResponseStateFailure:
            {
                // 分享失败
            }
                break;
            case CHSKResponseStateFinish:
            {
                // 分享完成
            }
                break;
            case CHSKResponseStateCancel:
            {
                // 取消分享
            }
                break;
        }
    }];
}

- (IBAction)onClickAuth:(id)sender {
    // Authorize
    [CHSKShare authorizeTo:CHSKPlatformTypeWX authorizeHandler:^(CHSKResponseState state, CHSKUser *user, NSDictionary *extraData, NSError *error) {
        switch (state) {
            case CHSKResponseStateBegin:
            {
                // 开始授权
            }
                break;
            case CHSKResponseStateSuccess:
            {
                // 授权成功
            }
                break;
            case CHSKResponseStateFailure:
            {
                // 授权失败
            }
                break;
            case CHSKResponseStateFinish:
            {
                // 授权完成
            }
                break;
            case CHSKResponseStateCancel:
            {
                // 取消授权
            }
                break;
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
