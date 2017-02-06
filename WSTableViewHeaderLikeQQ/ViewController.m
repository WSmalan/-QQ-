//
//  ViewController.m
//  WSTableViewHeaderLikeQQ
//
//  Created by SongLan on 2017/2/6.
//  Copyright © 2017年 SongLan. All rights reserved.
//

#import "ViewController.h"
#import "WSModel.h"
#define kScreenSize [UIScreen mainScreen].bounds.size

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //数据源数组
    NSMutableArray *_dataArr;
    //记录每个分区 的展开状态 0表示关闭 1表示展开状态
    int _sectionStatus[26];//默认:关闭
}
//表格
@property (nonatomic,retain) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self dataInit];
    [self creatTableView];

}
#pragma mark - 创建表格
- (void)creatTableView {
    //取消导航条影响
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, kScreenSize.width, kScreenSize.height-20) style:UITableViewStylePlain];
    //设置代理和数据源
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
#pragma mark - 数据
- (void)dataInit {
    _dataArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 26; i++) {
        //一维数组
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSInteger j = 0; j < 10 ; j++) {
            //每个内容都有model填充
            WSModel *model = [[WSModel alloc] init];
            model.name = [NSString stringWithFormat:@"%C%@",(unichar)('A'+i),@"吴松"];
            model.QQNumber = @"qq: 3145419760";
            model.sex = @"男";
            //把模型对象放入数组中
            [arr addObject:model];
        }
        //把一维数组放入数据源
        [_dataArr addObject:arr];
    }
}
#pragma mark - UITableView协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_sectionStatus[section]) { //1表示展开 0表示收起
        //表示展开
        return [_dataArr[section] count];
    }else{
        return 0;//0行
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"WSCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    //获取 数据源中数据模型对象
    WSModel *model = _dataArr[indexPath.section][indexPath.row];
    
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.QQNumber;
    return cell;
}
#pragma mark - 分区索引
//协议方法
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.tableView != tableView) {
        return nil;
    }
    
    NSMutableArray * titleArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 26; i++) {
        //设置26个分区的索引
        [titleArr addObject:[NSString stringWithFormat:@"%C",(unichar)('A'+i)]];
    }
    [titleArr addObject:@"#"];
    //返回一个数组
    return titleArr;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    //选中右侧索引之后 返回 指定分区的索引值
    NSLog(@"index:%ld title:%@",index,title);
    return index;
}
#pragma mark 分区的头视图
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.tableView != tableView) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 40)];
    view.backgroundColor = [UIColor lightGrayColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, view.bounds.size.width, 30);
    button.tag = 101+section;
    button.backgroundColor = [UIColor yellowColor];
    if (_sectionStatus[section] != 0) {
        [button setTitle:[NSString stringWithFormat:@"%C_%@",(unichar)('A'+section),@"展开中"] forState:UIControlStateNormal];
    }else{
        [button setTitle:[NSString stringWithFormat:@"%C_%@",(unichar)('A'+section),@"关闭中"] forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    return view;
}
- (void)btnClick:(UIButton *)button {
    NSInteger section = button.tag - 101;
    //跟原来状态 取反
    _sectionStatus[section] = !_sectionStatus[section];
    //只刷新指定分区
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}
//设置分区的高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
