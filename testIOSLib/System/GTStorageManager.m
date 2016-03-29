//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "GTStorageManager.h"

#define G_LOCALE_TMP_DIR [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]
#define G_LOCALE_DOC_DIR [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define CACHE_IMAGE_FOLDER @"cimages"
#define CACHE_FILE_FOLDER @"cfiles"
#define CACHE_DATA_FOLDER @"cdata"
#define CACHE_TMP_FOLDER @"ctmp"

#define kGTStorageTypeImage @"image"
#define kGTStorageTypeData @"data"
#define kGTStorageTypeFile @"file"
#define kGTStorageTypeTmp @"tmp"
#define kGTStorageTypeNeverRelease @"retaindata"

#define PATH_IMAGE_FOLDER [NSString stringWithFormat:@"%@/%@", G_LOCALE_TMP_DIR, CACHE_IMAGE_FOLDER]
#define PATH_FILE_FOLDER [NSString stringWithFormat:@"%@/%@", G_LOCALE_DOC_DIR, CACHE_FILE_FOLDER]
#define PATH_DATA_FOLDER [NSString stringWithFormat:@"%@/%@", G_LOCALE_DOC_DIR, CACHE_DATA_FOLDER]
#define PATH_TMP_FOLDER [NSString stringWithFormat:@"%@/%@", G_LOCALE_TMP_DIR, CACHE_TMP_FOLDER]

#define MAX_CACHE_COUNT 50

@implementation GTStorageManager
@synthesize memoryStorageDatas = _memoryStorageDatas;

- (void)dealloc {
    [_memoryStorageDatas removeAllObjects];
}

- (id)init {
    if (self = [super init]) {
        self.memoryStorageDatas = [[NSMutableDictionary alloc] initWithCapacity:5];
        [self.memoryStorageDatas setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:kGTStorageTypeImage];
        [self.memoryStorageDatas setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:kGTStorageTypeData];
        [self.memoryStorageDatas setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:kGTStorageTypeFile];
        [self.memoryStorageDatas setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:kGTStorageTypeTmp];
        [self.memoryStorageDatas setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:kGTStorageTypeNeverRelease];
    }

    return self;
}

+ (id)sharedInstance {
    static id _sharedInstance = nil;
    if (!_sharedInstance) {
        _sharedInstance = [[[self class] alloc] init];
    }

    return _sharedInstance;
}

#pragma mark - 内存数据存取方法
//储存内存数据方法
- (void)saveObject:(id)object withKey:(id)key type:(GTStorageType)type {
    NSMutableDictionary *cache_datas = [NSMutableDictionary dictionaryWithCapacity:10];
    NSString *type_key = nil;

    switch (type) {
        case GTStorageTypeImage:
            type_key = kGTStorageTypeImage;
            break;
        case GTStorageTypeData:
            type_key = kGTStorageTypeData;
            break;
        case GTStorageTypeFile:
            type_key = kGTStorageTypeFile;
            break;
        case GTStorageTypeTmp:
            type_key = kGTStorageTypeTmp;
            break;
        case GTStorageTypeNeverRelease:
            type_key = kGTStorageTypeNeverRelease;
            break;
        default:
            break;
    }

    if ([self.memoryStorageDatas objectForKey:type_key]) {
        cache_datas = [_memoryStorageDatas objectForKey:type_key];
    }
    //    if (object) [cache_datas setObject:object forKey:key];

    @synchronized(self) {
        if (cache_datas.count > MAX_CACHE_COUNT && ![type_key isEqualToString:kGTStorageTypeData]) {
            //            [self clearMemoryDatas:cache_datas];
            NSArray *allKeys = [cache_datas allKeys];
            NSString *randomKey = [allKeys objectAtIndex:0];
            [cache_datas removeObjectForKey:randomKey];
        }
        if (object) [cache_datas setObject:object forKey:key];
    }

    [self.memoryStorageDatas setObject:cache_datas forKey:type_key];
}

//读取内存数据方法
- (id)readObjectForKey:(NSString *)key type:(GTStorageType)type {
    NSMutableDictionary *cache_datas = nil;
    NSString *type_key = nil;

    switch (type) {
        case GTStorageTypeImage:
            type_key = kGTStorageTypeImage;
            break;
        case GTStorageTypeData:
            type_key = kGTStorageTypeData;
            break;
        case GTStorageTypeFile:
            type_key = kGTStorageTypeFile;
            break;
        case GTStorageTypeTmp:
            type_key = kGTStorageTypeTmp;
            break;
        case GTStorageTypeNeverRelease:
            type_key = kGTStorageTypeNeverRelease;
            break;
        default:
            break;
    }

    cache_datas = [self.memoryStorageDatas objectForKey:type_key];
    return [cache_datas objectForKey:key];
}

