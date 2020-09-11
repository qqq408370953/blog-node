-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: 2020-09-11 11:06:37
-- 服务器版本： 5.6.48-log
-- PHP Version: 5.6.40

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `myblog`
--

-- --------------------------------------------------------

--
-- 表的结构 `article`
--

CREATE TABLE `article` (
  `id` bigint(20) NOT NULL,
  `arttitle` text NOT NULL,
  `abstract` text NOT NULL,
  `category` bigint(20) NOT NULL,
  `tag` bigint(20) NOT NULL,
  `thumbnail` text,
  `content` text NOT NULL,
  `cdate` bigint(20) NOT NULL COMMENT '文章发布时间',
  `pv` int(11) NOT NULL DEFAULT '0' COMMENT '文章浏览量',
  `discuss` int(11) NOT NULL DEFAULT '0',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '文章状态：1-公开；0-未公开',
  `editdate` bigint(20) NOT NULL COMMENT '文章修改时间',
  `html` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- 转存表中的数据 `article`
--

INSERT INTO `article` (`id`, `arttitle`, `abstract`, `category`, `tag`, `thumbnail`, `content`, `cdate`, `pv`, `discuss`, `status`, `editdate`, `html`) VALUES
(2, 'vue 中一些API 或属性的常见用法', 'Vue (读音 /vjuː/，类似于 view) 是一套用于构建用户界面的渐进式框架。与其它大型框架不同的是，Vue 被设计为可以自底向上逐层应用。Vue 的核心库只关注视图层，不仅易于上手，还便于与第三方库或既有项目整合。另一方面，当与现代化的工具链以及各种支持类库结合使用时，Vue 也完全能够为复杂的单页应用提供驱动。', 10, 25, 'http://localhost:5000/\\uploads\\20200910\\1599724925195.png', '**prop**\n\n> 官方解释：Prop 是你可以在组件上注册的一些自定义特性。当一个值传递给一个 prop 特性的时候，它就变成了那个组件实例的一个属性。\n\n通俗点讲就是：prop是父组件用来传递数据的一个自定义属性。\n\n<pre><div class=\"hljs\">`Vue.component(<span class=\"hljs-string\">\'blog-post\'</span>, {\n  <span class=\"hljs-attr\">props</span>: [<span class=\"hljs-string\">\'title\'</span>],\n  <span class=\"hljs-attr\">template</span>: <span class=\"hljs-string\">\'&lt;h3&gt;{{ title }}&lt;/h3&gt;\'</span>\n})\n`</div></pre>\n\n一个组件默认可以拥有任意数量的 prop，任何值都可以传递给任何 prop。在上述模板中，你会发现我们能够在组件实例中访问这个值，就像访问 data 中的值一样。\n\n一个 prop 被注册之后，你就可以像这样把数据作为一个自定义特性传递进来：\n\n<pre><div class=\"hljs\">`&lt;blog-post title=<span class=\"hljs-string\">\"My journey with Vue\"</span>&gt;&lt;/blog-post&gt;\n&lt;blog-post title=\"Blogging with Vue\"&gt;&lt;/blog-post&gt;\n&lt;blog-post title=\"Why Vue is so fun\"&gt;&lt;/blog-post&gt;\n`</div></pre>\n\n结果如下\n\n![img.jpg](./0)\n\n* * *\n\n**单向数据流**\n\n所有的 prop 都使得其父子 prop 之间形成了一个单向下行绑定：父级 prop 的更新会向下流动到子组件中，但是反过来则不行。（父传子可以，子传父不行）这样会防止从子组件意外改变父级组件的状态，从而导致你的应用的数据流向难以理解。\n\n每次父级组件发生更新时，子组件中所有的 prop 都将会刷新为最新的值。这意味着你不应该在一个子组件内部改变 prop。如果你这样做了，Vue 会在浏览器的控制台中发出警告。（不能直接改props里面的值，可以定义一个属性或者方法来接受props里面的值后再操作）\n\n* * *\n\n官方举例：\n\n> 1.这个 prop 用来传递一个初始值；这个子组件接下来希望将其作为一个本地的 prop 数据来使用。在这种情况下，最好定义一个本地的 data 属性并将这个 prop 用作其初始值：\n<pre><div class=\"hljs\">`props: [<span class=\"hljs-string\">\'initialCounter\'</span>],\n<span class=\"hljs-attr\">data</span>: <span class=\"hljs-function\"><span class=\"hljs-keyword\">function</span> (<span class=\"hljs-params\"></span>) </span>{\n  <span class=\"hljs-keyword\">return</span> {\n    <span class=\"hljs-attr\">counter</span>: <span class=\"hljs-keyword\">this</span>.initialCounter\n  }\n}\n`</div></pre>\n> 2.这个 prop 以一种原始的值传入且需要进行转换。在这种情况下，最好使用这个 prop 的值来定义一个计算属性：\n<pre><div class=\"hljs\">`props: [<span class=\"hljs-string\">\'size\'</span>],\n<span class=\"hljs-attr\">computed</span>: {\n  <span class=\"hljs-attr\">normalizedSize</span>: <span class=\"hljs-function\"><span class=\"hljs-keyword\">function</span> (<span class=\"hljs-params\"></span>) </span>{\n    <span class=\"hljs-keyword\">return</span> <span class=\"hljs-keyword\">this</span>.size.trim().toLowerCase()\n  }\n}\n`</div></pre>\n\n**案例：prop父组件向子组件传值**\n\n**父组件：**\n\n<pre><div class=\"hljs\">`&lt;template&gt;\n  &lt;div&gt;\n    父组件:\n    &lt;input type=\"text\" v-model=\"name\"&gt;\n    &lt;br&gt;\n    &lt;br&gt;\n    &lt;!-- 引入子组件 --&gt;\n    &lt;child :inputName=\"name\"&gt;&lt;/child&gt;\n  &lt;/div&gt;\n&lt;/template&gt;\n&lt;script&gt;\n  import child from \'./child\'\n  export default {\n    components: {\n      child\n    },\n    data () {\n      return {\n        name: \'\'\n      }\n    }\n  }\n&lt;/script&gt;\n`</div></pre>\n\n**子组件：**\n\n<pre><div class=\"hljs\">`&lt;template&gt;\n  <span class=\"xml\"><span class=\"hljs-tag\">&lt;<span class=\"hljs-name\">div</span>&gt;</span>\n    子组件:\n    <span class=\"hljs-tag\">&lt;<span class=\"hljs-name\">span</span>&gt;</span>{{inputName}}<span class=\"hljs-tag\">&lt;/<span class=\"hljs-name\">span</span>&gt;</span>\n  <span class=\"hljs-tag\">&lt;/<span class=\"hljs-name\">div</span>&gt;</span></span>\n&lt;<span class=\"hljs-regexp\">/template&gt;\n&lt;script&gt;\n  export default {\n    /</span><span class=\"hljs-regexp\">/ 接受父组件的值\n    props: {\n      inputName: String,\n      required: true\n    }\n  }\n&lt;/</span>script&gt;\n`</div></pre>\n\n**emit  子组件向父组件传值：自定义事件，this.emit。**\n\n**子组件：**\n\n<pre><div class=\"hljs\">`&lt;template&gt;\n  <span class=\"xml\"><span class=\"hljs-tag\">&lt;<span class=\"hljs-name\">div</span>&gt;</span>\n    子组件:\n    <span class=\"hljs-tag\">&lt;<span class=\"hljs-name\">span</span>&gt;</span>{{childValue}}<span class=\"hljs-tag\">&lt;/<span class=\"hljs-name\">span</span>&gt;</span>\n    <span class=\"hljs-comment\">&lt;!-- 定义一个子组件传值的方法 --&gt;</span>\n    <span class=\"hljs-tag\">&lt;<span class=\"hljs-name\">input</span> <span class=\"hljs-attr\">type</span>=<span class=\"hljs-string\">\"button\"</span> <span class=\"hljs-attr\">value</span>=<span class=\"hljs-string\">\"点击触发\"</span> @<span class=\"hljs-attr\">click</span>=<span class=\"hljs-string\">\"childClick\"</span>&gt;</span>\n  <span class=\"hljs-tag\">&lt;/<span class=\"hljs-name\">div</span>&gt;</span>\n<span class=\"hljs-tag\">&lt;/<span class=\"hljs-name\">template</span>&gt;</span></span>\n&lt;script&gt;\n  <span class=\"hljs-keyword\">export</span> <span class=\"hljs-keyword\">default</span> {\n    data () {\n      <span class=\"hljs-keyword\">return</span> {\n        <span class=\"hljs-attr\">childValue</span>: <span class=\"hljs-string\">\'我是子组件的数据\'</span>\n      }\n    },\n    <span class=\"hljs-attr\">methods</span>: {\n      childClick () {\n        <span class=\"hljs-comment\">// childByValue是在父组件on监听的方法</span>\n        <span class=\"hljs-comment\">// 第二个参数this.childValue是需要传的值</span>\n        <span class=\"hljs-keyword\">this</span>.$emit(<span class=\"hljs-string\">\'childByValue\'</span>, <span class=\"hljs-keyword\">this</span>.childValue)\n      }\n    }\n  }\n&lt;<span class=\"hljs-regexp\">/script&gt;\n</span>`</div></pre>\n\n**父组件：**\n\n<pre><div class=\"hljs\">`&lt;template&gt;\n  <span class=\"xml\"><span class=\"hljs-tag\">&lt;<span class=\"hljs-name\">div</span>&gt;</span>\n    父组件:\n    <span class=\"hljs-tag\">&lt;<span class=\"hljs-name\">span</span>&gt;</span>{{name}}<span class=\"hljs-tag\">&lt;/<span class=\"hljs-name\">span</span>&gt;</span>\n    <span class=\"hljs-tag\">&lt;<span class=\"hljs-name\">br</span>&gt;</span>\n    <span class=\"hljs-tag\">&lt;<span class=\"hljs-name\">br</span>&gt;</span>\n    <span class=\"hljs-comment\">&lt;!-- 引入子组件 定义一个on的方法监听子组件的状态--&gt;</span>\n    <span class=\"hljs-tag\">&lt;<span class=\"hljs-name\">child</span> <span class=\"hljs-attr\">v-on:childByValue</span>=<span class=\"hljs-string\">\"childByValue\"</span>&gt;</span><span class=\"hljs-tag\">&lt;/<span class=\"hljs-name\">child</span>&gt;</span>\n  <span class=\"hljs-tag\">&lt;/<span class=\"hljs-name\">div</span>&gt;</span>\n<span class=\"hljs-tag\">&lt;/<span class=\"hljs-name\">template</span>&gt;</span>\n<span class=\"hljs-tag\">&lt;<span class=\"hljs-name\">script</span>&gt;</span><span class=\"javascript\">\n  <span class=\"hljs-keyword\">import</span> child <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'./child\'</span>\n  <span class=\"hljs-keyword\">export</span> <span class=\"hljs-keyword\">default</span> {\n    <span class=\"hljs-attr\">components</span>: {\n      child\n    },\n    data () {\n      <span class=\"hljs-keyword\">return</span> {\n        <span class=\"hljs-attr\">name</span>: <span class=\"hljs-string\">\'\'</span>\n      }\n    },\n    <span class=\"hljs-attr\">methods</span>: {\n      <span class=\"hljs-attr\">childByValue</span>: <span class=\"hljs-function\"><span class=\"hljs-keyword\">function</span> (<span class=\"hljs-params\">childValue</span>) </span>{\n        <span class=\"hljs-comment\">// childValue就是子组件传过来的值</span>\n        <span class=\"hljs-keyword\">this</span>.name = childValue\n      }\n    }\n  }\n</span><span class=\"hljs-tag\">&lt;/<span class=\"hljs-name\">script</span>&gt;</span>\n</span>`</div></pre>\n\n**以上讲了父传子，子传父，那么非父子组件直接如何传值呢？**\n\n_网上搜到了这样一个例子：vue事件总线（vue-bus）可实现非父子组件传值_\n\n**安装**\n\n<pre><div class=\"hljs\">`$ npm install vue-bus\n`</div></pre>\n\n如果在一个模块化工程中使用它，必须要通过 Vue.use() 明确地安装 vue-bus：\n\n<pre><div class=\"hljs\">`<span class=\"hljs-keyword\">import</span> Vue <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'vue\'</span>;\n<span class=\"hljs-keyword\">import</span> VueBus <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'vue-bus\'</span>;\nVue.use(VueBus);\n`</div></pre>\n\n如果使用全局的 script 标签，则无须如此（手动安装）。\n\n1.公共实例文件bus.js，作为公共数控中央总线\n\n<pre><div class=\"hljs\">`<span class=\"hljs-keyword\">import</span> Vue <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\"vue\"</span>;\n<span class=\"hljs-keyword\">export</span> <span class=\"hljs-keyword\">default</span> <span class=\"hljs-keyword\">new</span> Vue();\n`</div></pre>\n\n2.在组件A中传递参数\n\n<pre><div class=\"hljs\">`<span class=\"hljs-keyword\">import</span> Bus <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'../bus.js\'</span>;\n<span class=\"hljs-keyword\">export</span> <span class=\"hljs-keyword\">default</span> {\n  <span class=\"hljs-attr\">name</span>: <span class=\"hljs-string\">\'first\'</span>,\n  data () {\n    <span class=\"hljs-keyword\">return</span> {\n      <span class=\"hljs-attr\">value</span>: <span class=\"hljs-string\">\'我来自first.vue组件！\'</span>\n    }\n  },\n  <span class=\"hljs-attr\">methods</span>:{\n    add(){<span class=\"hljs-comment\">// 定义add方法，并将msg通过txt传给second组件</span>\n      Bus.$emit(<span class=\"hljs-string\">\'txt\'</span>,<span class=\"hljs-keyword\">this</span>.value);\n    }\n  }\n}\n`</div></pre>\n\n3.在组件B中接受参数\n\n<pre><div class=\"hljs\">`<span class=\"hljs-keyword\">import</span> Bus <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'../bus.js\'</span>;\n<span class=\"hljs-keyword\">export</span> <span class=\"hljs-keyword\">default</span> {\n  <span class=\"hljs-attr\">name</span>: <span class=\"hljs-string\">\'first\'</span>,\n  data () {\n    <span class=\"hljs-keyword\">return</span> {\n      <span class=\"hljs-attr\">value</span>: <span class=\"hljs-string\">\'我来自second.vue组件！\'</span>\n    }\n  },\n  <span class=\"hljs-attr\">methods</span>:{\n    add(){<span class=\"hljs-comment\">// 定义add方法，并将msg通过txt传给second组件</span>\n      Bus.$on(<span class=\"hljs-string\">\'txt\'</span>,()=&gt;{\n　　　　　　<span class=\"hljs-keyword\">this</span>.message=<span class=\"hljs-keyword\">this</span>.vue;\n　　　　});\n    }\n  }\n}\n`</div></pre>\n\n这样，就可以在第二个非父子关系的组件中，通过第三者bus.js来获取到第一个组件的value。\n\n兄弟组件之间与父子组件之间的数据交互，两者相比较，兄弟组件之间的通信其实和子组件向父组件传值有些类似，其实他们的通信原理都是相同的，\n\n例如子向父传值也是emit和on的形式，只是没有eventBus，但若我们仔细想想，此时父组件其实就充当了bus这个事件总线的角色。\n\n这种用一个Vue实例来作为中央事件总线来管理组件通信的方法只适用于通信需求简单一点的项目，对于更复杂的情况，Vue也有提供更复杂的状态管理模式Vuex来进行处理，请自行到官网进行学习。\n\nvue router按需加载\n\n<pre><div class=\"hljs\">`<span class=\"hljs-keyword\">import</span> VueRouter <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'vue-router\'</span>\n\n<span class=\"hljs-keyword\">import</span> Layout <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'components/layout\'</span>\n<span class=\"hljs-comment\">// import Layout_2 from \'components/layout1\'</span>\n<span class=\"hljs-keyword\">import</span> HeadTopbar <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'components/head_top_bar\'</span>\n<span class=\"hljs-keyword\">import</span> HeadTopbar1 <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'components/head_top_bar1\'</span>\n<span class=\"hljs-keyword\">import</span> TopBar1 <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'components/top_bar1\'</span>\n<span class=\"hljs-keyword\">import</span> TopBar2 <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'components/top_bar2\'</span>\n<span class=\"hljs-keyword\">import</span> TopBar3 <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'components/top_bar3\'</span>\n<span class=\"hljs-keyword\">import</span> TopBar4 <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'components/top_bar4\'</span>\n<span class=\"hljs-keyword\">import</span> TopBar5 <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'components/top_bar5\'</span>\n<span class=\"hljs-comment\">//MobileApp</span>\n<span class=\"hljs-comment\">// 登陆模块（按需加载,当渲染其他页面时才加载其组件,并缓存,减少首屏加载时间）</span>\n<span class=\"hljs-keyword\">const</span> Login = <span class=\"hljs-function\"><span class=\"hljs-params\">resolve</span> =&gt;</span> <span class=\"hljs-built_in\">require</span>([<span class=\"hljs-string\">\'views/login\'</span>], resolve)\n<span class=\"hljs-keyword\">const</span> LocalAllList = <span class=\"hljs-function\"><span class=\"hljs-params\">resolve</span> =&gt;</span> <span class=\"hljs-built_in\">require</span>([<span class=\"hljs-string\">\'views/MobileApp/local_all_list\'</span>], resolve)\n<span class=\"hljs-keyword\">const</span> Administration = <span class=\"hljs-function\"><span class=\"hljs-params\">resolve</span> =&gt;</span> <span class=\"hljs-built_in\">require</span>([<span class=\"hljs-string\">\'views/MobileApp/administration\'</span>], resolve)\n`</div></pre>\n\n**computed 和 methods  watch区别**\n\n**描述**\n\nvue 中computed 和methods 在使用效果来看可以说是一样的，但是深入看还是不一样的。区别就在于： computed 依赖缓存， methods 却不是。怎么理解呢？当Dom每次需要渲染computed的值，这个值已经处于缓存之中，不需要再重复的经历一遍计算过程，只有当computed依赖的数据变量发生变化，这个计算属性会自动更新，不需要渲染触发。methods 的值被获取的时候就会每次都会重新经历一遍计算过程。\n\n所以由此可以看出，computed和methods 的应用场景 和 计算过程的复杂程度有关， 如果计算过程复杂庞杂，而且计算属性会被经常调用（getter），那么最好使用缓存；如果，需要的值，计算简单，调用不频繁，实时性比较高（存在异步请求）,会比较适合methods\n\ncomputed有缓存，若相关数据未发生变化，则不调用；\n\nmethods无缓存，需要事件才能调用它（如点击等）；\n\nwatch多用于数据交互频繁的内容。（例如定时axios从服务器获取数据）。', 20200603165340, 72, 0, 1, 20200603165340, '<p><strong>prop</strong></p>\n<blockquote>\n<p>官方解释：Prop 是你可以在组件上注册的一些自定义特性。当一个值传递给一个 prop 特性的时候，它就变成了那个组件实例的一个属性。</p>\n</blockquote>\n<p>通俗点讲就是：prop是父组件用来传递数据的一个自定义属性。</p>\n<pre><div class=\"hljs\">`Vue.component(<span class=\"hljs-string\">\'blog-post\'</span>, {\n  <span class=\"hljs-attr\">props</span>: [<span class=\"hljs-string\">\'title\'</span>],\n  <span class=\"hljs-attr\">template</span>: <span class=\"hljs-string\">\'&lt;h3&gt;{{ title }}&lt;/h3&gt;\'</span>\n})\n`</div></pre>\n<p>一个组件默认可以拥有任意数量的 prop，任何值都可以传递给任何 prop。在上述模板中，你会发现我们能够在组件实例中访问这个值，就像访问 data 中的值一样。</p>\n<p>一个 prop 被注册之后，你就可以像这样把数据作为一个自定义特性传递进来：</p>\n<pre><div class=\"hljs\">`&lt;blog-post title=<span class=\"hljs-string\">\"My journey with Vue\"</span>&gt;&lt;/blog-post&gt;\n&lt;blog-post title=\"Blogging with Vue\"&gt;&lt;/blog-post&gt;\n&lt;blog-post title=\"Why Vue is so fun\"&gt;&lt;/blog-post&gt;\n`</div></pre>\n<p>结果如下</p>\n<p><img src=\"./0\" alt=\"img.jpg\" /></p>\n<hr />\n<p><strong>单向数据流</strong></p>\n<p>所有的 prop 都使得其父子 prop 之间形成了一个单向下行绑定：父级 prop 的更新会向下流动到子组件中，但是反过来则不行。（父传子可以，子传父不行）这样会防止从子组件意外改变父级组件的状态，从而导致你的应用的数据流向难以理解。</p>\n<p>每次父级组件发生更新时，子组件中所有的 prop 都将会刷新为最新的值。这意味着你不应该在一个子组件内部改变 prop。如果你这样做了，Vue 会在浏览器的控制台中发出警告。（不能直接改props里面的值，可以定义一个属性或者方法来接受props里面的值后再操作）</p>\n<hr />\n<p>官方举例：</p>\n<blockquote>\n<p>1.这个 prop 用来传递一个初始值；这个子组件接下来希望将其作为一个本地的 prop 数据来使用。在这种情况下，最好定义一个本地的 data 属性并将这个 prop 用作其初始值：</p>\n</blockquote>\n<pre><div class=\"hljs\">`props: [<span class=\"hljs-string\">\'initialCounter\'</span>],\n<span class=\"hljs-attr\">data</span>: <span class=\"hljs-function\"><span class=\"hljs-keyword\">function</span> (<span class=\"hljs-params\"></span>) </span>{\n  <span class=\"hljs-keyword\">return</span> {\n    <span class=\"hljs-attr\">counter</span>: <span class=\"hljs-keyword\">this</span>.initialCounter\n  }\n}\n`</div></pre>\n<blockquote>\n<p>2.这个 prop 以一种原始的值传入且需要进行转换。在这种情况下，最好使用这个 prop 的值来定义一个计算属性：</p>\n</blockquote>\n<pre><div class=\"hljs\">`props: [<span class=\"hljs-string\">\'size\'</span>],\n<span class=\"hljs-attr\">computed</span>: {\n  <span class=\"hljs-attr\">normalizedSize</span>: <span class=\"hljs-function\"><span class=\"hljs-keyword\">function</span> (<span class=\"hljs-params\"></span>) </span>{\n    <span class=\"hljs-keyword\">return</span> <span class=\"hljs-keyword\">this</span>.size.trim().toLowerCase()\n  }\n}\n`</div></pre>\n<p><strong>案例：prop父组件向子组件传值</strong></p>\n<p><strong>父组件：</strong></p>\n<pre><div class=\"hljs\">`&lt;template&gt;\n  &lt;div&gt;\n    父组件:\n    &lt;input type=\"text\" v-model=\"name\"&gt;\n    &lt;br&gt;\n    &lt;br&gt;\n    &lt;!-- 引入子组件 --&gt;\n    &lt;child :inputName=\"name\"&gt;&lt;/child&gt;\n  &lt;/div&gt;\n&lt;/template&gt;\n&lt;script&gt;\n  import child from \'./child\'\n  export default {\n    components: {\n      child\n    },\n    data () {\n      return {\n        name: \'\'\n      }\n    }\n  }\n&lt;/script&gt;\n`</div></pre>\n<p><strong>子组件：</strong></p>\n<pre><div class=\"hljs\">`&lt;template&gt;\n  <span class=\"xml\"><span class=\"hljs-tag\">&lt;<span class=\"hljs-name\">div</span>&gt;</span>\n    子组件:\n    <span class=\"hljs-tag\">&lt;<span class=\"hljs-name\">span</span>&gt;</span>{{inputName}}<span class=\"hljs-tag\">&lt;/<span class=\"hljs-name\">span</span>&gt;</span>\n  <span class=\"hljs-tag\">&lt;/<span class=\"hljs-name\">div</span>&gt;</span></span>\n&lt;<span class=\"hljs-regexp\">/template&gt;\n&lt;script&gt;\n  export default {\n    /</span><span class=\"hljs-regexp\">/ 接受父组件的值\n    props: {\n      inputName: String,\n      required: true\n    }\n  }\n&lt;/</span>script&gt;\n`</div></pre>\n<p><strong>emit  子组件向父组件传值：自定义事件，this.emit。</strong></p>\n<p><strong>子组件：</strong></p>\n<pre><div class=\"hljs\">`&lt;template&gt;\n  <span class=\"xml\"><span class=\"hljs-tag\">&lt;<span class=\"hljs-name\">div</span>&gt;</span>\n    子组件:\n    <span class=\"hljs-tag\">&lt;<span class=\"hljs-name\">span</span>&gt;</span>{{childValue}}<span class=\"hljs-tag\">&lt;/<span class=\"hljs-name\">span</span>&gt;</span>\n    <span class=\"hljs-comment\">&lt;!-- 定义一个子组件传值的方法 --&gt;</span>\n    <span class=\"hljs-tag\">&lt;<span class=\"hljs-name\">input</span> <span class=\"hljs-attr\">type</span>=<span class=\"hljs-string\">\"button\"</span> <span class=\"hljs-attr\">value</span>=<span class=\"hljs-string\">\"点击触发\"</span> @<span class=\"hljs-attr\">click</span>=<span class=\"hljs-string\">\"childClick\"</span>&gt;</span>\n  <span class=\"hljs-tag\">&lt;/<span class=\"hljs-name\">div</span>&gt;</span>\n<span class=\"hljs-tag\">&lt;/<span class=\"hljs-name\">template</span>&gt;</span></span>\n&lt;script&gt;\n  <span class=\"hljs-keyword\">export</span> <span class=\"hljs-keyword\">default</span> {\n    data () {\n      <span class=\"hljs-keyword\">return</span> {\n        <span class=\"hljs-attr\">childValue</span>: <span class=\"hljs-string\">\'我是子组件的数据\'</span>\n      }\n    },\n    <span class=\"hljs-attr\">methods</span>: {\n      childClick () {\n        <span class=\"hljs-comment\">// childByValue是在父组件on监听的方法</span>\n        <span class=\"hljs-comment\">// 第二个参数this.childValue是需要传的值</span>\n        <span class=\"hljs-keyword\">this</span>.$emit(<span class=\"hljs-string\">\'childByValue\'</span>, <span class=\"hljs-keyword\">this</span>.childValue)\n      }\n    }\n  }\n&lt;<span class=\"hljs-regexp\">/script&gt;\n</span>`</div></pre>\n<p><strong>父组件：</strong></p>\n<pre><div class=\"hljs\">`&lt;template&gt;\n  <span class=\"xml\"><span class=\"hljs-tag\">&lt;<span class=\"hljs-name\">div</span>&gt;</span>\n    父组件:\n    <span class=\"hljs-tag\">&lt;<span class=\"hljs-name\">span</span>&gt;</span>{{name}}<span class=\"hljs-tag\">&lt;/<span class=\"hljs-name\">span</span>&gt;</span>\n    <span class=\"hljs-tag\">&lt;<span class=\"hljs-name\">br</span>&gt;</span>\n    <span class=\"hljs-tag\">&lt;<span class=\"hljs-name\">br</span>&gt;</span>\n    <span class=\"hljs-comment\">&lt;!-- 引入子组件 定义一个on的方法监听子组件的状态--&gt;</span>\n    <span class=\"hljs-tag\">&lt;<span class=\"hljs-name\">child</span> <span class=\"hljs-attr\">v-on:childByValue</span>=<span class=\"hljs-string\">\"childByValue\"</span>&gt;</span><span class=\"hljs-tag\">&lt;/<span class=\"hljs-name\">child</span>&gt;</span>\n  <span class=\"hljs-tag\">&lt;/<span class=\"hljs-name\">div</span>&gt;</span>\n<span class=\"hljs-tag\">&lt;/<span class=\"hljs-name\">template</span>&gt;</span>\n<span class=\"hljs-tag\">&lt;<span class=\"hljs-name\">script</span>&gt;</span><span class=\"javascript\">\n  <span class=\"hljs-keyword\">import</span> child <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'./child\'</span>\n  <span class=\"hljs-keyword\">export</span> <span class=\"hljs-keyword\">default</span> {\n    <span class=\"hljs-attr\">components</span>: {\n      child\n    },\n    data () {\n      <span class=\"hljs-keyword\">return</span> {\n        <span class=\"hljs-attr\">name</span>: <span class=\"hljs-string\">\'\'</span>\n      }\n    },\n    <span class=\"hljs-attr\">methods</span>: {\n      <span class=\"hljs-attr\">childByValue</span>: <span class=\"hljs-function\"><span class=\"hljs-keyword\">function</span> (<span class=\"hljs-params\">childValue</span>) </span>{\n        <span class=\"hljs-comment\">// childValue就是子组件传过来的值</span>\n        <span class=\"hljs-keyword\">this</span>.name = childValue\n      }\n    }\n  }\n</span><span class=\"hljs-tag\">&lt;/<span class=\"hljs-name\">script</span>&gt;</span>\n</span>`</div></pre>\n<p><strong>以上讲了父传子，子传父，那么非父子组件直接如何传值呢？</strong></p>\n<p><em>网上搜到了这样一个例子：vue事件总线（vue-bus）可实现非父子组件传值</em></p>\n<p><strong>安装</strong></p>\n<pre><div class=\"hljs\">`$ npm install vue-bus\n`</div></pre>\n<p>如果在一个模块化工程中使用它，必须要通过 Vue.use() 明确地安装 vue-bus：</p>\n<pre><div class=\"hljs\">`<span class=\"hljs-keyword\">import</span> Vue <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'vue\'</span>;\n<span class=\"hljs-keyword\">import</span> VueBus <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'vue-bus\'</span>;\nVue.use(VueBus);\n`</div></pre>\n<p>如果使用全局的 script 标签，则无须如此（手动安装）。</p>\n<p>1.公共实例文件bus.js，作为公共数控中央总线</p>\n<pre><div class=\"hljs\">`<span class=\"hljs-keyword\">import</span> Vue <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\"vue\"</span>;\n<span class=\"hljs-keyword\">export</span> <span class=\"hljs-keyword\">default</span> <span class=\"hljs-keyword\">new</span> Vue();\n`</div></pre>\n<p>2.在组件A中传递参数</p>\n<pre><div class=\"hljs\">`<span class=\"hljs-keyword\">import</span> Bus <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'../bus.js\'</span>;\n<span class=\"hljs-keyword\">export</span> <span class=\"hljs-keyword\">default</span> {\n  <span class=\"hljs-attr\">name</span>: <span class=\"hljs-string\">\'first\'</span>,\n  data () {\n    <span class=\"hljs-keyword\">return</span> {\n      <span class=\"hljs-attr\">value</span>: <span class=\"hljs-string\">\'我来自first.vue组件！\'</span>\n    }\n  },\n  <span class=\"hljs-attr\">methods</span>:{\n    add(){<span class=\"hljs-comment\">// 定义add方法，并将msg通过txt传给second组件</span>\n      Bus.$emit(<span class=\"hljs-string\">\'txt\'</span>,<span class=\"hljs-keyword\">this</span>.value);\n    }\n  }\n}\n`</div></pre>\n<p>3.在组件B中接受参数</p>\n<pre><div class=\"hljs\">`<span class=\"hljs-keyword\">import</span> Bus <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'../bus.js\'</span>;\n<span class=\"hljs-keyword\">export</span> <span class=\"hljs-keyword\">default</span> {\n  <span class=\"hljs-attr\">name</span>: <span class=\"hljs-string\">\'first\'</span>,\n  data () {\n    <span class=\"hljs-keyword\">return</span> {\n      <span class=\"hljs-attr\">value</span>: <span class=\"hljs-string\">\'我来自second.vue组件！\'</span>\n    }\n  },\n  <span class=\"hljs-attr\">methods</span>:{\n    add(){<span class=\"hljs-comment\">// 定义add方法，并将msg通过txt传给second组件</span>\n      Bus.$on(<span class=\"hljs-string\">\'txt\'</span>,()=&gt;{\n　　　　　　<span class=\"hljs-keyword\">this</span>.message=<span class=\"hljs-keyword\">this</span>.vue;\n　　　　});\n    }\n  }\n}\n`</div></pre>\n<p>这样，就可以在第二个非父子关系的组件中，通过第三者bus.js来获取到第一个组件的value。</p>\n<p>兄弟组件之间与父子组件之间的数据交互，两者相比较，兄弟组件之间的通信其实和子组件向父组件传值有些类似，其实他们的通信原理都是相同的，</p>\n<p>例如子向父传值也是emit和on的形式，只是没有eventBus，但若我们仔细想想，此时父组件其实就充当了bus这个事件总线的角色。</p>\n<p>这种用一个Vue实例来作为中央事件总线来管理组件通信的方法只适用于通信需求简单一点的项目，对于更复杂的情况，Vue也有提供更复杂的状态管理模式Vuex来进行处理，请自行到官网进行学习。</p>\n<p>vue router按需加载</p>\n<pre><div class=\"hljs\">`<span class=\"hljs-keyword\">import</span> VueRouter <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'vue-router\'</span>\n\n<span class=\"hljs-keyword\">import</span> Layout <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'components/layout\'</span>\n<span class=\"hljs-comment\">// import Layout_2 from \'components/layout1\'</span>\n<span class=\"hljs-keyword\">import</span> HeadTopbar <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'components/head_top_bar\'</span>\n<span class=\"hljs-keyword\">import</span> HeadTopbar1 <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'components/head_top_bar1\'</span>\n<span class=\"hljs-keyword\">import</span> TopBar1 <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'components/top_bar1\'</span>\n<span class=\"hljs-keyword\">import</span> TopBar2 <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'components/top_bar2\'</span>\n<span class=\"hljs-keyword\">import</span> TopBar3 <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'components/top_bar3\'</span>\n<span class=\"hljs-keyword\">import</span> TopBar4 <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'components/top_bar4\'</span>\n<span class=\"hljs-keyword\">import</span> TopBar5 <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'components/top_bar5\'</span>\n<span class=\"hljs-comment\">//MobileApp</span>\n<span class=\"hljs-comment\">// 登陆模块（按需加载,当渲染其他页面时才加载其组件,并缓存,减少首屏加载时间）</span>\n<span class=\"hljs-keyword\">const</span> Login = <span class=\"hljs-function\"><span class=\"hljs-params\">resolve</span> =&gt;</span> <span class=\"hljs-built_in\">require</span>([<span class=\"hljs-string\">\'views/login\'</span>], resolve)\n<span class=\"hljs-keyword\">const</span> LocalAllList = <span class=\"hljs-function\"><span class=\"hljs-params\">resolve</span> =&gt;</span> <span class=\"hljs-built_in\">require</span>([<span class=\"hljs-string\">\'views/MobileApp/local_all_list\'</span>], resolve)\n<span class=\"hljs-keyword\">const</span> Administration = <span class=\"hljs-function\"><span class=\"hljs-params\">resolve</span> =&gt;</span> <span class=\"hljs-built_in\">require</span>([<span class=\"hljs-string\">\'views/MobileApp/administration\'</span>], resolve)\n`</div></pre>\n<p><strong>computed 和 methods  watch区别</strong></p>\n<p><strong>描述</strong></p>\n<p>vue 中computed 和methods 在使用效果来看可以说是一样的，但是深入看还是不一样的。区别就在于： computed 依赖缓存， methods 却不是。怎么理解呢？当Dom每次需要渲染computed的值，这个值已经处于缓存之中，不需要再重复的经历一遍计算过程，只有当computed依赖的数据变量发生变化，这个计算属性会自动更新，不需要渲染触发。methods 的值被获取的时候就会每次都会重新经历一遍计算过程。</p>\n<p>所以由此可以看出，computed和methods 的应用场景 和 计算过程的复杂程度有关， 如果计算过程复杂庞杂，而且计算属性会被经常调用（getter），那么最好使用缓存；如果，需要的值，计算简单，调用不频繁，实时性比较高（存在异步请求）,会比较适合methods</p>\n<p>computed有缓存，若相关数据未发生变化，则不调用；</p>\n<p>methods无缓存，需要事件才能调用它（如点击等）；</p>\n<p>watch多用于数据交互频繁的内容。（例如定时axios从服务器获取数据）。</p>\n'),
(4, '解决git/github下载速度缓慢的问题总汇', '官网下载Git时，速度几乎是超不过20KB，解决方法有很多，这里介绍几个简单粗暴的方法。这里使用windows系统作为演示，其他系统对号入座即可。', 11, 29, 'http://localhost:5000/\\uploads\\20200910\\1599724908040.png', '官网下载Git时，速度几乎是超不过20KB，解决方法有很多，这里介绍几个简单粗暴的方法。这里使用windows系统作为演示，其他系统对号入座即可。\n\n**方法一：淘宝镜像**\n\n淘宝有一个镜像的网站 可以提供下载：https://npm.taobao.org/mirrors/git-for-windows/\n点击上方链接，往下拉就会看到相应的版本，第一个最新版本，后面的是历史版本。 \n\n**方法二:利用码云来克隆GitHub项目，操作简单而且有效**\n\n1、首先需要一个码云账户，如果你没有，这个是官网地址——https://gitee.com/ 。\n2、如果没有账户,需要注册一个账户。注册使用手机号就可以，一分钟的事。\n3、新建一个仓库,选择导入已有仓库。\n4、找到你的GitHub网站，选择clone下的网址，复制。\n5、在上面链接中输入我们刚刚复制的要导入的github项目地址，然后点击创建。\n6、等待码云克隆项目，大概1-3分钟（由你的网络和要克隆项目大小决定）。\n7、克隆完成，下载我们码云上的项目（这个就是你正常下载速度了）。\n8、正常下载项目（原谅我的超级慢校园网速）。\n9、最后下载完成后，如果不需要这个项目了可以在码云上删除，我们只是想解决下载慢和下载不下来的问题而已，不要过多的创建无用项目。\n10、选择删除仓库，复制黑色验证信息到相应位置，点击确认删除，然后验证你的密码，就可以删除了。\n\n**方法三：修改hosts**\n\n第一步：去这个网站查询3个域名对应的IP地址，不能用ping来获取IP地址哦\n\n```html\nhttps://www.ipaddress.com/\n```\n第二步：在/etc/hosts文件中添加类似下面的3行\n```js\n192.30.253.113  github.com\n151.101.185.194 github.global.ssl.fastly.net\n192.30.253.120  codeload.github.com\n```\n第三步：重启网络\n```js\nsudo /etc/init.d/networking restart \n```\n现在可以飞快的下载Github上的代码了。\n\n转自：++http://www.fly63.com/article/detial/8409++', 20200610171408, 31, 0, 1, 20200610171408, '<p>官网下载Git时，速度几乎是超不过20KB，解决方法有很多，这里介绍几个简单粗暴的方法。这里使用windows系统作为演示，其他系统对号入座即可。</p>\n<p><strong>方法一：淘宝镜像</strong></p>\n<p>淘宝有一个镜像的网站 可以提供下载：https://npm.taobao.org/mirrors/git-for-windows/<br />\n点击上方链接，往下拉就会看到相应的版本，第一个最新版本，后面的是历史版本。</p>\n<p><strong>方法二:利用码云来克隆GitHub项目，操作简单而且有效</strong></p>\n<p>1、首先需要一个码云账户，如果你没有，这个是官网地址——https://gitee.com/ 。<br />\n2、如果没有账户,需要注册一个账户。注册使用手机号就可以，一分钟的事。<br />\n3、新建一个仓库,选择导入已有仓库。<br />\n4、找到你的GitHub网站，选择clone下的网址，复制。<br />\n5、在上面链接中输入我们刚刚复制的要导入的github项目地址，然后点击创建。<br />\n6、等待码云克隆项目，大概1-3分钟（由你的网络和要克隆项目大小决定）。<br />\n7、克隆完成，下载我们码云上的项目（这个就是你正常下载速度了）。<br />\n8、正常下载项目（原谅我的超级慢校园网速）。<br />\n9、最后下载完成后，如果不需要这个项目了可以在码云上删除，我们只是想解决下载慢和下载不下来的问题而已，不要过多的创建无用项目。<br />\n10、选择删除仓库，复制黑色验证信息到相应位置，点击确认删除，然后验证你的密码，就可以删除了。</p>\n<p><strong>方法三：修改hosts</strong></p>\n<p>第一步：去这个网站查询3个域名对应的IP地址，不能用ping来获取IP地址哦</p>\n<pre><div class=\"hljs\"><code class=\"lang-html\">https://www.ipaddress.com/\n</code></div></pre>\n<p>第二步：在/etc/hosts文件中添加类似下面的3行</p>\n<pre><div class=\"hljs\"><code class=\"lang-js\"><span class=\"hljs-number\">192.30</span><span class=\"hljs-number\">.253</span><span class=\"hljs-number\">.113</span>  github.com\n<span class=\"hljs-number\">151.101</span><span class=\"hljs-number\">.185</span><span class=\"hljs-number\">.194</span> github.global.ssl.fastly.net\n<span class=\"hljs-number\">192.30</span><span class=\"hljs-number\">.253</span><span class=\"hljs-number\">.120</span>  codeload.github.com\n</code></div></pre>\n<p>第三步：重启网络</p>\n<pre><div class=\"hljs\"><code class=\"lang-js\">sudo /etc/init.d/networking restart \n</code></div></pre>\n<p>现在可以飞快的下载Github上的代码了。</p>\n<p>转自：<ins>http://www.fly63.com/article/detial/8409</ins></p>\n'),
(8, 'vue中使用axios上传图片(文件)时遇到的问题', 'axios上传图片时不能设置header,header会自动设置,不要设置请求头,因为上传文件时请求头的mulpipart/formData格式需要boundary,boundary是浏览器自动给请求头内容添加的,如果设置了请求头header, boundary就会被覆盖,然后上传时就没有数据传到后台和后台报错\"no multipart boundary was found\"', 10, 25, 'http://localhost:5000/\\uploads\\20200910\\1599724895021.png', '**今天使用==axios上传图片==时遇到了这样的问题,如下图**\n\n![121.png](http://server.itemsblog.com/uploads/20200616/1592293759249.png)\n项目中其他axios请求可以正常使用啊，为啥图片上传这里出问题了呢，\n接着网上搜了一大堆资料，结果发现：\n> **axios上传图片时不能设置header, header会自动设置，不要设置请求头headers： {\'Content-Type\': \'......\'},因为上传文件时请求头的mulpipart/formData格式需要boundary,boundary是浏览器自动给请求头内容添加的,如果设置了请求头header,boundary就会被覆盖,  然后上传时就没有数据传到后台和后台报错 “no multipart boundary was found”!**\n\n看来只能特殊处理了，因为其他的axios需要设置请求头。\n\n**解决方法**\n\n在main.js中设置以下代码\n```js\nimport axios from \'axios\';\n.\n.\n.\nlet instance=axios.create({\n    baseURL:process.env.API_ROOT,//请求的url\n    timeout:1000,//可自行选择设置时间\n});\nVue.prototype.instance=instance;\n```\n然后在图片上传处引用：\n```js\nthis.instance.post(`${this.baseURL}/upload`, formdata).then((res)=>{\n    let _res = res.data;\n    this.$refs.md.$img2Url(pos, _res.data);\n});\n```\n打开控制台后,请求成功，如下图。\n\n![222.png](http://server.itemsblog.com/uploads/20200616/1592293844525.png)', 20200616155049, 9, 0, 1, 20200616155049, '<p><strong>今天使用<mark>axios上传图片</mark>时遇到了这样的问题,如下图</strong></p>\n<p><img src=\"http://server.itemsblog.com/uploads/20200616/1592293759249.png\" alt=\"121.png\" /><br />\n项目中其他axios请求可以正常使用啊，为啥图片上传这里出问题了呢，<br />\n接着网上搜了一大堆资料，结果发现：</p>\n<blockquote>\n<p><strong>axios上传图片时不能设置header, header会自动设置，不要设置请求头headers： {‘Content-Type’: ‘…’},因为上传文件时请求头的mulpipart/formData格式需要boundary,boundary是浏览器自动给请求头内容添加的,如果设置了请求头header,boundary就会被覆盖,  然后上传时就没有数据传到后台和后台报错 “no multipart boundary was found”!</strong></p>\n</blockquote>\n<p>看来只能特殊处理了，因为其他的axios需要设置请求头。</p>\n<p><strong>解决方法</strong></p>\n<p>在main.js中设置以下代码</p>\n<pre><div class=\"hljs\"><code class=\"lang-js\"><span class=\"hljs-keyword\">import</span> axios <span class=\"hljs-keyword\">from</span> <span class=\"hljs-string\">\'axios\'</span>;\n.\n.\n.\nlet instance=axios.create({\n    <span class=\"hljs-attr\">baseURL</span>:process.env.API_ROOT,<span class=\"hljs-comment\">//请求的url</span>\n    timeout:<span class=\"hljs-number\">1000</span>,<span class=\"hljs-comment\">//可自行选择设置时间</span>\n});\nVue.prototype.instance=instance;\n</code></div></pre>\n<p>然后在图片上传处引用：</p>\n<pre><div class=\"hljs\"><code class=\"lang-js\"><span class=\"hljs-keyword\">this</span>.instance.post(<span class=\"hljs-string\">`<span class=\"hljs-subst\">${<span class=\"hljs-keyword\">this</span>.baseURL}</span>/upload`</span>, formdata).then(<span class=\"hljs-function\">(<span class=\"hljs-params\">res</span>)=&gt;</span>{\n    <span class=\"hljs-keyword\">let</span> _res = res.data;\n    <span class=\"hljs-keyword\">this</span>.$refs.md.$img2Url(pos, _res.data);\n});\n</code></div></pre>\n<p>打开控制台后,请求成功，如下图。</p>\n<p><img src=\"http://server.itemsblog.com/uploads/20200616/1592293844525.png\" alt=\"222.png\" /></p>\n');

-- --------------------------------------------------------

--
-- 表的结构 `category`
--

CREATE TABLE `category` (
  `id` int(11) NOT NULL,
  `categoryname` text NOT NULL,
  `categorydesc` text NOT NULL,
  `cdate` bigint(20) NOT NULL DEFAULT '1582612530978' COMMENT '创建时间',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '分类状态, 1-可用，0-不可用'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- 转存表中的数据 `category`
--

INSERT INTO `category` (`id`, `categoryname`, `categorydesc`, `cdate`, `status`) VALUES
(10, '原创', '#d3adf7', 20200602190721, 1),
(11, '转载', 'gold', 20200603163415, 1),
(12, '混撰', 'cyan', 20200610163637, 1);

-- --------------------------------------------------------

--
-- 表的结构 `comment`
--

CREATE TABLE `comment` (
  `id` int(11) NOT NULL,
  `artId` bigint(20) NOT NULL COMMENT '文章id',
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_uname` text CHARACTER SET utf8 NOT NULL,
  `from_uemail` text CHARACTER SET utf8 NOT NULL,
  `from_uavatar` text CHARACTER SET utf8 NOT NULL,
  `to_uname` text CHARACTER SET utf8,
  `to_uavatar` text CHARACTER SET utf8,
  `to_uemail` text CHARACTER SET utf8,
  `cdate` bigint(20) NOT NULL COMMENT '评论回复时间',
  `from_uweb` text CHARACTER SET utf8,
  `to_uweb` text CHARACTER SET utf8,
  `oldContent` text COLLATE utf8mb4_unicode_ci,
  `oldCdate` bigint(20) DEFAULT NULL COMMENT '被回复的内容的回复时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- 表的结构 `link`
--

CREATE TABLE `link` (
  `id` int(11) NOT NULL,
  `siteName` text NOT NULL,
  `siteUrl` text NOT NULL,
  `status` int(11) DEFAULT '0' COMMENT '链接状态, 1-可用，0-不可用',
  `cdate` bigint(20) NOT NULL DEFAULT '1582612530977' COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- 表的结构 `nav`
--

CREATE TABLE `nav` (
  `id` bigint(20) NOT NULL,
  `title` text NOT NULL,
  `img` text NOT NULL,
  `homeurl` text NOT NULL,
  `githuburl` text NOT NULL,
  `describes` text NOT NULL,
  `details` text NOT NULL,
  `detailhtml` longtext NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '文章状态：1-公开；0-未公开',
  `cdate` bigint(20) NOT NULL COMMENT '文章发布时间',
  `editdate` bigint(20) NOT NULL COMMENT '文章修改时间',
  `types` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- 转存表中的数据 `nav`
--

INSERT INTO `nav` (`id`, `title`, `img`, `homeurl`, `githuburl`, `describes`, `details`, `detailhtml`, `status`, `cdate`, `editdate`, `types`) VALUES
(32, 'Vue', 'http://server.itemsblog.com\\uploads\\20200611\\1591868294899.png', 'https://cn.vuejs.org/', 'https://github.com/vuejs/vue', 'Vue.js是一套构建用户界面的渐进式JavaScript框架', '**Vue的特点**\n<br/>\n**1、易用**\n已经会了 HTML、CSS、JavaScript？即刻阅读指南开始构建应用！\n\n**2、灵活**\n不断繁荣的生态系统，可以在一个库和一套完整框架之间自如伸缩。\n\n**3、高效**\n20kB min+gzip 运行大小\n超快虚拟 DOM \n最省心的优化\n<br/>\n**Vue的安装**\nVue.js 提供一个官方命令行工具，可用于快速搭建大型单页应用： \n```html\n//全局安装 vue-cli\nnpm install --global vue-cli\n//创建一个基于 webpack 模板的新项目\nvue init webpack my-project\n//这里需要进行一些配置，默认回车即可\n```\n进入项目，安装并运行：  \n```html\ncd my-project\nnpm install\nnpm run dev\n```\n', '<p><strong>Vue的特点</strong><br />\n<br/><br />\n<strong>1、易用</strong><br />\n已经会了 HTML、CSS、JavaScript？即刻阅读指南开始构建应用！</p>\n<p><strong>2、灵活</strong><br />\n不断繁荣的生态系统，可以在一个库和一套完整框架之间自如伸缩。</p>\n<p><strong>3、高效</strong><br />\n20kB min+gzip 运行大小<br />\n超快虚拟 DOM<br />\n最省心的优化<br />\n<br/><br />\n<strong>Vue的安装</strong><br />\nVue.js 提供一个官方命令行工具，可用于快速搭建大型单页应用：</p>\n<pre><div class=\"hljs\"><code class=\"lang-html\">//全局安装 vue-cli\nnpm install --global vue-cli\n//创建一个基于 webpack 模板的新项目\nvue init webpack my-project\n//这里需要进行一些配置，默认回车即可\n</code></div></pre>\n<p>进入项目，安装并运行：</p>\n<pre><div class=\"hljs\"><code class=\"lang-html\">cd my-project\nnpm install\nnpm run dev\n</code></div></pre>\n', 1, 20200611173822, 20200611173822, '框架/库'),
(33, 'TypeScript', 'http://server.itemsblog.com\\uploads\\20200612\\1591931843219.png', 'http://www.typescriptlang.org', 'https://github.com/Microsoft/TypeScript', '一种由微软开发的自由和开源的编程语言。它是JavaScript的一个超集', '**始于JavaScript，归于JavaScript**\n\nTypeScript从今天数以百万计的JavaScript开发者所熟悉的语法和语义开始。使用现有的JavaScript代码，包括流行的JavaScript库，并从JavaScript代码中调用TypeScript代码。\n\nTypeScript可以编译出纯净、 简洁的JavaScript代码，并且可以运行在任何浏览器上、Node.js环境中和任何支持ECMAScript 3（或更高版本）的JavaScript引擎中。\n\n**强大的工具构建 大型应用程序**\n\n类型允许JavaScript开发者在开发JavaScript应用程序时使用高效的开发工具和常用操作比如静态检查和代码重构。\n\n类型是可选的，类型推断让一些类型的注释使你的代码的静态验证有很大的不同。类型让你定义软件组件之间的接口和洞察现有JavaScript库的行为。\n\n\n\n**先进的 JavaScript**\n\nTypeScript提供最新的和不断发展的JavaScript特性，包括那些来自2015年的ECMAScript和未来的提案中的特性，比如异步功能和Decorators，以帮助建立健壮的组件。\n\n这些特性为高可信应用程序开发时是可用的，但是会被编译成简洁的ECMAScript3（或更新版本）的JavaScript。', '<p><strong>始于JavaScript，归于JavaScript</strong></p>\n<p>TypeScript从今天数以百万计的JavaScript开发者所熟悉的语法和语义开始。使用现有的JavaScript代码，包括流行的JavaScript库，并从JavaScript代码中调用TypeScript代码。</p>\n<p>TypeScript可以编译出纯净、 简洁的JavaScript代码，并且可以运行在任何浏览器上、Node.js环境中和任何支持ECMAScript 3（或更高版本）的JavaScript引擎中。</p>\n<p><strong>强大的工具构建 大型应用程序</strong></p>\n<p>类型允许JavaScript开发者在开发JavaScript应用程序时使用高效的开发工具和常用操作比如静态检查和代码重构。</p>\n<p>类型是可选的，类型推断让一些类型的注释使你的代码的静态验证有很大的不同。类型让你定义软件组件之间的接口和洞察现有JavaScript库的行为。</p>\n<p><strong>先进的 JavaScript</strong></p>\n<p>TypeScript提供最新的和不断发展的JavaScript特性，包括那些来自2015年的ECMAScript和未来的提案中的特性，比如异步功能和Decorators，以帮助建立健壮的组件。</p>\n<p>这些特性为高可信应用程序开发时是可用的，但是会被编译成简洁的ECMAScript3（或更新版本）的JavaScript。</p>\n', 1, 20200612111810, 20200612111810, '模块/管理'),
(34, 'Flutter', 'http://server.itemsblog.com\\uploads\\20200612\\1591932196832.png', 'https://flutter.io/', 'https://github.com/flutter/', '谷歌推出的跨平台移动UI框架', 'Flutter是Google用以帮助开发者在Ios和Android两个平台开发高质量原生应用的全新移动UI框架。\n\n\n\n**Flutter的优点**\n1、热重载（Hot Reload）：利用Android Studio直接一个ctrl+s就可以保存并重载，模拟器立马就可以看见效果。\n2、一切皆为控件Widget的理念， 在Flutter中，每个应用程序都是Widget 。 \n3、借助可移植的GPU加速的渲染引擎以及高性能本地代码运行时以达到跨平台设备的高质量用户体验。 ', '<p>Flutter是Google用以帮助开发者在Ios和Android两个平台开发高质量原生应用的全新移动UI框架。</p>\n<p><strong>Flutter的优点</strong><br />\n1、热重载（Hot Reload）：利用Android Studio直接一个ctrl+s就可以保存并重载，模拟器立马就可以看见效果。<br />\n2、一切皆为控件Widget的理念， 在Flutter中，每个应用程序都是Widget 。<br />\n3、借助可移植的GPU加速的渲染引擎以及高性能本地代码运行时以达到跨平台设备的高质量用户体验。</p>\n', 1, 20200612112342, 20200612112342, '移动端UI框架'),
(35, 'react', 'http://server.itemsblog.com\\uploads\\20200612\\1591939551235.png', 'https://reactjs.org/', 'https://github.com/facebook/react', 'Facebook开发的一款高效、灵活、声明式设计的JS库', 'React 起源于 Facebook 的内部项目，因为该公司对市场上所有 JavaScript MVC 框架，都不满意，就决定自己写一套，用来架设Instagram 的网站。做出来以后，发现这套东西很好用，就在2013年5月开源了。\n\n\n\n**React特点**\n1.声明式设计 −React采用声明范式，可以轻松描述应用。 \n\n2.高效 −React通过对DOM的模拟，最大限度地减少与DOM的交互。 \n\n3.灵活 −React可以与已知的库或框架很好地配合。 \n\n4.JSX − JSX 是 JavaScript 语法的扩展。React 开发不一定使用 JSX ，但我们建议使用它。\n\n 5.组件 − 通过 React 构建组件，使得代码更加容易得到复用，能够很好的应用在大项目的开发中。\n\n 6.单向响应的数据流 − React 实现了单向响应的数据流，从而减少了重复代码，这也是它为什么比传统数据绑定更简单。\n\n\n\n**React安装与使用**\n```html\nnpm install -g create-react-app\ncreate-react-app my-app\n\ncd my-app\nnpm start\n```\n一个最简单的React例子如下:\n```html\nReactDOM.render(\n  <h1>Hello, world!</h1>,\n  document.getElementById(\'root\')\n);\n```\n在使用前，建议你先熟悉一下这些内容：箭头函数， 类， 模板字符串， let， 和 const 声明，Babel...', '<p>React 起源于 Facebook 的内部项目，因为该公司对市场上所有 JavaScript MVC 框架，都不满意，就决定自己写一套，用来架设Instagram 的网站。做出来以后，发现这套东西很好用，就在2013年5月开源了。</p>\n<p><strong>React特点</strong><br />\n1.声明式设计 −React采用声明范式，可以轻松描述应用。</p>\n<p>2.高效 −React通过对DOM的模拟，最大限度地减少与DOM的交互。</p>\n<p>3.灵活 −React可以与已知的库或框架很好地配合。</p>\n<p>4.JSX − JSX 是 JavaScript 语法的扩展。React 开发不一定使用 JSX ，但我们建议使用它。</p>\n<p>5.组件 − 通过 React 构建组件，使得代码更加容易得到复用，能够很好的应用在大项目的开发中。</p>\n<p>6.单向响应的数据流 − React 实现了单向响应的数据流，从而减少了重复代码，这也是它为什么比传统数据绑定更简单。</p>\n<p><strong>React安装与使用</strong></p>\n<pre><div class=\"hljs\"><code class=\"lang-html\">npm install -g create-react-app\ncreate-react-app my-app\n\ncd my-app\nnpm start\n</code></div></pre>\n<p>一个最简单的React例子如下:</p>\n<pre><div class=\"hljs\"><code class=\"lang-html\">ReactDOM.render(\n  <span class=\"hljs-tag\">&lt;<span class=\"hljs-name\">h1</span>&gt;</span>Hello, world!<span class=\"hljs-tag\">&lt;/<span class=\"hljs-name\">h1</span>&gt;</span>,\n  document.getElementById(\'root\')\n);\n</code></div></pre>\n<p>在使用前，建议你先熟悉一下这些内容：箭头函数， 类， 模板字符串， let， 和 const 声明，Babel…</p>\n', 1, 20200612132713, 20200612132713, '框架/库'),
(36, 'AngularJS', 'http://server.itemsblog.com\\uploads\\20200612\\1591940054562.png', 'https://angularjs.org/', 'https://github.com/angular/angular.js', 'Google推出有条理，可维护，易编程的MVVM框架', 'AngularJS 诞生于2009年，由Misko Hevery 等人创建，后为Google所收购。是一款优秀的前端JS框架，已经被用于Google的多款产品当中。\n\nAngularJS有着诸多特性，最为核心的是：MVW（Model-View-Whatever）、模块化、自动化双向数据绑定、语义化标签、依赖注入等等。 \n\nAngularJS 是一个 JavaScript框架。它是一个以 JavaScript 编写的库。它可通过script标签添加到HTML 页面。 AngularJS 通过 指令 扩展了 HTML，且通过 表达式 绑定数据到 HTML。\n\nAngularJS 是以一个 JavaScript 文件形式发布的，可通过script标签添加到网页中。\n\n\n\n**AngularJS组件**\nAngularJS提供了很多功能丰富的组件，处理核心的ng组件外，还扩展了很多常用的功能组件，如ngRoute(路由)，ngAnimate(动画)，ngTouch(移动端操作)等，只需要引入相应的头文件，并依赖注入你的工作模块，则可使用。\n\n\n\n**AngularJS安装与使用**\n1.首先确认安装了node.js和npm\n```html\n// 显示当前node和npm版本\n$ node -v\n$ npm -v\n// node 版本高于6.9.3 npm版本高于3.0.0\n```\n2.全局安装typescript（可选） \n```html\n$ npm install -g typescript \n// 新建项目的时候会自动安装typescript(非全局)所以这里也可以不用安装。\n```\n3.安装Angular CLI  \n```html\nnpm install -g @angular/cli\n```\n4.新建Angular项目\n```html\nng new my-app\n```\n5.安装完成之后就可以启动项目了\n```html\ncd my-app\nng serve -open\n```', '<p>AngularJS 诞生于2009年，由Misko Hevery 等人创建，后为Google所收购。是一款优秀的前端JS框架，已经被用于Google的多款产品当中。</p>\n<p>AngularJS有着诸多特性，最为核心的是：MVW（Model-View-Whatever）、模块化、自动化双向数据绑定、语义化标签、依赖注入等等。</p>\n<p>AngularJS 是一个 JavaScript框架。它是一个以 JavaScript 编写的库。它可通过script标签添加到HTML 页面。 AngularJS 通过 指令 扩展了 HTML，且通过 表达式 绑定数据到 HTML。</p>\n<p>AngularJS 是以一个 JavaScript 文件形式发布的，可通过script标签添加到网页中。</p>\n<p><strong>AngularJS组件</strong><br />\nAngularJS提供了很多功能丰富的组件，处理核心的ng组件外，还扩展了很多常用的功能组件，如ngRoute(路由)，ngAnimate(动画)，ngTouch(移动端操作)等，只需要引入相应的头文件，并依赖注入你的工作模块，则可使用。</p>\n<p><strong>AngularJS安装与使用</strong><br />\n1.首先确认安装了node.js和npm</p>\n<pre><div class=\"hljs\"><code class=\"lang-html\">// 显示当前node和npm版本\n$ node -v\n$ npm -v\n// node 版本高于6.9.3 npm版本高于3.0.0\n</code></div></pre>\n<p>2.全局安装typescript（可选）</p>\n<pre><div class=\"hljs\"><code class=\"lang-html\">$ npm install -g typescript \n// 新建项目的时候会自动安装typescript(非全局)所以这里也可以不用安装。\n</code></div></pre>\n<p>3.安装Angular CLI</p>\n<pre><div class=\"hljs\"><code class=\"lang-html\">npm install -g @angular/cli\n</code></div></pre>\n<p>4.新建Angular项目</p>\n<pre><div class=\"hljs\"><code class=\"lang-html\">ng new my-app\n</code></div></pre>\n<p>5.安装完成之后就可以启动项目了</p>\n<pre><div class=\"hljs\"><code class=\"lang-html\">cd my-app\nng serve -open\n</code></div></pre>\n', 1, 20200612133537, 20200612133537, '框架/库'),
(37, 'backbone', 'http://server.itemsblog.com\\uploads\\20200612\\1591942522617.png', 'http://backbonejs.org/', 'https://github.com/jashkenas/backbone', '提供：模型、集合、视图，开发重量级的javascript应用的框架', '**Backbone的介绍**\nBackbone.js为复杂WEB应用程序提供模型(models)、集合(collections)、视图(views)的结构。其中模型用于绑定键值数据和自定义事件；集合附有可枚举函数的丰富API； 视图可以声明事件处理函数，并通过RESRful JSON接口连接到应用程序。\n\n当我们开发含有大量Javascript的web应用程序时，首先你需要做的事情之一便是停止向DOM对象附加数据。 通过复杂多变的jQuery选择符和回调函数很容易创建Javascript应用程序，包括在HTML UI，Javascript逻辑和数据之间保持同步，都不复杂。 但对富客户端应用来说，良好的架构通常是有很多益处的。\n\n通过Backbone，你可以将数据呈现为 Models, 你可以对模型进行创建，验证和销毁，以及将它保存到服务器。 任何时候只要UI事件引起模型内的属性变化，模型会触发\"change\"事件； 所有显示模型数据的 Views 会接收到该事件的通知，继而视图重新渲染。 你无需查找DOM来搜索指定id的元素去手动更新HTML。 — 当模型改变了，视图便会自动变化。\n\n某种意义上说，在用javaScript来创建web项目时，Backbone试图定义一组最小而高效的集合，包括了数据结构（models（模型） 和 collections（集合））和用户接口（views（视图） 和 URLS）。在web开发环境里，到处都是框架（帮你写好了一切），不过这些库需要你的网站在构建的时候符合该框架的样子，风格，默认的行为。但是，Backbone还是作为一个工具，让你可以随心所欲的设计你的网站。\n\n\n\n**backbone的使用**\n1：基于jquery(针对试图的实现具体的效果，操作dom)，服务器环境，面向对象\n\n 2：基于underscore.js库--作用是：提供了80多种方法，包括数组，对象，事件中的方法，有利于对backbone中的数据模型和集合的操作。\n\n', '<p><strong>Backbone的介绍</strong><br />\nBackbone.js为复杂WEB应用程序提供模型(models)、集合(collections)、视图(views)的结构。其中模型用于绑定键值数据和自定义事件；集合附有可枚举函数的丰富API； 视图可以声明事件处理函数，并通过RESRful JSON接口连接到应用程序。</p>\n<p>当我们开发含有大量Javascript的web应用程序时，首先你需要做的事情之一便是停止向DOM对象附加数据。 通过复杂多变的jQuery选择符和回调函数很容易创建Javascript应用程序，包括在HTML UI，Javascript逻辑和数据之间保持同步，都不复杂。 但对富客户端应用来说，良好的架构通常是有很多益处的。</p>\n<p>通过Backbone，你可以将数据呈现为 Models, 你可以对模型进行创建，验证和销毁，以及将它保存到服务器。 任何时候只要UI事件引起模型内的属性变化，模型会触发&quot;change&quot;事件； 所有显示模型数据的 Views 会接收到该事件的通知，继而视图重新渲染。 你无需查找DOM来搜索指定id的元素去手动更新HTML。 — 当模型改变了，视图便会自动变化。</p>\n<p>某种意义上说，在用javaScript来创建web项目时，Backbone试图定义一组最小而高效的集合，包括了数据结构（models（模型） 和 collections（集合））和用户接口（views（视图） 和 URLS）。在web开发环境里，到处都是框架（帮你写好了一切），不过这些库需要你的网站在构建的时候符合该框架的样子，风格，默认的行为。但是，Backbone还是作为一个工具，让你可以随心所欲的设计你的网站。</p>\n<p><strong>backbone的使用</strong><br />\n1：基于jquery(针对试图的实现具体的效果，操作dom)，服务器环境，面向对象</p>\n<p>2：基于underscore.js库–作用是：提供了80多种方法，包括数组，对象，事件中的方法，有利于对backbone中的数据模型和集合的操作。</p>\n', 1, 20200612141546, 20200612141546, '框架/库'),
(38, 'jquery', 'http://server.itemsblog.com\\uploads\\20200612\\1591942602040.png', 'http://jquery.com/', 'https://github.com/jquery/jquery', '一个快速、简洁的JavaScript代码库', 'jquery倡导的是写更少的代码，做更多的事情，它优化HTML文档操作、事件处理、动画设计和Ajax交互，使用它不用考虑js浏览器的兼容问题，如IE 6.0+、FF 1.5+、Safari 2.0+、Opera 9.0+等都是兼容的。\n\n\n\n**jQuery的核心特性** \n1、独特的链式语法和短小清晰的多功能接口\n\n2、具有高效灵活的css选择器，并且可对CSS选择器进行扩展 \n\n3、拥有便捷的插件扩展机制和丰富的插件\n\n\n\n**jQuery的语言特点**\n1、快速获取文档元素\n2、提供漂亮的页面动态效果\n3、创建AJAX无刷新网页\n4、提供对JavaScript语言的增强\n5、增强的事件处理\n6、更改网页内容', '<p>jquery倡导的是写更少的代码，做更多的事情，它优化HTML文档操作、事件处理、动画设计和Ajax交互，使用它不用考虑js浏览器的兼容问题，如IE 6.0+、FF 1.5+、Safari 2.0+、Opera 9.0+等都是兼容的。</p>\n<p><strong>jQuery的核心特性</strong><br />\n1、独特的链式语法和短小清晰的多功能接口</p>\n<p>2、具有高效灵活的css选择器，并且可对CSS选择器进行扩展</p>\n<p>3、拥有便捷的插件扩展机制和丰富的插件</p>\n<p><strong>jQuery的语言特点</strong><br />\n1、快速获取文档元素<br />\n2、提供漂亮的页面动态效果<br />\n3、创建AJAX无刷新网页<br />\n4、提供对JavaScript语言的增强<br />\n5、增强的事件处理<br />\n6、更改网页内容</p>\n', 1, 20200612141703, 20200612141703, '框架/库'),
(39, 'zepto.js', 'http://server.itemsblog.com\\uploads\\20200612\\1591942688086.png', 'http://zeptojs.com', 'https://github.com/madrobby/zepto', '一个轻量级的针对现代高级浏览器的JavaScript库', '**Zepto**是一个轻量级的针对现代**高级浏览器的JavaScript库**， 它与jquery有着类似的api。 如果你会用jquery，那么你也会用zepto。 但并不是100%覆盖 jQuery 。**Zepto**设计的目的是有一个5-10k的通用库、下载并快速执行、有一个熟悉通用的API，所以你能把你主要的精力放到应用开发上。 ', '<p><strong>Zepto</strong>是一个轻量级的针对现代<strong>高级浏览器的JavaScript库</strong>， 它与jquery有着类似的api。 如果你会用jquery，那么你也会用zepto。 但并不是100%覆盖 jQuery 。<strong>Zepto</strong>设计的目的是有一个5-10k的通用库、下载并快速执行、有一个熟悉通用的API，所以你能把你主要的精力放到应用开发上。</p>\n', 1, 20200612141840, 20200612141840, '框架/库'),
(40, 'Ember', 'http://server.itemsblog.com\\uploads\\20200612\\1591942847442.png', 'http://www.emberjs.com/', 'https://github.com/emberjs/ember.js', 'JavaScript MVC框架，它用来创建复杂的Web应用程序，消除了样板', '**Ember的介绍**\n**Ember**一个用于创建 web 应用的 **JavaScript MVC** 框架，采用基于字符串的Handlebars模板，支持双向绑定、观察者模式、计算属性（依赖其他属性动态变化）、自动更新模板、路由控制、状态机等。 Ember使用自身扩展的类来创建Ember对象、数组、字符串、函数，提供大量方法与属性用于操作。 \n\n每一个Ember应用都使用各自的命名空间，避免冲突。\nEmber采用可嵌套的视图层，使视图变得有层次。\n\n\n\n**Ember的三个特性**\n1、绑定\n\n2、计算出的属性\n\n3、模版自动更新', '<p><strong>Ember的介绍</strong><br />\n<strong>Ember</strong>一个用于创建 web 应用的 <strong>JavaScript MVC</strong> 框架，采用基于字符串的Handlebars模板，支持双向绑定、观察者模式、计算属性（依赖其他属性动态变化）、自动更新模板、路由控制、状态机等。 Ember使用自身扩展的类来创建Ember对象、数组、字符串、函数，提供大量方法与属性用于操作。</p>\n<p>每一个Ember应用都使用各自的命名空间，避免冲突。<br />\nEmber采用可嵌套的视图层，使视图变得有层次。</p>\n<p><strong>Ember的三个特性</strong><br />\n1、绑定</p>\n<p>2、计算出的属性</p>\n<p>3、模版自动更新</p>\n', 1, 20200612142108, 20200612142108, '框架/库'),
(41, 'Next.js', 'http://server.itemsblog.com\\uploads\\20200612\\1591946485260.png', 'https://nextjs.org/', 'https://github.com/zeit/next.js', '实现react的服务端渲染的框架', 'Next.js是一个基于React的一个服务端渲染简约框架。它使用React语法，可以很好的实现代码的模块化，有利于代码的开发和维护。 \n\n\n\n**Next.js特性：**\n默认服务端渲染模式，以文件系统为基础的客户端路由\n\n代码自动分隔使页面加载更快\n\n（以页面为基础的）简洁的客户端路由\n\n以webpack的热替换为基础的开发环境\n\n使用React的JSX和ES6的module，模块化和维护更方便\n\n可以运行在Express和其他Node.js的HTTP 服务器上\n\n可以定制化专属的babel和webpack配置\n\n\n\n**始构建Next.js项目之前，需要做好一些准备：**\n首先，不管你使用哪个操作系统，你需要一个趁手的命令行工具，在Mac系统和Linux下自带的命令行工具比较好用，在Windows系统下，我推荐一个命令行工具：Cmder；\n\n已经在本地安装好Nodejs和Npm；\n\n熟悉React技术栈开发及ES6语法；\n\n熟悉Express架构的Nodejs开发。\n\n', '<p>Next.js是一个基于React的一个服务端渲染简约框架。它使用React语法，可以很好的实现代码的模块化，有利于代码的开发和维护。</p>\n<p><strong>Next.js特性：</strong><br />\n默认服务端渲染模式，以文件系统为基础的客户端路由</p>\n<p>代码自动分隔使页面加载更快</p>\n<p>（以页面为基础的）简洁的客户端路由</p>\n<p>以webpack的热替换为基础的开发环境</p>\n<p>使用React的JSX和ES6的module，模块化和维护更方便</p>\n<p>可以运行在Express和其他Node.js的HTTP 服务器上</p>\n<p>可以定制化专属的babel和webpack配置</p>\n<p><strong>始构建Next.js项目之前，需要做好一些准备：</strong><br />\n首先，不管你使用哪个操作系统，你需要一个趁手的命令行工具，在Mac系统和Linux下自带的命令行工具比较好用，在Windows系统下，我推荐一个命令行工具：Cmder；</p>\n<p>已经在本地安装好Nodejs和Npm；</p>\n<p>熟悉React技术栈开发及ES6语法；</p>\n<p>熟悉Express架构的Nodejs开发。</p>\n', 1, 20200612152151, 20200612152151, '框架/库'),
(42, 'nuxt.js', 'http://server.itemsblog.com\\uploads\\20200612\\1591946579841.png', 'https://zh.nuxtjs.org/', 'https://github.com/nuxt/nuxt.js', '基于 Vue.js 的轻量级、服务端渲染 (SSR) 应用框架', '**Nuxt.js 是什么？\nNuxt.js 是一个基于 Vue.js 的通用应用框架。**\n\n通过对客户端/服务端基础架构的抽象组织，Nuxt.js 主要关注的是应用的 UI渲染。\n\n我们的目标是创建一个灵活的应用框架，你可以基于它初始化新项目的基础结构代码，或者在已有 Node.js 项目中使用 Nuxt.js。\n\nNuxt.js 预设了利用Vue.js开发**服务端渲染**的应用所需要的各种配置。\n\n除此之外，我们还提供了一种命令叫：nuxt generate，为基于 Vue.js 的应用提供生成对应的静态站点的功能。\n\n我们相信这个命令所提供的功能，是向开发集成各种微服务（microservices）的 Web 应用迈开的新一步。\n\n作为框架，Nuxt.js 为 客户端/服务端 这种典型的应用架构模式提供了许多有用的特性，例如异步数据加载、中间件支持、布局支持等。', '<p><strong>Nuxt.js 是什么？<br />\nNuxt.js 是一个基于 Vue.js 的通用应用框架。</strong></p>\n<p>通过对客户端/服务端基础架构的抽象组织，Nuxt.js 主要关注的是应用的 UI渲染。</p>\n<p>我们的目标是创建一个灵活的应用框架，你可以基于它初始化新项目的基础结构代码，或者在已有 Node.js 项目中使用 Nuxt.js。</p>\n<p>Nuxt.js 预设了利用Vue.js开发<strong>服务端渲染</strong>的应用所需要的各种配置。</p>\n<p>除此之外，我们还提供了一种命令叫：nuxt generate，为基于 Vue.js 的应用提供生成对应的静态站点的功能。</p>\n<p>我们相信这个命令所提供的功能，是向开发集成各种微服务（microservices）的 Web 应用迈开的新一步。</p>\n<p>作为框架，Nuxt.js 为 客户端/服务端 这种典型的应用架构模式提供了许多有用的特性，例如异步数据加载、中间件支持、布局支持等。</p>\n', 1, 20200612152334, 20200612152334, '框架/库'),
(43, 'apify-js', 'http://server.itemsblog.com\\uploads\\20200612\\1591946740937.png', 'https://sdk.apify.com/', 'https://github.com/apifytech/apify-js', '可伸缩的 web 爬虫和抓取库', 'apify-js是一款用于 JavaScript 的可伸缩的 web 爬虫和抓取库。能通过无头（headless）Chrome 和 Puppeteer 实现数据提取和 Web 自动化作业的开发。  它提供了管理和自动扩展无头Chrome / Puppeteer实例池的工具，维护要爬网的URL队列，将爬网结果存储到本地文件系统或云端。\n\n安装：\n```js\nnpm install apify --save\n```\n运行以下示例以使用Puppeteer执行网站的爬取：\n```js\nconst Apify = require(\'apify\');\n\nApify.main(async () => {\n    const requestQueue = await Apify.openRequestQueue();\n    await requestQueue.addRequest({ url: \'https://www.iana.org/\' });\n    const pseudoUrls = [new Apify.PseudoUrl(\'https://www.iana.org/[.*]\')];\n\n    const crawler = new Apify.PuppeteerCrawler({\n        requestQueue,\n        handlePageFunction: async ({ request, page }) => {\n            const title = await page.title();\n            console.log(`Title of ${request.url}: ${title}`);\n            await Apify.utils.puppeteer.enqueueLinks(page, \'a\', pseudoUrls, requestQueue);\n        },\n        maxRequestsPerCrawl: 100,\n        maxConcurrency: 10,\n    });\n\n    await crawler.run();\n});\n```', '<p>apify-js是一款用于 JavaScript 的可伸缩的 web 爬虫和抓取库。能通过无头（headless）Chrome 和 Puppeteer 实现数据提取和 Web 自动化作业的开发。  它提供了管理和自动扩展无头Chrome / Puppeteer实例池的工具，维护要爬网的URL队列，将爬网结果存储到本地文件系统或云端。</p>\n<p>安装：</p>\n<pre><div class=\"hljs\"><code class=\"lang-js\">npm install apify --save\n</code></div></pre>\n<p>运行以下示例以使用Puppeteer执行网站的爬取：</p>\n<pre><div class=\"hljs\"><code class=\"lang-js\"><span class=\"hljs-keyword\">const</span> Apify = <span class=\"hljs-built_in\">require</span>(<span class=\"hljs-string\">\'apify\'</span>);\n\nApify.main(<span class=\"hljs-keyword\">async</span> () =&gt; {\n    <span class=\"hljs-keyword\">const</span> requestQueue = <span class=\"hljs-keyword\">await</span> Apify.openRequestQueue();\n    <span class=\"hljs-keyword\">await</span> requestQueue.addRequest({ <span class=\"hljs-attr\">url</span>: <span class=\"hljs-string\">\'https://www.iana.org/\'</span> });\n    <span class=\"hljs-keyword\">const</span> pseudoUrls = [<span class=\"hljs-keyword\">new</span> Apify.PseudoUrl(<span class=\"hljs-string\">\'https://www.iana.org/[.*]\'</span>)];\n\n    <span class=\"hljs-keyword\">const</span> crawler = <span class=\"hljs-keyword\">new</span> Apify.PuppeteerCrawler({\n        requestQueue,\n        <span class=\"hljs-attr\">handlePageFunction</span>: <span class=\"hljs-keyword\">async</span> ({ request, page }) =&gt; {\n            <span class=\"hljs-keyword\">const</span> title = <span class=\"hljs-keyword\">await</span> page.title();\n            <span class=\"hljs-built_in\">console</span>.log(<span class=\"hljs-string\">`Title of <span class=\"hljs-subst\">${request.url}</span>: <span class=\"hljs-subst\">${title}</span>`</span>);\n            <span class=\"hljs-keyword\">await</span> Apify.utils.puppeteer.enqueueLinks(page, <span class=\"hljs-string\">\'a\'</span>, pseudoUrls, requestQueue);\n        },\n        <span class=\"hljs-attr\">maxRequestsPerCrawl</span>: <span class=\"hljs-number\">100</span>,\n        <span class=\"hljs-attr\">maxConcurrency</span>: <span class=\"hljs-number\">10</span>,\n    });\n\n    <span class=\"hljs-keyword\">await</span> crawler.run();\n});\n</code></div></pre>\n', 1, 20200612152618, 20200612152618, '框架/库'),
(44, 'vue-router', 'http://server.itemsblog.com\\uploads\\20200612\\1591946849298.png', 'https://router.vuejs.org/', 'https://github.com/vuejs/vue-router', 'Vue.js 的官方路由', '**Vue Router 是 Vue.js 官方的路由管理器**。它和 Vue.js 的核心深度集成，让构建单页面应用变得易如反掌。包含的功能有：\n\n嵌套的路由/视图表\n模块化的、基于组件的路由配置\n路由参数、查询、通配符\n基于 Vue.js 过渡系统的视图过渡效果\n细粒度的导航控制\n带有自动激活的 CSS class 的链接\nHTML5 历史模式或 hash 模式，在 IE9 中自动降级\n自定义的滚动条行为\n', '<p><strong>Vue Router 是 Vue.js 官方的路由管理器</strong>。它和 Vue.js 的核心深度集成，让构建单页面应用变得易如反掌。包含的功能有：</p>\n<p>嵌套的路由/视图表<br />\n模块化的、基于组件的路由配置<br />\n路由参数、查询、通配符<br />\n基于 Vue.js 过渡系统的视图过渡效果<br />\n细粒度的导航控制<br />\n带有自动激活的 CSS class 的链接<br />\nHTML5 历史模式或 hash 模式，在 IE9 中自动降级<br />\n自定义的滚动条行为</p>\n', 1, 20200612152751, 20200612152751, '框架/库'),
(45, 'vuex', 'http://server.itemsblog.com\\uploads\\20200612\\1591947581955.png', 'http://vuex.vuejs.org/', 'https://github.com/vuejs/vuex', '一个专门为 Vue.js 应用所设计的集中式状态管理架构', 'Vuex 是一个专门为 Vue.js 应用所设计的集中式状态管理架构。它借鉴了 Flux 和 Redux 的设计思想，但简化了概念，并且采用了一种为能更好发挥 Vue.js 数据响应机制而专门设计的实现 。\n\n\n\n**vuex 包含有五个基本的对象：** \n**state**：存储状态。也就是变量；\n\n**getters**：派生状态。也就是set、get中的get，有两个可选参数：state、getters分别可以获取state中的变量和其他的getters。外部调用方式：store.getters.personInfo()。就和vue的computed差不多；\n\n**mutations**：提交状态修改。也就是set、get中的set，这是vuex中唯一修改state的方式，但不支持异步操作。第一个参数默认是state。外部调用方式：store.commit(\'SET_AGE\', 18)。和vue中的methods类似。\n\n**actions**：和mutations类似。不过actions支持异步操作。第一个参数默认是和store具有相同参数属性的对象。外部调用方式：store.dispatch(\'nameAsyn\')。\n**\nmodules**：store的子模块，内容就相当于是store的一个实例。调用方式和前面介绍的相似，只是要加上当前子模块名，如：store.a.getters.xxx()。\n', '<p>Vuex 是一个专门为 Vue.js 应用所设计的集中式状态管理架构。它借鉴了 Flux 和 Redux 的设计思想，但简化了概念，并且采用了一种为能更好发挥 Vue.js 数据响应机制而专门设计的实现 。</p>\n<p><strong>vuex 包含有五个基本的对象：</strong><br />\n<strong>state</strong>：存储状态。也就是变量；</p>\n<p><strong>getters</strong>：派生状态。也就是set、get中的get，有两个可选参数：state、getters分别可以获取state中的变量和其他的getters。外部调用方式：store.getters.personInfo()。就和vue的computed差不多；</p>\n<p><strong>mutations</strong>：提交状态修改。也就是set、get中的set，这是vuex中唯一修改state的方式，但不支持异步操作。第一个参数默认是state。外部调用方式：store.commit(‘SET_AGE’, 18)。和vue中的methods类似。</p>\n<p><strong>actions</strong>：和mutations类似。不过actions支持异步操作。第一个参数默认是和store具有相同参数属性的对象。外部调用方式：store.dispatch(‘nameAsyn’)。<br />\n**<br />\nmodules**：store的子模块，内容就相当于是store的一个实例。调用方式和前面介绍的相似，只是要加上当前子模块名，如：store.a.getters.xxx()。</p>\n', 1, 20200612154028, 20200612154028, '框架/库');

-- --------------------------------------------------------

--
-- 表的结构 `tag`
--

CREATE TABLE `tag` (
  `id` int(11) NOT NULL,
  `tagname` text NOT NULL,
  `tagdesc` text NOT NULL,
  `cdate` bigint(20) NOT NULL DEFAULT '1582612530977' COMMENT '创建时间',
  `status` int(11) DEFAULT '0' COMMENT '标签状态, 1-可用，0-不可用'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- 转存表中的数据 `tag`
--

INSERT INTO `tag` (`id`, `tagname`, `tagdesc`, `cdate`, `status`) VALUES
(24, 'Vue.js', '前端框架', 20200602180800, 0),
(25, 'Vue', '前端框架', 20200602184100, 1),
(26, 'React', '前端框架', 20200602184108, 1),
(27, 'Node', '运行在服务端的 JavaScript', 20200602184144, 1),
(28, 'Nuxt', 'Nuxt.js 是一个基于 Vue.js 的轻量级应用框架,可用来创建服务端渲染 (SSR) 应用', 20200603163256, 1),
(29, 'Git/Github', 'Git/Github相关', 20200610170315, 1);

-- --------------------------------------------------------

--
-- 表的结构 `types`
--

CREATE TABLE `types` (
  `id` bigint(20) NOT NULL,
  `typename` text NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '导航类型状态：1-公开；0-未公开',
  `cdate` bigint(20) NOT NULL COMMENT '导航类型发布时间',
  `editdate` bigint(20) NOT NULL COMMENT '导航类型修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- 转存表中的数据 `types`
--

INSERT INTO `types` (`id`, `typename`, `status`, `cdate`, `editdate`) VALUES
(1, '框架/库', 1, 20200612111114, 20200612111114),
(2, '模块/管理', 1, 20200612111217, 20200612111217),
(3, '移动端UI框架', 1, 20200612111238, 20200612111238),
(4, 'Web-UI框架', 1, 20200612111246, 20200612111246),
(5, 'Js插件', 1, 20200612111253, 20200612111253),
(6, 'Jquery插件', 1, 20200612111301, 20200612111301),
(7, 'CSS相关', 1, 20200612111309, 20200612111309),
(8, 'IDE环境', 1, 20200612111320, 20200612111320),
(9, '在线工具', 1, 20200612111334, 20200612111334),
(10, '图形动效', 1, 20200612111343, 20200612111343),
(11, '游戏框架', 1, 20200612111350, 20200612111350),
(12, 'node相关', 1, 20200612111357, 20200612111357),
(13, '调试/测试', 1, 20200612111404, 20200612111404),
(14, '在线学习', 1, 20200612111411, 20200612111411),
(15, '社区/论坛', 1, 20200612111419, 20200612111419),
(16, '博客/团队', 1, 20200612111425, 20200612111425),
(17, '前端素材', 1, 20200612111435, 20200612111435),
(18, '图标/图库', 1, 20200612111442, 20200612111442),
(19, '建站资源', 1, 20200612111449, 20200612111449),
(20, '设计/灵感', 1, 20200612111456, 20200612111456),
(21, '招聘/兼职', 1, 20200612111503, 20200612111503),
(22, 'IT资讯', 1, 20200612111512, 20200612111512),
(23, '酷站推荐', 1, 20200612111519, 20200612111519);

-- --------------------------------------------------------

--
-- 表的结构 `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL COMMENT '用户 id',
  `username` text NOT NULL,
  `password` text NOT NULL,
  `nickname` text,
  `avatar` text,
  `signature` text,
  `cdate` bigint(20) NOT NULL DEFAULT '1582612530953' COMMENT '用户创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- 转存表中的数据 `user`
--

INSERT INTO `user` (`id`, `username`, `password`, `nickname`, `avatar`, `signature`, `cdate`) VALUES
(3, 'admin', 'edea6cb12dc467591f4732d685ede3e4', NULL, NULL, NULL, 20200602161704);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `article`
--
ALTER TABLE `article`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `comment`
--
ALTER TABLE `comment`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `link`
--
ALTER TABLE `link`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `nav`
--
ALTER TABLE `nav`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `tag`
--
ALTER TABLE `tag`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `types`
--
ALTER TABLE `types`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `article`
--
ALTER TABLE `article`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- 使用表AUTO_INCREMENT `category`
--
ALTER TABLE `category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
--
-- 使用表AUTO_INCREMENT `comment`
--
ALTER TABLE `comment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=189;
--
-- 使用表AUTO_INCREMENT `link`
--
ALTER TABLE `link`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
--
-- 使用表AUTO_INCREMENT `nav`
--
ALTER TABLE `nav`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;
--
-- 使用表AUTO_INCREMENT `tag`
--
ALTER TABLE `tag`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;
--
-- 使用表AUTO_INCREMENT `types`
--
ALTER TABLE `types`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;
--
-- 使用表AUTO_INCREMENT `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户 id', AUTO_INCREMENT=6;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
