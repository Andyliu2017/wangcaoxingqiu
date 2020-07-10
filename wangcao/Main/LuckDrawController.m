//
//  LuckDrawController.m
//  wangcao
//
//  Created by EDZ on 2020/5/9.
//  Copyright © 2020 andy. All rights reserved.
//

#import "LuckDrawController.h"
#import "WXWTimer.h"
#import "DrowPopView.h"

#define top_HEIGHT 135
#define PopViwe_WIDTH 345

@interface LuckDrawController ()<DrowPopViewDelegate,AdHandleManagerDelegate>

//消耗完每天凌晨赠送10张抽奖劵
@property (nonatomic,strong) UILabel *titleLabel;
//抽奖背景
@property (nonatomic,strong) UIImageView *luckBgimg;
@property (nonatomic,strong) UIImageView *luckImg;
//抽奖按钮
@property (nonatomic,strong) UIButton *luckBtn;
//中奖弹窗
@property (nonatomic,strong) DrowPopView *drowPopView;

@property (nonatomic,strong) WinLotteryModel *winModel;
@property (strong, nonatomic) NSMutableArray * btnArray;
@property (strong, nonatomic) UIButton * startBtn;
@property (assign, nonatomic) BOOL isImage;
@property (assign, nonatomic) CGFloat time;
@property (assign, nonatomic) BOOL TimeoutFlag;
//剩余领券次数
@property (assign, nonatomic) NSInteger receivingTicket;
//能否退出  抽奖时不能退出
@property (nonatomic,assign) BOOL isExitViewControll;

@end

@implementation LuckDrawController
{
    NSTimer *imageTimer;
    NSTimer *startTimer;
    
    NSInteger currentTime;
    NSInteger stopTime;
    NSInteger result;
    
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UIButton *btn4;
    UIButton *btn5;
    UIButton *btn6;
    UIButton *btn7;
    UIButton *btn0;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHGOLDCOINS object:self userInfo:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"luck_bg"]];
    [self.view addSubview:bgImg];
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.left.and.right.mas_equalTo(self.view);
    }];
    self.isExitViewControll = YES;
    [self createUI];
    [self getData];
}
- (void)getData{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager fetchLotteryList] subscribeNext:^(LotteryListModel *model) {
        NSMutableArray *muArr = [NSMutableArray array];
        for (int i = 0; i < model.lotteryLists.count; i++) {
            WinContentModel *wModel = model.lotteryLists[i];
            wModel.index = i;
            [muArr addObject:wModel];
        }
        self.localImageArray = muArr;
        self.receivingTicket = model.remainRecevieVoucherNum;
        self.lotteryNumber = model.remainVoucher;
    } error:^(NSError * _Nullable error) {
        
    }];
}
- (void)createUI{
    __block LuckDrawController *weakSelf = self;
    UIButton *backBtn = [GGUI ui_buttonSimple:CGRectZero font:Font_(0) normalColor:[UIColor clearColor] normalText:@"" click:^(id  _Nonnull x) {
        if (self.isExitViewControll) {
            [self->imageTimer invalidate];
            self->imageTimer = nil;
            [self->startTimer invalidate];
            self->startTimer = nil;
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
    [backBtn setImage:[UIImage imageNamed:@"luck_back"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ANDY_Adapta(23));
        make.top.mas_equalTo(spaceHeight(88));
        make.width.and.height.mas_equalTo(ANDY_Adapta(32));
    }];
    UIImageView *titleImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"luck_title"]];
    [self.view addSubview:titleImg];
    [titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(spaceHeight(144));
        make.width.mas_equalTo(ANDY_Adapta(468));
        make.height.mas_equalTo(ANDY_Adapta(84));
    }];
    
    self.titleLabel = [GGUI ui_label:CGRectZero lines:1 align:NSTextAlignmentCenter font:Font_(13) textColor:[UIColor whiteColor] text:@"消耗完每天00:00和12:00 分别各赠送5张抽奖劵" Radius:0];
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleImg.mas_bottom);
        make.left.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(spaceHeight(83));
    }];
    //抽奖区背景
    self.luckBgimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"luck_drawBg"]];
    [self.view addSubview:self.luckBgimg];
    [self.luckBgimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(spaceHeight(10));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(ANDY_Adapta(683));
        make.height.mas_equalTo(ANDY_Adapta(666));
    }];
    self.luckImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"luck_drawimg1"]];
    [self.view addSubview:self.luckImg];
    [self.luckImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.luckBgimg.mas_top).offset(ANDY_Adapta(8));
        make.left.mas_equalTo(self.luckBgimg.mas_left).offset(ANDY_Adapta(63));
        make.width.and.height.mas_equalTo(ANDY_Adapta(549));
    }];
    
    //抽奖按钮
    self.luckBtn = [GGUI ui_buttonSimple:CGRectZero font:FontBold_(16) normalColor:[UIColor whiteColor] normalText:@"" click:^(id  _Nonnull x) {
        [self luckBtnAction];
    }];
    [self.luckBtn setBackgroundImage:[UIImage imageNamed:@"rank_invite"] forState:UIControlStateNormal];
    [self.view addSubview:self.luckBtn];
    [self.luckBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.luckBgimg.mas_bottom).offset(spaceHeight(14));
        make.width.mas_equalTo(ANDY_Adapta(642));
        make.height.mas_equalTo(ANDY_Adapta(110));
    }];
    
    currentTime = 0;
    self.isImage = YES;
    self.time = 0.1;
    _stopCount = 7; //默认为7
