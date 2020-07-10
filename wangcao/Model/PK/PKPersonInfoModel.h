//
//  PKPersonInfoModel.h
//  wangcao
//
//  Created by EDZ on 2020/5/19.
//  Copyright © 2020 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PKPersonInfoModel : NSObject

//answerNumber (integer, optional): 已答题次数 ,
//isMustAd (boolean, optional): 下次挑战是不是需要看广告 ,
//rank (integer, optional): 当前排名/如果没有排名返回-1 ,
//sulplusBattleNumber (integer, optional): 剩余挑战次数 ,
//totalAnswerNumber (integer, optional): 总共能答对多少题 ,
//totalBattleNumber (integer, optional): 总挑战次数 ,
//videoAd (视频广告对象, optional): 广告对象
@property (nonatomic,assign) NSInteger answerNumber;
@property (nonatomic,assign) BOOL isMustAd;
@property (nonatomic,assign) NSInteger rank;
@property (nonatomic,assign) NSInteger sulplusBattleNumber;
@property (nonatomic,assign) NSInteger totalAnswerNumber;
@property (nonatomic,assign) NSInteger totalBattleNumber;
@property (nonatomic,strong) VideoModel *videoAd;

@end

NS_ASSUME_NONNULL_END
