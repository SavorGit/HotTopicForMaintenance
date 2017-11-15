//
//  BaseDetailCell.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/10.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "BaseDetailCell.h"

@interface BaseDetailCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * bigScrollView;
@property (nonatomic, strong) UIImageView * bigImageView;
@property (nonatomic, assign) BOOL isBigPhoto;

@end

@implementation BaseDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self createBaseDetailCell];
    }
    return self;
}

- (void)createBaseDetailCell
{
    self.bigScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bigScrollView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.7f];
    self.bigScrollView.maximumZoomScale = 3.f;
    self.bigScrollView.minimumZoomScale = 1.f;
    self.bigScrollView.showsVerticalScrollIndicator = NO;
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    self.bigScrollView.delegate = self;
    
    self.bigImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bigImageView.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self.bigScrollView action:@selector(removeFromSuperview)];
    tap2.numberOfTapsRequired = 1;
    [self.bigScrollView addGestureRecognizer:tap2];
    [self.bigScrollView addSubview:self.bigImageView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.bigImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView == self.bigScrollView) {
        CGSize superSize = self.bigScrollView.frame.size;
        CGPoint center = CGPointMake(superSize.width / 2, superSize.height / 2);
        CGSize size = self.bigImageView.frame.size;
        if (size.width > superSize.width) {
            center.x = size.width / 2;
        }
        if (size.height > superSize.height) {
            center.y = size.height / 2;
        }
        self.bigImageView.center = center;
    }
}

- (void)showWindowImage:(NSString *)url
{
    if (isEmptyString(url)) {
        return;
    }
    
    self.isBigPhoto = YES;
    self.bigScrollView.zoomScale = 1.f;
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage new] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (image) {
            CGFloat scale = self.bigScrollView.frame.size.width / self.bigScrollView.frame.size.height;
            CGFloat imageScale = image.size.width / image.size.height;
            
            CGRect frame;
            if (imageScale > scale) {
                CGFloat width = self.bigScrollView.frame.size.width;
                CGFloat height = self.bigScrollView.frame.size.width / image.size.width * image.size.height;
                frame = CGRectMake(0, 0, width, height);
            }else{
                CGFloat height = self.bigScrollView.frame.size.height;
                CGFloat width = self.bigScrollView.frame.size.height / image.size.height * image.size.width;
                frame = CGRectMake(0, 0, width, height);
            }
            self.bigImageView.frame = frame;
            self.bigImageView.center = self.bigScrollView.center;
        }
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.bigScrollView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