//    self.lotteryNumber = 1; //默认次数为1
    self.timeoutInterval = 10;
    stopTime = 8 * (self.timeoutInterval + 2) - 1 + self.stopCount; //默认多转10圈+2圈（10*8-1=79）
    //self.failureMessage = @"网络异常，请连接网络";
    //self.networkStatus = NetworkStatusUnknown; //默认未知网络
    
    imageTimer = [WXWTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(updataImage:) userInfo:nil repeats:YES];
    
}
//背景图切换
- (void)updataImage:(NSTimer *)timer
{
    self.isImage = !self.isImage;
    if (self.isImage == YES) {
        self.luckImg.image = [UIImage imageNamed:@"luck_drawimg1"];
    } else {
        self.luckImg.image = [UIImage imageNamed:@"luck_drawimg2"];
    }
}
- (void)setStopCount:(NSInteger)stopCount {
    _stopCount = stopCount;
    NSInteger turns = currentTime / 8; //圈数
    if(turns > 3) {
        stopTime = turns * 8 - 1 + _stopCount;
    } else { //小于3圈的时候默认三圈
        stopTime = 23 + _stopCount;
    }
    if (stopTime < currentTime) { //以为停止时间计算存在一圈的误差，当停止时间小于当前时间时，多转一圈
        stopTime += 8;
    }
    
    NSLog(@"计算出来的停止时间：%ld, 当前时间：%ld", (long)stopTime, (long)currentTime);
}

- (void)setTimeoutInterval:(NSInteger)timeoutInterval {
    if (_timeoutInterval != timeoutInterval) {
        _timeoutInterval = timeoutInterval;
        stopTime = 8 * (timeoutInterval + 2) - 1 + self.stopCount; //默认多转10圈（10*8-1=79）
    }
}

- (void)setLocalImageArray:(NSMutableArray *)localImageArray
{
    _urlImageArray = nil;
    _localImageArray = localImageArray;
    if (_localImageArray.count) {
        [self initLuckViewSubViews];
    }
}

- (void)setUrlImageArray:(NSMutableArray *)urlImageArray
{
    _localImageArray = nil;
    _urlImageArray = urlImageArray;
    [self initLuckViewSubViews];
}
- (void)setLotteryNumber:(NSInteger)lotteryNumber
{
    if (lotteryNumber == 0) {
        self.startBtn.enabled = NO;
    }else{
        self.startBtn.enabled = YES;
    }
    _lotteryNumber = lotteryNumber;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.receivingTicket == 0 && self.lotteryNumber == 0) {
            [self.luckBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.luckBtn setTitle:@"今日次数已用完" forState:0];
        }else{
            if (self.lotteryNumber == 0) {
//                if ([PBCache shared].memberModel.userType == 2) {
//                    [self.luckBtn setTitle:@"领取抽奖券" forState:0];
//                }else{
                    [self.luckBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, ANDY_Adapta(15))];
                    [self.luckBtn setImage:[UIImage imageNamed:@"pop_videoicon"] forState:UIControlStateNormal];
                    [self.luckBtn setTitle:@"看视频领取抽奖券" forState:0];
//                }
            }else{
                [self.luckBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [self.luckBtn setTitle:F(@" 抽奖券x%ld",(long)self.lotteryNumber) forState:0];
            }
        }
    });
}
- (void)setFailureMessage:(NSString *)failureMessage {
    if (![_failureMessage isEqualToString:failureMessage]) {
        _failureMessage = failureMessage;
    }
}

