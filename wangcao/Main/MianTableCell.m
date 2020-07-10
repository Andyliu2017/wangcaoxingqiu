//
//  MianTableCell.m
//  wangcao
//
//  Created by EDZ on 2020/5/7.
//  Copyright © 2020 andy. All rights reserved.
//

#import "MianTableCell.h"
#import <AVFoundation/AVFoundation.h>

@interface MianTableCell()

@property (nonatomic,strong) DynastyBuildModel *dyModel;
@property (nonatomic,assign) NSInteger dyIndex;

@property (nonatomic,strong) UIImageView *goldIcon;
@property (nonatomic,assign) BOOL isUnlock;  //升级按钮是否已解锁

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;

@end

@implementation MianTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCellUI];
        self.audioPlayer = [Tools loadMusic:@"click"];
    }
    return self;
}

- (void)createCellUI{
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *bgimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sy_jianzhuBg"]];
    bgimage.userInteractionEnabled = YES;
    [self addSubview:bgimage];
    [bgimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self);
        make.height.mas_equalTo(ANDY_Adapta(134));
    }];
    UIImageView *headBg = [[UIImageView alloc] init];
    headBg.backgroundColor = RGBA(195, 207, 242, 1);
    headBg.layer.cornerRadius = ANDY_Adapta(47);
    headBg.layer.masksToBounds = YES;
    [self addSubview:headBg];
    [headBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(49));
        make.centerY.mas_equalTo(bgimage);
        make.width.and.height.mas_equalTo(ANDY_Adapta(94));
    }];
    //建筑图标
    self.dynastyImg = [[UIImageView alloc] init];
    [self addSubview:self.dynastyImg];
    [self.dynastyImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.mas_equalTo(headBg);
        make.width.and.height.mas_equalTo(ANDY_Adapta(82));
    }];
    UIImageView *personBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sy_personBg"]];
    [bgimage addSubview:personBg];
    [personBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(23));
        make.left.mas_equalTo(headBg.mas_right).offset(ANDY_Adapta(44));
        make.width.mas_equalTo(ANDY_Adapta(324));
        make.height.mas_equalTo(ANDY_Adapta(34));
    }];
    //建筑名称
    self.dynastyNameLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(14) textColor:RGBA(49, 38, 102, 1) text:@"" Radius:0];
    [personBg addSubview:self.dynastyNameLabel];
    [self.dynastyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(17));
        make.top.and.bottom.and.right.mas_equalTo(personBg);
    }];
    //升级进度
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.layer.cornerRadius = ANDY_Adapta(4);
    self.progressView.layer.masksToBounds = YES;
    //已过进度条颜色
    self.progressView.progressTintColor = RGBA(84, 163, 88, 1);
    //未过
    self.progressView.trackTintColor = RGBA(52, 39, 103, 1);
    [self addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(personBg.mas_left).offset(ANDY_Adapta(18));
        make.top.mas_equalTo(personBg.mas_bottom).inset(ANDY_Adapta(6));
        make.width.mas_equalTo(ANDY_Adapta(267));
        make.height.mas_equalTo(ANDY_Adapta(8));
    }];
    //下一次消耗金币
    self.nextGoldLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:Font_(12) textColor:RGBA(49, 38, 102, 1) text:@"" Radius:0];
    [self addSubview:self.nextGoldLabel];
    [self.nextGoldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(personBg.mas_left).offset(ANDY_Adapta(16));
        make.top.mas_equalTo(self.progressView.mas_bottom).inset(ANDY_Adapta(12));
        make.height.mas_equalTo(ANDY_Adapta(25));
        make.right.mas_equalTo(personBg.mas_right);
    }];
    //升级 解锁
    self.unlockImg = [[UIImageView alloc] init];
    self.unlockImg.userInteractionEnabled = YES;
    [bgimage addSubview:self.unlockImg];
    [self.unlockImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(23));
        make.left.mas_equalTo(personBg.mas_right).offset(ANDY_Adapta(25));
        make.width.mas_equalTo(ANDY_Adapta(174));
        make.height.mas_equalTo(ANDY_Adapta(80));
    }];
    self.unlockLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(16) textColor:[UIColor whiteColor] text:@"" Radius:0];
    [self.unlockImg addSubview:self.unlockLabel];
    [self.unlockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(self.unlockImg);
        make.height.mas_equalTo(ANDY_Adapta(50));
    }];
    UIImageView *goldimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sy_jinbi"]];
    [self.unlockImg addSubview:goldimg];
    [goldimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(44));
        make.top.mas_equalTo(self.unlockLabel.mas_bottom);
        make.width.and.height.mas_equalTo(ANDY_Adapta(24));
    }];
    self.goldIcon = goldimg;
    
    self.needGoldLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(12) textColor:RGBA(182, 72, 28, 1) text:@"" Radius:0];
    [self.unlockImg addSubview:self.needGoldLabel];
    [self.needGoldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(goldimg.mas_right).inset(ANDY_Adapta(7));
        make.top.and.height.mas_equalTo(goldimg);
        make.right.mas_equalTo(self.unlockImg.mas_right);
    }];
    
    self.unlockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.unlockBtn addTarget:self action:@selector(shengjiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.unlockImg addSubview:self.unlockBtn];
    [self.unlockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self.unlockImg);
    }];
}
- (void)setData:(DynastyBuildModel *)model index:(NSInteger)dynum{
    self.dyModel = model;
    self.dyIndex = dynum;
    [self.dynastyImg setImageURL:[NSURL URLWithString:model.backgroundImg]];
    self.dynastyNameLabel.text = [NSString stringWithFormat:@"%@  %ld",model.name,model.buyNumber];
    self.nextGoldLabel.text = [NSString stringWithFormat:@"下一次消耗金币%@",[GGUI goldConversion:[NSString stringWithFormat:@"%ld",model.nextBuyGold]]];
    self.needGoldLabel.text = [GGUI goldConversion:[NSString stringWithFormat:@"%ld",model.nextBuyGold]];
    self.progressView.progress = model.buyNumber / (CGFloat)model.maxNumber;
    if (model.buyNumber == model.maxNumber) {
        [self.unlockBtn setTitle:@"已满级" forState:UIControlStateNormal];
        self.unlockBtn.titleLabel.font = FontBold_(18);
        [self.unlockBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.unlockLabel.hidden = YES;
        self.needGoldLabel.hidden = YES;
        self.unlockImg.image = [UIImage imageNamed:@"sy_upgrade"];
        self.goldIcon.hidden = YES;
    }else{
        NSLog(@"model.name:%@",model.name);
        self.unlockLabel.hidden = NO;
        self.needGoldLabel.hidden = NO;
        self.goldIcon.hidden = NO;
        [self.unlockBtn setTitle:@"" forState:UIControlStateNormal];
        if (model.unlock) {
            self.unlockImg.image = [UIImage imageNamed:@"sy_upgrade"];
            self.unlockLabel.text = @"升级";
            self.needGoldLabel.textColor = RGBA(153, 58, 20, 1);
        }else{
            self.unlockImg.image = [UIImage imageNamed:@"sy_unlock"];
            self.unlockLabel.text = @"解锁";
            self.needGoldLabel.textColor = RGBA(100, 83, 181, 1);
        }
    }
}
- (void)shengjiAction{
    if (self.dyModel.unlock && self.dyModel.buyNumber < self.dyModel.maxNumber) {  //已解锁
        [self updateDynasty:self.dyModel];
    }
}
//升级建筑
- (void)updateDynasty:(DynastyBuildModel *)dyModel{
//    if ([self.audioPlayer isPlaying]) {
//        [self.audioPlayer stop];
//    }
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([[def valueForKey:BACKGROUNDMUSIC] isEqualToString:@"1"]) {
        [self.audioPlayer play];
    }
    self.unlockBtn.enabled = NO;
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager updateStructure:dyModel.build_id] subscribeNext:^(DynastyBuildModel *model) {
        self.unlockBtn.enabled = YES;
        self.sjblock(model,self.dyIndex,self.dyModel.nextBuyGold);
        [self setData:model index:self.dyIndex];
    } error:^(NSError * _Nullable error) {
        NSLog(@"error:%@",error);
        self.unlockBtn.enabled = YES;
        //金币不足
        if ([error.userInfo[@"code"] isEqualToString:@"AC041"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GOLDNOTENOUGH object:self userInfo:nil];
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
