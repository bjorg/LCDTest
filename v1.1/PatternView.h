// Copyright 2004 Steve Bjorg
//
// This file is part of LCDTest.
// 
// LCDTest is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.

// LCDTest is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with LCDTest; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

#import <Cocoa/Cocoa.h>

typedef enum TestMode {
	TESTMODE_CALIBRATION,
	TESTMODE_DEAD_PIXELS,
	TESTMODE_PANEL_ALIGNMENT,
	TESTMODE_COLOR_GRADIENT,
	TESTMODE_PIXEL_RESPONSE_TIME
} TestMode;

@interface PatternView : NSView {
	TestMode mode;
	int state;
	float position;
	int iteration;
	NSTimer* timer;
}

// standard view create/free methods
- (id)initWithFrame:(NSRect)frame withTestMode:(TestMode)testMode;

// drawing
- (void)nextState;
- (void)prevState;
- (void)nextPosition;
- (void)drawDeadPixelsBackground;
- (void)drawColorGradientBackground;
- (void)drawCalibrationBackground;
- (void)drawPanelAlignmentBackground;
- (void)setColorForIteration:(int)number;
- (void)drawPixelResponseBackground;
- (void)drawRect:(NSRect)rect;
- (BOOL)isOpaque;

// event handling
- (BOOL)acceptsFirstResponder;
- (void)mouseUp:(NSEvent*)event;
- (void)keyDown:(NSEvent*)event;

@end