- (void)initLuckViewSubViews
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[self.luckBgimg subviews] count]) {
            [self.luckBgimg.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
    });
    dispatch_async(dispatch_get_main_queue(), ^{
//        CGFloat topMarge = PopViwe_WIDTH * 3 / 28 + 3; //button距离顶部边距, 2为btn到黑边框距离
        CGFloat topMarge = ANDY_Adapta(54);
//        CGFloat leftMarge = PopViwe_WIDTH / 7 + 2; //button距离左边距, 2为btn到黑边框距离
        CGFloat leftMarge = ANDY_Adapta(107);
//        CGFloat btnSpace = 1.5f; //button之间的距离
        CGFloat btnSpace = ANDY_Adapta(5);
//        CGFloat btnw = (PopViwe_WIDTH  - leftMarge * 2 )/3+4;
        CGFloat btnw = ANDY_Adapta(150);
        CGFloat margeW = 0; // imageView与button的边框宽度
        
        NSArray *prizeImageArr = self.localImageArray ? : self.urlImageArray;
        for (int i = 0; i < prizeImageArr.count + 1; i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(margeW, margeW, margeW, margeW)];
            
//            CGFloat x = leftMarge + btnSpace * (i % 3) + (i % 3) * btnw-28;
//            CGFloat y = topMarge + btnSpace * (i / 3) + (i / 3) * 76;
//            CGFloat width = btnw;
//            CGFloat height = 76;
            CGFloat x = leftMarge + btnSpace * (i % 3) + (i % 3) * btnw;
            CGFloat y = topMarge + btnSpace * (i / 3) + (i / 3) * btnw;
            CGFloat width = btnw;
            CGFloat height = btnw;
            btn.frame = CGRectMake(x, y, width, height);
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [btn setBackgroundImage:[UIImage imageNamed:@"luck_drawBtnBg"] forState:0];
            btn.titleLabel.font = Font_(12);
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.userInteractionEnabled = NO;
            self.luckBgimg.userInteractionEnabled = YES;
            [self.luckBgimg addSubview:btn];
            
            if (i == 4) {
                btn.titleLabel.font = FontBold_(30);
                btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                [btn setTitle:@"GO\n开始抽奖" forState:UIControlStateNormal];
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:btn.titleLabel.text];
                [attString addAttribute:(NSString*)NSForegroundColorAttributeName value:[UIColor whiteColor] range:[btn.titleLabel.text rangeOfString:btn.titleLabel.text]];
                [attString addAttribute:(NSString*)NSForegroundColorAttributeName value:[UIColor whiteColor] range:[btn.titleLabel.text rangeOfString:@"开始抽奖"]];
                [attString addAttribute:(NSString*)NSFontAttributeName value:FontBold_(12) range:[btn.titleLabel.text rangeOfString:@"开始抽奖"]];
                [btn setAttributedTitle:attString forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"luck_goBtn"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                btn.userInteractionEnabled = YES;
                btn.tag = 10;
                self.startBtn = btn;
                
                continue;
            }
            
            btn.tag = i > 4? i -1: i;
            WinContentModel *model = prizeImageArr[i > 4? i -1: i];
            [btn setImageWithURL:[NSURL URLWithString:model.icon] forState:0 placeholder:nil];
//            [btn setImage:[UIImage imageNamed:model.icon] forState:UIControlStateNormal];
//            [btn setTitle:F(@"%@", model.name) forState:0];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0,0, 15,0)];
            UILabel *label = [GGUI ui_label:CGRectMake(0, btn.frame.size.height-28, btn.frame.size.width, 20) lines:1 align:NSTextAlignmentCenter font:Font_(12) textColor:[UIColor whiteColor] text:model.name Radius:0];
            [btn addSubview:label];
            
            switch (i) {
                case 0:
                    self->btn0 = btn;
                    break;
                case 1:
                    self->btn1 = btn;
                    break;
                case 2:
                    self->btn2 = btn;
                    break;
                case 3:
                    self->btn3 = btn;
                    break;
                case 5:
                    self->btn4 = btn;
                    break;
                case 6:
                    self->btn5 = btn;
                    break;
                case 7:
                    self->btn6= btn;
                    break;
                case 8:
                    self->btn7 = btn;
                    break;
                    
                default:
                    
                    break;
            }
            
            [self.btnArray addObject:btn];
        }
        
        [self TradePlacesWithBtn1:self->btn3 btn2:self->btn4];
        [self TradePlacesWithBtn1:self->btn4 btn2:self->btn7];
        [self TradePlacesWithBtn1:self->btn5 btn2:self->btn6];
    });
    
}
- (void)btnClick:(UIButton *)btn
{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager winLottery] subscribeNext:^(WinLotteryModel *model) {
        self.winModel = model;
        NSLog(@"开始抽奖:%@",model);
        if (btn.tag == 10)
        {
            if (self.lotteryNumber > 0)
            {
                self.isExitViewControll = NO;
                self.lotteryNumber = model.remainVoucher;
                [self.luckBtn setTitle:F(@" 抽奖券x%ld",(long)model.remainVoucher) forState:0];
                //有抽奖次数 点击开始抽奖
//                self.stopCount = model.winId-1;
                for (int i = 0; i < self.localImageArray.count; i++) {
                    WinContentModel *wModel = self.localImageArray[i];
                    if (wModel.luck_Id == model.winId) {
                        self.stopCount = wModel.index;
                    }
                }
                NSLog(@"中奖id:%ld,,中奖下标:%ld",model.winId,self.stopCount);
                self->currentTime = self->result;
                self.time = 0.1;
                [self.startBtn setEnabled:NO];
                [self.startBtn setImage:[UIImage imageNamed:@"Luckydraw_btn_no"] forState:UIControlStateNormal];
//                [self setUserInteractionEnabled:NO];
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    self->startTimer = [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(start:) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop] run];
                });
            }
            else
            { //已经无抽奖次数
                
            }

        }
        
    } error:^(NSError * _Nullable error) {
        
        NSDictionary *dic = error.userInfo;
        if (error.code == 500)
        {
            
        }
        [MBProgressHUD showSuccess:dic[NSLocalizedDescriptionKey] toView:self.view afterDelay:2.0];
    }];
}

