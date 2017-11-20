//
//  HotTopicTools.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HotTopicTools.h"
#import "BGNetWorkManager.h"
#import "NetworkConfiguration.h"
#import "GCCKeyChain.h"
#import "CheckUpdateRequest.h"
#import "Helper.h"
#import "RDAlertView.h"
#import <AliyunOSSiOS/OSSService.h>
#import "MBProgressHUD+Custom.h"

@implementation HotTopicTools

+ (void)configApplication
{
    [[BGNetworkManager sharedManager] setNetworkConfiguration:[NetworkConfiguration configuration]];
    
    //item字体大小
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : kNavTitleColor, NSFontAttributeName : [UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    
    //设置标题颜色和字体
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : kNavTitleColor, NSFontAttributeName : [UIFont boldSystemFontOfSize:17]}];
    
    [[UINavigationBar appearance] setTintColor:kNavTitleColor];
    
    NSString* identifierNumber = [[UIDevice currentDevice].identifierForVendor UUIDString];
    if (![GCCKeyChain load:keychainID]) {
        [GCCKeyChain save:keychainID data:identifierNumber];
    }
    
    [UITableView appearance].estimatedSectionHeaderHeight = 0;
    [UITableView appearance].estimatedSectionFooterHeight = 0;
//    if (@available(iOS 11.0, *)) {
//        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        // Fallback on earlier versions
//    }
    
    [self checkUpdate];
}

+ (void)saveFileOnPath:(NSString *)path withArray:(NSArray *)array
{
    NSFileManager * manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:FileCachePath]) {
        [manager createDirectoryAtPath:FileCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if ([manager fileExistsAtPath:path]) {
        [manager removeItemAtPath:path error:nil];
    }
    BOOL temp = [array writeToFile:path atomically:YES];
    if (temp) {
        NSLog(@"缓存成功");
    }else{
        NSLog(@"缓存失败");
    }
}

+ (void)saveFileOnPath:(NSString *)path withDictionary:(NSDictionary *)dict
{
    NSFileManager * manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:FileCachePath]) {
        [manager createDirectoryAtPath:FileCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if ([manager fileExistsAtPath:path]) {
        [manager removeItemAtPath:path error:nil];
    }
    BOOL temp = [dict writeToFile:path atomically:YES];
    if (temp) {
        NSLog(@"缓存成功");
    }else{
        NSLog(@"缓存失败");
    }
}

+ (void)removeFileOnPath:(NSString *)path
{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        [manager removeItemAtPath:path error:nil];
    }
}

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font lineModel:(NSLineBreakMode)model
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.lineBreakMode = model;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

