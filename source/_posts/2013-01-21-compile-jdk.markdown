---
layout: post
title: "编译 openJDK source code 札记"
date: 2013-01-21 11:36
comments: true
tags: [JVM, Book_Notes ]

---
## 0. Prepare for Build ##
{% codeblock lang:bash %}
sudo aptitude build-dep
sudo apt-get install gawk
{% endcodeblock%}


## 1. Download JDK ##
- 这次准备从[官网](http://hg.openjdk.java.net/jdk7/jdk7)的repo上直接取source code
先下载 mercurial 和 hg
{% codeblock lang:bash %}
sudo apt-get install mercurial
hg clone http://hg.openjdk.java.net/jdk7/jdk7
{% endcodeblock%}

- 其实真正的code 还没下载下来，需要运行 get_source.sh
{% codeblock lang:bash %}
cd jdk7/ && sh get_source.sh
{% endcodeblock%}

- 最好再下载最新的binary [http://jdk7.java.net/download.html](http://jdk7.java.net/download.html)


## 2. Environment Setting ##

因为编译的时候可能会出现如下错误：  `ERROR: Cannot find source for project jaxp.`

这个需要下载，所以需要在make选项添加 `ALLOW_DOWNLOADS=true`

最终的编译脚本如下：

{% codeblock lang:bash %}
#!/bin/sh
export ALT_BOOTDIR=/usr/lib/jvm/java-7-openjdk-amd64/
export ALT_HOTSPOT_IMPORT_PATH=/local/code/lang/jdk1.7.0_13/
unset JAVA_HOME
make LANG=C ALLOW_DOWNLOADS=true DISABLE_HOTSPOT_OS_VERSION_CHECK=ok 
{% endcodeblock%}

## 2. Build ##

#### 下面就是解决make出现的各种问题和解决方案： ####

* ERROR: `You do not have access to valid Cups header files.`

需要安装cpus的dev包

{% codeblock lang:bash %}
sudo apt-get install libcups2-dev
{% endcodeblock%}

* ERROR: `The version of ant being used is older than the required version of '1.7.1'.  The version of ant found was ''.`

这说明没有装ant

{% codeblock lang:bash %}
sudo apt-get install ant
{% endcodeblock%}

* ERROR: `FreeType version  2.3.0  or higher is required.`

安装freetype的dev包

{% codeblock lang:bash %}
sudo apt-get install libfreetype6-dev
{% endcodeblock%}

* ERROR: `You seem to not have installed ALSA 0.9.1 or higher.`

不需要从ALSA官网下载alsa-dev和alsa-drive， ubuntu提供包的

{% codeblock lang:bash %}
sudo apt-get install libasound2-dev
{% endcodeblock%}

* ERROR: `echo "*** This OS is not supported:" 'uname -a'; exit 1;` 

很奇怪的错误，anyway，注释掉hotspot/make/linux/Makefile里面的checkOS

{% codeblock lang:bash %}
check_os_version:
#ifeq ($(DISABLE_HOTSPOT_OS_VERSION_CHECK)$(EMPTY_IF_NOT_SUPPORTED),)
#	$(QUIETLY) >&2 echo "*** This OS is not supported:" `uname -a`; exit 1;
#endif
{% endcodeblock%}

**Update: 最好的办法是在make参数后面添加 DISABLE_HOTSPOT_OS_VERSION_CHECK=OK 即可**


* ERROR: `error: "__LEAF" redefined [-Werror]`  

这个是已知的[bug](http://hg.openjdk.java.net/hsx/hotspot-comp/hotspot/rev/a6eef545f1a2),
在hopspot下打入该[patch](http://hg.openjdk.java.net/hsx/hotspot-comp/hotspot/raw-rev/a6eef545f1a2)即可

* ERROR `error: converting ‘false’ to pointer type ‘methodOop’ [-Werror=conversion-null]` 

这个的问题是把 false 转换成 NULL的时候出错了

同样在hotspot下 打入该 [patch](http://hg.openjdk.java.net/hsx/hotspot-rt/hotspot/raw-rev/f457154eee8b)

* ERROR `gcc: error: unrecognized command line option '-mimpure-text'`

这个`-mimpure-text`是gcc给Solaris的编译选项，所以注释掉即可

文件在`./jdk/make/common/shared/Compiler-gcc.gmk +70`

* ERROR `undefined reference to 'snd_pcm_format_**'`

folow this link [Build openjdk in Ubuntu 11.10](http://comments.gmane.org/gmane.comp.java.openjdk.build.devel/5311)
在`jdk/make/javax/sound/jsoundalsa/Makefile` 里面

{% codeblock lang:bash %}
@@ -65,7 +65,7 @@
 	$(MIDIFILES_export) \
 	$(PORTFILES_export)
    
-LDFLAGS += -lasound
+OTHER_LDLIBS += -lasound

CPPFLAGS += \
 	-DUSE_DAUDIO=TRUE \
{% endcodeblock %}

## 4. Success Output ##
{% codeblock lang:bash %}
########################################################################
##### Leaving jdk for target(s) sanity all docs images             #####
########################################################################
##### Build time 00:05:35 jdk for target(s) sanity all docs images #####
########################################################################

-- Build times ----------
Target all_product_build
Start 2013-02-05 13:47:18
End   2013-02-05 13:53:04
00:00:03 corba
00:00:02 jaxp
00:00:03 jaxws
00:05:35 jdk
00:00:03 langtools
00:05:46 TOTAL
-------------------------
{% endcodeblock%}
