//
//  PKBattleController.m
//  wangcao
//
//  Created by EDZ on 2020/5/20.
//  Copyright © 2020 andy. All rights reserved.
//

#import "PKBattleController.h"
#import "PKOptionModel.h"
#import <AVFoundation/AVFoundation.h>

#define CorrectColor RGBA(56, 189, 74, 1)
#define ErrorColor RGBA(226, 55, 55, 1)
#define NormalColor RGBA(82, 50, 130, 1)

@interface PKBattleController ()<OtherPopViewDelegate,AdHandleManagerDelegate>

@property (nonatomic,strong) UIImageView *headImg;  //头像
@property (nonatomic,strong) UILabel *fhCardLabel;  //复活卡数量
@property (nonatomic,strong) UILabel *nickNameLabel;   //昵称
@property (nonatomic,assign) NSInteger countDownNum;   //倒计时
@property (nonatomic,strong) UILabel *countDownLabel;  //倒计时
@property (nonatomic,strong) UIProgressView *countDownProgress;  //倒计时
@property (nonatomic,strong) RedButton *leftBtn;
@property (nonatomic,strong) RedButton *rightBtn;
@property (nonatomic,strong) UILabel *descLabel;   //题目描述
@property (nonatomic,strong) NSMutableArray *subjectArr;   //题目数组
@property (nonatomic,strong) PKSubjectModel *subjectModel;  //作答的题目
@property (nonatomic,assign) NSInteger answerNum;   //当前答题数
@property (nonatomic,strong) UILabel *currentAnswerLabel;  //当前答到多少题
@property (nonatomic,strong) dispatch_source_t timer;
@property (nonatomic,strong) OtherPopView *anView;   //答错弹窗
@property (nonatomic,strong) OtherPopView *determineView;   //确定弹窗

@property (nonatomic,strong) AVAudioPlayer *correctPlayer;   //答对
@property (nonatomic,strong) AVAudioPlayer *errorPlayer;    //答错
@property (nonatomic,assign) BOOL isplay;

@end

@implementation PKBattleController