- (void)clearMemoryDatasByType:(GTStorageType)type {
    NSMutableDictionary *cache_datas = nil;
    switch (type) {
        case GTStorageTypeImage:
            cache_datas = [self.memoryStorageDatas objectForKey:kGTStorageTypeImage];
            break;
        case GTStorageTypeData:
            cache_datas = [self.memoryStorageDatas objectForKey:kGTStorageTypeData];
            break;
        case GTStorageTypeFile:
            cache_datas = [self.memoryStorageDatas objectForKey:kGTStorageTypeFile];
            break;
        case GTStorageTypeTmp:
            cache_datas = [self.memoryStorageDatas objectForKey:kGTStorageTypeTmp];
            break;
        case GTStorageTypeNeverRelease:
            cache_datas = [self.memoryStorageDatas objectForKey:kGTStorageTypeNeverRelease];
            break;
        default:
            break;
    }

    [self clearMemoryDatas:cache_datas];
}

- (void)clearMemoryDatas:(NSMutableDictionary *)datas {
    @synchronized(datas) {
        [datas removeAllObjects];
    }
}

- (void)clearAllMemoryDatas {
    NSMutableDictionary *cache_datas = [self.memoryStorageDatas objectForKey:kGTStorageTypeImage];
    [self clearMemoryDatas:cache_datas];
    cache_datas = [self.memoryStorageDatas objectForKey:kGTStorageTypeData];
    [self clearMemoryDatas:cache_datas];
    cache_datas = [self.memoryStorageDatas objectForKey:kGTStorageTypeFile];
    [self clearMemoryDatas:cache_datas];
    cache_datas = [self.memoryStorageDatas objectForKey:kGTStorageTypeTmp];
    [self clearMemoryDatas:cache_datas];
}

#pragma mark - 磁盘数据存取方法
- (BOOL)storeImage:(UIImage *)image withFileName:(NSString *)fileName {
    //暂时不可用
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self getCachedImagePath], fileName];
    NSData *data = UIImageJPEGRepresentation(image, 0.9);
    return [data writeToFile:path atomically:YES];
}

- (BOOL)storeArray:(NSArray *)array withFileName:(NSString *)fileName {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self getCachedDataPath], fileName];

    BOOL result = [array writeToFile:path atomically:YES];

    return result;
}

- (BOOL)storeDictionary:(NSDictionary *)dictionary withFileName:(NSString *)fileName {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self getCachedDataPath], fileName];
    return [dictionary writeToFile:path atomically:YES];
}

- (BOOL)storeData:(NSData *)data withFileName:(NSString *)fileName {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self getCachedDataPath], fileName];
    return [data writeToFile:path atomically:YES];
}

- (BOOL)storeValue:(id)value forKey:(NSString *)key {
    BOOL ret = NO;
    if (!value) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    }

    ret = [[NSUserDefaults standardUserDefaults] synchronize];
    return ret;
}

//读取方法
- (UIImage *)fetchImageForFileName:(NSString *)fileName {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self getCachedImagePath], fileName];

    UIImage *image = nil;
    @try {
        image = [UIImage imageWithContentsOfFile:path];
    }
    @catch (NSException *exception) {
        ;
    }
    @finally {
        ;
    }

    return image;
}

- (NSArray *)fetchArrayForFileName:(NSString *)fileName {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self getCachedDataPath], fileName];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    return array;
}

- (NSDictionary *)fetchDictionaryForFileName:(NSString *)fileName {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self getCachedDataPath], fileName];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    return dictionary;
}

- (NSData *)fetchDataForFileName:(NSString *)fileName {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self getCachedDataPath], fileName];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

- (id)fetchValueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#pragma mark - 各缓存目录

- (NSString *)getCachedImagePath {
    if ([GTStorageManager getOrCreateFolder:PATH_IMAGE_FOLDER]) {
        return PATH_IMAGE_FOLDER;
    }
    return nil;
}

- (NSString *)getCachedFilePath {
    if ([GTStorageManager getOrCreateFolder:PATH_FILE_FOLDER]) {
        return PATH_TMP_FOLDER;
    }
    return nil;
}

- (NSString *)getCachedDataPath {
    if ([GTStorageManager getOrCreateFolder:PATH_DATA_FOLDER]) {
        return PATH_DATA_FOLDER;
    }
    return nil;
}

- (NSString *)getCachedTmpPath {
    if ([GTStorageManager getOrCreateFolder:PATH_TMP_FOLDER]) {
        return PATH_FILE_FOLDER;
    }
    return nil;
}

#pragma mark - 其他方法

- (BOOL)isFileEmpty:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL ret = [fileManager fileExistsAtPath:filePath];
    if (ret) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        if ([data length] == 0) {
            ret = YES;
        } else {
            ret = NO;
        }
    } else {
        ret = YES;
    }
    return ret;
}

- (BOOL)removeArrayForFileName:(NSString *)fileName {
    return NO;
}

- (BOOL)removeDictionaryForFileName:(NSString *)fileName {
    return NO;
}

