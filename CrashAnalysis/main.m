//
//  main.m
//  CrashAnalysis
//
//  Created by 王永刚 on 2018/4/28.
//  Copyright © 2018年 CrashAnalysis. All rights reserved.
//


//.app的路径
#define APP_PATH @"/Users/wyon/Desktop/学习/crash分析/crash/LianAi.app"
//appName
#define APP_NAME @"LianAi"
//内存地址
#define MODULE_ADDRESS @"0x000000010438c964"
//偏移量
#define SLIDE_VALUE 51556

#import <Foundation/Foundation.h>

//MODULE_ADDRESS（16进制）减去 SLIDE_VALUE（10进制），最后得到一个16进制的字符串
NSString * dealWithAddress(){
    unsigned long long result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:[MODULE_ADDRESS substringFromIndex:2]];
    [scanner scanHexLongLong:&result];
    NSString *hexString = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%16llx",result - SLIDE_VALUE]];
    return hexString;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        //如果内存地址是18位，就是arm64,其余是armv7
        NSString * type = MODULE_ADDRESS.length == 18 ? @"arm64" : @"armv7";
        //把所有参数拼接成命令行
        NSString * result = [NSString stringWithFormat:@"xcrun atos --arch %@ -o %@/%@ -l %@ %@",type,APP_PATH,APP_NAME,dealWithAddress(),MODULE_ADDRESS];
        NSLog(@"\n%@\n程序crash在：" , result);
        //执行命令行，定位到在什么位置崩溃
        system([result UTF8String]);
        
    }
    return 0;
}


