//
//  PTImageAlbumView.h
//  AlbumDemo
//
//  Created by Ali Servet Donmez on 17.2.12.
//  Copyright (c) 2012 Apex-net srl. All rights reserved.
//

@protocol PTImageAlbumViewDataSource;

@interface PTImageAlbumView : NIPhotoAlbumScrollView

@property (nonatomic, assign) id<PTImageAlbumViewDataSource> imageAlbumDataSource;

- (NSInteger)numberOfImages;
- (NSString *)originalSourceForImageAtIndex:(NSInteger)index;
- (CGSize)originalSizeForImageAtIndex:(NSInteger)index;
- (NSString *)thumbnailSourceForImageAtIndex:(NSInteger)index;

- (void)reloadData;

@end
