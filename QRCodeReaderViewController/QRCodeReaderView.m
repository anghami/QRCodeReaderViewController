/*
 * QRCodeReaderViewController
 *
 * Copyright 2014-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "QRCodeReaderView.h"

@interface QRCodeReaderView ()
@property (nonatomic, strong) CAShapeLayer *overlay;

@property (nonatomic, strong) NSArray<UIView *> * overlayViews;

@end

@implementation QRCodeReaderView

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    [self addOverlay];
    [self addOverlayViews];
  }

  return self;
}

- (void)addOverlayViews
{
  NSMutableArray<UIView *> * overlayViews = [[NSMutableArray alloc] initWithCapacity:4];
  for (int i = 0; i < 4; i++)
  {
    UIView * overlayView = [[UIView alloc] init];
    overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self addSubview:overlayView];
    [overlayViews addObject:overlayView];
  }
  self.overlayViews = overlayViews;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  CGFloat margin = 50;
  CGFloat width = self.bounds.size.width;
  CGFloat height = self.bounds.size.height;
  CGRect innerRect = CGRectInset(self.bounds, margin, margin);
  CGFloat minSize = MIN(innerRect.size.width, innerRect.size.height);
  CGFloat hMargin = (width - minSize)/2;;
  CGFloat vMargin = (height - minSize)/2;
  CGFloat yOffset = 15;
    
  self.overlayViews[0].frame = CGRectMake(0, 0, width, vMargin+yOffset); // top
  self.overlayViews[1].frame = CGRectMake(0, height-vMargin+yOffset, width, vMargin+yOffset); // bottom
  self.overlayViews[2].frame = CGRectMake(0, vMargin+yOffset, hMargin, height-vMargin*2); // left
  self.overlayViews[3].frame = CGRectMake(width-hMargin, vMargin+yOffset, hMargin, height-vMargin*2); // right
}

- (void)drawRect:(CGRect)rect
{
  CGRect innerRect = CGRectInset(rect, 50, 50);

  CGFloat minSize = MIN(innerRect.size.width, innerRect.size.height);
  if (innerRect.size.width != minSize) {
    innerRect.origin.x   += (innerRect.size.width - minSize) / 2;
    innerRect.size.width = minSize;
  }
  else if (innerRect.size.height != minSize) {
    innerRect.origin.y    += (innerRect.size.height - minSize) / 2;
    innerRect.size.height = minSize;
  }

  CGRect offsetRect = CGRectOffset(innerRect, 0, 15);


  _overlay.path = [UIBezierPath bezierPathWithRoundedRect:offsetRect cornerRadius:5].CGPath;
}

#pragma mark - Private Methods

- (void)addOverlay
{
  _overlay = [[CAShapeLayer alloc] init];
  _overlay.backgroundColor = [UIColor clearColor].CGColor;
  _overlay.fillColor       = [UIColor clearColor].CGColor;
  _overlay.strokeColor     = [UIColor whiteColor].CGColor;
  _overlay.lineWidth       = 3;
  _overlay.lineDashPattern = @[@7.0, @7.0];
  _overlay.lineDashPhase   = 0;

  [self.layer addSublayer:_overlay];
}

@end
