//
// Copyright (C) 2012 Ali Servet Donmez. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <Foundation/Foundation.h>

@class PTImageAlbumView;

@protocol PTImageAlbumViewDataSource <NSObject>

@required
- (NSInteger)numberOfImagesInAlbumView:(PTImageAlbumView *)imageAlbumView;
- (NSString *)imageAlbumView:(PTImageAlbumView *)imageAlbumView sourceForImageAtIndex:(NSInteger)index;
- (NSString *)imageAlbumView:(PTImageAlbumView *)imageAlbumView sourceForThumbnailImageAtIndex:(NSInteger)index;

@optional
// if you don't implement this, we will try to guess it
- (CGSize)imageAlbumView:(PTImageAlbumView *)imageAlbumView sizeForImageAtIndex:(NSInteger)index;

- (NSString *)imageAlbumView:(PTImageAlbumView *)imageAlbumView captionForImageAtIndex:(NSInteger)index;

@end
