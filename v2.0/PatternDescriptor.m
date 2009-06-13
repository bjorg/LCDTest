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

#import "PatternDescriptor.h"


@implementation PatternDescriptor

/*
 * Class Methods
 */
+ (id)patternWithClassName:(NSString*)_class_name title:(NSString*)_title descriptionFile:(NSString*)_description flags:(device_flags_t)_flags {
	PatternDescriptor* result = [self alloc];
	return [result initWithClassName:_class_name title:_title descriptionFile:_description flags:_flags];
}

/*
 * Public Methods
 */
- (id)initWithClassName:(NSString*)_class_name title:(NSString*)_title descriptionFile:(NSString*)_description_file flags:(device_flags_t)_must_flags {
	if(self = [super init]) {
		class_name = [_class_name retain];
		title = [_title retain];
		description_file = [_description_file retain];
		must_flags = _must_flags;
	}
	return self;
}

- (NSString*)title {
	return title;
}

- (NSString*)descriptionFile {
	return description_file;
}

- (bool)isVisibleForFlags:(device_flags_t)flags {
	return (must_flags & flags) == must_flags;
}

- (PatternView*)createPatternView {
	Class c = [[NSBundle mainBundle] classNamed:class_name];
	return [c alloc];
}

/*
 * Overridden Methods
 */
- (void)dealloc {
	[class_name release];
	[title release];
	[description_file release];
	[super dealloc];
}

@end