- (BOOL)removeDataForFileName:(NSString *)fileName {
    return NO;
}

- (BOOL)removeValueForKey:(NSString *)key {
    return NO;
}

- (BOOL)removeFile:(NSString *)fileName atFolder:(GTStorageType)folderType {
    NSString *folder = nil;
    switch (folderType) {
        case GTStorageTypeImage:
            folder = [self getCachedImagePath];
            break;
        case GTStorageTypeFile:
            folder = [self getCachedFilePath];
            break;
        case GTStorageTypeTmp:
            folder = [self getCachedTmpPath];
            break;
        case GTStorageTypeData:
            folder = [self getCachedDataPath];
            break;
        default:
            break;
    }

    if (!folder) {
        return NO;
    }

    NSString *path = [NSString stringWithFormat:@"%@/%@", folder, fileName];
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

#pragma mark - 清除方法

- (BOOL)clearCachedImages {
    NSString *path = [self getCachedImagePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:path error:nil];
}

- (BOOL)clearCachedDatas {
    NSString *path = [self getCachedDataPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:path error:nil];
}

- (BOOL)clearCachedFiles {
    NSString *path = [self getCachedFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:path error:nil];
}

- (BOOL)clearCachedTmpFiles {
    NSString *path = [self getCachedTmpPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:path error:nil];
}

#pragma mark - 获取缓存目录大小

- (NSString *)dataCacheSize {
    NSString *path = [self getCachedDataPath];
    NSNumber *file_size = [GTStorageManager sizeForFolder:path];

    NSString *ret = [GTStorageManager formattedTextForFileSize:file_size];
    return ret;
}

- (NSString *)fileCacheSize {
    NSString *path = [self getCachedFilePath];
    NSNumber *file_size = [GTStorageManager sizeForFolder:path];

    NSString *ret = [GTStorageManager formattedTextForFileSize:file_size];
    return ret;
}

- (NSString *)imageCacheSize {
    NSString *path = [self getCachedImagePath];
    NSNumber *file_size = [GTStorageManager sizeForFolder:path];

    NSString *ret = [GTStorageManager formattedTextForFileSize:file_size];
    return ret;
}

- (NSString *)tmpCacheSize {
    NSString *path = [self getCachedTmpPath];
    NSNumber *file_size = [GTStorageManager sizeForFolder:path];

    NSString *ret = [GTStorageManager formattedTextForFileSize:file_size];
    return ret;
}

#pragma mark - 静态方法

/*
 计算文件大小，格式化显示
 */
+ (NSString *)formattedTextForFileSize:(NSNumber *)fileSize {
    NSString *ret = nil;
    NSNumber *tmp = nil;
    if (fileSize.unsignedLongLongValue < 1024) {
        ret = [NSString stringWithFormat:@"%@ 字节", fileSize];
    } else if (fileSize.unsignedLongLongValue < 1024 * 1024) {
        tmp = [NSNumber numberWithLongLong:fileSize.doubleValue / 1024.0];
        ret = [NSString stringWithFormat:@"%.1lf KB", tmp.doubleValue];
    } else if (fileSize.unsignedLongLongValue < 1024 * 1024 * 1024) {
        tmp = [NSNumber numberWithLongLong:fileSize.doubleValue / 1024.0 / 1024.0];
        ret = [NSString stringWithFormat:@"%.2lf MB", tmp.doubleValue];
    } else if (fileSize.unsignedLongLongValue / (1024 * 1024 * 1024) < 1024) {
        tmp = [NSNumber numberWithLongLong:fileSize.doubleValue / 1024.0 / 1024.0 / 1024.0];
        ret = [NSString stringWithFormat:@"%.2lf GB", tmp.doubleValue];
    }

    return ret;
}

+ (BOOL)getOrCreateFolder:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL ret = YES;
    if ([fileManager fileExistsAtPath:path isDirectory:&isDir] == NO) {
        ret = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return ret;
}

+ (BOOL)getOrCreateFile:(NSString *)path {
    BOOL isDir;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path isDirectory:&isDir] == YES) {
        return YES;
    }

    BOOL ret = [[NSFileManager defaultManager] createFileAtPath:path contents:[NSData data] attributes:nil];
    return ret;
}

+ (NSNumber *)sizeForFolder:(NSString *)folderPath {
    unsigned long long n = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *array = [fileManager subpathsOfDirectoryAtPath:folderPath error:nil];
    NSMutableString *ms = [NSMutableString stringWithCapacity:20];

    for (int i = 0; i < [array count]; i++) {
        [ms setString:folderPath];
        NSString *fpath = [array objectAtIndex:i];
        [ms appendFormat:@"/%@", fpath];

        NSDictionary *dict = [fileManager attributesOfItemAtPath:ms error:nil];
        NSNumber *tmp = [dict objectForKey:@"NSFileSize"];
        n += [tmp longLongValue];
    }

    return [NSNumber numberWithLongLong:n];
}

@end
