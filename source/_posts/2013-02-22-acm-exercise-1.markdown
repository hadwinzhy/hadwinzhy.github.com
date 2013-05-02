---
layout: post
title: "《算法竞赛入门经典》 exercise 1"
date: 2013-02-22 16:49
comments: true
tags: [ACM]
---

## 习题2-9 分数化小数 ##

>输入正整数a,b,c, 输出a/b的小数形式，精确到小数点后c位，a,b <= 10^6 c <=100, 例如 a=1 b=6 c=4 时输出为0.1667

这里其实用到了一个printf的用法，具体请看C API of [Printf](http://www.acm.uiuc.edu/webmonkeys/book/c_guide/2.12.html#printf)

Precision:
The precision begins with a dot (.) to distinguish itself from the width specifier. The precision can be given as a decimal value or as an asterisk (*). If a * is used, then the next argument (which is an int type) specifies the precision. Note: when using the * with the width and/or precision specifier, the width argument comes first, then the precision argument, then the value to be converted. Precision does not affect the c type.

所以最后结果就是:
{% codeblock lang:c %}
printf ("%.*lf\n", c, (double)a/b);
{% endcodeblock%}


## 习题2-10 排列 ##

>用1,2,3,···,9 组成 3 个三位数 abc,def和ghi,每个数字恰好使用一次，要求abc:def:ghi=1:2:3。输出所有解。

从102到329循环，将所有数据输入到一个string里面，然后循环1-9，判断string里面是否都包含这些数字即可

{% codeblock lang:c %}
int main(int argc, char *argv[])
{
    int a, digitChar;
    char* pos;
    char str[10];
    for (a = 102; a < 329; ++a)
    {
        sprintf(str, "%d%d%d", a, a*2,a*3);

        for(digitChar = '1'; digitChar <='9'; ++digitChar){
            pos = strchr(str, digitChar);
            if(pos == NULL) // not found such digit
                break;
        }

        if (pos != NULL) printf ("%d %d %d\n", a, a*2, a*3);
    }

    return 0;
}

{% endcodeblock%}