+ (void)checkUpdate
{
    CheckUpdateRequest * request = [[CheckUpdateRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary * info = [response objectForKey:@"result"];
        
        if ([[info objectForKey:@"device_type"] integerValue] == 8) {
            
            NSArray * detailArray =  info[@"remark"];
            
            NSString * detail = @"本次更新内容:\n";
            for (int i = 0; i < detailArray.count; i++) {
                NSString * tempsTr = [detailArray objectAtIndex:i];
                detail = [detail stringByAppendingString:tempsTr];
            }
            
            NSInteger update_type = [[info objectForKey:@"update_type"] integerValue];
            
            UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.7f];
            [[UIApplication sharedApplication].keyWindow addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [Helper autoWidthWith:320], [Helper autoHeightWith:344])];
            [imageView setImage:[UIImage imageNamed:@"banbengengxin_bg"]];
            imageView.center = CGPointMake(kMainBoundsWidth / 2, kMainBoundsHeight / 2);
            imageView.userInteractionEnabled = YES;
            [view addSubview:imageView];
            
            UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, [Helper autoHeightWith:75], imageView.frame.size.width - 40, imageView.frame.size.height - [Helper autoHeightWith:155])];
            [imageView addSubview:scrollView];
            
            CGRect rect = [detail boundingRectWithSize:CGSizeMake(scrollView.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height + 20)];
            label.textColor = [UIColor blackColor];
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:15];
            label.text = detail;
            [scrollView addSubview:label];
            scrollView.contentSize = label.frame.size;
            
            if (update_type == 1) {
                RDAlertAction * leftButton = [[RDAlertAction alloc] initVersionWithTitle:@"立即更新" handler:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1288402607"]];
                    
                } bold:YES];
                leftButton.frame = CGRectMake(scrollView.frame.origin.x - 10, imageView.frame.size.height - [Helper autoHeightWith:50], scrollView.frame.size.width + 20, [Helper autoHeightWith:35]);
                [imageView addSubview:leftButton];
            }else if (update_type == 0) {
                UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(imageView.frame.size.width / 2, imageView.frame.size.height - [Helper autoHeightWith:50], .5f, [Helper autoHeightWith:35])];
                lineView.backgroundColor = UIColorFromRGB(0xb6a482);
                [imageView addSubview:lineView];
                
                RDAlertAction * leftButton = [[RDAlertAction alloc] initVersionWithTitle:@"取消" handler:^{
                    [view removeFromSuperview];
                    
                } bold:NO];
                leftButton.frame = CGRectMake(scrollView.frame.origin.x - 10, imageView.frame.size.height - [Helper autoHeightWith:50], scrollView.frame.size.width / 2 + 10, [Helper autoHeightWith:35]);
                [imageView addSubview:leftButton];
                
                RDAlertAction * righButton = [[RDAlertAction alloc] initVersionWithTitle:@"立即更新" handler:^{
                    [view removeFromSuperview];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1288402607"]];
                } bold:YES];
                righButton.frame =  CGRectMake(leftButton.frame.size.width + leftButton.frame.origin.x, imageView.frame.size.height - [Helper autoHeightWith:50], scrollView.frame.size.width / 2 + 10, [Helper autoHeightWith:35]);
                [imageView addSubview:righButton];
            }
        }
        
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

+ (UILabel *)labelWithFrame:(CGRect)frame TextColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)Alignment
{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = textColor;
    label.font = font;
    label.textAlignment = Alignment;
    
    return label;
}

+ (UIButton *)buttonWithTitleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor title:(NSString *)title
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setBackgroundColor:backgroundColor];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

+ (UIButton *)buttonWithTitleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor title:(NSString *)title cornerRadius:(CGFloat)cornerRadius
{
    UIButton * button = [self buttonWithTitleColor:titleColor font:font backgroundColor:backgroundColor title:title];
    button.layer.cornerRadius = cornerRadius;
    button.layer.masksToBounds = YES;
    return button;
}

