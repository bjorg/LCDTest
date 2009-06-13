// Copyright 2004, 2005 Steve Bjorg
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
#import "PatternView.h"

typedef enum device_flags_t {
	ANALOG		= 0x01,	// vs. DIGITAL
	PIXELS		= 0x02,	// vs. BEAM
	PROJECTED	= 0x04, // vs. MONITOR
} device_flags_t;

@interface PatternDescriptor : NSObject {
	NSString* class_name;
	NSString* title;
	NSString* description_file;
	device_flags_t must_flags;
}

// allocator
+ (id)patternWithClassName:(NSString*)_class_name title:(NSString*)_title descriptionFile:(NSString*)_description flags:(device_flags_t)_flags;

// initializer
- (id)initWithClassName:(NSString*)_class_name title:(NSString*)_title descriptionFile:(NSString*)_description flags:(device_flags_t)_flags;

// selectors
- (NSString*)title;
- (NSString*)descriptionFile;

// pattern behavior
- (bool)isVisibleForFlags:(device_flags_t)flags;
- (PatternView*)createPatternView;

@end
