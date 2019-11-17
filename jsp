一:什么是jsp
从用户角度看待,就是一个网页,从程序员看待,其实是一个java类,他继承了servlet,所以可以说jsp就是一个servlet
为什么会有jsp这种技术?
html多数情况下用来显示静态内容,他是不便的,但是如果我们需要在网页上显示一些动态的数据,一些会变化的数据,比如学生的信息.这些都需要去
查询数据库,然后在网页上显示,但是html是不支持java代码,jsp里面可以写java代码.

二jsp文件的构成
<%@ %> 这种带@可以写指令  一共有三种指令
1page指令 <%@page%>  设置一些页面信息
比如在web工程里面建设的jsp页面顶端一行
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
language属性指的是在jsp中可以写java代码
extends属性 指定jsp翻译成java文件后,继承的父类是谁,一般来说默认继承servlet
import属性 导包
session属性 值只有true和false 用于控制在这个jsp页面能否直接使用session这个对象
可以直接用session.get...  session就是已有的会话对象
errorPage属性 用于跳转去一个页面,如果当前页面出错了会跳转到这个页面 值是跳转的地址
ierrorPage属性 是发生错误后跳转的界面,用这个属性表名是否是错误界面 值有ture或false

2<%@include %> 包含指令 可以用于包含其他jsp文件的内容
比如<%@include file="url"%>
就是把另外一个页面的内容拿过来一起输出

3<%@taglib %> 标签库指令
<%@taglib  prefix="" uri=""%> prefix 标签库别名  uri是地址

三jsp动作标签  主要有三个 
1<jsp:include  page=""></jsp:include>
这个动作标签和include指令有相似的作用,用于包含指定的页面,但是是一种动态包含,它不是直接将一个页面的东西全部拿过来拼接,而是
将要拼接的页面先编译 ,得到最终结果后将内容放进来.
2<jsp:forward></jsp:forward> 
 前往那个界面 可以跳转向另外一个页面
 这个动作标签等同于
 <%  request.getRequestDispatcher("url?...").forward(request,response); %> 相当于一个请求转发
 3<jsp:param  ></jsp:param>
 意思是在包含某个页面或者跳转某个页面,带这个参数过去
 <jsp:foward page="">
<jsp:param name= " " value=" " ></jsp:param>   这个参数标签是写在跳转标签或者包含标签里面的
 
 </jsp:foward>
 在跳转页面怎么收这个参数? 用request.getParamter();
 
 中文乱码问题:
 首先在jsp文件顶部有三处设置,作用分别为:
 contentType="text/html; charset=utf-8"  jsp响应内容的编码  指的是jsp响应给浏览器时的编码,也就是我们看到的样子

pageEncoding="utf-8"  jsp编译为servlet时的编码  

<mete http-equiv="Content-Type" content="text/html; utf-8"  >html页面编码,以什么编码安排这个html

 而我们这里的中文问题和上面三个无关,因为他是在跳转时传递参数的问题,并且和之前request与response的问题也有所不同
 
 因为jsp的动作标签forward跳转实质是一种请求转发,请求只有一个,就是初始的请求,那么传递参数给另外一个页面之前,要设置请求的编码格式
 通过查看jsp翻译后的Servlet源码，可以发现jsp:forward是使用request的编码对jsp:param参数进行URLEncode的，
 所以我们可以设置request的编码格式
 在forward之前 要设置<% request.setCharacterSet("UTF-8");%>
 
 
 四jsp的内置对象
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