- (void)start:(NSTimer *)timer
{
    UIButton *oldBtn = [self.btnArray objectAtIndex:currentTime % self.btnArray.count];
    currentTime++;
    UIButton *btn = [self.btnArray objectAtIndex:currentTime % self.btnArray.count];
    dispatch_async(dispatch_get_main_queue(), ^{
//        btn.layer.borderColor = RGB(255, 254, 84).CGColor;
//        btn.layer.borderWidth = 5;
//        btn.layer.cornerRadius = 10;
//        btn.enabled = NO;
//        NSLog(@"%@",btn.currentTitle);
//
//        oldBtn.layer.borderColor = [UIColor clearColor].CGColor;
//        oldBtn.enabled = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"luck_drawBtn"] forState:UIControlStateNormal];
        [oldBtn setBackgroundImage:[UIImage imageNamed:@"luck_drawBtnBg"] forState:UIControlStateNormal];
    });
    
    NSLog(@"当前时间：%ld, 停止时间：%ld", (long)currentTime, (long)stopTime);
    if (currentTime > stopTime)
    { //抽奖结果
        NSLog(@"抽到的位%ld：%ld， stopTime：%ld", (long)self.stopCount, (long)stopTime);
        self.TimeoutFlag = (stopTime == 8 * (self.timeoutInterval + 2) + 8 - 1 + self.stopCount) ? YES : NO; // + 8是因为停止时间有一圈的误差，和上面多转一圈的情况一样
        [timer invalidate];
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self setUserInteractionEnabled:YES];
        });
        result = currentTime%self.btnArray.count;
        [self stopWithCount:currentTime%self.btnArray.count];
        return;
    }
    
    if (currentTime > stopTime - 10) {
        self.time += 0.01 * (currentTime + 10 - stopTime); //动画效果由快变慢
        [timer invalidate];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self->startTimer = [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(start:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] run];
        });
    }
}