+ (void)callPhoneByNumber:(NSString *)num{
    
    NSMutableString  *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",num];
    
    if (@available(iOS 10.0, *)) {
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    
}

+ (void)uploadImage:(UIImage *)image withBoxID:(NSString *)boxID progress:(void (^)(int64_t, int64_t, int64_t))progress success:(void (^)(NSString *))successBlock failure:(void (^)(NSError *))failureBlock
{
    NSString * path =[NSString stringWithFormat:@"log/resource/operation/mobile/%@/%@_%@.jpg", [Helper getCurrentTimeWithFormat:@"yyyyMMdd"], boxID, [Helper getTimeStampMS]];
    
    [self uploadImage:image withPath:path progress:progress success:successBlock failure:failureBlock];
}

+ (void)uploadImageArray:(NSArray<UIImage *> *)images withBoxIDArray:(NSArray *)boxIDArray progress:(void (^)(int64_t, int64_t, int64_t))progress success:(void (^)(NSString *, NSInteger))successBlock failure:(void (^)(NSError *, NSInteger))failureBlock
{
    for (NSInteger i = 0; i < images.count; i++) {
        UIImage * image = [images objectAtIndex:i];
        if ([image isKindOfClass:[UIImage class]]) {
            
            NSString * boxID = [boxIDArray objectAtIndex:i];
            NSString * path =[NSString stringWithFormat:@"log/resource/operation/mobile/box/%@/%@_%@.jpg", [Helper getCurrentTimeWithFormat:@"yyyyMMdd"], boxID, [Helper getTimeStampMS]];
            [self uploadImage:image withPath:path progress:progress success:^(NSString *path) {
                
                if (successBlock) {
                    successBlock(path, i);
                }
                
            } failure:^(NSError *error) {
                
                [MBProgressHUD showTextHUDWithText:[NSString stringWithFormat:@"第%ld几张图片上传失败",i] inView:[UIApplication sharedApplication].keyWindow];
                return;
//                if (failureBlock) {
//                    failureBlock(error, i);
//                }
                
            }];
        }else{
            if (successBlock) {
                successBlock(@"", i);
            }
        }
        
    }
}

+ (void)uploadImage:(UIImage *)image withHotelID:(NSString *)hotelID progress:(void (^)(int64_t, int64_t, int64_t))progress success:(void (^)(NSString *))successBlock failure:(void (^)(NSError *))failureBlock
{
    NSString * path =[NSString stringWithFormat:@"log/resource/operation/mobile/hotel/%@/%@_%@.jpg", [Helper getCurrentTimeWithFormat:@"yyyyMMdd"], hotelID, [Helper getTimeStampMS]];
    
    [self uploadImage:image withPath:path progress:progress success:^(NSString *path) {
        
        if (successBlock) {
            successBlock(path);
        }
        
    } failure:^(NSError *error) {
        
        if (failureBlock) {
            failureBlock(error);
        }
        
    }];
}

+ (void)uploadImageArray:(NSArray<UIImage *> *)images withHotelIDArray:(NSArray *)hotelIDArray progress:(void (^)(int64_t, int64_t, int64_t))progress success:(void (^)(NSString *, NSInteger))successBlock failure:(void (^)(NSError *, NSInteger))failureBlock
{
    for (NSInteger i = 0; i < images.count; i++) {
        UIImage * image = [images objectAtIndex:i];
        NSString * hotelID = [hotelIDArray objectAtIndex:i];
        NSString * path =[NSString stringWithFormat:@"log/resource/operation/mobile/hotel/%@/%@_%@.jpg", [Helper getCurrentTimeWithFormat:@"yyyyMMdd"], hotelID, [Helper getTimeStampMS]];
        [self uploadImage:image withPath:path progress:progress success:^(NSString *path) {
            
            if (successBlock) {
                successBlock(path, i);
            }
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD showTextHUDWithText:[NSString stringWithFormat:@"第%ld几张图片上传失败",i] inView:[UIApplication sharedApplication].keyWindow];
            return;
//            if (failureBlock) {
//                failureBlock(error, i);
//            }
            
        }];
    }
}

+ (void)uploadImage:(UIImage *)image withPath:(NSString *)path progress:(void (^)(int64_t, int64_t, int64_t))progress success:(void (^)(NSString *path))successBlock failure:(void (^)(NSError *error))failureBlock
{
    NSString *endpoint = AliynEndPoint;
    
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 3; // 网络请求遇到异常失败后的重试次数
    
    // 由阿里云颁发的AccessKeyId/AccessKeySecret构造一个CredentialProvider。
    // 明文设置secret的方式建议只在测试时使用，更多鉴权模式请参考后面的访问控制章节。
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:AliyunAccessKeyID secretKey:AliyunAccessKeySecret];
    OSSClient * client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential clientConfiguration:conf];
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = AliyunBucketName;
    put.objectKey = path;
    put.uploadingData = UIImageJPEGRepresentation(image, 1);
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        if (progress) {
            progress(bytesSent, totalBytesSent, totalBytesExpectedToSend);
        }
    };
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
        if (task.error) {
            if (failureBlock) {
                failureBlock(task.error);
            }
        }else{
            if (successBlock) {
                successBlock([AliynEndPoint stringByAppendingString:put.objectKey]);
            }
        }
        return nil;
    }];
}

@end
