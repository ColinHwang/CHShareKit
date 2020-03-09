//
//  CHMacroHelper.m
//  CHCategories
//
//  Created by CHwang on 2017/11/22.
//

#pragma mark - Mathematics

unsigned long ch_gcd(unsigned long x, unsigned long y) {
    if (x < y) return ch_gcd(y, x);
    if (x == y) return y;
    
    while (true) {
        if (y == 0) return 0;

        unsigned long buffer = x % y;
        if (buffer == 0) return y;
        
        x = y;
        y = buffer;
    }
}