- (void)stopWithCount:(NSInteger)count
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isExitViewControll = YES;
        [self.startBtn setEnabled:YES];
        self.drowPopView = [[DrowPopView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.drowPopView.delegate = self;
        [self.drowPopView setDrowPopViewData:self.winModel array:self.localImageArray];
        [self.drowPopView showPopView:self];
    });
}
#pragma mark DrowPopViewDelegate宝箱看视频
- (void)drowPopWatchVideoBack:(WinLotteryModel *)model{
    AdHandleManager *magager = [AdHandleManager sharedManager];
    magager.delegate = self;
    [magager RewardedSlotVideoAdViewRender:model.videoAdVo videoType:3 viewController:self];
}
//抽中宝箱 跳过视频直接加倍
- (void)drowPopNoVideoBack:(WinLotteryModel *)model{
    [self watchVideoFinish:model.videoAdVo.videoId withType:3];
}
- (void)BUADVideoFinish:(id)rewardedVideoAd withVideoModel:(VideoModel *)model withType:(NSInteger)type{
//    if ([model.advertChannel isEqualToString:BUADVIDEOTYPE]) {
//        BUNativeExpressRewardedVideoAd *rewardedVideoAd = rewardedVideoAd;
//        [self watchVideoFinish:model.videoId withType:rewardedVideoAd.rewardedVideoModel.rewardAmount];
//    }else if ([model.advertChannel isEqualToString:TENCENTVIDEOTYPE]){
//        [self watchVideoFinish:model.videoId withType:type];
//    }else if ([model.advertChannel isEqualToString:SIGMOBVIDEOTYPE]){
//        [self watchVideoFinish:model.videoId withType:type];
//    }
    [self watchVideoFinish:model.videoId withType:type];
}
//看完视频回调
- (void)watchVideoFinish:(NSString *)videoId withType:(NSInteger)type{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager WatchFinish:videoId] subscribeNext:^(id  _Nullable x) {
        if (type == 3) {   //宝箱弹窗
            [self.drowPopView closeAction];
        }else if (type == 2){   //看视频领取抽奖券
            [self refreshLotteryNumber];
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark 看视频领取抽奖券
- (void)luckBtnAction{
    if (self.lotteryNumber == 0 && self.receivingTicket > 0) {
        WCApiManager *manager = [WCApiManager sharedManager];
        [[manager receiveVoucher] subscribeNext:^(VideoModel *model) {
            if (model.remainNum == 0) {
                [MBProgressHUD showText:@"领取抽奖券次数不足" toView:self.view afterDelay:1.0];
                return;
            }
//            if ([PBCache shared].memberModel.userType == 2) {
//                [self watchVideoFinish:model.videoId withType:2];
//            }else{
                AdHandleManager *manager = [AdHandleManager sharedManager];
                manager.delegate = self;
                [manager RewardedSlotVideoAdViewRender:model videoType:2 viewController:self];
//            }
        } error:^(NSError * _Nullable error) {
            
        }];
    }
}
//观看视频成功 刷新抽奖券
- (void)refreshLotteryNumber{
    WCApiManager *manager = [WCApiManager sharedManager];
    [[manager fetchLotteryList] subscribeNext:^(LotteryListModel *model) {
        self.receivingTicket = model.remainRecevieVoucherNum;
        self.lotteryNumber = model.remainVoucher;
    } error:^(NSError * _Nullable error) {

    }];
}

- (void)TradePlacesWithBtn1:(UIButton *)firstBtn btn2:(UIButton *)secondBtn {
    CGRect frame = firstBtn.frame;
    firstBtn.frame = secondBtn.frame;
    secondBtn.frame = frame;
}
- (void)dismissNSTimer {
    [imageTimer invalidate];
    imageTimer = nil;
    [startTimer invalidate];
    startTimer = nil;
}
- (NSMutableArray *)btnArray
{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}
- (void)dismiss{
    [UIView animateWithDuration:0.6f animations:^{
//        self.backgroundColor = [UIColor clearColor];
//        self.alpha = 0;
        self.endLotteryResults();
    }completion:^(BOOL finished) {
//        [self removeFromSuperview];
        [self dismissNSTimer];
    } ];
}

@end
