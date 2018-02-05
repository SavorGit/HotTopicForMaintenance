//
//  RepairHeaderTableCell.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepairContentModel.h"
#import "RDTextView.h"

@protocol RepairHeaderTableDelegate<NSObject>

- (void)addNPress;
- (void)reduceNPress;
- (void)hotelPress:(NSIndexPath *)index;
- (void)Segmented:(NSInteger )segTag;

@end

@interface RepairHeaderTableCell : UITableViewCell

@property (nonatomic, weak) id <RepairHeaderTableDelegate> delegate;

@property (nonatomic, strong) UIButton *hotelBtn;
@property (nonatomic, strong) UITextField *inPutTextField;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic,strong)  RDTextView *remarkTextView;

- (void)configWithContent:(RepairContentModel *)model andPNum:(NSString *)numStr andIdexPath:(NSIndexPath *)index;

@end
