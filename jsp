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
 常用九大内置对象:
 pageContext request session application
 作用域对象 这些对象可以存值,它们的取值范围有限定 它们都有setAttribute() 和 gettribute()方法来存值
 它们的区别
 pageContext
 作用域仅限于当前页面,跳转到另外一个页面后就不是同一个对象了
 
 request
 同一请求下,属于同一对象,作用域限制于同一请求
 很明显在请求转发下,属于同一请求,而在重定向下是不同的两次请求
 
 session 作用域限制于一次会话
 很明显在默认情况下创建了session后 有效期30分钟 由于依托于cookie的,当关闭浏览器后存取sessionid 的cookie消失了,之前那个cookie无法访问了
 所以关闭浏览器前的访问都属于都已session,当然也不是所有访问都是属于一个session,拥有相同sessionidCookie的http请求才属于同一会话,什么时候才拥有
 同一sessionid呢? 我们创建session时会创建这个cookie 而cookie默认的路径setpath(也就是客户端当在什么路径下才带回这个cookie)是servlet的前一级,
 其实也就是web项目目录.所以其实保存sessionid 的cookie默认是被同一项目下所有子路径文件所公用的,所以当我们访问一个项目中的各种文件时,在不关闭浏览器
 的情况下都属于同一会话
 
 application对象  作用域限制于同一项目下 关闭服务器后就不能用了(这个对象明天继承了servletContext)
 从小到大应该是 pageContext request session application
 
 exception page config
 page其实就是jsp翻译成sevlet类后的一个实例对象
 exception是一个错误对象  可以打印错误信息
config可以获得这个翻译后的servlet类的一些配置信息
 
 out  response
 out对象 输出对象 向页面输出东西 jsp翻译成servlet后都是使用的这个out对象
 reponse对象 也是向页面输出东西 
 但是不同点是out输出的东西是输出到reponse的缓冲区中
 所以假如在一个jsp页面上同时有out和reponse语句
 那么最终呈现出来的很明显response输出的东西在前面,因为out放在了response的缓冲区中
 
 
 
 五jsp EL表达式
 可以使用EL表达式取出作用域对象中存的值(会输出在页面上)  作用域对象通过setAttribute存属性值
 ${ pageScope.name}比如这个会输出name属性的值在页面上
 ${ pageScope.name}  这里的name是存在每个对象里面的属性的名字 也就是属性名
 ${ requestScope.name}
  ${ sessionScope.name}
  ${ applicationScope.name}
 

 如果是数组的话 怎么用EL表达式取出存在作用域对象里面的
 比如 
 <%
 String[] a=new String[]{"aa","bb","cc","dd"};
 pageContext.setAttribute("array",a);
 %>
 ${ array[0]} , ${ array[0]}, ${ array[0]}, ${ array[0]}  在页面上的效果就是aa,bb,cc,dd
 
 如果存的是图的话,直接用属性名.key 就可以得到相应的value
 比如
 ${ map.name  }, ${map.age}
 
 注意:没有指定作用域然后直接取某个属性值的话,是从小到大去取的
 
 若是在jsp的作用域对象里面存入一个对象,并且这个对象里面有私有的成员变量的时候
  比如一个user对象 User user =new User("张三","13");  两个成员变量 一个name 一个age
  将这个对象存入属性中
  
  <%  pageContext.setAttribute("U",user); %>
  怎么访问这个属性存的值?
  ${ pageScope.u.name} 
  ${ pageScope.u.age}  EL表达式和java不一样  这里直接通过.的方式将属性的值(一个对象)里面的成员给引用了
也就是EL表达式可以通过.的方式得到属性值对象里面的成员 
 
 EL还有一些其他的作用
 ${ empty 对象 } 判断一个对象是否为空
 ${ } 在这里面可以进行+-*/的运算然后输出 也可以进行逻辑操作
 El的11个内置对象
 1pageScope
 2requestScope
 3sessionScope
 4applicationScope
 这四个EL内置对象用以在EL表达式内获得jsp内置对象设置的属性值
 
 5param(存参数的一个主要值)  比如${param.name}
 6paramvalues (是以String数组的形式储存参数的值) 这两个用来获得页面的参数(http请求带来的参数)  比如${paramValues.name[...]}
 
 7header
 8herderValues 用来获得http请求头的内容
 
 9pagecontext
 10cookie
 11Initparam
 
 EL主要是用来做取值操作并输出到jsp页面
 
 七JSTL  jsp标准标签库
 使用jstl
 1导入支持jstl的jar包到 wencont.里面的lib中
 2在jsp页面中用taglib指令 prefix ="c"标签库别名(默认为c)  uri 路径 快捷生成alt+/ 选择1.1
 
 
 常用标签
 <c:set var="name" value="zhangsan" scope=""></c:set>  相当于String name ="zhangsan",但是这个变量是存到了域当中去了(默认是pagecontext中)
 <c:if test="这里是一个逻辑表达式">  逻辑表达式是用EL来写的 ${ age>16 } 1.1支持EL 
    这里是会执行的语句(在test的值为true的情况下)
 </c:if>
 
 
 <c:foreach begin="" end="" var="" step="指定一个数字,跨越几步打印一次,增幅的意思,不是一步一步走了"></c:foreach> 在jstl里面遍历
 <c:foreach var="stu" items="要循环的数组或集合(就是某个存在作用域的属性)"></c;foreach>  用来遍历值为数组或者集合的属性 集合的每一项
 的值赋值给stu 然后可以使用stu取值 items=里面的值要用EL来取
 <c:foreach var="stu" items="list"> 循环往页面输出一行行的数据
 <tr>
 <td>${stu.name}</td>
 <td>${atu.age}</td>
 
 </c:foreach>
 
 注意在作用域对象中存的属性 要通过EL表达式取值 ${list}
 
 因为有jstl 所以就简化了jsp里面java的书写 可以不用<%%>来写一大堆java,因为可以通过EL直接取值 可以用jstl来判断和循环
 
 在jstl的if和foreach标签里面可以直接写html代码或者EL表达式
 
 
 
 
七jsp细节
 在jsp页面里面<%%>可以写java代码 很明显可以使用java的类 也可以使用自定义的类 只要在jsp页面里面导包就行
 在一个web项目里面,不能用正确的方式比如(filestream)读到java resourse里面的文件,因为最后这个src被整合到了web项目里面
 但是如果不在servlet,也就是不继承httpservlet的话也不能用servletcontext的方法,因此只有用类加载器,然后将文件放在src里面
 向页面输出东西方式
 1:不在<%%>里面 直接在外面写html标签
 2:在<%%>用out 和response
 3:在jstl的标签里面可以写html代码和E表达式 
 4使用EL取值输出
 
 所以EL+JSTL可以极大的省略jsp中java代码的书写
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
