//
//  PTImageAlbumViewDataSource.h
//  AlbumDemo
//
//  Created by Ali Servet Donmez on 17.2.12.
//  Copyright (c) 2012 Apex-net srl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTImageAlbumView;

@protocol PTImageAlbumViewDataSource <NSObject>

@required
- (NSInteger)numberOfImagesInAlbumView:(PTImageAlbumView *)imageAlbumView;
- (NSString *)imageAlbumView:(PTImageAlbumView *)imageAlbumView sourceForImageAtIndex:(NSInteger)index;
- (CGSize)imageAlbumView:(PTImageAlbumView *)imageAlbumView sizeForImageAtIndex:(NSInteger)index;
- (NSString *)imageAlbumView:(PTImageAlbumView *)imageAlbumView sourceForThumbnailImageAtIndex:(NSInteger)index;

@end
