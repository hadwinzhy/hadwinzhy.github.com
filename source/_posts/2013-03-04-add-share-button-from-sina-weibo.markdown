---
layout: post
title: "在Octopress添加新浪微博按钮 札记"
date: 2013-03-04 00:31
comments: true
categories: [WebTech]
---
其实很简单的，只是对网络技术忘得差不多了，所以花了一点时间

## Prepare ##
- 到 `http://open.weibo.com/sharebutton` 去申请一个 share button， 申请之后看到有WBML方法， 和JS方法。 我这里选择的是WBML方法

## Steps ##

- 在 `source/_includes/head.html` 里面修改，添加xmlns：

{% codeblock%}
- <!--[if (gt IE 8)|(gt IEMobile 7)|!(IEMobile)|!(IE)]><!--><html class="no-js" lang="en"><!--<![endif]-->
+ <!--[if (gt IE 8)|(gt IEMobile 7)|!(IEMobile)|!(IE)]><!--><html class="no-js" lang="en" xmlns:wb="http://open.weibo.com/wb"><!--<![endif]-->

{% endcodeblock%}

- 在 `</head>` 之前添加script语句：
{% codeblock %}
+ <!-- load sina weibo share -->
+ <script src="http://tjs.sjs.sinajs.cn/open/api/js/wb.js?appkey=" type="text/javascript" charset="utf-8"></script>
+ </head>
{% endcodeblock%}

- 在 `source/_includes/post/sharing.html` 里面添加Button

{% codeblock %}
+  {% if site.weibo_share %}
+    <wb:share-button relateuid="xxxxxxxx" title="Share a blog  <<{{page.title}}>>" ></wb:share-button>
+  {% endif %}
{% endcodeblock%}

这里`site.weibo_share` 是用于在 `_config.yml` 上修改的，relateduid 就是你新浪微博的id， 当然这是自动生成的，另外title参数 请看 [这个列表](http://weibojs.com/widget/share.php#wb), 我这里就加了一个title

- 为了让上述改动有效在 `_config.yml` 添加一点信息：

{% codeblock %}
+ #weibo share
+ weibo_share: true
{% endcodeblock%}

## After ##
markdown 似乎在解析的时候遇到codeblock 会打断number list
这个[bug](https://github.com/imathis/octopress/issues/488)已经解决的 但是好像没有merge
需要手动merge
