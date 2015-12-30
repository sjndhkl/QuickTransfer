//
//  QTRPhotoLibraryController.m
//  QuickTransfer
//
//  Created by Tarun Yadav on 29/12/15.
//  Copyright © 2015 Laughing Buddha Software. All rights reserved.
//


#import "QTRPhotoLibraryController.h"

@interface QTRPhotoLibraryController()

@property (nonatomic, strong) PHFetchResult *assetsFetchResult;
@property (nonatomic, strong) PHImageRequestOptions *requestOptions;



@end

const NSInteger imageFetchLimit = 9999;

@implementation QTRPhotoLibraryController

#pragma mark - Fetch image for specific index

- (void)imageAtIndex:(NSUInteger)imageIndex imageWithFullSize:(BOOL)isFullSize imageSize:(CGSize)fetchImageSize completion:(void (^)(UIImage *image))completion {
    
    if (completion != nil) {
        
        if (imageIndex < [self fetchImageCount]) {
            
            PHImageManager *manager = [PHImageManager defaultManager];
            PHAsset *asset = [_assetsFetchResult objectAtIndex:imageIndex];
            CGSize imageSize = PHImageManagerMaximumSize;
            
            if (isFullSize == NO ) {
                imageSize = fetchImageSize;
            }
            
            [manager requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeDefault options:_requestOptions resultHandler:^void(UIImage *image, NSDictionary *info) {
                completion(image);
            }];
            
        } else {
            
            completion(nil);
        }
    }
}

#pragma mark - Fetch PHAssetResultArray for all images

- (void)fetchAssetInformation {
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
    
    _assetsFetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
    
    _requestOptions = [[PHImageRequestOptions alloc] init];
    _requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    _requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    _requestOptions.synchronous = NO;
    
}

- (NSInteger)fetchImageCount {

    return [_assetsFetchResult count];

}
#pragma mark - deliver image data to reciver

- (void)originalImageAtIndex:(NSInteger)imageIndex completion: (void(^)(PHAsset *asset, NSDictionary *info))completion {

    if (imageIndex < 0 && imageIndex > imageFetchLimit && completion == nil) {
        completion(nil, nil);
        
    } else {
        
        PHImageManager *manager = [PHImageManager defaultManager];
        PHAsset *asset = [_assetsFetchResult objectAtIndex:imageIndex];
        
        [manager requestImageForAsset:asset
                           targetSize:CGSizeMake(160, 160)
                          contentMode:PHImageContentModeDefault
                              options:_requestOptions
         
                        resultHandler:^void(UIImage *image, NSDictionary *info) {
                            
                            if (completion != nil) {
                                completion(asset, info);
                            }
                        }];
    }
    
}






@end
