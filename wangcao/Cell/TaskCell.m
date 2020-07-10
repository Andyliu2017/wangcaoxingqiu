//
//  TaskCell.m
//  wangcao
//
//  Created by EDZ on 2020/5/16.
//  Copyright © 2020 andy. All rights reserved.
//

#import "TaskCell.h"

@interface TaskCell()

@property (nonatomic,strong) TaskDetailModel *taskModel;

@end

@interface TaskCell()

@property (nonatomic,strong) UIImageView *iconImg; //图标
@property (nonatomic,strong) UILabel *titleLabel;  //标题
@property (nonatomic,strong) UILabel *descLabel;   //详情
@property (nonatomic,strong) UIImageView *coinImg; //金币图标
@property (nonatomic,strong) UILabel *goldLabel;   //金币
@property (nonatomic,strong) UIButton *taskBtn;    //任务按钮

@end

@implementation TaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self cellUI];
    }
    return self;
}

- (void)cellUI{
    self.iconImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"task_icon"]];
    [self addSubview:self.iconImg];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.centerY.mas_equalTo(0);
        make.width.and.height.mas_equalTo(ANDY_Adapta(74));
    }];
    self.descLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(12) textColor:MessageColor text:@"赚取更多金币，上不封顶。" Radius:0];
    [self addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImg.mas_right).offset(ANDY_Adapta(27));
        make.bottom.mas_equalTo(self.iconImg.mas_bottom);
        make.height.mas_equalTo(ANDY_Adapta(30));
        make.width.mas_equalTo(ANDY_Adapta(400));
    }];
    self.titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(14) textColor:TitleColor text:@"" Radius:0];
    [self addSubview:self.titleLabel];
    
    self.coinImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"task_coin"]];
    [self addSubview:self.coinImg];
    
    self.goldLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(12) textColor:MoneyColor text:@"" Radius:0];
    [self addSubview:self.goldLabel];
    
    self.taskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.taskBtn setBackgroundColor:RGBA(254, 172, 56, 1)];
    [self.taskBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.taskBtn.titleLabel.font = Font_(12);
    self.taskBtn.layer.cornerRadius = ANDY_Adapta(27);
    self.taskBtn.layer.masksToBounds = YES;
    [self.taskBtn addTarget:self action:@selector(taskAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.taskBtn];
    [self.taskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-ANDY_Adapta(30));
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(ANDY_Adapta(173));
        make.height.mas_equalTo(ANDY_Adapta(54));
    }];
    
    UIImageView *lineImg = [[UIImageView alloc] init];
    lineImg.backgroundColor = LineColor;
    [self addSubview:lineImg];
    [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.centerX.mas_equalTo(self);
        make.width.mas_equalTo(ANDY_Adapta(690));
        make.height.mas_equalTo(ANDY_Adapta(2));
    }];
}
- (void)setData:(TaskDetailModel *)model{
    [self.iconImg setImageWithURL:[NSURL URLWithString:model.taskIcon] placeholder:[UIImage imageNamed:@"task_icon"]];
    self.taskModel = model;
    self.descLabel.text = model.taskDesc;
    self.titleLabel.text = model.taskTitle;
    self.goldLabel.text = [NSString stringWithFormat:@"+%ld",model.reward];
    NSString *taskBtnName = @"";
    if (model.status == 0) {  //可以做
        self.taskBtn.enabled = YES;
        if (model.conditionNumber == 1) {  //任务条件次数
            taskBtnName = @"去玩";
        }else{
            taskBtnName = [NSString stringWithFormat:@"去玩(%ld/%ld)",model.processNumber,model.conditionNumber];
        }
    }else if (model.status == 1){  //已完成
        self.taskBtn.enabled = NO;
        taskBtnName = @"已完成";
    }else{  //不能做
        self.taskBtn.enabled = NO;
        taskBtnName = @"不能做";
    }
    [self.taskBtn setTitle:taskBtnName forState:UIControlStateNormal];
    CGSize size = [model.taskTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, ANDY_Adapta(30)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FontBold_(14)} context:nil].size;
    NSLog(@"size.width::%f",size.width);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.descLabel.mas_left);
        make.top.mas_equalTo(self.iconImg.mas_top);
        make.height.mas_equalTo(ANDY_Adapta(30));
        make.width.mas_equalTo(size.width+10);
    }];
    [self.coinImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(ANDY_Adapta(22));
        make.centerY.mas_equalTo(self.titleLabel);
        make.width.and.height.mas_equalTo(ANDY_Adapta(29));
    }];
    [self.goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.coinImg.mas_right).offset(ANDY_Adapta(9));
        make.right.mas_equalTo(self.taskBtn.mas_left);
        make.top.and.height.mas_equalTo(self.titleLabel);
    }];
}

- (void)taskAction{
    self.taskblock(self.taskModel);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
