//
//  TGChatInputTextPanel.h
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

#import <NoChat/NoChat.h>

@class TGChatInputTextPanel;
@class HPGrowingTextView;

@protocol TGChatInputTextPanelDelegate <NOCChatInputPanelDelegate>

@optional
- (void)inputTextPanel:(TGChatInputTextPanel *)inputTextPanel requestSendText:(NSString *)text;
- (void)inputTextPanel:(TGChatInputTextPanel *)inputTextPanel didInputText:(NSString *)text;

@end

@interface TGChatInputTextPanel : NOCChatInputPanel

@property (nonatomic, strong) CALayer *stripeLayer;
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) HPGrowingTextView *inputField;
@property (nonatomic, strong) UIView *inputFieldClippingContainer;
@property (nonatomic, strong) UIImageView *fieldBackground;

@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *attachButton;
@property (nonatomic, strong) UIButton *micButton;

- (void)toggleSendButtonEnabled;
- (void)clearInputField;

@end
