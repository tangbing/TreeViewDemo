//
//  ViewController.m
//  tableView折叠Demo
//
//  Created by Tb on 2018/6/21.
//  Copyright © 2018年 Tb. All rights reserved.
//

#define SCREEN_WIDTH       ([UIScreen mainScreen].bounds.size.width)

#import "ViewController.h"
#import "ContactModel.h"
#import "ContactCell.h"
#import <RATreeView/RATreeView.h>
#import "NSObject+YYModel.h"


@interface ViewController ()<RATreeViewDataSource,RATreeViewDelegate>

@property (nonatomic,strong) RATreeView *raTreeView;
@property (nonatomic,strong) NSMutableArray *modelArray;//存储model的数组
@end

@implementation ViewController

static NSString * const DefaultCellIdentifier = @"DefaultCellIdentifier";
static NSString * const UserCellIdentifier = @"UserCellIdentifier";

//懒加载
- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self text];
    
    //创建raTreeView
    self.raTreeView = [[RATreeView alloc] initWithFrame:self.view.frame];
    
    //设置代理
    self.raTreeView.delegate = self;
    self.raTreeView.dataSource = self;
    [self.view addSubview:self.raTreeView];
    
    //注册单元格
    [self.raTreeView registerClass:[UITableViewCell class] forCellReuseIdentifier:DefaultCellIdentifier];
    
    [self.raTreeView registerClass:[ContactCell class] forCellReuseIdentifier:UserCellIdentifier];

}

#pragma mark - 网格数据请求
// 读取本地JSON文件
- (NSDictionary *)readLocalFileWithName {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"adressBook.json" ofType:nil];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (void)text{
    NSDictionary *responseObj = [self readLocalFileWithName];
    NSDictionary * contactDict = [responseObj objectForKey:@"b"];
    NSArray *departmentArray = [contactDict objectForKey:@"data"];
    
    for (NSDictionary *goverment in departmentArray) {
        ContactModel *contact = [ContactModel modelWithJSON:goverment];
        contact.isOpen = YES;
        [self.modelArray addObject:contact];
    }
}
#pragma mark -----------dataSource
//返回cell
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
    NSInteger level = [treeView levelForCellForItem:item];
    NSLog(@"cellForItem: level:%zd,item:%@",level,item);
    
    if (level == 0) {// 公司层
        UITableViewCell *cell = [treeView dequeueReusableCellWithIdentifier:DefaultCellIdentifier];
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UIImageView * clickImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 8 , 18.5 , 16 , 13)];
        clickImageView.contentMode = UIViewContentModeScaleAspectFit;
        clickImageView.image = [UIImage imageNamed:@"side_triang_right"];
        clickImageView.tag = 200;
        [cell.contentView addSubview:clickImageView];

        ContactModel *model = item;
        cell.textLabel.text = model.name;
        return cell;
        
    } else if (level == 1) {// 公司下的部门层
        UITableViewCell *cell = [treeView dequeueReusableCellWithIdentifier:DefaultCellIdentifier];
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

        UIImageView * clickImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 8 , 18.5 , 16 , 13)];
        clickImageView.contentMode = UIViewContentModeScaleAspectFit;
        clickImageView.image = [UIImage imageNamed:@"side_triang_right"];
        clickImageView.tag = 300;
        [cell.contentView addSubview:clickImageView];

        Offices *office = item;
        cell.textLabel.text = [NSString stringWithFormat:@"   %@(%zd)",office.name,office.personNO];
        return cell;
    }else if (level == 2) {// 员工层
        ContactCell *cell = [treeView dequeueReusableCellWithIdentifier:UserCellIdentifier];
        Staffs *staff = item;
        cell.staffModel = staff;
        return cell;
    }
    return nil;
}

/**
 *  必须实现
 *
 *  @param treeView treeView
 *  @param item    节点对应的item
 *
 *  @return  每一节点对应的个数
 */

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return self.modelArray.count;
    }

    NSInteger level = [treeView levelForCellForItem:item];
    
    NSLog(@"numberOfChildrenOfItem: level:%zd,item:%@",level,item);
     NSInteger number = 0;
    if ([item isKindOfClass:[ContactModel class]]) {
        ContactModel *model = item;
        number = model.offices.count;
    } else if ([item isKindOfClass:[Offices class]]){
        Offices *model = item;
        number = model.staff.count;
    }
    return number;
}
/**
 *必须实现的dataSource方法
 *
 *  @param treeView treeView
 *  @param index    子节点的索引
 *  @param item     子节点索引对应的item
 *
 *  @return 返回 节点对应的item
 */
- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item {
    
    NSLog(@"treeView: index:%zd,item:%@",index,item);
    if (item == nil) {
        return self.modelArray[index];;
    }
    
    if ([item isKindOfClass:[ContactModel class]]) {
        ContactModel *contact = item;
        return contact.offices[index];
    } else if([item isKindOfClass:[Offices class]]){
        Offices *office = item;
        return office.staff[index];
    }
    return nil;
}


//cell的点击方法
- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
    
    //获取当前的层
    NSInteger level = [treeView levelForCellForItem:item];
    NSLog(@"didSelectRowForItem: level:%zd,item:%@",level,item);

    //NSLog(@"%zd",level);
    //当前点击的model
    if(level == 2){
        Staffs *model = item;
        NSLog(@"点击的是第%ld层,name=%@",level,model.name);
    }
}

//单元格是否可以编辑 默认是YES
- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item {
    
    return NO;
}

//编辑要实现的方法
- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item {
    
    NSLog(@"编辑了实现的方法");
    
    
}

#pragma mark - delegate
//返回行高
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item {
    return 50;
}
//将要展开
- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item {
    
    if ([item isKindOfClass:[ContactModel class]] || [item isKindOfClass:[Offices class]]) {
        UITableViewCell *cell = (UITableViewCell *)[treeView cellForItem:item];
        NSLog(@"subviews:%@",cell.contentView);
        UIImageView *clickImageView = nil;
        for (UIView * view in cell.contentView.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                clickImageView = (UIImageView *)view;
                NSLog(@"clickImageView:%@",clickImageView);
                break;
            }
         }
        [UIView animateWithDuration:0.25 animations:^{
            clickImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
    }
    
}
//将要收缩
- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item {
    if ([item isKindOfClass:[ContactModel class]] || [item isKindOfClass:[Offices class]]) {
        UITableViewCell *cell = (UITableViewCell *)[treeView cellForItem:item];
        UIImageView *clickImageView = nil;
        for (UIView * view in cell.contentView.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                clickImageView = (UIImageView *)view;
                break;
            }
        }
        [UIView animateWithDuration:0.25 animations:^{
            clickImageView.transform = CGAffineTransformIdentity;
        }];
    }

}

//已经展开
- (void)treeView:(RATreeView *)treeView didExpandRowForItem:(id)item {
    
    
    NSLog(@"已经展开了");
}
//已经收缩
- (void)treeView:(RATreeView *)treeView didCollapseRowForItem:(id)item {
    
    NSLog(@"已经收缩了");
}



@end
