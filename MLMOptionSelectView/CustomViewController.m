//
//  CustomViewController.m
//  MLMOptionSelectView
//
//  Created by my on 16/10/12.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "CustomViewController.h"
#import "MLMOptionSelectView.h"
#import "UIView+Category.h"
#import "CustomCell.h"

@interface CustomViewController ()
{
    NSMutableArray *listArray;
    
    
    UILabel *leftRightView;
    UILabel *topBottomView;
    
    UILabel *centerShowView;
    UILabel *vhBottomView;
}

@property (nonatomic, strong) MLMOptionSelectView *cellView;

@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    listArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 7; i++) {
        [listArray addObject:[NSString stringWithFormat:@"%@",@(i)]];
    }
    _cellView = [[MLMOptionSelectView alloc] initOptionView];
    _cellView.shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    _cellView.shadowView.layer.shadowColor = [[UIColor redColor] colorWithAlphaComponent:0.4].CGColor;
    _cellView.shadowView.layer.shadowOpacity = 1.0;
    _cellView.shadowView.layer.shadowRadius = 10;
    
    [self leftRight];
    [self topBottom];
    [self vhBottom];
    [self centerShow];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"展开" style:UIBarButtonItemStylePlain target:self action:@selector(showView)];
}


- (void)showView {
    [self defaultCell];
    _cellView.vhShow = NO;
    _cellView.optionType = MLMOptionSelectViewTypeArrow;
    _cellView.edgeInsets = UIEdgeInsetsMake(65, 10, 10, 10);
    [_cellView showTapPoint:CGPointMake(SCREEN_WIDTH -35, 64 + 1) viewWidth:200 direction:MLMOptionSelectViewBottom];
}


#pragma mark - 中心弹出
- (void)centerShow {
    centerShowView = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 200, 80, 200, 40)];
    centerShowView.text = @"中心弹出";
    centerShowView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:centerShowView];
    
    
    [centerShowView tapHandle:^{
        [self customCell];
        _cellView.vhShow = NO;
        _cellView.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [_cellView showViewCenter:self.view.center viewWidth:300];
    }];
}


#pragma mark - 左右
- (void)leftRight {
    leftRightView = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 40, 100)];
    leftRightView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:leftRightView];
    UIPanGestureRecognizer *pan1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLRView:)];
    [leftRightView addGestureRecognizer:pan1];
    
    [leftRightView tapHandle:^{
        [self customCell];
        _cellView.vhShow = NO;
        _cellView.optionType = MLMOptionSelectViewTypeArrow;
        _cellView.selectedOption = nil;

#warning ---- 想保持无论何种情况都上、下对齐,可以选择自己想要对齐的边，重新设置edgeInset
        CGRect rect = [MLMOptionSelectView targetView:leftRightView];
        _cellView.edgeInsets = UIEdgeInsetsMake(rect.origin.y, 10, SCREEN_HEIGHT - rect.origin.y - rect.size.height, 10);
        
        [_cellView showOffSetScale:.5 viewWidth:300 targetView:leftRightView direction:MLMOptionSelectViewRight];
    }];
}


#pragma mark - 缩放上下
- (void)topBottom {
    topBottomView = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 200, 40)];
    topBottomView.text = @"缩放上下";
    topBottomView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:topBottomView];
    UIPanGestureRecognizer *pan2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLRView:)];
    [topBottomView addGestureRecognizer:pan2];


    [topBottomView tapHandle:^{
        [self defaultCell];
        _cellView.vhShow = NO;
        _cellView.optionType = MLMOptionSelectViewTypeArrow;
#warning ---- 想保持无论何种情况都左、右对齐,可以选择自己想要对齐的边，重新设置edgeInset
        CGRect rect = [MLMOptionSelectView targetView:topBottomView];
        _cellView.edgeInsets = UIEdgeInsetsMake(10, rect.origin.x, 10, SCREEN_WIDTH - rect.origin.x - rect.size.width);

        [_cellView showOffSetScale:0.5 viewWidth:200 targetView:topBottomView direction:MLMOptionSelectViewBottom];
    }];
}


#pragma mark - 竖直上下
- (void)vhBottom {
    vhBottomView = [[UILabel alloc] initWithFrame:CGRectMake(0, 280, 200, 40)];
    vhBottomView.text = @"竖直上下";
    vhBottomView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:vhBottomView];
    UIPanGestureRecognizer *pan2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLRView:)];
    [vhBottomView addGestureRecognizer:pan2];
    [vhBottomView tapHandle:^{
        [self defaultCell];
        _cellView.vhShow = YES;
        _cellView.optionType = MLMOptionSelectViewTypeCustom;
        _cellView.edgeInsets = UIEdgeInsetsZero;
        [_cellView showOffSetScale:.5 viewWidth:200 targetView:vhBottomView direction:MLMOptionSelectViewBottom];
    }];
}


#pragma mark - 设置——cell
- (void)customCell {
    WEAK(weaklistArray, listArray);
    WEAK(weakSelf, self);
    _cellView.canEdit = YES;
    [_cellView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    _cellView.cell = ^(NSIndexPath *indexPath){
        CustomCell *cell = [weakSelf.cellView dequeueReusableCellWithIdentifier:@"CustomCell"];
        cell.label1.text = weaklistArray[indexPath.row];
        return cell;
    };
    _cellView.optionCellHeight = ^{
        return 60.f;
    };
    _cellView.rowNumber = ^(){
        return (NSInteger)weaklistArray.count;
    };
    _cellView.removeOption = ^(NSIndexPath *indexPath){
        [weaklistArray removeObjectAtIndex:indexPath.row];
        if (weaklistArray.count == 0) {
            [weakSelf.cellView dismiss];
        }
    };
}

- (void)defaultCell {
    WEAK(weaklistArray, listArray);
    WEAK(weakSelf, self);
    _cellView.canEdit = NO;
    [_cellView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultCell"];
    _cellView.cell = ^(NSIndexPath *indexPath){
        UITableViewCell *cell = [weakSelf.cellView dequeueReusableCellWithIdentifier:@"DefaultCell"];
        cell.textLabel.text = [NSString stringWithFormat:@"DefaultCell：%@",weaklistArray[indexPath.row]];
        return cell;
    };
    _cellView.optionCellHeight = ^{
        return 40.f;
    };
    _cellView.rowNumber = ^(){
        return (NSInteger)weaklistArray.count;
    };
}


- (void)moveLRView:(UIGestureRecognizer *)ges {
    if (ges.state != UIGestureRecognizerStateEnded && ges.state != UIGestureRecognizerStateFailed){
        //通过使用 locationInView 这个方法,来获取到手势的坐标
        CGPoint location = [ges locationInView:ges.view.superview];
        ges.view.center = location;
    }
}

@end
