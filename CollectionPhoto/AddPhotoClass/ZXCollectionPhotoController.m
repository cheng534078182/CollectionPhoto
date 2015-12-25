//
//  ZXCollectionPhotoController.m
//  ImageViewTest
//
//  Created by ching on 15/12/25.
//  Copyright © 2015年 杭州中新力合-程朋. All rights reserved.
//
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define StatusBarHeight (IOS7==YES ? 0 : 20)
#define BackHeight      (IOS7==YES ? 0 : 15)
#define fNavBarHeigth (IOS7==YES ? 64 : 44)
#define fDeviceWidth ([UIScreen mainScreen].bounds.size.width)
#define fDeviceHeight ([UIScreen mainScreen].bounds.size.height)

#import "ZXCollectionPhotoController.h"
#import "ZXCollectionCell.h"
@interface ZXCollectionPhotoController ()<ZXCollectionCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property(nonatomic,strong)NSMutableArray * imageArr;

@end

@implementation ZXCollectionPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"主页面";
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightItemAction:)];
    self.navigationItem.rightBarButtonItem = right;
    
    [self loadData];
    [self drawUI];
}

-(void)loadData{
    NSArray * arr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    
    _imageArr = [NSMutableArray array];
    for (int i=1; i<arr.count; i++) {
        NSString * name = [NSString stringWithFormat:@"%d.jpg",i];
        UIImage * img = [UIImage imageNamed:name];
        [_imageArr addObject:img];
    }
}
-(void)drawUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];//不能放init处
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"自定义collectionView";
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, fDeviceWidth, fDeviceHeight) collectionViewLayout:flowLayout];
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //注册cell和ReusableView（相当于头部）
    [self.collectionView registerClass:[ZXCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    
}
-(void)rightItemAction:(UIBarButtonItem *)item{
    
    if (IOS7) {
        UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"相册选取", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [actionSheet showInView:self.view];
    }else{
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //        相机
            UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
            [imgPicker setAllowsEditing:YES];
            [imgPicker setDelegate:self];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:imgPicker animated:YES completion:NULL];
            
        }];
        
        UIAlertAction *archiveAction2 = [UIAlertAction actionWithTitle:@"相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
            [imgPicker setAllowsEditing:YES];
            [imgPicker setDelegate:self];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self presentViewController:imgPicker animated:YES completion:NULL];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:archiveAction];
        [alertController addAction:archiveAction2];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}
#pragma mark UIActionSheet协议
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0)
    {
        //        相机
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        [imgPicker setAllowsEditing:YES];
        [imgPicker setDelegate:self];
        [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:imgPicker animated:YES completion:NULL];
    }
    if (buttonIndex ==1) {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        [imgPicker setAllowsEditing:YES];
        [imgPicker setDelegate:self];
        [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:imgPicker animated:YES completion:NULL];
    }
}

//相机
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    [self.imageArr addObject:image];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.collectionView reloadData];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    return;
}



#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageArr.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    ZXCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    cell.imgView.image = [_imageArr objectAtIndex:indexPath.row];
    //    cell.text.text = [NSString stringWithFormat:@"Cell %ld",indexPath.row];
    cell.delegate = self;
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake((fDeviceWidth-20)/3, (fDeviceWidth-20)/3);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 5, 5);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //        UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //        cell.backgroundColor = [UIColor redColor];
    NSLog(@"选择%ld",indexPath.row);
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)moveImageBtnClick:(ZXCollectionCell *)aCell{
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:aCell];
    NSLog(@"_____%ld",indexPath.row);
    [_imageArr removeObjectAtIndex:indexPath.row];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