- (NSMutableArray *)subjectArr{
    if (!_subjectArr) {
        _subjectArr = [NSMutableArray array];
    }
    return _subjectArr;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_bg"]];
    bgImg.userInteractionEnabled = YES;
    [self.view addSubview:bgImg];
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self.view);
    }];
    self.answerNum = 0;
    self.countDownNum = [PBCache shared].maxCountDown;
    [self createUI];
    [self getData];
    [self setData];
    self.correctPlayer = [Tools loadMusic:@"right_music"];
    self.errorPlayer = [Tools loadMusic:@"error_music"];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([[def valueForKey:BACKGROUNDMUSIC] isEqualToString:@"1"]) {
        self.isplay = YES;
    }else{
        self.isplay = NO;
    }
}
#pragma mark 界面
- (void)createUI{
    self.headImg = [[UIImageView alloc] init];
    self.headImg.backgroundColor = GrayColor;
    self.headImg.layer.cornerRadius = ANDY_Adapta(48);
    self.headImg.layer.masksToBounds = YES;
    [self.view addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(30));
        make.top.mas_equalTo(ANDY_Adapta(80));
        make.width.and.height.mas_equalTo(ANDY_Adapta(96));
    }];
    
    self.nickNameLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentLeft font:FontBold_(14) textColor:[UIColor whiteColor] text:@"" Radius:0];
    [self.view addSubview:self.nickNameLabel];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImg.mas_right).offset(ANDY_Adapta(15));
        make.top.mas_equalTo(self.headImg.mas_top);
        make.height.mas_equalTo(ANDY_Adapta(41));
    }];
    
    UIView *fhCardView = [GGUI ui_view:CGRectZero backgroundColor:RGBA(28, 15, 95, 1) alpha:1.0 cornerRadius:ANDY_Adapta(21) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:fhCardView];
    [fhCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImg.mas_right).offset(ANDY_Adapta(20));
        make.top.mas_equalTo(self.nickNameLabel.mas_bottom).offset(ANDY_Adapta(4));
        make.width.mas_equalTo(ANDY_Adapta(160));
        make.height.mas_equalTo(ANDY_Adapta(42));
    }];
    UIImageView *cardImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_card"]];
    [self.view addSubview:cardImg];
    [cardImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(fhCardView);
        make.left.mas_equalTo(fhCardView.mas_left).offset(-ANDY_Adapta(7));
        make.width.mas_equalTo(ANDY_Adapta(40));
        make.height.mas_equalTo(ANDY_Adapta(48));
    }];
    UIButton *addCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addCardBtn setImage:[UIImage imageNamed:@"pk_addCard"] forState:UIControlStateNormal];
    [self.view addSubview:addCardBtn];
    [addCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(fhCardView);
        make.right.mas_equalTo(fhCardView.mas_right);
        make.width.and.height.mas_equalTo(ANDY_Adapta(43));
    }];
    self.fhCardLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(14) textColor:[UIColor whiteColor] text:@"" Radius:0];
    [self.view addSubview:self.fhCardLabel];
    [self.fhCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cardImg.mas_right);
        make.right.mas_equalTo(addCardBtn.mas_left);
        make.top.and.bottom.mas_equalTo(fhCardView);
    }];
    
    self.currentAnswerLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(18) textColor:RGBA(100, 83, 181, 1) text:@"" Radius:0];
    [self.view addSubview:self.currentAnswerLabel];
    [self.currentAnswerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headImg);
        make.right.mas_equalTo(self.view.mas_right).offset(-ANDY_Adapta(30));
        make.height.mas_equalTo(ANDY_Adapta(40));
    }];
    
    UIImageView *subjectImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_subject"]];
    [self.view addSubview:subjectImg];
    [subjectImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.currentAnswerLabel);
        make.right.mas_equalTo(self.currentAnswerLabel.mas_left).offset(-ANDY_Adapta(13));
        make.width.and.height.mas_equalTo(ANDY_Adapta(50));
    }];
    
    UIView *blackView = [GGUI ui_view:CGRectZero backgroundColor:BlackBgColor alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:blackView];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(259));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(ANDY_Adapta(667));
        make.height.mas_equalTo(ANDY_Adapta(747));
    }];
    
    UIView *whiteView = [GGUI ui_view:CGRectZero backgroundColor:[UIColor whiteColor] alpha:1.0 cornerRadius:ANDY_Adapta(20) borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ANDY_Adapta(249));
        make.left.and.width.and.height.mas_equalTo(blackView);
    }];
    
    UIImageView *countDownImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_countdown"]];
    [whiteView addSubview:countDownImg];
    [countDownImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(56));
        make.top.mas_equalTo(ANDY_Adapta(40));
        make.width.and.height.mas_equalTo(ANDY_Adapta(86));
    }];
    self.countDownLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:FontBold_(20) textColor:RGBA(153, 58, 20, 1) text:@"" Radius:0];
    [countDownImg addSubview:self.countDownLabel];
    [self.countDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(countDownImg);
    }];
    
    self.countDownProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    //已过进度条颜色
    self.countDownProgress.progressTintColor = RGBA(254, 172, 56, 1);
    //未过
    self.countDownProgress.trackTintColor = RGBA(235, 235, 235, 1);
    self.countDownProgress.progress = 1.0;
    self.countDownProgress.layer.cornerRadius = ANDY_Adapta(10);
    self.countDownProgress.layer.masksToBounds = YES;
    [whiteView addSubview:self.countDownProgress];
    [self.countDownProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(countDownImg.mas_right).offset(-ANDY_Adapta(9));
        make.centerY.mas_equalTo(countDownImg);
        make.width.mas_equalTo(ANDY_Adapta(473));
        make.height.mas_equalTo(ANDY_Adapta(20));
    }];
    
    self.leftBtn = [RedButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.titleLabel.font = FontBold_(20);
    self.leftBtn.titleLabel.numberOfLines = 0;
    self.leftBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.leftBtn addTarget:self action:@selector(answerAction:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(59));
        make.bottom.mas_equalTo(-ANDY_Adapta(59));
        make.width.mas_equalTo(ANDY_Adapta(253));
        make.height.mas_equalTo(ANDY_Adapta(295));
    }];
    
    self.rightBtn = [RedButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.titleLabel.font = FontBold_(20);
    self.rightBtn.titleLabel.numberOfLines = 0;
    self.rightBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.rightBtn addTarget:self action:@selector(answerAction:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(whiteView.mas_right).offset(-ANDY_Adapta(59));
        make.top.and.width.and.height.mas_equalTo(self.leftBtn);
    }];
    
    self.descLabel = [GGUI ui_label:CGRectZero lines:0 align:NSTextAlignmentLeft font:FontBold_(16) textColor:TitleColor text:@"" Radius:0];
    [whiteView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(countDownImg.mas_bottom).offset(ANDY_Adapta(35));
        make.centerX.mas_equalTo(whiteView);
        make.width.mas_equalTo(ANDY_Adapta(530));
    }];
}
#pragma mark 题目数据
- (void)getData{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiPKGetSubject:self.battleType code:[PBCache shared].code limit:10] subscribeNext:^(NSArray *array) {
        NSLog(@"array.count11:%ld",array.count);
        for (int i = 0; i < array.count; i++) {
            PKSubjectModel *model = [PKSubjectModel mj_objectWithKeyValues:array[i]];
            [self.subjectArr addObject:model];
        }
        [self setSubjectData];
    } error:^(NSError * _Nullable error) {
        
    }];
}
- (void)setSubjectData{
    self.answerNum++;
    if (self.answerNum == self.subjectArr.count) {
        //获取后续题目
        [self getData];
        return;
    }
    if (self.subjectArr.count < self.answerNum) {
        self.answerNum--;
        [self getData];
        return;
    }
    PKSubjectModel *model = self.subjectArr[self.answerNum-1];
    self.countDownLabel.text = [NSString stringWithFormat:@"%ld",self.countDownNum];
    self.descLabel.text = model.title;
    PKOptionModel *optionModel1;
    PKOptionModel *optionModel2;
    if (model.options.count == 0) {
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
    }else if (model.options.count == 1){
        self.leftBtn.hidden = NO;
        self.rightBtn.hidden = YES;
        optionModel1 = model.options[0];
    }else{
        self.leftBtn.hidden = NO;
        self.rightBtn.hidden = NO;
        optionModel1 = model.options[0];
        optionModel2 = model.options[1];
    }
    [self.leftBtn setTitle:optionModel1.optionText forState:UIControlStateNormal];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"pk_option_1"] forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:NormalColor forState:UIControlStateNormal];
    self.leftBtn.redId = optionModel1.option_id;
    [self.rightBtn setTitle:optionModel2.optionText forState:UIControlStateNormal];
    self.rightBtn.redId = optionModel2.option_id;
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"pk_option_1"] forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:NormalColor forState:UIControlStateNormal];
    self.subjectModel = model;
    self.currentAnswerLabel.text = [NSString stringWithFormat:@"第%ld题",self.answerNum];
    NSLog(@"ddddddddddddddd");
    //倒计时
    __block NSInteger second = self.countDownNum;
    //全局队列    默认优先级
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //定时器模式  事件源
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    //NSEC_PER_SEC是秒，＊1是每秒
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * 1, 0);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(_timer, ^{
        //回调主线程，在主线程中操作UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second > 0) {
                second--;
                self.countDownLabel.text = [NSString stringWithFormat:@"%ld",second];
                self.countDownProgress.progress = second/(CGFloat)self.countDownNum;
            }else{
                //错误
                dispatch_source_cancel(self->_timer);
                [self getRebirthInfo];
            }
        });
    });
    //启动源
    dispatch_resume(_timer);
}
//答题
- (void)answerAction:(RedButton *)btn{
    self.leftBtn.enabled = NO;
    self.rightBtn.enabled = NO;
    __block PKBattleController *weakSelf = self;
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiPKAnswerWithCode:[PBCache shared].code subjectInvokeId:self.subjectModel.subjectInvokeId optionId:btn.redId battleType:self.battleType] subscribeNext:^(PKAnswerModel *model) {
        if (model.right) {  //回答正确
            if (self.isplay) {
                [self.correctPlayer play];
            }
            [btn setBackgroundImage:[UIImage imageNamed:@"pk_option_3"] forState:UIControlStateNormal];
            [btn setTitleColor:CorrectColor forState:UIControlStateNormal];            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [weakSelf setSubjectData];
            });
        }else{
            if (self.isplay) {
                [self.errorPlayer play];
            }
            [btn setBackgroundImage:[UIImage imageNamed:@"pk_option_2"] forState:UIControlStateNormal];
            [btn setTitleColor:ErrorColor forState:UIControlStateNormal];
            dispatch_source_cancel(weakSelf.timer);
            [weakSelf getRebirthInfo];
        }
        self.leftBtn.enabled = YES;
        self.rightBtn.enabled = YES;
    } error:^(NSError * _Nullable error) {
        self.leftBtn.enabled = YES;
        self.rightBtn.enabled = YES;
    }];
}
//答错获取复活信息
- (void)getRebirthInfo{
    __block PKBattleController *weakSelf = self;
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiPkRebirthInfo:self.battleType] subscribeNext:^(PKRebirthModel *model) {
        weakSelf.anView = [[OtherPopView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        weakSelf.anView.delegate = weakSelf;
        [weakSelf.anView setAnswerErrorUI];
        [weakSelf.anView setAnswerErrorData:self.answerNum-1 fhCardNum:model.rebirthNumber reBirthNum:model.videoAd.remainNum viewType:1 pkrebirthModel:model];
        [weakSelf.anView showPopView:self];
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark OtherPopViewDelegate弹窗代理
//直接退出挑战页面
- (void)confirmIsExit{
    NSLog(@"直接退出");
    [self.correctPlayer pause];
    self.correctPlayer = nil;
    [self.errorPlayer pause];
    self.errorPlayer = nil;
    [self.anView outCloseAction];
    self.anView = nil;
    [self.determineView removeFromSuperview];
    self.determineView = nil;
    _timer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
//确认是否退出
- (void)exitBattleController{
    NSLog(@"确认是否退出");
    self.determineView = [[OtherPopView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.determineView.delegate = self;
    [self.determineView setDetermineExitUI];
    [self.determineView setDetermineExitData:self.answerNum viewType:2];
    [self.determineView showPopView:self];
}
//使用复活卡
- (void)useRebirthCard{
    NSLog(@"使用复活卡");
    [self.anView outCloseAction];
    [self rebirthAction];
}
//看视频复活
- (void)watchVideoRebirth:(PKRebirthModel *)model{
    NSLog(@"看视频复活");
    [self rebirthWatchVideo:model.videoAd];
}
//跳过视频复活
- (void)noVideoRebirth:(PKRebirthModel *)model{
    [self watchVideoSuccess:model.videoAd.videoId withType:7];
}
//用户看视频复活
- (void)rebirthWatchVideo:(VideoModel *)videomodel{
    AdHandleManager *manager = [AdHandleManager sharedManager];
    manager.delegate = self;
    [manager RewardedSlotVideoAdViewRender:videomodel videoType:7 viewController:self];
}
- (void)BUADVideoFinish:(id)rewardedVideoAd withVideoModel:(VideoModel *)model withType:(NSInteger)type{
//    if ([model.advertChannel isEqualToString:BUADVIDEOTYPE]) {
//        BUNativeExpressRewardedVideoAd *rewardedVideoAd = rewardedVideoAd;
//        [self watchVideoSuccess:model.videoId withType:rewardedVideoAd.rewardedVideoModel.rewardAmount];
//    }else if ([model.advertChannel isEqualToString:TENCENTVIDEOTYPE]){
//        [self watchVideoSuccess:model.videoId withType:type];
//    }else if ([model.advertChannel isEqualToString:SIGMOBVIDEOTYPE]){
//        [self watchVideoSuccess:model.videoId withType:type];
//    }
    [self watchVideoSuccess:model.videoId withType:type];
}
- (void)watchVideoSuccess:(NSString *)videoId withType:(NSInteger)type{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager WatchFinish:videoId] subscribeNext:^(id  _Nullable x) {
        if (type == 7) {
            //看广告成功
            [self.anView removeAllSubviews];
            [self.anView outCloseAction];
            //复活成功重新获取题目
//            if (self.subjectArr.count >= 10) {
//                [self.subjectArr removeObjectsInRange:NSMakeRange(self.subjectArr.count-10,10)];
//            }else{
//                self.answerNum--;
//            }
//            [self getData];
            //复活删除错题
            [self.subjectArr removeObjectAtIndex:self.answerNum-1];
            self.answerNum--;
            [self setSubjectData];
        }
    } error:^(NSError * _Nullable error) {
        [self confirmIsExit];
    }];
}
//用户使用复活卡复活
- (void)rebirthAction{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager ApiPKRebirtn:self.battleType] subscribeNext:^(id  _Nullable x) {
        [PBCache shared].fhCardNum = [PBCache shared].fhCardNum - 1;
        self.fhCardLabel.text = [NSString stringWithFormat:@"%ld张",[PBCache shared].fhCardNum];
        [self.anView removeAllSubviews];
        //复活成功重新获取题目
//        if (self.subjectArr.count >= 10) {
//            [self.subjectArr removeObjectsInRange:NSMakeRange(self.subjectArr.count-10,10)];
//        }else{
//            self.answerNum--;
//        }
//        [self getData];
        //复活删除错题
        [self.subjectArr removeObjectAtIndex:self.answerNum-1];
        self.answerNum--;
        [self setSubjectData];
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark 数据处理
- (void)setData{
    [self.headImg setImageWithURL:[NSURL URLWithString:[PBCache shared].userModel.avatar] placeholder:[UIImage imageNamed:@"sy_head"]];
    self.nickNameLabel.text = [PBCache shared].userModel.nickName;
    self.fhCardLabel.text = [NSString stringWithFormat:@"%ld张",[PBCache shared].fhCardNum];
}

@end
