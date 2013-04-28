---
layout: post
title: "Compile Optimize of JVM (Compiler Period)"
date: 2013-02-05 16:43
comments: true
categories: [JVM, Compiler]
---

> Compiler Period主要指javac的优化，而javac的优化体现在Syntactic Sugar
{% codeblock lang:java %}
try {
     initProcessAnnotations(processors); //处理Annotations
     // These method calls must be chained to avoid memory leaks
     /*
     * parseFile for 词法分析 
     * enterTrees for 语法分析
     */
     delegateCompiler =
         processAnnotations(
            enterTrees(stopIfError(CompileState.PARSE, parseFiles(sourceFileObjects))),
            classnames);            
     delegateCompiler.compile2();
     delegateCompiler.close();
     elapsed_msec = delegateCompiler.elapsed_msec;
} catch (Abort ex) {
    if (devVerbose)
        ex.printStackTrace(System.err);
} 
{% endcodeblock%}

## 1. 词法分析 ##
Called by method: `parseFiles(Iterable<JavaFileObject> fileObjects)` in `JavaCompiler.java` 
为了看得更清楚, 先设 `scannerDebug = true;` in `Scanner.java`

#### Step 1 :####

new a JavacParser, 在new的时候就先处理第一个token.

{% codeblock lang:java %}
protected JavacParser(ParserFactory fac, Lexer S, boolean keepDocComments, boolean keepLineMap) {
        this.S = S;
        S.nextToken(); // prime the pump
        this.F = fac.F;
        this.log = fac.log;
{% endcodeblock %}

读取的方法还是[LL(1)](http://en.wikipedia.org/wiki/LL\(1\))

大致步骤是：

1. 先判断是否是`class`,`interface`还是`Enum`, 然后跳到相应的不同Declaration去解析
{% codeblock lang:java %}
JCStatement classOrInterfaceOrEnumDeclaration(JCModifiers mods, String dc) {
    if (S.token() == CLASS) {
        return classDeclaration(mods, dc);   // for class
    } else if (S.token() == INTERFACE) {
        return interfaceDeclaration(mods, dc);  //for interface
    } else if (allowEnums) {
        if (S.token() == ENUM) {     // for enum
            return enumDeclaration(mods, dc);
        }
        ...
    }
{% endcodeblock %}

2.  如果是一个`class` 第二步处理各种 method， 处理完之后返回一个`JCMethodDecl` 类
比如 `public static void main（String[] args）` 这个方法最终生成如下
{% codeblock lang:java %}
JCMethodDecl MethodDef(JCModifiers mods, // 解析 public static 之后产生的修饰flag
                       Name name, // main
                       JCExpression restype,  //void
                       List<JCTypeParameter> typarams, //null
                       List<JCVariableDecl> params,  //String[] args
                       List<JCExpression> thrown, //null
                       JCBlock body, //body of method
                       JCExpression defaultValue) //null
{% endcodeblock %}

3.  所有的基本变量都是一个 `JCVariableDecl`， 包括一个JCModifiers表示修饰属性，Name表示名字，JCExpression init表示初始值 

{% codeblock lang:java %}
/**
* A variable definition.
* @param modifiers variable modifiers
* @param name variable name
* @param vartype type of the variable
* @param init variables initial value
* @param sym symbol
*/
public static class JCVariableDecl extends JCStatement implements VariableTree{
    protected JCVariableDecl(JCModifiers mods,Name name, 
                  JCExpression vartype, JCExpression init, VarSymbol sym) {
        ...
    }
}    
{% endcodeblock %}

4. 接下来就是处理method内部block。 如果是一个expression， like： `System.out.println("Hello World")`


