//
//  ZXCollectionCell.h
//  ImageViewTest
//
//  Created by ching on 15/12/25.
//  Copyright © 2015年 杭州中新力合-程朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXCollectionCell;

@protocol ZXCollectionCellDelegate <NSObject>

-(void)moveImageBtnClick:(ZXCollectionCell *)aCell;

@end

@interface ZXCollectionCell : UICollectionViewCell
@property(nonatomic ,strong)UIImageView *imgView;
@property(nonatomic ,strong)UILabel *text;
@property(nonatomic ,strong)UIButton *btn;
@property(nonatomic,strong)UIButton * close;
@property(nonatomic,assign)id<ZXCollectionCellDelegate>delegate;

@end
