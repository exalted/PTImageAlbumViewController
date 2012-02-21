//
//  PTImageAlbumViewController.h
//  AlbumDemo
//
//  Created by Ali Servet Donmez on 16.2.12.
//  Copyright (c) 2012 Apex-net srl. All rights reserved.
//

#import "NetworkPhotoAlbumViewController.h"

#import "PTImageAlbumViewDataSource.h"

@class PTImageAlbumView;

@interface PTImageAlbumViewController : NetworkPhotoAlbumViewController <PTImageAlbumViewDataSource>

@property (nonatomic, retain) PTImageAlbumView *imageAlbumView;

@end
