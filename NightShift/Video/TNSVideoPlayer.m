//
//  TNSPlayVideoView.m
//  SFH_test
//
//  Created by 陈颖鹏 on 15/10/24.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import "TNSVideoPlayer.h"

@implementation TNSVideoPlayer

- (id)initWithFrame:(CGRect)frame identifier:(NSString *)identifier
{
    self = [super initWithFrame:frame];
    if (self) {
        self.identifier = identifier;
        [self setupUIWithIdentifier:identifier];
    }
    return self;
}

- (void)setupUIWithIdentifier:(NSString *)identifier
{
    self.identifier = identifier;
    if (self.identifier) {
        NSURL *url = [NSURL URLWithString:[TNSQiubaiVideoCrawler URLString4Video:self.identifier]];
        AVPlayer *player = [[AVPlayer alloc] initWithURL:url];
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
        layer.frame = self.layer.bounds;
        [self.layer addSublayer:layer];
        
        _player = player;
        [_player addObserver:self forKeyPath:@"status" options:0 context:nil];
        _playerLayer = layer;
        
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [playBtn setImage:[UIImage imageNamed:@"icon_play_normal"] forState:UIControlStateNormal];
        [playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
        _playBtn = playBtn;
    }
}

- (void)play
{
    [self.player play];
}

- (void)pause
{
    [self.player pause];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (object == self.player && [keyPath isEqualToString:@"status"]) {
        if (self.player.status == AVPlayerStatusReadyToPlay) {
            self.backgroundColor = [UIColor blackColor];
        }
    }
}

// 为了避免内存泄露进行手动释放
- (void)dealloc
{
    [self.player pause];
    [self.playerLayer removeFromSuperlayer];
    [self removeObserver:self.player forKeyPath:@"status" context:nil];
    _player = nil;
    _player = nil;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    self.playerLayer.frame = self.layer.bounds;
    self.playBtn.center = CGPointMake(rect.size.width/2, rect.size.height/2);
}

- (void)disappear{
    self.hidden = YES;
    [self.player pause];
    self.backgroundColor = [UIColor blackColor];
}

@end
