



<!DOCTYPE html>
<html>
<head>
 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" >
 <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" >
 
 <meta name="ROBOTS" content="NOARCHIVE">
 
 <link rel="icon" type="image/vnd.microsoft.icon" href="http://www.gstatic.com/codesite/ph/images/phosting.ico">
 
 
 <script type="text/javascript">
 
 
 
 
 var codesite_token = null;
 
 
 var CS_env = {"token":null,"loggedInUserEmail":null,"projectHomeUrl":"/p/xsdtorngconverter","profileUrl":null,"domainName":null,"assetVersionPath":"http://www.gstatic.com/codesite/ph/11312328449230880833","projectName":"xsdtorngconverter","assetHostPath":"http://www.gstatic.com/codesite/ph","relativeBaseUrl":""};
 var _gaq = _gaq || [];
 _gaq.push(
 ['siteTracker._setAccount', 'UA-18071-1'],
 ['siteTracker._trackPageview']);
 
 _gaq.push(
 ['projectTracker._setAccount', 'UA-6192198-2'],
 ['projectTracker._trackPageview']);
 
 (function() {
 var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
 ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
 (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(ga);
 })();
 
 </script>
 
 
 <title>XSDtoRNG.xsl - 
 xsdtorngconverter -
 
 
 XSD to RelaxNG converter - Google Project Hosting
 </title>
 <link type="text/css" rel="stylesheet" href="http://www.gstatic.com/codesite/ph/11312328449230880833/css/core.css">
 
 <link type="text/css" rel="stylesheet" href="http://www.gstatic.com/codesite/ph/11312328449230880833/css/ph_detail.css" >
 
 
 <link type="text/css" rel="stylesheet" href="http://www.gstatic.com/codesite/ph/11312328449230880833/css/d_sb.css" >
 
 
 
<!--[if IE]>
 <link type="text/css" rel="stylesheet" href="http://www.gstatic.com/codesite/ph/11312328449230880833/css/d_ie.css" >
<![endif]-->
 <style type="text/css">
 .menuIcon.off { background: no-repeat url(http://www.gstatic.com/codesite/ph/images/dropdown_sprite.gif) 0 -42px }
 .menuIcon.on { background: no-repeat url(http://www.gstatic.com/codesite/ph/images/dropdown_sprite.gif) 0 -28px }
 .menuIcon.down { background: no-repeat url(http://www.gstatic.com/codesite/ph/images/dropdown_sprite.gif) 0 0; }
 
 
 
  tr.inline_comment {
 background: #fff;
 vertical-align: top;
 }
 div.draft, div.published {
 padding: .3em;
 border: 1px solid #999; 
 margin-bottom: .1em;
 font-family: arial, sans-serif;
 max-width: 60em;
 }
 div.draft {
 background: #ffa;
 } 
 div.published {
 background: #e5ecf9;
 }
 div.published .body, div.draft .body {
 padding: .5em .1em .1em .1em;
 max-width: 60em;
 white-space: pre-wrap;
 white-space: -moz-pre-wrap;
 white-space: -pre-wrap;
 white-space: -o-pre-wrap;
 word-wrap: break-word;
 font-size: 1em;
 }
 div.draft .actions {
 margin-left: 1em;
 font-size: 90%;
 }
 div.draft form {
 padding: .5em .5em .5em 0;
 }
 div.draft textarea, div.published textarea {
 width: 95%;
 height: 10em;
 font-family: arial, sans-serif;
 margin-bottom: .5em;
 }

 
 .nocursor, .nocursor td, .cursor_hidden, .cursor_hidden td {
 background-color: white;
 height: 2px;
 }
 .cursor, .cursor td {
 background-color: darkblue;
 height: 2px;
 display: '';
 }
 
 
.list {
 border: 1px solid white;
 border-bottom: 0;
}

 
 </style>
</head>
<body class="t4">
<script type="text/javascript">
 window.___gcfg = {lang: 'en'};
 (function() 
 {var po = document.createElement("script");
 po.type = "text/javascript"; po.async = true;po.src = "https://apis.google.com/js/plusone.js";
 var s = document.getElementsByTagName("script")[0];
 s.parentNode.insertBefore(po, s);
 })();
</script>
<div class="headbg">

 <div id="gaia">
 

 <span>
 
 
 <a href="#" id="projects-dropdown" onclick="return false;"><u>My favorites</u> <small>&#9660;</small></a>
 | <a href="https://www.google.com/accounts/ServiceLogin?service=code&amp;ltmpl=phosting&amp;continue=http%3A%2F%2Fcode.google.com%2Fp%2Fxsdtorngconverter%2Fsource%2Fbrowse%2Ftrunk%2Fxsdtorngconverter%2FXSDtoRNG.xsl&amp;followup=http%3A%2F%2Fcode.google.com%2Fp%2Fxsdtorngconverter%2Fsource%2Fbrowse%2Ftrunk%2Fxsdtorngconverter%2FXSDtoRNG.xsl" onclick="_CS_click('/gb/ph/signin');"><u>Sign in</u></a>
 
 </span>

 </div>

 <div class="gbh" style="left: 0pt;"></div>
 <div class="gbh" style="right: 0pt;"></div>
 
 
 <div style="height: 1px"></div>
<!--[if lte IE 7]>
<div style="text-align:center;">
Your version of Internet Explorer is not supported. Try a browser that
contributes to open source, such as <a href="http://www.firefox.com">Firefox</a>,
<a href="http://www.google.com/chrome">Google Chrome</a>, or
<a href="http://code.google.com/chrome/chromeframe/">Google Chrome Frame</a>.
</div>
<![endif]-->



 <table style="padding:0px; margin: 0px 0px 10px 0px; width:100%" cellpadding="0" cellspacing="0"
 itemscope itemtype="http://schema.org/CreativeWork">
 <tr style="height: 58px;">
 
 
 
 <td id="plogo">
 <link itemprop="url" href="/p/xsdtorngconverter">
 <a href="/p/xsdtorngconverter/">
 
 <img src="http://www.gstatic.com/codesite/ph/images/defaultlogo.png" alt="Logo" itemprop="image">
 
 </a>
 </td>
 
 <td style="padding-left: 0.5em">
 
 <div id="pname">
 <a href="/p/xsdtorngconverter/"><span itemprop="name">xsdtorngconverter</span></a>
 </div>
 
 <div id="psum">
 <a id="project_summary_link"
 href="/p/xsdtorngconverter/"><span itemprop="description">XSD to RelaxNG converter</span></a>
 
 </div>
 
 
 </td>
 <td style="white-space:nowrap;text-align:right; vertical-align:bottom;">
 
 <form action="/hosting/search">
 <input size="30" name="q" value="" type="text">
 
 <input type="submit" name="projectsearch" value="Search projects" >
 </form>
 
 </tr>
 </table>

</div>

 
<div id="mt" class="gtb"> 
 <a href="/p/xsdtorngconverter/" class="tab ">Project&nbsp;Home</a>
 
 
 
 
 <a href="/p/xsdtorngconverter/downloads/list" class="tab ">Downloads</a>
 
 
 
 
 
 <a href="/p/xsdtorngconverter/w/list" class="tab ">Wiki</a>
 
 
 
 
 
 <a href="/p/xsdtorngconverter/issues/list"
 class="tab ">Issues</a>
 
 
 
 
 
 <a href="/p/xsdtorngconverter/source/checkout"
 class="tab active">Source</a>
 
 
 
 
 
 
 
 
 <div class=gtbc></div>
</div>
<table cellspacing="0" cellpadding="0" width="100%" align="center" border="0" class="st">
 <tr>
 
 
 
 
 
 
 <td class="subt">
 <div class="st2">
 <div class="isf">
 
 


 <span class="inst1"><a href="/p/xsdtorngconverter/source/checkout">Checkout</a></span> &nbsp;
 <span class="inst2"><a href="/p/xsdtorngconverter/source/browse/">Browse</a></span> &nbsp;
 <span class="inst3"><a href="/p/xsdtorngconverter/source/list">Changes</a></span> &nbsp;
 
 
 
 
 
 
 
 </form>
 <script type="text/javascript">
 
 function codesearchQuery(form) {
 var query = document.getElementById('q').value;
 if (query) { form.action += '%20' + query; }
 }
 </script>
 </div>
</div>

 </td>
 
 
 
 <td align="right" valign="top" class="bevel-right"></td>
 </tr>
</table>


<script type="text/javascript">
 var cancelBubble = false;
 function _go(url) { document.location = url; }
</script>
<div id="maincol"
 
>

 




<div class="expand">
<div id="colcontrol">
<style type="text/css">
 #file_flipper { white-space: nowrap; padding-right: 2em; }
 #file_flipper.hidden { display: none; }
 #file_flipper .pagelink { color: #0000CC; text-decoration: underline; }
 #file_flipper #visiblefiles { padding-left: 0.5em; padding-right: 0.5em; }
</style>
<table id="nav_and_rev" class="list"
 cellpadding="0" cellspacing="0" width="100%">
 <tr>
 
 <td nowrap="nowrap" class="src_crumbs src_nav" width="33%">
 <strong class="src_nav">Source path:&nbsp;</strong>
 <span id="crumb_root">
 
 <a href="/p/xsdtorngconverter/source/browse/">svn</a>/&nbsp;</span>
 <span id="crumb_links" class="ifClosed"><a href="/p/xsdtorngconverter/source/browse/trunk/">trunk</a><span class="sp">/&nbsp;</span><a href="/p/xsdtorngconverter/source/browse/trunk/xsdtorngconverter/">xsdtorngconverter</a><span class="sp">/&nbsp;</span>XSDtoRNG.xsl</span>
 
 


 </td>
 
 
 <td nowrap="nowrap" width="33%" align="right">
 <table cellpadding="0" cellspacing="0" style="font-size: 100%"><tr>
 
 
 <td class="flipper">
 <ul class="leftside">
 
 <li><a href="/p/xsdtorngconverter/source/browse/trunk/xsdtorngconverter/XSDtoRNG.xsl?r=20" title="Previous">&lsaquo;r20</a></li>
 
 </ul>
 </td>
 
 <td class="flipper"><b>r21</b></td>
 
 </tr></table>
 </td> 
 </tr>
</table>

<div class="fc">
 
 
 
<style type="text/css">
.undermouse span {
 background-image: url(http://www.gstatic.com/codesite/ph/images/comments.gif); }
</style>
<table class="opened" id="review_comment_area"
><tr>
<td id="nums">
<pre><table width="100%"><tr class="nocursor"><td></td></tr></table></pre>
<pre><table width="100%" id="nums_table_0"><tr id="gr_svn21_1"

><td id="1"><a href="#1">1</a></td></tr
><tr id="gr_svn21_2"

><td id="2"><a href="#2">2</a></td></tr
><tr id="gr_svn21_3"

><td id="3"><a href="#3">3</a></td></tr
><tr id="gr_svn21_4"

><td id="4"><a href="#4">4</a></td></tr
><tr id="gr_svn21_5"

><td id="5"><a href="#5">5</a></td></tr
><tr id="gr_svn21_6"

><td id="6"><a href="#6">6</a></td></tr
><tr id="gr_svn21_7"

><td id="7"><a href="#7">7</a></td></tr
><tr id="gr_svn21_8"

><td id="8"><a href="#8">8</a></td></tr
><tr id="gr_svn21_9"

><td id="9"><a href="#9">9</a></td></tr
><tr id="gr_svn21_10"

><td id="10"><a href="#10">10</a></td></tr
><tr id="gr_svn21_11"

><td id="11"><a href="#11">11</a></td></tr
><tr id="gr_svn21_12"

><td id="12"><a href="#12">12</a></td></tr
><tr id="gr_svn21_13"

><td id="13"><a href="#13">13</a></td></tr
><tr id="gr_svn21_14"

><td id="14"><a href="#14">14</a></td></tr
><tr id="gr_svn21_15"

><td id="15"><a href="#15">15</a></td></tr
><tr id="gr_svn21_16"

><td id="16"><a href="#16">16</a></td></tr
><tr id="gr_svn21_17"

><td id="17"><a href="#17">17</a></td></tr
><tr id="gr_svn21_18"

><td id="18"><a href="#18">18</a></td></tr
><tr id="gr_svn21_19"

><td id="19"><a href="#19">19</a></td></tr
><tr id="gr_svn21_20"

><td id="20"><a href="#20">20</a></td></tr
><tr id="gr_svn21_21"

><td id="21"><a href="#21">21</a></td></tr
><tr id="gr_svn21_22"

><td id="22"><a href="#22">22</a></td></tr
><tr id="gr_svn21_23"

><td id="23"><a href="#23">23</a></td></tr
><tr id="gr_svn21_24"

><td id="24"><a href="#24">24</a></td></tr
><tr id="gr_svn21_25"

><td id="25"><a href="#25">25</a></td></tr
><tr id="gr_svn21_26"

><td id="26"><a href="#26">26</a></td></tr
><tr id="gr_svn21_27"

><td id="27"><a href="#27">27</a></td></tr
><tr id="gr_svn21_28"

><td id="28"><a href="#28">28</a></td></tr
><tr id="gr_svn21_29"

><td id="29"><a href="#29">29</a></td></tr
><tr id="gr_svn21_30"

><td id="30"><a href="#30">30</a></td></tr
><tr id="gr_svn21_31"

><td id="31"><a href="#31">31</a></td></tr
><tr id="gr_svn21_32"

><td id="32"><a href="#32">32</a></td></tr
><tr id="gr_svn21_33"

><td id="33"><a href="#33">33</a></td></tr
><tr id="gr_svn21_34"

><td id="34"><a href="#34">34</a></td></tr
><tr id="gr_svn21_35"

><td id="35"><a href="#35">35</a></td></tr
><tr id="gr_svn21_36"

><td id="36"><a href="#36">36</a></td></tr
><tr id="gr_svn21_37"

><td id="37"><a href="#37">37</a></td></tr
><tr id="gr_svn21_38"

><td id="38"><a href="#38">38</a></td></tr
><tr id="gr_svn21_39"

><td id="39"><a href="#39">39</a></td></tr
><tr id="gr_svn21_40"

><td id="40"><a href="#40">40</a></td></tr
><tr id="gr_svn21_41"

><td id="41"><a href="#41">41</a></td></tr
><tr id="gr_svn21_42"

><td id="42"><a href="#42">42</a></td></tr
><tr id="gr_svn21_43"

><td id="43"><a href="#43">43</a></td></tr
><tr id="gr_svn21_44"

><td id="44"><a href="#44">44</a></td></tr
><tr id="gr_svn21_45"

><td id="45"><a href="#45">45</a></td></tr
><tr id="gr_svn21_46"

><td id="46"><a href="#46">46</a></td></tr
><tr id="gr_svn21_47"

><td id="47"><a href="#47">47</a></td></tr
><tr id="gr_svn21_48"

><td id="48"><a href="#48">48</a></td></tr
><tr id="gr_svn21_49"

><td id="49"><a href="#49">49</a></td></tr
><tr id="gr_svn21_50"

><td id="50"><a href="#50">50</a></td></tr
><tr id="gr_svn21_51"

><td id="51"><a href="#51">51</a></td></tr
><tr id="gr_svn21_52"

><td id="52"><a href="#52">52</a></td></tr
><tr id="gr_svn21_53"

><td id="53"><a href="#53">53</a></td></tr
><tr id="gr_svn21_54"

><td id="54"><a href="#54">54</a></td></tr
><tr id="gr_svn21_55"

><td id="55"><a href="#55">55</a></td></tr
><tr id="gr_svn21_56"

><td id="56"><a href="#56">56</a></td></tr
><tr id="gr_svn21_57"

><td id="57"><a href="#57">57</a></td></tr
><tr id="gr_svn21_58"

><td id="58"><a href="#58">58</a></td></tr
><tr id="gr_svn21_59"

><td id="59"><a href="#59">59</a></td></tr
><tr id="gr_svn21_60"

><td id="60"><a href="#60">60</a></td></tr
><tr id="gr_svn21_61"

><td id="61"><a href="#61">61</a></td></tr
><tr id="gr_svn21_62"

><td id="62"><a href="#62">62</a></td></tr
><tr id="gr_svn21_63"

><td id="63"><a href="#63">63</a></td></tr
><tr id="gr_svn21_64"

><td id="64"><a href="#64">64</a></td></tr
><tr id="gr_svn21_65"

><td id="65"><a href="#65">65</a></td></tr
><tr id="gr_svn21_66"

><td id="66"><a href="#66">66</a></td></tr
><tr id="gr_svn21_67"

><td id="67"><a href="#67">67</a></td></tr
><tr id="gr_svn21_68"

><td id="68"><a href="#68">68</a></td></tr
><tr id="gr_svn21_69"

><td id="69"><a href="#69">69</a></td></tr
><tr id="gr_svn21_70"

><td id="70"><a href="#70">70</a></td></tr
><tr id="gr_svn21_71"

><td id="71"><a href="#71">71</a></td></tr
><tr id="gr_svn21_72"

><td id="72"><a href="#72">72</a></td></tr
><tr id="gr_svn21_73"

><td id="73"><a href="#73">73</a></td></tr
><tr id="gr_svn21_74"

><td id="74"><a href="#74">74</a></td></tr
><tr id="gr_svn21_75"

><td id="75"><a href="#75">75</a></td></tr
><tr id="gr_svn21_76"

><td id="76"><a href="#76">76</a></td></tr
><tr id="gr_svn21_77"

><td id="77"><a href="#77">77</a></td></tr
><tr id="gr_svn21_78"

><td id="78"><a href="#78">78</a></td></tr
><tr id="gr_svn21_79"

><td id="79"><a href="#79">79</a></td></tr
><tr id="gr_svn21_80"

><td id="80"><a href="#80">80</a></td></tr
><tr id="gr_svn21_81"

><td id="81"><a href="#81">81</a></td></tr
><tr id="gr_svn21_82"

><td id="82"><a href="#82">82</a></td></tr
><tr id="gr_svn21_83"

><td id="83"><a href="#83">83</a></td></tr
><tr id="gr_svn21_84"

><td id="84"><a href="#84">84</a></td></tr
><tr id="gr_svn21_85"

><td id="85"><a href="#85">85</a></td></tr
><tr id="gr_svn21_86"

><td id="86"><a href="#86">86</a></td></tr
><tr id="gr_svn21_87"

><td id="87"><a href="#87">87</a></td></tr
><tr id="gr_svn21_88"

><td id="88"><a href="#88">88</a></td></tr
><tr id="gr_svn21_89"

><td id="89"><a href="#89">89</a></td></tr
><tr id="gr_svn21_90"

><td id="90"><a href="#90">90</a></td></tr
><tr id="gr_svn21_91"

><td id="91"><a href="#91">91</a></td></tr
><tr id="gr_svn21_92"

><td id="92"><a href="#92">92</a></td></tr
><tr id="gr_svn21_93"

><td id="93"><a href="#93">93</a></td></tr
><tr id="gr_svn21_94"

><td id="94"><a href="#94">94</a></td></tr
><tr id="gr_svn21_95"

><td id="95"><a href="#95">95</a></td></tr
><tr id="gr_svn21_96"

><td id="96"><a href="#96">96</a></td></tr
><tr id="gr_svn21_97"

><td id="97"><a href="#97">97</a></td></tr
><tr id="gr_svn21_98"

><td id="98"><a href="#98">98</a></td></tr
><tr id="gr_svn21_99"

><td id="99"><a href="#99">99</a></td></tr
><tr id="gr_svn21_100"

><td id="100"><a href="#100">100</a></td></tr
><tr id="gr_svn21_101"

><td id="101"><a href="#101">101</a></td></tr
><tr id="gr_svn21_102"

><td id="102"><a href="#102">102</a></td></tr
><tr id="gr_svn21_103"

><td id="103"><a href="#103">103</a></td></tr
><tr id="gr_svn21_104"

><td id="104"><a href="#104">104</a></td></tr
><tr id="gr_svn21_105"

><td id="105"><a href="#105">105</a></td></tr
><tr id="gr_svn21_106"

><td id="106"><a href="#106">106</a></td></tr
><tr id="gr_svn21_107"

><td id="107"><a href="#107">107</a></td></tr
><tr id="gr_svn21_108"

><td id="108"><a href="#108">108</a></td></tr
><tr id="gr_svn21_109"

><td id="109"><a href="#109">109</a></td></tr
><tr id="gr_svn21_110"

><td id="110"><a href="#110">110</a></td></tr
><tr id="gr_svn21_111"

><td id="111"><a href="#111">111</a></td></tr
><tr id="gr_svn21_112"

><td id="112"><a href="#112">112</a></td></tr
><tr id="gr_svn21_113"

><td id="113"><a href="#113">113</a></td></tr
><tr id="gr_svn21_114"

><td id="114"><a href="#114">114</a></td></tr
><tr id="gr_svn21_115"

><td id="115"><a href="#115">115</a></td></tr
><tr id="gr_svn21_116"

><td id="116"><a href="#116">116</a></td></tr
><tr id="gr_svn21_117"

><td id="117"><a href="#117">117</a></td></tr
><tr id="gr_svn21_118"

><td id="118"><a href="#118">118</a></td></tr
><tr id="gr_svn21_119"

><td id="119"><a href="#119">119</a></td></tr
><tr id="gr_svn21_120"

><td id="120"><a href="#120">120</a></td></tr
><tr id="gr_svn21_121"

><td id="121"><a href="#121">121</a></td></tr
><tr id="gr_svn21_122"

><td id="122"><a href="#122">122</a></td></tr
><tr id="gr_svn21_123"

><td id="123"><a href="#123">123</a></td></tr
><tr id="gr_svn21_124"

><td id="124"><a href="#124">124</a></td></tr
><tr id="gr_svn21_125"

><td id="125"><a href="#125">125</a></td></tr
><tr id="gr_svn21_126"

><td id="126"><a href="#126">126</a></td></tr
><tr id="gr_svn21_127"

><td id="127"><a href="#127">127</a></td></tr
><tr id="gr_svn21_128"

><td id="128"><a href="#128">128</a></td></tr
><tr id="gr_svn21_129"

><td id="129"><a href="#129">129</a></td></tr
><tr id="gr_svn21_130"

><td id="130"><a href="#130">130</a></td></tr
><tr id="gr_svn21_131"

><td id="131"><a href="#131">131</a></td></tr
><tr id="gr_svn21_132"

><td id="132"><a href="#132">132</a></td></tr
><tr id="gr_svn21_133"

><td id="133"><a href="#133">133</a></td></tr
><tr id="gr_svn21_134"

><td id="134"><a href="#134">134</a></td></tr
><tr id="gr_svn21_135"

><td id="135"><a href="#135">135</a></td></tr
><tr id="gr_svn21_136"

><td id="136"><a href="#136">136</a></td></tr
><tr id="gr_svn21_137"

><td id="137"><a href="#137">137</a></td></tr
><tr id="gr_svn21_138"

><td id="138"><a href="#138">138</a></td></tr
><tr id="gr_svn21_139"

><td id="139"><a href="#139">139</a></td></tr
><tr id="gr_svn21_140"

><td id="140"><a href="#140">140</a></td></tr
><tr id="gr_svn21_141"

><td id="141"><a href="#141">141</a></td></tr
><tr id="gr_svn21_142"

><td id="142"><a href="#142">142</a></td></tr
><tr id="gr_svn21_143"

><td id="143"><a href="#143">143</a></td></tr
><tr id="gr_svn21_144"

><td id="144"><a href="#144">144</a></td></tr
><tr id="gr_svn21_145"

><td id="145"><a href="#145">145</a></td></tr
><tr id="gr_svn21_146"

><td id="146"><a href="#146">146</a></td></tr
><tr id="gr_svn21_147"

><td id="147"><a href="#147">147</a></td></tr
><tr id="gr_svn21_148"

><td id="148"><a href="#148">148</a></td></tr
><tr id="gr_svn21_149"

><td id="149"><a href="#149">149</a></td></tr
><tr id="gr_svn21_150"

><td id="150"><a href="#150">150</a></td></tr
><tr id="gr_svn21_151"

><td id="151"><a href="#151">151</a></td></tr
><tr id="gr_svn21_152"

><td id="152"><a href="#152">152</a></td></tr
><tr id="gr_svn21_153"

><td id="153"><a href="#153">153</a></td></tr
><tr id="gr_svn21_154"

><td id="154"><a href="#154">154</a></td></tr
><tr id="gr_svn21_155"

><td id="155"><a href="#155">155</a></td></tr
><tr id="gr_svn21_156"

><td id="156"><a href="#156">156</a></td></tr
><tr id="gr_svn21_157"

><td id="157"><a href="#157">157</a></td></tr
><tr id="gr_svn21_158"

><td id="158"><a href="#158">158</a></td></tr
><tr id="gr_svn21_159"

><td id="159"><a href="#159">159</a></td></tr
><tr id="gr_svn21_160"

><td id="160"><a href="#160">160</a></td></tr
><tr id="gr_svn21_161"

><td id="161"><a href="#161">161</a></td></tr
><tr id="gr_svn21_162"

><td id="162"><a href="#162">162</a></td></tr
><tr id="gr_svn21_163"

><td id="163"><a href="#163">163</a></td></tr
><tr id="gr_svn21_164"

><td id="164"><a href="#164">164</a></td></tr
><tr id="gr_svn21_165"

><td id="165"><a href="#165">165</a></td></tr
><tr id="gr_svn21_166"

><td id="166"><a href="#166">166</a></td></tr
><tr id="gr_svn21_167"

><td id="167"><a href="#167">167</a></td></tr
><tr id="gr_svn21_168"

><td id="168"><a href="#168">168</a></td></tr
><tr id="gr_svn21_169"

><td id="169"><a href="#169">169</a></td></tr
><tr id="gr_svn21_170"

><td id="170"><a href="#170">170</a></td></tr
><tr id="gr_svn21_171"

><td id="171"><a href="#171">171</a></td></tr
><tr id="gr_svn21_172"

><td id="172"><a href="#172">172</a></td></tr
><tr id="gr_svn21_173"

><td id="173"><a href="#173">173</a></td></tr
><tr id="gr_svn21_174"

><td id="174"><a href="#174">174</a></td></tr
><tr id="gr_svn21_175"

><td id="175"><a href="#175">175</a></td></tr
><tr id="gr_svn21_176"

><td id="176"><a href="#176">176</a></td></tr
><tr id="gr_svn21_177"

><td id="177"><a href="#177">177</a></td></tr
><tr id="gr_svn21_178"

><td id="178"><a href="#178">178</a></td></tr
><tr id="gr_svn21_179"

><td id="179"><a href="#179">179</a></td></tr
><tr id="gr_svn21_180"

><td id="180"><a href="#180">180</a></td></tr
><tr id="gr_svn21_181"

><td id="181"><a href="#181">181</a></td></tr
><tr id="gr_svn21_182"

><td id="182"><a href="#182">182</a></td></tr
><tr id="gr_svn21_183"

><td id="183"><a href="#183">183</a></td></tr
><tr id="gr_svn21_184"

><td id="184"><a href="#184">184</a></td></tr
><tr id="gr_svn21_185"

><td id="185"><a href="#185">185</a></td></tr
><tr id="gr_svn21_186"

><td id="186"><a href="#186">186</a></td></tr
><tr id="gr_svn21_187"

><td id="187"><a href="#187">187</a></td></tr
><tr id="gr_svn21_188"

><td id="188"><a href="#188">188</a></td></tr
><tr id="gr_svn21_189"

><td id="189"><a href="#189">189</a></td></tr
><tr id="gr_svn21_190"

><td id="190"><a href="#190">190</a></td></tr
><tr id="gr_svn21_191"

><td id="191"><a href="#191">191</a></td></tr
><tr id="gr_svn21_192"

><td id="192"><a href="#192">192</a></td></tr
><tr id="gr_svn21_193"

><td id="193"><a href="#193">193</a></td></tr
><tr id="gr_svn21_194"

><td id="194"><a href="#194">194</a></td></tr
><tr id="gr_svn21_195"

><td id="195"><a href="#195">195</a></td></tr
><tr id="gr_svn21_196"

><td id="196"><a href="#196">196</a></td></tr
><tr id="gr_svn21_197"

><td id="197"><a href="#197">197</a></td></tr
><tr id="gr_svn21_198"

><td id="198"><a href="#198">198</a></td></tr
><tr id="gr_svn21_199"

><td id="199"><a href="#199">199</a></td></tr
><tr id="gr_svn21_200"

><td id="200"><a href="#200">200</a></td></tr
><tr id="gr_svn21_201"

><td id="201"><a href="#201">201</a></td></tr
><tr id="gr_svn21_202"

><td id="202"><a href="#202">202</a></td></tr
><tr id="gr_svn21_203"

><td id="203"><a href="#203">203</a></td></tr
><tr id="gr_svn21_204"

><td id="204"><a href="#204">204</a></td></tr
><tr id="gr_svn21_205"

><td id="205"><a href="#205">205</a></td></tr
><tr id="gr_svn21_206"

><td id="206"><a href="#206">206</a></td></tr
><tr id="gr_svn21_207"

><td id="207"><a href="#207">207</a></td></tr
><tr id="gr_svn21_208"

><td id="208"><a href="#208">208</a></td></tr
><tr id="gr_svn21_209"

><td id="209"><a href="#209">209</a></td></tr
><tr id="gr_svn21_210"

><td id="210"><a href="#210">210</a></td></tr
><tr id="gr_svn21_211"

><td id="211"><a href="#211">211</a></td></tr
><tr id="gr_svn21_212"

><td id="212"><a href="#212">212</a></td></tr
><tr id="gr_svn21_213"

><td id="213"><a href="#213">213</a></td></tr
><tr id="gr_svn21_214"

><td id="214"><a href="#214">214</a></td></tr
><tr id="gr_svn21_215"

><td id="215"><a href="#215">215</a></td></tr
><tr id="gr_svn21_216"

><td id="216"><a href="#216">216</a></td></tr
><tr id="gr_svn21_217"

><td id="217"><a href="#217">217</a></td></tr
><tr id="gr_svn21_218"

><td id="218"><a href="#218">218</a></td></tr
><tr id="gr_svn21_219"

><td id="219"><a href="#219">219</a></td></tr
><tr id="gr_svn21_220"

><td id="220"><a href="#220">220</a></td></tr
><tr id="gr_svn21_221"

><td id="221"><a href="#221">221</a></td></tr
><tr id="gr_svn21_222"

><td id="222"><a href="#222">222</a></td></tr
><tr id="gr_svn21_223"

><td id="223"><a href="#223">223</a></td></tr
><tr id="gr_svn21_224"

><td id="224"><a href="#224">224</a></td></tr
><tr id="gr_svn21_225"

><td id="225"><a href="#225">225</a></td></tr
><tr id="gr_svn21_226"

><td id="226"><a href="#226">226</a></td></tr
><tr id="gr_svn21_227"

><td id="227"><a href="#227">227</a></td></tr
><tr id="gr_svn21_228"

><td id="228"><a href="#228">228</a></td></tr
><tr id="gr_svn21_229"

><td id="229"><a href="#229">229</a></td></tr
><tr id="gr_svn21_230"

><td id="230"><a href="#230">230</a></td></tr
><tr id="gr_svn21_231"

><td id="231"><a href="#231">231</a></td></tr
><tr id="gr_svn21_232"

><td id="232"><a href="#232">232</a></td></tr
><tr id="gr_svn21_233"

><td id="233"><a href="#233">233</a></td></tr
><tr id="gr_svn21_234"

><td id="234"><a href="#234">234</a></td></tr
><tr id="gr_svn21_235"

><td id="235"><a href="#235">235</a></td></tr
><tr id="gr_svn21_236"

><td id="236"><a href="#236">236</a></td></tr
><tr id="gr_svn21_237"

><td id="237"><a href="#237">237</a></td></tr
><tr id="gr_svn21_238"

><td id="238"><a href="#238">238</a></td></tr
><tr id="gr_svn21_239"

><td id="239"><a href="#239">239</a></td></tr
><tr id="gr_svn21_240"

><td id="240"><a href="#240">240</a></td></tr
><tr id="gr_svn21_241"

><td id="241"><a href="#241">241</a></td></tr
><tr id="gr_svn21_242"

><td id="242"><a href="#242">242</a></td></tr
><tr id="gr_svn21_243"

><td id="243"><a href="#243">243</a></td></tr
><tr id="gr_svn21_244"

><td id="244"><a href="#244">244</a></td></tr
><tr id="gr_svn21_245"

><td id="245"><a href="#245">245</a></td></tr
><tr id="gr_svn21_246"

><td id="246"><a href="#246">246</a></td></tr
><tr id="gr_svn21_247"

><td id="247"><a href="#247">247</a></td></tr
><tr id="gr_svn21_248"

><td id="248"><a href="#248">248</a></td></tr
><tr id="gr_svn21_249"

><td id="249"><a href="#249">249</a></td></tr
><tr id="gr_svn21_250"

><td id="250"><a href="#250">250</a></td></tr
><tr id="gr_svn21_251"

><td id="251"><a href="#251">251</a></td></tr
><tr id="gr_svn21_252"

><td id="252"><a href="#252">252</a></td></tr
><tr id="gr_svn21_253"

><td id="253"><a href="#253">253</a></td></tr
><tr id="gr_svn21_254"

><td id="254"><a href="#254">254</a></td></tr
><tr id="gr_svn21_255"

><td id="255"><a href="#255">255</a></td></tr
><tr id="gr_svn21_256"

><td id="256"><a href="#256">256</a></td></tr
><tr id="gr_svn21_257"

><td id="257"><a href="#257">257</a></td></tr
><tr id="gr_svn21_258"

><td id="258"><a href="#258">258</a></td></tr
><tr id="gr_svn21_259"

><td id="259"><a href="#259">259</a></td></tr
><tr id="gr_svn21_260"

><td id="260"><a href="#260">260</a></td></tr
><tr id="gr_svn21_261"

><td id="261"><a href="#261">261</a></td></tr
><tr id="gr_svn21_262"

><td id="262"><a href="#262">262</a></td></tr
><tr id="gr_svn21_263"

><td id="263"><a href="#263">263</a></td></tr
><tr id="gr_svn21_264"

><td id="264"><a href="#264">264</a></td></tr
><tr id="gr_svn21_265"

><td id="265"><a href="#265">265</a></td></tr
><tr id="gr_svn21_266"

><td id="266"><a href="#266">266</a></td></tr
><tr id="gr_svn21_267"

><td id="267"><a href="#267">267</a></td></tr
><tr id="gr_svn21_268"

><td id="268"><a href="#268">268</a></td></tr
><tr id="gr_svn21_269"

><td id="269"><a href="#269">269</a></td></tr
><tr id="gr_svn21_270"

><td id="270"><a href="#270">270</a></td></tr
><tr id="gr_svn21_271"

><td id="271"><a href="#271">271</a></td></tr
><tr id="gr_svn21_272"

><td id="272"><a href="#272">272</a></td></tr
><tr id="gr_svn21_273"

><td id="273"><a href="#273">273</a></td></tr
><tr id="gr_svn21_274"

><td id="274"><a href="#274">274</a></td></tr
><tr id="gr_svn21_275"

><td id="275"><a href="#275">275</a></td></tr
><tr id="gr_svn21_276"

><td id="276"><a href="#276">276</a></td></tr
><tr id="gr_svn21_277"

><td id="277"><a href="#277">277</a></td></tr
><tr id="gr_svn21_278"

><td id="278"><a href="#278">278</a></td></tr
><tr id="gr_svn21_279"

><td id="279"><a href="#279">279</a></td></tr
><tr id="gr_svn21_280"

><td id="280"><a href="#280">280</a></td></tr
><tr id="gr_svn21_281"

><td id="281"><a href="#281">281</a></td></tr
><tr id="gr_svn21_282"

><td id="282"><a href="#282">282</a></td></tr
><tr id="gr_svn21_283"

><td id="283"><a href="#283">283</a></td></tr
><tr id="gr_svn21_284"

><td id="284"><a href="#284">284</a></td></tr
><tr id="gr_svn21_285"

><td id="285"><a href="#285">285</a></td></tr
><tr id="gr_svn21_286"

><td id="286"><a href="#286">286</a></td></tr
><tr id="gr_svn21_287"

><td id="287"><a href="#287">287</a></td></tr
><tr id="gr_svn21_288"

><td id="288"><a href="#288">288</a></td></tr
><tr id="gr_svn21_289"

><td id="289"><a href="#289">289</a></td></tr
><tr id="gr_svn21_290"

><td id="290"><a href="#290">290</a></td></tr
><tr id="gr_svn21_291"

><td id="291"><a href="#291">291</a></td></tr
><tr id="gr_svn21_292"

><td id="292"><a href="#292">292</a></td></tr
><tr id="gr_svn21_293"

><td id="293"><a href="#293">293</a></td></tr
><tr id="gr_svn21_294"

><td id="294"><a href="#294">294</a></td></tr
><tr id="gr_svn21_295"

><td id="295"><a href="#295">295</a></td></tr
><tr id="gr_svn21_296"

><td id="296"><a href="#296">296</a></td></tr
><tr id="gr_svn21_297"

><td id="297"><a href="#297">297</a></td></tr
><tr id="gr_svn21_298"

><td id="298"><a href="#298">298</a></td></tr
><tr id="gr_svn21_299"

><td id="299"><a href="#299">299</a></td></tr
><tr id="gr_svn21_300"

><td id="300"><a href="#300">300</a></td></tr
><tr id="gr_svn21_301"

><td id="301"><a href="#301">301</a></td></tr
><tr id="gr_svn21_302"

><td id="302"><a href="#302">302</a></td></tr
><tr id="gr_svn21_303"

><td id="303"><a href="#303">303</a></td></tr
><tr id="gr_svn21_304"

><td id="304"><a href="#304">304</a></td></tr
><tr id="gr_svn21_305"

><td id="305"><a href="#305">305</a></td></tr
><tr id="gr_svn21_306"

><td id="306"><a href="#306">306</a></td></tr
><tr id="gr_svn21_307"

><td id="307"><a href="#307">307</a></td></tr
><tr id="gr_svn21_308"

><td id="308"><a href="#308">308</a></td></tr
><tr id="gr_svn21_309"

><td id="309"><a href="#309">309</a></td></tr
><tr id="gr_svn21_310"

><td id="310"><a href="#310">310</a></td></tr
><tr id="gr_svn21_311"

><td id="311"><a href="#311">311</a></td></tr
><tr id="gr_svn21_312"

><td id="312"><a href="#312">312</a></td></tr
><tr id="gr_svn21_313"

><td id="313"><a href="#313">313</a></td></tr
><tr id="gr_svn21_314"

><td id="314"><a href="#314">314</a></td></tr
><tr id="gr_svn21_315"

><td id="315"><a href="#315">315</a></td></tr
><tr id="gr_svn21_316"

><td id="316"><a href="#316">316</a></td></tr
><tr id="gr_svn21_317"

><td id="317"><a href="#317">317</a></td></tr
><tr id="gr_svn21_318"

><td id="318"><a href="#318">318</a></td></tr
><tr id="gr_svn21_319"

><td id="319"><a href="#319">319</a></td></tr
><tr id="gr_svn21_320"

><td id="320"><a href="#320">320</a></td></tr
><tr id="gr_svn21_321"

><td id="321"><a href="#321">321</a></td></tr
><tr id="gr_svn21_322"

><td id="322"><a href="#322">322</a></td></tr
><tr id="gr_svn21_323"

><td id="323"><a href="#323">323</a></td></tr
><tr id="gr_svn21_324"

><td id="324"><a href="#324">324</a></td></tr
><tr id="gr_svn21_325"

><td id="325"><a href="#325">325</a></td></tr
><tr id="gr_svn21_326"

><td id="326"><a href="#326">326</a></td></tr
><tr id="gr_svn21_327"

><td id="327"><a href="#327">327</a></td></tr
><tr id="gr_svn21_328"

><td id="328"><a href="#328">328</a></td></tr
><tr id="gr_svn21_329"

><td id="329"><a href="#329">329</a></td></tr
><tr id="gr_svn21_330"

><td id="330"><a href="#330">330</a></td></tr
><tr id="gr_svn21_331"

><td id="331"><a href="#331">331</a></td></tr
><tr id="gr_svn21_332"

><td id="332"><a href="#332">332</a></td></tr
><tr id="gr_svn21_333"

><td id="333"><a href="#333">333</a></td></tr
><tr id="gr_svn21_334"

><td id="334"><a href="#334">334</a></td></tr
><tr id="gr_svn21_335"

><td id="335"><a href="#335">335</a></td></tr
><tr id="gr_svn21_336"

><td id="336"><a href="#336">336</a></td></tr
><tr id="gr_svn21_337"

><td id="337"><a href="#337">337</a></td></tr
><tr id="gr_svn21_338"

><td id="338"><a href="#338">338</a></td></tr
><tr id="gr_svn21_339"

><td id="339"><a href="#339">339</a></td></tr
><tr id="gr_svn21_340"

><td id="340"><a href="#340">340</a></td></tr
><tr id="gr_svn21_341"

><td id="341"><a href="#341">341</a></td></tr
><tr id="gr_svn21_342"

><td id="342"><a href="#342">342</a></td></tr
><tr id="gr_svn21_343"

><td id="343"><a href="#343">343</a></td></tr
><tr id="gr_svn21_344"

><td id="344"><a href="#344">344</a></td></tr
><tr id="gr_svn21_345"

><td id="345"><a href="#345">345</a></td></tr
><tr id="gr_svn21_346"

><td id="346"><a href="#346">346</a></td></tr
><tr id="gr_svn21_347"

><td id="347"><a href="#347">347</a></td></tr
><tr id="gr_svn21_348"

><td id="348"><a href="#348">348</a></td></tr
><tr id="gr_svn21_349"

><td id="349"><a href="#349">349</a></td></tr
><tr id="gr_svn21_350"

><td id="350"><a href="#350">350</a></td></tr
><tr id="gr_svn21_351"

><td id="351"><a href="#351">351</a></td></tr
><tr id="gr_svn21_352"

><td id="352"><a href="#352">352</a></td></tr
><tr id="gr_svn21_353"

><td id="353"><a href="#353">353</a></td></tr
><tr id="gr_svn21_354"

><td id="354"><a href="#354">354</a></td></tr
><tr id="gr_svn21_355"

><td id="355"><a href="#355">355</a></td></tr
><tr id="gr_svn21_356"

><td id="356"><a href="#356">356</a></td></tr
><tr id="gr_svn21_357"

><td id="357"><a href="#357">357</a></td></tr
><tr id="gr_svn21_358"

><td id="358"><a href="#358">358</a></td></tr
><tr id="gr_svn21_359"

><td id="359"><a href="#359">359</a></td></tr
><tr id="gr_svn21_360"

><td id="360"><a href="#360">360</a></td></tr
><tr id="gr_svn21_361"

><td id="361"><a href="#361">361</a></td></tr
><tr id="gr_svn21_362"

><td id="362"><a href="#362">362</a></td></tr
><tr id="gr_svn21_363"

><td id="363"><a href="#363">363</a></td></tr
><tr id="gr_svn21_364"

><td id="364"><a href="#364">364</a></td></tr
><tr id="gr_svn21_365"

><td id="365"><a href="#365">365</a></td></tr
><tr id="gr_svn21_366"

><td id="366"><a href="#366">366</a></td></tr
><tr id="gr_svn21_367"

><td id="367"><a href="#367">367</a></td></tr
><tr id="gr_svn21_368"

><td id="368"><a href="#368">368</a></td></tr
><tr id="gr_svn21_369"

><td id="369"><a href="#369">369</a></td></tr
><tr id="gr_svn21_370"

><td id="370"><a href="#370">370</a></td></tr
><tr id="gr_svn21_371"

><td id="371"><a href="#371">371</a></td></tr
><tr id="gr_svn21_372"

><td id="372"><a href="#372">372</a></td></tr
><tr id="gr_svn21_373"

><td id="373"><a href="#373">373</a></td></tr
><tr id="gr_svn21_374"

><td id="374"><a href="#374">374</a></td></tr
><tr id="gr_svn21_375"

><td id="375"><a href="#375">375</a></td></tr
><tr id="gr_svn21_376"

><td id="376"><a href="#376">376</a></td></tr
><tr id="gr_svn21_377"

><td id="377"><a href="#377">377</a></td></tr
><tr id="gr_svn21_378"

><td id="378"><a href="#378">378</a></td></tr
><tr id="gr_svn21_379"

><td id="379"><a href="#379">379</a></td></tr
><tr id="gr_svn21_380"

><td id="380"><a href="#380">380</a></td></tr
><tr id="gr_svn21_381"

><td id="381"><a href="#381">381</a></td></tr
><tr id="gr_svn21_382"

><td id="382"><a href="#382">382</a></td></tr
><tr id="gr_svn21_383"

><td id="383"><a href="#383">383</a></td></tr
><tr id="gr_svn21_384"

><td id="384"><a href="#384">384</a></td></tr
><tr id="gr_svn21_385"

><td id="385"><a href="#385">385</a></td></tr
><tr id="gr_svn21_386"

><td id="386"><a href="#386">386</a></td></tr
><tr id="gr_svn21_387"

><td id="387"><a href="#387">387</a></td></tr
><tr id="gr_svn21_388"

><td id="388"><a href="#388">388</a></td></tr
><tr id="gr_svn21_389"

><td id="389"><a href="#389">389</a></td></tr
><tr id="gr_svn21_390"

><td id="390"><a href="#390">390</a></td></tr
><tr id="gr_svn21_391"

><td id="391"><a href="#391">391</a></td></tr
><tr id="gr_svn21_392"

><td id="392"><a href="#392">392</a></td></tr
><tr id="gr_svn21_393"

><td id="393"><a href="#393">393</a></td></tr
><tr id="gr_svn21_394"

><td id="394"><a href="#394">394</a></td></tr
><tr id="gr_svn21_395"

><td id="395"><a href="#395">395</a></td></tr
><tr id="gr_svn21_396"

><td id="396"><a href="#396">396</a></td></tr
><tr id="gr_svn21_397"

><td id="397"><a href="#397">397</a></td></tr
><tr id="gr_svn21_398"

><td id="398"><a href="#398">398</a></td></tr
><tr id="gr_svn21_399"

><td id="399"><a href="#399">399</a></td></tr
><tr id="gr_svn21_400"

><td id="400"><a href="#400">400</a></td></tr
><tr id="gr_svn21_401"

><td id="401"><a href="#401">401</a></td></tr
><tr id="gr_svn21_402"

><td id="402"><a href="#402">402</a></td></tr
><tr id="gr_svn21_403"

><td id="403"><a href="#403">403</a></td></tr
><tr id="gr_svn21_404"

><td id="404"><a href="#404">404</a></td></tr
><tr id="gr_svn21_405"

><td id="405"><a href="#405">405</a></td></tr
><tr id="gr_svn21_406"

><td id="406"><a href="#406">406</a></td></tr
><tr id="gr_svn21_407"

><td id="407"><a href="#407">407</a></td></tr
><tr id="gr_svn21_408"

><td id="408"><a href="#408">408</a></td></tr
><tr id="gr_svn21_409"

><td id="409"><a href="#409">409</a></td></tr
><tr id="gr_svn21_410"

><td id="410"><a href="#410">410</a></td></tr
><tr id="gr_svn21_411"

><td id="411"><a href="#411">411</a></td></tr
><tr id="gr_svn21_412"

><td id="412"><a href="#412">412</a></td></tr
><tr id="gr_svn21_413"

><td id="413"><a href="#413">413</a></td></tr
><tr id="gr_svn21_414"

><td id="414"><a href="#414">414</a></td></tr
><tr id="gr_svn21_415"

><td id="415"><a href="#415">415</a></td></tr
><tr id="gr_svn21_416"

><td id="416"><a href="#416">416</a></td></tr
><tr id="gr_svn21_417"

><td id="417"><a href="#417">417</a></td></tr
><tr id="gr_svn21_418"

><td id="418"><a href="#418">418</a></td></tr
><tr id="gr_svn21_419"

><td id="419"><a href="#419">419</a></td></tr
><tr id="gr_svn21_420"

><td id="420"><a href="#420">420</a></td></tr
><tr id="gr_svn21_421"

><td id="421"><a href="#421">421</a></td></tr
><tr id="gr_svn21_422"

><td id="422"><a href="#422">422</a></td></tr
><tr id="gr_svn21_423"

><td id="423"><a href="#423">423</a></td></tr
><tr id="gr_svn21_424"

><td id="424"><a href="#424">424</a></td></tr
><tr id="gr_svn21_425"

><td id="425"><a href="#425">425</a></td></tr
><tr id="gr_svn21_426"

><td id="426"><a href="#426">426</a></td></tr
><tr id="gr_svn21_427"

><td id="427"><a href="#427">427</a></td></tr
><tr id="gr_svn21_428"

><td id="428"><a href="#428">428</a></td></tr
><tr id="gr_svn21_429"

><td id="429"><a href="#429">429</a></td></tr
><tr id="gr_svn21_430"

><td id="430"><a href="#430">430</a></td></tr
><tr id="gr_svn21_431"

><td id="431"><a href="#431">431</a></td></tr
><tr id="gr_svn21_432"

><td id="432"><a href="#432">432</a></td></tr
><tr id="gr_svn21_433"

><td id="433"><a href="#433">433</a></td></tr
><tr id="gr_svn21_434"

><td id="434"><a href="#434">434</a></td></tr
><tr id="gr_svn21_435"

><td id="435"><a href="#435">435</a></td></tr
><tr id="gr_svn21_436"

><td id="436"><a href="#436">436</a></td></tr
><tr id="gr_svn21_437"

><td id="437"><a href="#437">437</a></td></tr
><tr id="gr_svn21_438"

><td id="438"><a href="#438">438</a></td></tr
><tr id="gr_svn21_439"

><td id="439"><a href="#439">439</a></td></tr
><tr id="gr_svn21_440"

><td id="440"><a href="#440">440</a></td></tr
><tr id="gr_svn21_441"

><td id="441"><a href="#441">441</a></td></tr
><tr id="gr_svn21_442"

><td id="442"><a href="#442">442</a></td></tr
><tr id="gr_svn21_443"

><td id="443"><a href="#443">443</a></td></tr
><tr id="gr_svn21_444"

><td id="444"><a href="#444">444</a></td></tr
><tr id="gr_svn21_445"

><td id="445"><a href="#445">445</a></td></tr
><tr id="gr_svn21_446"

><td id="446"><a href="#446">446</a></td></tr
><tr id="gr_svn21_447"

><td id="447"><a href="#447">447</a></td></tr
><tr id="gr_svn21_448"

><td id="448"><a href="#448">448</a></td></tr
></table></pre>
<pre><table width="100%"><tr class="nocursor"><td></td></tr></table></pre>
</td>
<td id="lines">
<pre><table width="100%"><tr class="cursor_stop cursor_hidden"><td></td></tr></table></pre>
<pre class="prettyprint lang-xsl"><table id="src_table_0"><tr
id=sl_svn21_1

><td class="source">&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;<br></td></tr
><tr
id=sl_svn21_2

><td class="source">&lt;!--<br></td></tr
><tr
id=sl_svn21_3

><td class="source">Copyright or © or Copr. Nicolas Debeissat<br></td></tr
><tr
id=sl_svn21_4

><td class="source"><br></td></tr
><tr
id=sl_svn21_5

><td class="source">nicolas.debeissat@gmail.com (http://debeissat.nicolas.free.fr/)<br></td></tr
><tr
id=sl_svn21_6

><td class="source"><br></td></tr
><tr
id=sl_svn21_7

><td class="source">This software is a computer program whose purpose is to convert a<br></td></tr
><tr
id=sl_svn21_8

><td class="source">XSD schema into a RelaxNG schema.<br></td></tr
><tr
id=sl_svn21_9

><td class="source"><br></td></tr
><tr
id=sl_svn21_10

><td class="source">This software is governed by the CeCILL license under French law and<br></td></tr
><tr
id=sl_svn21_11

><td class="source">abiding by the rules of distribution of free software.  You can  use, <br></td></tr
><tr
id=sl_svn21_12

><td class="source">modify and/ or redistribute the software under the terms of the CeCILL<br></td></tr
><tr
id=sl_svn21_13

><td class="source">license as circulated by CEA, CNRS and INRIA at the following URL<br></td></tr
><tr
id=sl_svn21_14

><td class="source">&quot;http://www.cecill.info&quot;. <br></td></tr
><tr
id=sl_svn21_15

><td class="source"><br></td></tr
><tr
id=sl_svn21_16

><td class="source">As a counterpart to the access to the source code and  rights to copy,<br></td></tr
><tr
id=sl_svn21_17

><td class="source">modify and redistribute granted by the license, users are provided only<br></td></tr
><tr
id=sl_svn21_18

><td class="source">with a limited warranty  and the software&#39;s author,  the holder of the<br></td></tr
><tr
id=sl_svn21_19

><td class="source">economic rights,  and the successive licensors  have only  limited<br></td></tr
><tr
id=sl_svn21_20

><td class="source">liability. <br></td></tr
><tr
id=sl_svn21_21

><td class="source"><br></td></tr
><tr
id=sl_svn21_22

><td class="source">In this respect, the user&#39;s attention is drawn to the risks associated<br></td></tr
><tr
id=sl_svn21_23

><td class="source">with loading,  using,  modifying and/or developing or reproducing the<br></td></tr
><tr
id=sl_svn21_24

><td class="source">software by the user in light of its specific status of free software,<br></td></tr
><tr
id=sl_svn21_25

><td class="source">that may mean  that it is complicated to manipulate,  and  that  also<br></td></tr
><tr
id=sl_svn21_26

><td class="source">therefore means  that it is reserved for developers  and  experienced<br></td></tr
><tr
id=sl_svn21_27

><td class="source">professionals having in-depth computer knowledge. Users are therefore<br></td></tr
><tr
id=sl_svn21_28

><td class="source">encouraged to load and test the software&#39;s suitability as regards their<br></td></tr
><tr
id=sl_svn21_29

><td class="source">requirements in conditions enabling the security of their systems and/or <br></td></tr
><tr
id=sl_svn21_30

><td class="source">data to be ensured and,  more generally, to use and operate it in the <br></td></tr
><tr
id=sl_svn21_31

><td class="source">same conditions as regards security. <br></td></tr
><tr
id=sl_svn21_32

><td class="source"><br></td></tr
><tr
id=sl_svn21_33

><td class="source">The fact that you are presently reading this means that you have had<br></td></tr
><tr
id=sl_svn21_34

><td class="source">knowledge of the CeCILL license and that you accept its terms.<br></td></tr
><tr
id=sl_svn21_35

><td class="source"><br></td></tr
><tr
id=sl_svn21_36

><td class="source">--&gt;<br></td></tr
><tr
id=sl_svn21_37

><td class="source">&lt;xsl:stylesheet xmlns:xsl=&quot;http://www.w3.org/1999/XSL/Transform&quot; xmlns:xs=&quot;http://www.w3.org/2001/XMLSchema&quot; xmlns:rng=&quot;http://relaxng.org/ns/structure/1.0&quot; xmlns:a=&quot;http://relaxng.org/ns/compatibility/annotations/1.0&quot; exclude-result-prefixes=&quot;xs&quot; version=&quot;1.0&quot;&gt;<br></td></tr
><tr
id=sl_svn21_38

><td class="source">	<br></td></tr
><tr
id=sl_svn21_39

><td class="source">	&lt;xsl:output indent=&quot;yes&quot; method=&quot;xml&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_40

><td class="source">	<br></td></tr
><tr
id=sl_svn21_41

><td class="source">	&lt;xsl:preserve-space elements=&quot;*&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_42

><td class="source">	<br></td></tr
><tr
id=sl_svn21_43

><td class="source">	&lt;xsl:template match=&quot;/xs:schema&quot;&gt;<br></td></tr
><tr
id=sl_svn21_44

><td class="source">		&lt;rng:grammar&gt;<br></td></tr
><tr
id=sl_svn21_45

><td class="source">			&lt;xsl:for-each select=&quot;namespace::*&quot;&gt;<br></td></tr
><tr
id=sl_svn21_46

><td class="source">				&lt;xsl:if test=&quot;local-name() != &#39;xs&#39;&quot;&gt;<br></td></tr
><tr
id=sl_svn21_47

><td class="source">					&lt;xsl:copy/&gt;<br></td></tr
><tr
id=sl_svn21_48

><td class="source">				&lt;/xsl:if&gt;<br></td></tr
><tr
id=sl_svn21_49

><td class="source">			&lt;/xsl:for-each&gt;<br></td></tr
><tr
id=sl_svn21_50

><td class="source">			&lt;xsl:attribute name=&quot;ns&quot;&gt;&lt;xsl:value-of select=&quot;@targetNamespace&quot;/&gt;&lt;/xsl:attribute&gt;<br></td></tr
><tr
id=sl_svn21_51

><td class="source">			&lt;xsl:attribute name=&quot;datatypeLibrary&quot;&gt;http://www.w3.org/2001/XMLSchema-datatypes&lt;/xsl:attribute&gt;<br></td></tr
><tr
id=sl_svn21_52

><td class="source">			&lt;xsl:apply-templates/&gt;<br></td></tr
><tr
id=sl_svn21_53

><td class="source">		&lt;/rng:grammar&gt;<br></td></tr
><tr
id=sl_svn21_54

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_55

><td class="source">	<br></td></tr
><tr
id=sl_svn21_56

><td class="source">	&lt;!-- in order to manage occurrences (and defaut) attributes goes there<br></td></tr
><tr
id=sl_svn21_57

><td class="source">		 before going to mode=&quot;content&quot; templates --&gt;<br></td></tr
><tr
id=sl_svn21_58

><td class="source">	&lt;xsl:template match=&quot;xs:*&quot;&gt;<br></td></tr
><tr
id=sl_svn21_59

><td class="source">		&lt;xsl:call-template name=&quot;occurrences&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_60

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_61

><td class="source">	<br></td></tr
><tr
id=sl_svn21_62

><td class="source">	&lt;xsl:template match=&quot;comment()&quot;&gt;<br></td></tr
><tr
id=sl_svn21_63

><td class="source">		&lt;xsl:copy/&gt;<br></td></tr
><tr
id=sl_svn21_64

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_65

><td class="source">	<br></td></tr
><tr
id=sl_svn21_66

><td class="source">	&lt;!-- unique and key are not supported in RelaxNG, must be done in schematron --&gt;<br></td></tr
><tr
id=sl_svn21_67

><td class="source">	&lt;xsl:template match=&quot;xs:unique|xs:key&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_68

><td class="source">	<br></td></tr
><tr
id=sl_svn21_69

><td class="source">	&lt;xsl:template match=&quot;xs:annotation&quot;&gt;<br></td></tr
><tr
id=sl_svn21_70

><td class="source">		&lt;a:documentation&gt;<br></td></tr
><tr
id=sl_svn21_71

><td class="source">			&lt;xsl:apply-templates/&gt;<br></td></tr
><tr
id=sl_svn21_72

><td class="source">		&lt;/a:documentation&gt;<br></td></tr
><tr
id=sl_svn21_73

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_74

><td class="source">	<br></td></tr
><tr
id=sl_svn21_75

><td class="source">	&lt;xsl:template match=&quot;xs:documentation&quot;&gt;<br></td></tr
><tr
id=sl_svn21_76

><td class="source">		&lt;xsl:copy-of select=&quot;child::node()&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_77

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_78

><td class="source">	<br></td></tr
><tr
id=sl_svn21_79

><td class="source">	&lt;xsl:template match=&quot;xs:appinfo&quot;&gt;<br></td></tr
><tr
id=sl_svn21_80

><td class="source">		&lt;xsl:copy-of select=&quot;child::node()&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_81

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_82

><td class="source">	<br></td></tr
><tr
id=sl_svn21_83

><td class="source">	&lt;xsl:template match=&quot;xs:union&quot;&gt;<br></td></tr
><tr
id=sl_svn21_84

><td class="source">		&lt;rng:choice&gt;<br></td></tr
><tr
id=sl_svn21_85

><td class="source">			&lt;xsl:apply-templates select=&quot;@memberTypes&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_86

><td class="source">			&lt;xsl:apply-templates/&gt;<br></td></tr
><tr
id=sl_svn21_87

><td class="source">		&lt;/rng:choice&gt;<br></td></tr
><tr
id=sl_svn21_88

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_89

><td class="source">	<br></td></tr
><tr
id=sl_svn21_90

><td class="source">	&lt;xsl:template match=&quot;@memberTypes&quot;&gt;<br></td></tr
><tr
id=sl_svn21_91

><td class="source">		&lt;xsl:call-template name=&quot;declareMemberTypes&quot;&gt;<br></td></tr
><tr
id=sl_svn21_92

><td class="source">			&lt;xsl:with-param name=&quot;memberTypes&quot; select=&quot;.&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_93

><td class="source">		&lt;/xsl:call-template&gt;<br></td></tr
><tr
id=sl_svn21_94

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_95

><td class="source">	<br></td></tr
><tr
id=sl_svn21_96

><td class="source">	&lt;xsl:template match=&quot;xs:list&quot;&gt;<br></td></tr
><tr
id=sl_svn21_97

><td class="source">		&lt;rng:list&gt;<br></td></tr
><tr
id=sl_svn21_98

><td class="source">			&lt;xsl:apply-templates select=&quot;@itemType&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_99

><td class="source">			&lt;xsl:apply-templates/&gt;<br></td></tr
><tr
id=sl_svn21_100

><td class="source">		&lt;/rng:list&gt;<br></td></tr
><tr
id=sl_svn21_101

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_102

><td class="source">	<br></td></tr
><tr
id=sl_svn21_103

><td class="source">	&lt;xsl:template match=&quot;@itemType&quot;&gt;<br></td></tr
><tr
id=sl_svn21_104

><td class="source">		&lt;xsl:call-template name=&quot;type&quot;&gt;<br></td></tr
><tr
id=sl_svn21_105

><td class="source">			&lt;xsl:with-param name=&quot;type&quot; select=&quot;.&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_106

><td class="source">		&lt;/xsl:call-template&gt;<br></td></tr
><tr
id=sl_svn21_107

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_108

><td class="source">	<br></td></tr
><tr
id=sl_svn21_109

><td class="source">	&lt;xsl:template match=&quot;xs:complexType[@name]|xs:simpleType[@name]|xs:group[@name]|xs:attributeGroup[@name]&quot;&gt;<br></td></tr
><tr
id=sl_svn21_110

><td class="source">		&lt;!-- the schemas may be included several times, so it needs a combine attribute<br></td></tr
><tr
id=sl_svn21_111

><td class="source">                                     (the attributes are inversed :-) at the transformation) --&gt;<br></td></tr
><tr
id=sl_svn21_112

><td class="source">		&lt;rng:define name=&quot;{@name}&quot;&gt;<br></td></tr
><tr
id=sl_svn21_113

><td class="source">			&lt;!-- work-around for empty issue --&gt;<br></td></tr
><tr
id=sl_svn21_114

><td class="source">			&lt;xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_115

><td class="source">				&lt;xsl:when test=&quot;not(*[local-name() != &#39;annotation&#39;])&quot;&gt;<br></td></tr
><tr
id=sl_svn21_116

><td class="source">					&lt;rng:empty/&gt;<br></td></tr
><tr
id=sl_svn21_117

><td class="source">					&lt;xsl:apply-templates/&gt;<br></td></tr
><tr
id=sl_svn21_118

><td class="source">				&lt;/xsl:when&gt;<br></td></tr
><tr
id=sl_svn21_119

><td class="source">				&lt;xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_120

><td class="source">					&lt;xsl:apply-templates/&gt;<br></td></tr
><tr
id=sl_svn21_121

><td class="source">				&lt;/xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_122

><td class="source">			&lt;/xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_123

><td class="source">		&lt;/rng:define&gt;<br></td></tr
><tr
id=sl_svn21_124

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_125

><td class="source">	<br></td></tr
><tr
id=sl_svn21_126

><td class="source">	&lt;!-- when finds a ref attribute replace it by its type call (ref name=&quot;&quot; or type) --&gt;	<br></td></tr
><tr
id=sl_svn21_127

><td class="source">	&lt;xsl:template match=&quot;xs:*[@ref]&quot; mode=&quot;content&quot;&gt;<br></td></tr
><tr
id=sl_svn21_128

><td class="source">		&lt;!-- when finds a attribute declaraction with a ref attribute replace it by<br></td></tr
><tr
id=sl_svn21_129

><td class="source">		its type call prefixed by attr_ --&gt;<br></td></tr
><tr
id=sl_svn21_130

><td class="source">		&lt;xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_131

><td class="source">			&lt;xsl:when test=&quot;local-name() = &#39;attribute&#39;&quot;&gt;<br></td></tr
><tr
id=sl_svn21_132

><td class="source">				&lt;xsl:variable name=&quot;type&quot;&gt;<br></td></tr
><tr
id=sl_svn21_133

><td class="source">					&lt;xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_134

><td class="source">						&lt;xsl:when test=&quot;contains(@ref, &#39;:&#39;)&quot;&gt;<br></td></tr
><tr
id=sl_svn21_135

><td class="source">							&lt;xsl:value-of select=&quot;concat(&#39;attr_&#39;, substring-after(@ref, &#39;:&#39;))&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_136

><td class="source">						&lt;/xsl:when&gt;<br></td></tr
><tr
id=sl_svn21_137

><td class="source">						&lt;xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_138

><td class="source">							&lt;xsl:value-of select=&quot;concat(&#39;attr_&#39;, @ref)&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_139

><td class="source">						&lt;/xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_140

><td class="source">					&lt;/xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_141

><td class="source">				&lt;/xsl:variable&gt;<br></td></tr
><tr
id=sl_svn21_142

><td class="source">				&lt;xsl:call-template name=&quot;type&quot;&gt;<br></td></tr
><tr
id=sl_svn21_143

><td class="source">					&lt;xsl:with-param name=&quot;type&quot; select=&quot;$type&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_144

><td class="source">				&lt;/xsl:call-template&gt;<br></td></tr
><tr
id=sl_svn21_145

><td class="source">			&lt;/xsl:when&gt;<br></td></tr
><tr
id=sl_svn21_146

><td class="source">			&lt;xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_147

><td class="source">				&lt;xsl:call-template name=&quot;type&quot;&gt;<br></td></tr
><tr
id=sl_svn21_148

><td class="source">					&lt;xsl:with-param name=&quot;type&quot; select=&quot;@ref&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_149

><td class="source">				&lt;/xsl:call-template&gt;<br></td></tr
><tr
id=sl_svn21_150

><td class="source">			&lt;/xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_151

><td class="source">		&lt;/xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_152

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_153

><td class="source">	<br></td></tr
><tr
id=sl_svn21_154

><td class="source">    &lt;!-- the &lt;xs:simpleType&gt; and &lt;xs:complexType without name attribute are ignored --&gt;<br></td></tr
><tr
id=sl_svn21_155

><td class="source">	&lt;xsl:template match=&quot;xs:sequence|xs:simpleContent|xs:complexContent|xs:simpleType|xs:complexType&quot;&gt;<br></td></tr
><tr
id=sl_svn21_156

><td class="source">		&lt;xsl:apply-templates/&gt;<br></td></tr
><tr
id=sl_svn21_157

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_158

><td class="source">	<br></td></tr
><tr
id=sl_svn21_159

><td class="source">	&lt;xsl:template match=&quot;xs:extension[@base]&quot;&gt;<br></td></tr
><tr
id=sl_svn21_160

><td class="source">		&lt;xsl:call-template name=&quot;type&quot;&gt;<br></td></tr
><tr
id=sl_svn21_161

><td class="source">			&lt;xsl:with-param name=&quot;type&quot; select=&quot;@base&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_162

><td class="source">		&lt;/xsl:call-template&gt;<br></td></tr
><tr
id=sl_svn21_163

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_164

><td class="source">    <br></td></tr
><tr
id=sl_svn21_165

><td class="source">	&lt;xsl:template match=&quot;xs:element[@name]&quot;&gt;<br></td></tr
><tr
id=sl_svn21_166

><td class="source">		&lt;!-- case of root element --&gt;<br></td></tr
><tr
id=sl_svn21_167

><td class="source">		&lt;xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_168

><td class="source">			&lt;xsl:when test=&quot;parent::xs:schema&quot;&gt;<br></td></tr
><tr
id=sl_svn21_169

><td class="source">				&lt;rng:start combine=&quot;choice&quot;&gt;<br></td></tr
><tr
id=sl_svn21_170

><td class="source">					&lt;!-- must introduce prefix in order not to override a complextype of the same name --&gt;<br></td></tr
><tr
id=sl_svn21_171

><td class="source">					&lt;rng:ref name=&quot;starting_{@name}&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_172

><td class="source">				&lt;/rng:start&gt;<br></td></tr
><tr
id=sl_svn21_173

><td class="source">				&lt;rng:define name=&quot;starting_{@name}&quot;&gt;<br></td></tr
><tr
id=sl_svn21_174

><td class="source">					&lt;xsl:apply-templates select=&quot;current()&quot; mode=&quot;content&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_175

><td class="source">				&lt;/rng:define&gt;<br></td></tr
><tr
id=sl_svn21_176

><td class="source">			&lt;/xsl:when&gt;<br></td></tr
><tr
id=sl_svn21_177

><td class="source">			&lt;xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_178

><td class="source">				&lt;xsl:call-template name=&quot;occurrences&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_179

><td class="source">			&lt;/xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_180

><td class="source">		&lt;/xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_181

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_182

><td class="source">    <br></td></tr
><tr
id=sl_svn21_183

><td class="source">	&lt;xsl:template match=&quot;xs:restriction[@base]&quot;&gt;<br></td></tr
><tr
id=sl_svn21_184

><td class="source">		&lt;xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_185

><td class="source">			&lt;xsl:when test=&quot;xs:enumeration[@value]&quot;&gt;<br></td></tr
><tr
id=sl_svn21_186

><td class="source">				&lt;rng:choice&gt;<br></td></tr
><tr
id=sl_svn21_187

><td class="source">					&lt;xsl:apply-templates/&gt;<br></td></tr
><tr
id=sl_svn21_188

><td class="source">				&lt;/rng:choice&gt;<br></td></tr
><tr
id=sl_svn21_189

><td class="source">			&lt;/xsl:when&gt;<br></td></tr
><tr
id=sl_svn21_190

><td class="source">			&lt;xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_191

><td class="source">				&lt;xsl:call-template name=&quot;type&quot;&gt;<br></td></tr
><tr
id=sl_svn21_192

><td class="source">					&lt;xsl:with-param name=&quot;type&quot; select=&quot;@base&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_193

><td class="source">				&lt;/xsl:call-template&gt;<br></td></tr
><tr
id=sl_svn21_194

><td class="source">			&lt;/xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_195

><td class="source">		&lt;/xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_196

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_197

><td class="source">	<br></td></tr
><tr
id=sl_svn21_198

><td class="source">	&lt;xsl:template match=&quot;xs:enumeration[@value]&quot;&gt;<br></td></tr
><tr
id=sl_svn21_199

><td class="source">		&lt;rng:value&gt;<br></td></tr
><tr
id=sl_svn21_200

><td class="source">			&lt;xsl:value-of select=&quot;@value&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_201

><td class="source">		&lt;/rng:value&gt;<br></td></tr
><tr
id=sl_svn21_202

><td class="source">		&lt;xsl:apply-templates/&gt;<br></td></tr
><tr
id=sl_svn21_203

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_204

><td class="source">	<br></td></tr
><tr
id=sl_svn21_205

><td class="source">    &lt;!--<br></td></tr
><tr
id=sl_svn21_206

><td class="source"> support for fractionDigits, length, maxExclusive, maxInclusive, maxLength, minExclusive, minInclusive, minLength, pattern, totalDigits, whiteSpace<br></td></tr
><tr
id=sl_svn21_207

><td class="source">explicit removal of enumeration as not all the XSLT processor respect templates priority<br></td></tr
><tr
id=sl_svn21_208

><td class="source"> --&gt;<br></td></tr
><tr
id=sl_svn21_209

><td class="source">	&lt;xsl:template match=&quot;xs:*[not(self::xs:enumeration)][@value]&quot;&gt;<br></td></tr
><tr
id=sl_svn21_210

><td class="source">		&lt;rng:param name=&quot;{local-name()}&quot;&gt;<br></td></tr
><tr
id=sl_svn21_211

><td class="source">			&lt;xsl:value-of select=&quot;@value&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_212

><td class="source">		&lt;/rng:param&gt;<br></td></tr
><tr
id=sl_svn21_213

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_214

><td class="source">	<br></td></tr
><tr
id=sl_svn21_215

><td class="source">	&lt;xsl:template match=&quot;xs:all&quot;&gt;<br></td></tr
><tr
id=sl_svn21_216

><td class="source">		&lt;rng:interleave&gt;<br></td></tr
><tr
id=sl_svn21_217

><td class="source">			&lt;xsl:for-each select=&quot;child::text()[normalize-space(.) != &#39;&#39;] | child::*&quot;&gt;<br></td></tr
><tr
id=sl_svn21_218

><td class="source">				&lt;rng:optional&gt;<br></td></tr
><tr
id=sl_svn21_219

><td class="source">					&lt;xsl:apply-templates select=&quot;current()&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_220

><td class="source">				&lt;/rng:optional&gt;<br></td></tr
><tr
id=sl_svn21_221

><td class="source">			&lt;/xsl:for-each&gt;<br></td></tr
><tr
id=sl_svn21_222

><td class="source">		&lt;/rng:interleave&gt;<br></td></tr
><tr
id=sl_svn21_223

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_224

><td class="source">	<br></td></tr
><tr
id=sl_svn21_225

><td class="source">	&lt;xsl:template match=&quot;xs:import|xs:include|xs:redefine&quot;&gt;<br></td></tr
><tr
id=sl_svn21_226

><td class="source">		&lt;rng:include&gt;<br></td></tr
><tr
id=sl_svn21_227

><td class="source">			&lt;xsl:if test=&quot;@schemaLocation&quot;&gt;<br></td></tr
><tr
id=sl_svn21_228

><td class="source">				&lt;xsl:attribute name=&quot;href&quot;&gt;&lt;xsl:value-of select=&quot;concat(substring-before(@schemaLocation, &#39;.xsd&#39;),&#39;.rng&#39;)&quot;/&gt;&lt;/xsl:attribute&gt;<br></td></tr
><tr
id=sl_svn21_229

><td class="source">			&lt;/xsl:if&gt;<br></td></tr
><tr
id=sl_svn21_230

><td class="source">			&lt;xsl:if test=&quot;@namespace&quot;&gt;<br></td></tr
><tr
id=sl_svn21_231

><td class="source">				&lt;xsl:attribute name=&quot;ns&quot;&gt;&lt;xsl:value-of select=&quot;@namespace&quot;/&gt;&lt;/xsl:attribute&gt;<br></td></tr
><tr
id=sl_svn21_232

><td class="source">			&lt;/xsl:if&gt;<br></td></tr
><tr
id=sl_svn21_233

><td class="source">			&lt;xsl:apply-templates/&gt;<br></td></tr
><tr
id=sl_svn21_234

><td class="source">		&lt;/rng:include&gt;<br></td></tr
><tr
id=sl_svn21_235

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_236

><td class="source">    <br></td></tr
><tr
id=sl_svn21_237

><td class="source">	&lt;xsl:template match=&quot;@default&quot;&gt;<br></td></tr
><tr
id=sl_svn21_238

><td class="source">		&lt;a:documentation&gt;<br></td></tr
><tr
id=sl_svn21_239

><td class="source">            default value is : &lt;xsl:value-of select=&quot;.&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_240

><td class="source">		&lt;/a:documentation&gt;<br></td></tr
><tr
id=sl_svn21_241

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_242

><td class="source">    <br></td></tr
><tr
id=sl_svn21_243

><td class="source">    &lt;xsl:template match=&quot;xs:attribute[@name]&quot;&gt;<br></td></tr
><tr
id=sl_svn21_244

><td class="source">    	&lt;xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_245

><td class="source">    		&lt;!-- attributes specified at schema level --&gt;<br></td></tr
><tr
id=sl_svn21_246

><td class="source">    		&lt;xsl:when test=&quot;parent::xs:schema&quot;&gt;<br></td></tr
><tr
id=sl_svn21_247

><td class="source">	    		&lt;rng:define name=&quot;attr_{@name}&quot;&gt;<br></td></tr
><tr
id=sl_svn21_248

><td class="source">					&lt;xsl:apply-templates select=&quot;current()&quot; mode=&quot;occurrences&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_249

><td class="source">				&lt;/rng:define&gt;<br></td></tr
><tr
id=sl_svn21_250

><td class="source">    		&lt;/xsl:when&gt;<br></td></tr
><tr
id=sl_svn21_251

><td class="source">    		&lt;xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_252

><td class="source">    			&lt;xsl:apply-templates select=&quot;current()&quot; mode=&quot;occurrences&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_253

><td class="source">    		&lt;/xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_254

><td class="source">    	&lt;/xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_255

><td class="source">    &lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_256

><td class="source">	<br></td></tr
><tr
id=sl_svn21_257

><td class="source">	&lt;xsl:template match=&quot;xs:attribute[@name]&quot; mode=&quot;occurrences&quot;&gt;<br></td></tr
><tr
id=sl_svn21_258

><td class="source">		&lt;xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_259

><td class="source">			&lt;xsl:when test=&quot;@use and @use=&#39;prohibited&#39;&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_260

><td class="source">			&lt;xsl:when test=&quot;@use and @use=&#39;required&#39;&quot;&gt;<br></td></tr
><tr
id=sl_svn21_261

><td class="source">				&lt;xsl:apply-templates select=&quot;current()&quot; mode=&quot;content&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_262

><td class="source">			&lt;/xsl:when&gt;<br></td></tr
><tr
id=sl_svn21_263

><td class="source">			&lt;!-- by default, attributes are optional --&gt;<br></td></tr
><tr
id=sl_svn21_264

><td class="source">			&lt;xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_265

><td class="source">				&lt;rng:optional&gt;<br></td></tr
><tr
id=sl_svn21_266

><td class="source">					&lt;xsl:apply-templates select=&quot;current()&quot; mode=&quot;content&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_267

><td class="source">				&lt;/rng:optional&gt;<br></td></tr
><tr
id=sl_svn21_268

><td class="source">			&lt;/xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_269

><td class="source">		&lt;/xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_270

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_271

><td class="source">    <br></td></tr
><tr
id=sl_svn21_272

><td class="source">	&lt;xsl:template match=&quot;xs:attribute[@name]&quot; mode=&quot;content&quot;&gt;<br></td></tr
><tr
id=sl_svn21_273

><td class="source">		&lt;rng:attribute name=&quot;{@name}&quot;&gt;<br></td></tr
><tr
id=sl_svn21_274

><td class="source">			&lt;xsl:apply-templates select=&quot;@default&quot; mode=&quot;attributeDefaultValue&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_275

><td class="source">			&lt;!-- there can be no type attribute to &lt;xs:attribute&gt;, in this case, the type is defined in <br></td></tr
><tr
id=sl_svn21_276

><td class="source">                                    a &lt;xs:simpleType&gt; or a &lt;xs:complexType&gt; inside --&gt;<br></td></tr
><tr
id=sl_svn21_277

><td class="source">			&lt;xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_278

><td class="source">				&lt;xsl:when test=&quot;@type&quot;&gt;<br></td></tr
><tr
id=sl_svn21_279

><td class="source">					&lt;xsl:call-template name=&quot;type&quot;&gt;<br></td></tr
><tr
id=sl_svn21_280

><td class="source">						&lt;xsl:with-param name=&quot;type&quot; select=&quot;@type&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_281

><td class="source">					&lt;/xsl:call-template&gt;<br></td></tr
><tr
id=sl_svn21_282

><td class="source">				&lt;/xsl:when&gt;<br></td></tr
><tr
id=sl_svn21_283

><td class="source">				&lt;xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_284

><td class="source">					&lt;xsl:apply-templates/&gt;<br></td></tr
><tr
id=sl_svn21_285

><td class="source">				&lt;/xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_286

><td class="source">			&lt;/xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_287

><td class="source">		&lt;/rng:attribute&gt;<br></td></tr
><tr
id=sl_svn21_288

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_289

><td class="source">	<br></td></tr
><tr
id=sl_svn21_290

><td class="source">	&lt;xsl:template match=&quot;@default&quot; mode=&quot;attributeDefaultValue&quot;&gt;<br></td></tr
><tr
id=sl_svn21_291

><td class="source">    	&lt;xsl:attribute name=&quot;defaultValue&quot; namespace=&quot;http://relaxng.org/ns/compatibility/annotations/1.0&quot;&gt;<br></td></tr
><tr
id=sl_svn21_292

><td class="source">    		&lt;xsl:value-of select=&quot;.&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_293

><td class="source">    	&lt;/xsl:attribute&gt;<br></td></tr
><tr
id=sl_svn21_294

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_295

><td class="source">	<br></td></tr
><tr
id=sl_svn21_296

><td class="source">	&lt;xsl:template match=&quot;xs:any&quot; mode=&quot;content&quot;&gt;<br></td></tr
><tr
id=sl_svn21_297

><td class="source">		&lt;rng:element&gt;<br></td></tr
><tr
id=sl_svn21_298

><td class="source">			&lt;rng:anyName/&gt;<br></td></tr
><tr
id=sl_svn21_299

><td class="source">			&lt;rng:text/&gt;<br></td></tr
><tr
id=sl_svn21_300

><td class="source">		&lt;/rng:element&gt;<br></td></tr
><tr
id=sl_svn21_301

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_302

><td class="source">	<br></td></tr
><tr
id=sl_svn21_303

><td class="source">	&lt;xsl:template match=&quot;xs:anyAttribute&quot; mode=&quot;content&quot;&gt;<br></td></tr
><tr
id=sl_svn21_304

><td class="source">		&lt;rng:attribute&gt;<br></td></tr
><tr
id=sl_svn21_305

><td class="source">			&lt;rng:anyName/&gt;<br></td></tr
><tr
id=sl_svn21_306

><td class="source">			&lt;rng:text/&gt;<br></td></tr
><tr
id=sl_svn21_307

><td class="source">		&lt;/rng:attribute&gt;<br></td></tr
><tr
id=sl_svn21_308

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_309

><td class="source">	<br></td></tr
><tr
id=sl_svn21_310

><td class="source">	&lt;xsl:template match=&quot;xs:choice&quot; mode=&quot;content&quot;&gt;<br></td></tr
><tr
id=sl_svn21_311

><td class="source">		&lt;rng:choice&gt;<br></td></tr
><tr
id=sl_svn21_312

><td class="source">			&lt;xsl:apply-templates/&gt;<br></td></tr
><tr
id=sl_svn21_313

><td class="source">		&lt;/rng:choice&gt;<br></td></tr
><tr
id=sl_svn21_314

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_315

><td class="source">	<br></td></tr
><tr
id=sl_svn21_316

><td class="source">	&lt;xsl:template match=&quot;xs:element&quot; mode=&quot;content&quot;&gt;<br></td></tr
><tr
id=sl_svn21_317

><td class="source">		&lt;rng:element name=&quot;{@name}&quot;&gt;<br></td></tr
><tr
id=sl_svn21_318

><td class="source">			&lt;xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_319

><td class="source">				&lt;xsl:when test=&quot;@type&quot;&gt;<br></td></tr
><tr
id=sl_svn21_320

><td class="source">					&lt;xsl:call-template name=&quot;type&quot;&gt;<br></td></tr
><tr
id=sl_svn21_321

><td class="source">						&lt;xsl:with-param name=&quot;type&quot; select=&quot;@type&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_322

><td class="source">					&lt;/xsl:call-template&gt;<br></td></tr
><tr
id=sl_svn21_323

><td class="source">				&lt;/xsl:when&gt;<br></td></tr
><tr
id=sl_svn21_324

><td class="source">				&lt;!-- work-around for empty issue --&gt;<br></td></tr
><tr
id=sl_svn21_325

><td class="source">				&lt;xsl:when test=&quot;not(*[local-name() != &#39;annotation&#39;]) and not(@type)&quot;&gt;<br></td></tr
><tr
id=sl_svn21_326

><td class="source">					&lt;rng:empty/&gt;<br></td></tr
><tr
id=sl_svn21_327

><td class="source">					&lt;xsl:apply-templates/&gt;<br></td></tr
><tr
id=sl_svn21_328

><td class="source">				&lt;/xsl:when&gt;<br></td></tr
><tr
id=sl_svn21_329

><td class="source">				&lt;xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_330

><td class="source">					&lt;xsl:apply-templates/&gt;<br></td></tr
><tr
id=sl_svn21_331

><td class="source">				&lt;/xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_332

><td class="source">			&lt;/xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_333

><td class="source">		&lt;/rng:element&gt;<br></td></tr
><tr
id=sl_svn21_334

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_335

><td class="source">	<br></td></tr
><tr
id=sl_svn21_336

><td class="source">	&lt;xsl:template name=&quot;occurrences&quot;&gt;<br></td></tr
><tr
id=sl_svn21_337

><td class="source">		&lt;xsl:apply-templates select=&quot;@default&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_338

><td class="source">		&lt;xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_339

><td class="source">			&lt;xsl:when test=&quot;@maxOccurs and @maxOccurs=&#39;unbounded&#39;&quot;&gt;<br></td></tr
><tr
id=sl_svn21_340

><td class="source">				&lt;xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_341

><td class="source">					&lt;xsl:when test=&quot;@minOccurs and @minOccurs=&#39;0&#39;&quot;&gt;<br></td></tr
><tr
id=sl_svn21_342

><td class="source">						&lt;rng:zeroOrMore&gt;<br></td></tr
><tr
id=sl_svn21_343

><td class="source">							&lt;xsl:apply-templates select=&quot;current()&quot; mode=&quot;content&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_344

><td class="source">						&lt;/rng:zeroOrMore&gt;<br></td></tr
><tr
id=sl_svn21_345

><td class="source">					&lt;/xsl:when&gt;<br></td></tr
><tr
id=sl_svn21_346

><td class="source">					&lt;xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_347

><td class="source">						&lt;rng:oneOrMore&gt;<br></td></tr
><tr
id=sl_svn21_348

><td class="source">							&lt;xsl:apply-templates select=&quot;current()&quot; mode=&quot;content&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_349

><td class="source">						&lt;/rng:oneOrMore&gt;<br></td></tr
><tr
id=sl_svn21_350

><td class="source">					&lt;/xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_351

><td class="source">				&lt;/xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_352

><td class="source">			&lt;/xsl:when&gt;<br></td></tr
><tr
id=sl_svn21_353

><td class="source">			&lt;xsl:when test=&quot;@minOccurs and @minOccurs=&#39;0&#39;&quot;&gt;<br></td></tr
><tr
id=sl_svn21_354

><td class="source">				&lt;rng:optional&gt;<br></td></tr
><tr
id=sl_svn21_355

><td class="source">					&lt;xsl:apply-templates select=&quot;current()&quot; mode=&quot;content&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_356

><td class="source">				&lt;/rng:optional&gt;<br></td></tr
><tr
id=sl_svn21_357

><td class="source">			&lt;/xsl:when&gt;<br></td></tr
><tr
id=sl_svn21_358

><td class="source">			&lt;!-- here minOccurs is present but not = 0 --&gt;<br></td></tr
><tr
id=sl_svn21_359

><td class="source">			&lt;xsl:when test=&quot;@minOccurs&quot;&gt;<br></td></tr
><tr
id=sl_svn21_360

><td class="source">				&lt;xsl:call-template name=&quot;loopUntilZero&quot;&gt;<br></td></tr
><tr
id=sl_svn21_361

><td class="source">					&lt;xsl:with-param name=&quot;nbLoops&quot; select=&quot;@minOccurs&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_362

><td class="source">				&lt;/xsl:call-template&gt;<br></td></tr
><tr
id=sl_svn21_363

><td class="source">			&lt;/xsl:when&gt;<br></td></tr
><tr
id=sl_svn21_364

><td class="source">			&lt;xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_365

><td class="source">				&lt;xsl:apply-templates select=&quot;current()&quot; mode=&quot;content&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_366

><td class="source">			&lt;/xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_367

><td class="source">		&lt;/xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_368

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_369

><td class="source"><br></td></tr
><tr
id=sl_svn21_370

><td class="source">	&lt;xsl:template name=&quot;loopUntilZero&quot;&gt;<br></td></tr
><tr
id=sl_svn21_371

><td class="source">		&lt;xsl:param name=&quot;nbLoops&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_372

><td class="source">		&lt;xsl:if test=&quot;$nbLoops &gt; 0&quot;&gt;<br></td></tr
><tr
id=sl_svn21_373

><td class="source">			&lt;xsl:apply-templates select=&quot;current()&quot; mode=&quot;content&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_374

><td class="source">			&lt;xsl:call-template name=&quot;loopUntilZero&quot;&gt;<br></td></tr
><tr
id=sl_svn21_375

><td class="source">				&lt;xsl:with-param name=&quot;nbLoops&quot; select=&quot;$nbLoops - 1&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_376

><td class="source">			&lt;/xsl:call-template&gt;<br></td></tr
><tr
id=sl_svn21_377

><td class="source">		&lt;/xsl:if&gt;<br></td></tr
><tr
id=sl_svn21_378

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_379

><td class="source"><br></td></tr
><tr
id=sl_svn21_380

><td class="source">	&lt;xsl:template name=&quot;type&quot;&gt;<br></td></tr
><tr
id=sl_svn21_381

><td class="source">		&lt;xsl:param name=&quot;type&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_382

><td class="source">		&lt;xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_383

><td class="source">			&lt;xsl:when test=&quot;contains($type, &#39;anyType&#39;)&quot;&gt;<br></td></tr
><tr
id=sl_svn21_384

><td class="source">				&lt;rng:data type=&quot;string&quot;&gt;<br></td></tr
><tr
id=sl_svn21_385

><td class="source">					&lt;xsl:apply-templates/&gt;<br></td></tr
><tr
id=sl_svn21_386

><td class="source">				&lt;/rng:data&gt;<br></td></tr
><tr
id=sl_svn21_387

><td class="source">			&lt;/xsl:when&gt;<br></td></tr
><tr
id=sl_svn21_388

><td class="source">			&lt;!-- have to improve the prefix detection --&gt;<br></td></tr
><tr
id=sl_svn21_389

><td class="source">			&lt;xsl:when test=&quot;starts-with($type, &#39;xs:&#39;) or starts-with($type, &#39;xsd:&#39;)&quot;&gt;<br></td></tr
><tr
id=sl_svn21_390

><td class="source">				&lt;rng:data type=&quot;{substring-after($type, &#39;:&#39;)}&quot;&gt;<br></td></tr
><tr
id=sl_svn21_391

><td class="source">					&lt;!-- xsltproc tries to apply templates on current attributes --&gt;<br></td></tr
><tr
id=sl_svn21_392

><td class="source">					&lt;xsl:apply-templates select=&quot;*&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_393

><td class="source">				&lt;/rng:data&gt;<br></td></tr
><tr
id=sl_svn21_394

><td class="source">			&lt;/xsl:when&gt;<br></td></tr
><tr
id=sl_svn21_395

><td class="source">			&lt;xsl:when test=&quot;starts-with($type, &#39;xml:&#39;)&quot;&gt;<br></td></tr
><tr
id=sl_svn21_396

><td class="source">				&lt;xsl:variable name=&quot;localName&quot; select=&quot;substring-after($type, &#39;:&#39;)&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_397

><td class="source">				&lt;rng:attribute name=&quot;{$localName}&quot; ns=&quot;http://www.w3.org/XML/1998/namespace&quot;&gt;<br></td></tr
><tr
id=sl_svn21_398

><td class="source">					&lt;xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_399

><td class="source">						&lt;xsl:when test=&quot;$localName=&#39;lang&#39;&quot;&gt;<br></td></tr
><tr
id=sl_svn21_400

><td class="source">							&lt;rng:value type=&quot;language&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_401

><td class="source">						&lt;/xsl:when&gt;<br></td></tr
><tr
id=sl_svn21_402

><td class="source">						&lt;xsl:when test=&quot;$localName=&#39;space&#39;&quot;&gt;<br></td></tr
><tr
id=sl_svn21_403

><td class="source">							&lt;rng:choice&gt;<br></td></tr
><tr
id=sl_svn21_404

><td class="source">						        &lt;rng:value&gt;default&lt;/rng:value&gt;<br></td></tr
><tr
id=sl_svn21_405

><td class="source">						        &lt;rng:value&gt;preserve&lt;/rng:value&gt;<br></td></tr
><tr
id=sl_svn21_406

><td class="source">					      	&lt;/rng:choice&gt;<br></td></tr
><tr
id=sl_svn21_407

><td class="source">						&lt;/xsl:when&gt;<br></td></tr
><tr
id=sl_svn21_408

><td class="source">						&lt;xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_409

><td class="source">							&lt;rng:text/&gt;<br></td></tr
><tr
id=sl_svn21_410

><td class="source">						&lt;/xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_411

><td class="source">					&lt;/xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_412

><td class="source">			  	&lt;/rng:attribute&gt;<br></td></tr
><tr
id=sl_svn21_413

><td class="source">			&lt;/xsl:when&gt;<br></td></tr
><tr
id=sl_svn21_414

><td class="source">			&lt;xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_415

><td class="source">				&lt;xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_416

><td class="source">					&lt;xsl:when test=&quot;contains($type, &#39;:&#39;)&quot;&gt;<br></td></tr
><tr
id=sl_svn21_417

><td class="source">						&lt;rng:ref name=&quot;{substring-after($type, &#39;:&#39;)}&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_418

><td class="source">						&lt;xsl:apply-templates/&gt;<br></td></tr
><tr
id=sl_svn21_419

><td class="source">					&lt;/xsl:when&gt;<br></td></tr
><tr
id=sl_svn21_420

><td class="source">					&lt;xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_421

><td class="source">						&lt;rng:ref name=&quot;{$type}&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_422

><td class="source">						&lt;xsl:apply-templates/&gt;<br></td></tr
><tr
id=sl_svn21_423

><td class="source">					&lt;/xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_424

><td class="source">				&lt;/xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_425

><td class="source">			&lt;/xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_426

><td class="source">		&lt;/xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_427

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_428

><td class="source">    <br></td></tr
><tr
id=sl_svn21_429

><td class="source">	&lt;xsl:template name=&quot;declareMemberTypes&quot;&gt;<br></td></tr
><tr
id=sl_svn21_430

><td class="source">		&lt;xsl:param name=&quot;memberTypes&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_431

><td class="source">		&lt;xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_432

><td class="source">            &lt;xsl:when test=&quot;contains($memberTypes, &#39; &#39;)&quot;&gt;<br></td></tr
><tr
id=sl_svn21_433

><td class="source">				&lt;xsl:call-template name=&quot;type&quot;&gt;<br></td></tr
><tr
id=sl_svn21_434

><td class="source">					&lt;xsl:with-param name=&quot;type&quot; select=&quot;substring-before($memberTypes, &#39; &#39;)&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_435

><td class="source">				&lt;/xsl:call-template&gt;<br></td></tr
><tr
id=sl_svn21_436

><td class="source">                &lt;xsl:call-template name=&quot;declareMemberTypes&quot;&gt;<br></td></tr
><tr
id=sl_svn21_437

><td class="source">                    &lt;xsl:with-param name=&quot;memberTypes&quot; select=&quot;substring-after($memberTypes, &#39; &#39;)&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_438

><td class="source">                &lt;/xsl:call-template&gt;<br></td></tr
><tr
id=sl_svn21_439

><td class="source">            &lt;/xsl:when&gt;<br></td></tr
><tr
id=sl_svn21_440

><td class="source">            &lt;xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_441

><td class="source">				&lt;xsl:call-template name=&quot;type&quot;&gt;<br></td></tr
><tr
id=sl_svn21_442

><td class="source">					&lt;xsl:with-param name=&quot;type&quot; select=&quot;$memberTypes&quot;/&gt;<br></td></tr
><tr
id=sl_svn21_443

><td class="source">				&lt;/xsl:call-template&gt;<br></td></tr
><tr
id=sl_svn21_444

><td class="source">            &lt;/xsl:otherwise&gt;<br></td></tr
><tr
id=sl_svn21_445

><td class="source">        &lt;/xsl:choose&gt;<br></td></tr
><tr
id=sl_svn21_446

><td class="source">	&lt;/xsl:template&gt;<br></td></tr
><tr
id=sl_svn21_447

><td class="source">    <br></td></tr
><tr
id=sl_svn21_448

><td class="source">&lt;/xsl:stylesheet&gt;<br></td></tr
></table></pre>
<pre><table width="100%"><tr class="cursor_stop cursor_hidden"><td></td></tr></table></pre>
</td>
</tr></table>

 
<script type="text/javascript">
 var lineNumUnderMouse = -1;
 
 function gutterOver(num) {
 gutterOut();
 var newTR = document.getElementById('gr_svn21_' + num);
 if (newTR) {
 newTR.className = 'undermouse';
 }
 lineNumUnderMouse = num;
 }
 function gutterOut() {
 if (lineNumUnderMouse != -1) {
 var oldTR = document.getElementById(
 'gr_svn21_' + lineNumUnderMouse);
 if (oldTR) {
 oldTR.className = '';
 }
 lineNumUnderMouse = -1;
 }
 }
 var numsGenState = {table_base_id: 'nums_table_'};
 var srcGenState = {table_base_id: 'src_table_'};
 var alignerRunning = false;
 var startOver = false;
 function setLineNumberHeights() {
 if (alignerRunning) {
 startOver = true;
 return;
 }
 numsGenState.chunk_id = 0;
 numsGenState.table = document.getElementById('nums_table_0');
 numsGenState.row_num = 0;
 if (!numsGenState.table) {
 return; // Silently exit if no file is present.
 }
 srcGenState.chunk_id = 0;
 srcGenState.table = document.getElementById('src_table_0');
 srcGenState.row_num = 0;
 alignerRunning = true;
 continueToSetLineNumberHeights();
 }
 function rowGenerator(genState) {
 if (genState.row_num < genState.table.rows.length) {
 var currentRow = genState.table.rows[genState.row_num];
 genState.row_num++;
 return currentRow;
 }
 var newTable = document.getElementById(
 genState.table_base_id + (genState.chunk_id + 1));
 if (newTable) {
 genState.chunk_id++;
 genState.row_num = 0;
 genState.table = newTable;
 return genState.table.rows[0];
 }
 return null;
 }
 var MAX_ROWS_PER_PASS = 1000;
 function continueToSetLineNumberHeights() {
 var rowsInThisPass = 0;
 var numRow = 1;
 var srcRow = 1;
 while (numRow && srcRow && rowsInThisPass < MAX_ROWS_PER_PASS) {
 numRow = rowGenerator(numsGenState);
 srcRow = rowGenerator(srcGenState);
 rowsInThisPass++;
 if (numRow && srcRow) {
 if (numRow.offsetHeight != srcRow.offsetHeight) {
 numRow.firstChild.style.height = srcRow.offsetHeight + 'px';
 }
 }
 }
 if (rowsInThisPass >= MAX_ROWS_PER_PASS) {
 setTimeout(continueToSetLineNumberHeights, 10);
 } else {
 alignerRunning = false;
 if (startOver) {
 startOver = false;
 setTimeout(setLineNumberHeights, 500);
 }
 }
 }
 function initLineNumberHeights() {
 // Do 2 complete passes, because there can be races
 // between this code and prettify.
 startOver = true;
 setTimeout(setLineNumberHeights, 250);
 window.onresize = setLineNumberHeights;
 }
 initLineNumberHeights();
</script>

 
 
 <div id="log">
 <div style="text-align:right">
 <a class="ifCollapse" href="#" onclick="_toggleMeta(this); return false">Show details</a>
 <a class="ifExpand" href="#" onclick="_toggleMeta(this); return false">Hide details</a>
 </div>
 <div class="ifExpand">
 
 
 <div class="pmeta_bubble_bg" style="border:1px solid white">
 <div class="round4"></div>
 <div class="round2"></div>
 <div class="round1"></div>
 <div class="box-inner">
 <div id="changelog">
 <p>Change log</p>
 <div>
 <a href="/p/xsdtorngconverter/source/detail?spec=svn21&amp;r=21">r21</a>
 by ndebeiss
 on Jan 2, 2012
 &nbsp; <a href="/p/xsdtorngconverter/source/diff?spec=svn21&r=21&amp;format=side&amp;path=/trunk/xsdtorngconverter/XSDtoRNG.xsl&amp;old_path=/trunk/xsdtorngconverter/XSDtoRNG.xsl&amp;old=20">Diff</a>
 </div>
 <pre>partially fixes <a title="Error converting IP-XACT schema"  href="/p/xsdtorngconverter/issues/detail?id=5">issue 5</a></pre>
 </div>
 
 
 
 
 
 
 <script type="text/javascript">
 var detail_url = '/p/xsdtorngconverter/source/detail?r=21&spec=svn21';
 var publish_url = '/p/xsdtorngconverter/source/detail?r=21&spec=svn21#publish';
 // describe the paths of this revision in javascript.
 var changed_paths = [];
 var changed_urls = [];
 
 changed_paths.push('/trunk/xsdtorngconverter/XSDtoRNG.xsl');
 changed_urls.push('/p/xsdtorngconverter/source/browse/trunk/xsdtorngconverter/XSDtoRNG.xsl?r\x3d21\x26spec\x3dsvn21');
 
 var selected_path = '/trunk/xsdtorngconverter/XSDtoRNG.xsl';
 
 
 function getCurrentPageIndex() {
 for (var i = 0; i < changed_paths.length; i++) {
 if (selected_path == changed_paths[i]) {
 return i;
 }
 }
 }
 function getNextPage() {
 var i = getCurrentPageIndex();
 if (i < changed_paths.length - 1) {
 return changed_urls[i + 1];
 }
 return null;
 }
 function getPreviousPage() {
 var i = getCurrentPageIndex();
 if (i > 0) {
 return changed_urls[i - 1];
 }
 return null;
 }
 function gotoNextPage() {
 var page = getNextPage();
 if (!page) {
 page = detail_url;
 }
 window.location = page;
 }
 function gotoPreviousPage() {
 var page = getPreviousPage();
 if (!page) {
 page = detail_url;
 }
 window.location = page;
 }
 function gotoDetailPage() {
 window.location = detail_url;
 }
 function gotoPublishPage() {
 window.location = publish_url;
 }
</script>

 
 <style type="text/css">
 #review_nav {
 border-top: 3px solid white;
 padding-top: 6px;
 margin-top: 1em;
 }
 #review_nav td {
 vertical-align: middle;
 }
 #review_nav select {
 margin: .5em 0;
 }
 </style>
 <div id="review_nav">
 <table><tr><td>Go to:&nbsp;</td><td>
 <select name="files_in_rev" onchange="window.location=this.value">
 
 <option value="/p/xsdtorngconverter/source/browse/trunk/xsdtorngconverter/XSDtoRNG.xsl?r=21&amp;spec=svn21"
 selected="selected"
 >...k/xsdtorngconverter/XSDtoRNG.xsl</option>
 
 </select>
 </td></tr></table>
 
 
 



 <div style="white-space:nowrap">
 Project members,
 <a href="https://www.google.com/accounts/ServiceLogin?service=code&amp;ltmpl=phosting&amp;continue=http%3A%2F%2Fcode.google.com%2Fp%2Fxsdtorngconverter%2Fsource%2Fbrowse%2Ftrunk%2Fxsdtorngconverter%2FXSDtoRNG.xsl&amp;followup=http%3A%2F%2Fcode.google.com%2Fp%2Fxsdtorngconverter%2Fsource%2Fbrowse%2Ftrunk%2Fxsdtorngconverter%2FXSDtoRNG.xsl"
 >sign in</a> to write a code review</div>


 
 </div>
 
 
 </div>
 <div class="round1"></div>
 <div class="round2"></div>
 <div class="round4"></div>
 </div>
 <div class="pmeta_bubble_bg" style="border:1px solid white">
 <div class="round4"></div>
 <div class="round2"></div>
 <div class="round1"></div>
 <div class="box-inner">
 <div id="older_bubble">
 <p>Older revisions</p>
 
 
 <div class="closed" style="margin-bottom:3px;" >
 <a class="ifClosed" onclick="return _toggleHidden(this)"><img src="http://www.gstatic.com/codesite/ph/images/plus.gif" ></a>
 <a class="ifOpened" onclick="return _toggleHidden(this)"><img src="http://www.gstatic.com/codesite/ph/images/minus.gif" ></a>
 <a href="/p/xsdtorngconverter/source/detail?spec=svn21&r=20">r20</a>
 by ndebeiss
 on Mar 25, 2011
 &nbsp; <a href="/p/xsdtorngconverter/source/diff?spec=svn21&r=20&amp;format=side&amp;path=/trunk/xsdtorngconverter/XSDtoRNG.xsl&amp;old_path=/trunk/xsdtorngconverter/XSDtoRNG.xsl&amp;old=19">Diff</a>
 <br>
 <pre class="ifOpened"><a title="File that produces invalid RNG"  href="/p/xsdtorngconverter/issues/detail?id=4">issue 4</a> : removing xs:unique and
xs:key, adding rng:empty when needed
and adding prefix starting_ to top
level elements def in order not to
overlap complextype defs</pre>
 </div>
 
 <div class="closed" style="margin-bottom:3px;" >
 <a class="ifClosed" onclick="return _toggleHidden(this)"><img src="http://www.gstatic.com/codesite/ph/images/plus.gif" ></a>
 <a class="ifOpened" onclick="return _toggleHidden(this)"><img src="http://www.gstatic.com/codesite/ph/images/minus.gif" ></a>
 <a href="/p/xsdtorngconverter/source/detail?spec=svn21&r=19">r19</a>
 by ndebeiss
 on Jul 21, 2009
 &nbsp; <a href="/p/xsdtorngconverter/source/diff?spec=svn21&r=19&amp;format=side&amp;path=/trunk/xsdtorngconverter/XSDtoRNG.xsl&amp;old_path=/trunk/xsdtorngconverter/XSDtoRNG.xsl&amp;old=18">Diff</a>
 <br>
 <pre class="ifOpened">better support for constraints like
length, totalDigits,...</pre>
 </div>
 
 <div class="closed" style="margin-bottom:3px;" >
 <a class="ifClosed" onclick="return _toggleHidden(this)"><img src="http://www.gstatic.com/codesite/ph/images/plus.gif" ></a>
 <a class="ifOpened" onclick="return _toggleHidden(this)"><img src="http://www.gstatic.com/codesite/ph/images/minus.gif" ></a>
 <a href="/p/xsdtorngconverter/source/detail?spec=svn21&r=18">r18</a>
 by ndebeiss
 on Jul 20, 2009
 &nbsp; <a href="/p/xsdtorngconverter/source/diff?spec=svn21&r=18&amp;format=side&amp;path=/trunk/xsdtorngconverter/XSDtoRNG.xsl&amp;old_path=/trunk/xsdtorngconverter/XSDtoRNG.xsl&amp;old=17">Diff</a>
 <br>
 <pre class="ifOpened">implement different behavior for
attributes occurrences</pre>
 </div>
 
 
 <a href="/p/xsdtorngconverter/source/list?path=/trunk/xsdtorngconverter/XSDtoRNG.xsl&start=21">All revisions of this file</a>
 </div>
 </div>
 <div class="round1"></div>
 <div class="round2"></div>
 <div class="round4"></div>
 </div>
 
 <div class="pmeta_bubble_bg" style="border:1px solid white">
 <div class="round4"></div>
 <div class="round2"></div>
 <div class="round1"></div>
 <div class="box-inner">
 <div id="fileinfo_bubble">
 <p>File info</p>
 
 <div>Size: 14567 bytes,
 448 lines</div>
 
 <div><a href="//xsdtorngconverter.googlecode.com/svn/trunk/xsdtorngconverter/XSDtoRNG.xsl">View raw file</a></div>
 </div>
 
 </div>
 <div class="round1"></div>
 <div class="round2"></div>
 <div class="round4"></div>
 </div>
 </div>
 </div>


</div>

</div>
</div>

<script src="http://www.gstatic.com/codesite/ph/11312328449230880833/js/prettify/prettify.js"></script>
<script type="text/javascript">prettyPrint();</script>


<script src="http://www.gstatic.com/codesite/ph/11312328449230880833/js/source_file_scripts.js"></script>

 <script type="text/javascript" src="http://www.gstatic.com/codesite/ph/11312328449230880833/js/kibbles.js"></script>
 <script type="text/javascript">
 var lastStop = null;
 var initialized = false;
 
 function updateCursor(next, prev) {
 if (prev && prev.element) {
 prev.element.className = 'cursor_stop cursor_hidden';
 }
 if (next && next.element) {
 next.element.className = 'cursor_stop cursor';
 lastStop = next.index;
 }
 }
 
 function pubRevealed(data) {
 updateCursorForCell(data.cellId, 'cursor_stop cursor_hidden');
 if (initialized) {
 reloadCursors();
 }
 }
 
 function draftRevealed(data) {
 updateCursorForCell(data.cellId, 'cursor_stop cursor_hidden');
 if (initialized) {
 reloadCursors();
 }
 }
 
 function draftDestroyed(data) {
 updateCursorForCell(data.cellId, 'nocursor');
 if (initialized) {
 reloadCursors();
 }
 }
 function reloadCursors() {
 kibbles.skipper.reset();
 loadCursors();
 if (lastStop != null) {
 kibbles.skipper.setCurrentStop(lastStop);
 }
 }
 // possibly the simplest way to insert any newly added comments
 // is to update the class of the corresponding cursor row,
 // then refresh the entire list of rows.
 function updateCursorForCell(cellId, className) {
 var cell = document.getElementById(cellId);
 // we have to go two rows back to find the cursor location
 var row = getPreviousElement(cell.parentNode);
 row.className = className;
 }
 // returns the previous element, ignores text nodes.
 function getPreviousElement(e) {
 var element = e.previousSibling;
 if (element.nodeType == 3) {
 element = element.previousSibling;
 }
 if (element && element.tagName) {
 return element;
 }
 }
 function loadCursors() {
 // register our elements with skipper
 var elements = CR_getElements('*', 'cursor_stop');
 var len = elements.length;
 for (var i = 0; i < len; i++) {
 var element = elements[i]; 
 element.className = 'cursor_stop cursor_hidden';
 kibbles.skipper.append(element);
 }
 }
 function toggleComments() {
 CR_toggleCommentDisplay();
 reloadCursors();
 }
 function keysOnLoadHandler() {
 // setup skipper
 kibbles.skipper.addStopListener(
 kibbles.skipper.LISTENER_TYPE.PRE, updateCursor);
 // Set the 'offset' option to return the middle of the client area
 // an option can be a static value, or a callback
 kibbles.skipper.setOption('padding_top', 50);
 // Set the 'offset' option to return the middle of the client area
 // an option can be a static value, or a callback
 kibbles.skipper.setOption('padding_bottom', 100);
 // Register our keys
 kibbles.skipper.addFwdKey("n");
 kibbles.skipper.addRevKey("p");
 kibbles.keys.addKeyPressListener(
 'u', function() { window.location = detail_url; });
 kibbles.keys.addKeyPressListener(
 'r', function() { window.location = detail_url + '#publish'; });
 
 kibbles.keys.addKeyPressListener('j', gotoNextPage);
 kibbles.keys.addKeyPressListener('k', gotoPreviousPage);
 
 
 }
 </script>
<script src="http://www.gstatic.com/codesite/ph/11312328449230880833/js/code_review_scripts.js"></script>
<script type="text/javascript">
 function showPublishInstructions() {
 var element = document.getElementById('review_instr');
 if (element) {
 element.className = 'opened';
 }
 }
 var codereviews;
 function revsOnLoadHandler() {
 // register our source container with the commenting code
 var paths = {'svn21': '/trunk/xsdtorngconverter/XSDtoRNG.xsl'}
 codereviews = CR_controller.setup(
 {"token":null,"loggedInUserEmail":null,"projectHomeUrl":"/p/xsdtorngconverter","profileUrl":null,"domainName":null,"assetVersionPath":"http://www.gstatic.com/codesite/ph/11312328449230880833","projectName":"xsdtorngconverter","assetHostPath":"http://www.gstatic.com/codesite/ph","relativeBaseUrl":""}, '', 'svn21', paths,
 CR_BrowseIntegrationFactory);
 
 codereviews.registerActivityListener(CR_ActivityType.REVEAL_DRAFT_PLATE, showPublishInstructions);
 
 codereviews.registerActivityListener(CR_ActivityType.REVEAL_PUB_PLATE, pubRevealed);
 codereviews.registerActivityListener(CR_ActivityType.REVEAL_DRAFT_PLATE, draftRevealed);
 codereviews.registerActivityListener(CR_ActivityType.DISCARD_DRAFT_COMMENT, draftDestroyed);
 
 
 
 
 
 
 
 var initialized = true;
 reloadCursors();
 }
 window.onload = function() {keysOnLoadHandler(); revsOnLoadHandler();};

</script>
<script type="text/javascript" src="http://www.gstatic.com/codesite/ph/11312328449230880833/js/dit_scripts.js"></script>

 
 
 
 <script type="text/javascript" src="http://www.gstatic.com/codesite/ph/11312328449230880833/js/ph_core.js"></script>
 
 
 
 
</div> 

<div id="footer" dir="ltr">
 <div class="text">
 <a href="/projecthosting/terms.html">Terms</a> -
 <a href="http://www.google.com/privacy.html">Privacy</a> -
 <a href="/p/support/">Project Hosting Help</a>
 </div>
</div>
 <div class="hostedBy" style="margin-top: -20px;">
 <span style="vertical-align: top;">Powered by <a href="http://code.google.com/projecthosting/">Google Project Hosting</a></span>
 </div>

 
 


 
 </body>
</html>

