//
//  TGTextMessageCell.m
//  NoChat-Example
//
//  Copyright (c) 2016-present, little2s.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "TGSoundMessageCell.h"
#import "TGSoundMessageCellLayout.h"

@implementation TGSoundMessageCell

+ (NSString *)reuseIdentifier
{
    return @"TGSoundMessageCell";
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bubbleImageView = [[UIImageView alloc] init];
        [self.bubbleView addSubview:_bubbleImageView];
        
        _textLabel = [[UIButton alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        [_textLabel setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
        [_textLabel addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.bubbleView addSubview:_textLabel];
        
        _timeLabel = [[UILabel alloc] init];
        [self.bubbleView addSubview:_timeLabel];
        
        _deliveryStatusView = [[TGDeliveryStatusView alloc] init];
        [self.bubbleView addSubview:_deliveryStatusView];
    }
    return self;
}

- (void)didTapButton: (id)sender {
    if (self.isPlaying) {
        self.isPlaying = NO;
        [_textLabel setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
    } else {
        self.isPlaying = YES;
        [_textLabel setImage:[UIImage imageNamed:@"btn_pause"] forState:UIControlStateNormal];
    }
    id<TGSoundMessageCellDelegate> delegate = (id<TGSoundMessageCellDelegate>) self.delegate;
    if ([delegate respondsToSelector:@selector(cell:didTapPlayButton:)]) {
        [delegate cell:self didTapPlayButton:self.isPlaying];
    }
}

- (void)setLayout:(id<NOCChatItemCellLayout>)layout
{
    [super setLayout:layout];
    [_textLabel setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];

    TGSoundMessageCellLayout *cellLayout = (TGSoundMessageCellLayout *)layout;
    
    self.bubbleImageView.frame = cellLayout.bubbleImageViewFrame;
    self.bubbleImageView.image = self.isHighlight ? cellLayout.highlightBubbleImage : cellLayout.bubbleImage;
    
    self.textLabel.frame = cellLayout.textLabelFrame;    
    self.timeLabel.frame = cellLayout.timeLabelFrame;
    self.timeLabel.attributedText = cellLayout.attributedTime;
    
    self.deliveryStatusView.frame = cellLayout.deliveryStatusViewFrame;
    self.deliveryStatusView.deliveryStatus = cellLayout.message.deliveryStatus;
}

@end
