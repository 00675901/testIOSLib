//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GTStorageType) {
    GTStorageTypeImage,
    GTStorageTypeData,
    GTStorageTypeFile,
    GTStorageTypeTmp,
    GTStorageTypeNeverRelease
};

@interface GTStorageManager : NSObject {
    NSMutableDictionary *_memoryStorageDatas;
}

@property (nonatomic, retain) NSMutableDictionary *memoryStorageDatas;

+ (id)sharedInstance;
+ (BOOL)getOrCreateFolder:(NSString *)path;
+ (NSString *)formattedTextForFileSize:(NSNumber *)fileSize;

//储存内存数据方法
- (void)saveObject:(id)object withKey:(id)key type:(GTStorageType)type;
- (void)clearMemoryDatas:(NSMutableDictionary *)datas;
- (void)clearMemoryDatasByType:(GTStorageType)type;

//读取内存数据方法
- (id)readObjectForKey:(NSString *)key type:(GTStorageType)type;

//清除所有内存数据，不包含Never Release
- (void)clearAllMemoryDatas;

//存储磁盘数据方法
- (BOOL)storeImage:(UIImage *)image withFileName:(NSString *)fileName;
- (BOOL)storeArray:(NSArray *)array withFileName:(NSString *)fileName;
- (BOOL)storeDictionary:(NSDictionary *)dictionary withFileName:(NSString *)fileName;
- (BOOL)storeData:(NSData *)data withFileName:(NSString *)fileName;
- (BOOL)storeValue:(id)value forKey:(NSString *)key;

//读取磁盘数据方法
- (UIImage *)fetchImageForFileName:(NSString *)fileName;
- (NSArray *)fetchArrayForFileName:(NSString *)fileName;
- (NSDictionary *)fetchDictionaryForFileName:(NSString *)fileName;
- (NSData *)fetchDataForFileName:(NSString *)fileName;
- (id)fetchValueForKey:(NSString *)key;

//删除单个文件

- (BOOL)removeArrayForFileName:(NSString *)fileName;
- (BOOL)removeDictionaryForFileName:(NSString *)fileName;
- (BOOL)removeDataForFileName:(NSString *)fileName;
- (BOOL)removeValueForKey:(NSString *)key;
- (BOOL)removeFile:(NSString *)fileName atFolder:(GTStorageType)folderType;

//清除缓存文件
- (BOOL)clearCachedImages;
- (BOOL)clearCachedFiles;
- (BOOL)clearCachedDatas;
- (BOOL)clearCachedTmpFiles;

//获取缓存目录尺寸
//格式化输出，例如100 字节，100.1 KB等
- (NSString *)imageCacheSize;
- (NSString *)dataCacheSize;
- (NSString *)fileCacheSize;
- (NSString *)tmpCacheSize;

//缓存目录路径
- (NSString *)getCachedImagePath;
- (NSString *)getCachedFilePath;
- (NSString *)getCachedDataPath;
- (NSString *)getCachedTmpPath;
@end
