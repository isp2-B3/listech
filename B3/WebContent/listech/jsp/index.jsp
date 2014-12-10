<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<%@ page import="listech.twitter.*" %>
<%@ page import="twitter4j.*" %>

<% twitter4j.Twitter twitter = (twitter4j.Twitter) session.getAttribute("twitter"); %>
<% TwitterUtils t = (TwitterUtils)session.getAttribute("t_utils");%>

<html>
<head>
    <meta content="text/html; charset=utf-8" http-equiv="Content-Type"/>
    <title>Sign in with Twitter example</title>
</head>
<body>
	<% if(twitter == null){ %>
		<link rel="stylesheet" type="text/css" href="./listech/css/input_style.css"/>
		<img src="./listech/images/ListTech.png" alt="ListTech" height="100">


	<div class="page">
		<div id="navigation">
			<p>このアプリはTwitterのフォロー、フォロワーのリスト管理を容易にするためのものです。</p>
			<p>簡単なステップを２つふむだけであなたのTwitterライフをより良いものにします。</p>

			<p>Step1：TwitterにSign inしてください</p>
    		<a href="signin"><img src="./listech/images/btn_twitter_login.png"/></a>
    		<p>Step2：サインインしたらドラックアンドドロップで簡単にリスト管理！</p>
    		
		</div>
	</div>
	
	<% } %>
	
	<% if(null != twitter){ %>
		<link rel="stylesheet" type="text/css" href="./listech/css/main_style.css"/>
		<div id="header_frame" class="item">
			<div id="image_frame"class="item">
				<img src="./listech/images/ListTech.png" alt="ListTech" height="100">
			</div>
			
			<div id="myprof_frame"class="item">
				<!-- <p>myprof</p>-->
				<br>
				<br>
				<div align="right">
					<a href= "logout">logout</a>
				</div>
			</div>
		</div>
		
		<div id="under_frame"class="item">
			<div id="left_frame"class="item">
		
			<form method="get" action="#" class="search">
				<div>
					<input type="text" name="example" class="textBox">
					<a id="search" href=""><img src="./listech/images/search.png" alt="検索" height="15"></a>
				</div>
			</form>
			<br>
			
			<font size=6 color="#6D72B2">Friendship</font>
				<div>
					<a id="friends" href="">
						<img src="./listech/images/each.png" alt="friends" height="15">
						<font color="#3E478F">Friends</font>
					</a>
				</div>
				
				<div>
					<a id="followings" href="">
						<img src="./listech/images/yazi_migi.png" alt="following" height="15">
						<font color="#3E478F">Followings</font>
					</a>
				</div>
				
				<div>
					<a id="followers" href="">
						<img src="./listech/images/yazi_hidari.png" alt="followers" height="15">
						<font color="#3E478F">Followers </font>
					</a>
				</div>
				<br>
			
				<!--リスト-->
				<font size=6 color="#6D72B2">Lists</font> 
				<a  href="#popup1" class="popup_btn1">
					<img src="./listech/images/plus.png" alt="追加" height="15">
				</a>
				
				<a href="#popup2" class="popup_btn2">
					<img src="./listech/images/pen.png" alt="編集" height="15">
				</a>
				<br>
			</div>
				
			<div id="center_frame"class="item">
				<!--<p> icons </p>-->
			</div>
			
			<div id="right_frame"class="item">
				<!--<p>prof</p>-->
			</div>
		</div>	
		<!-- ポップアップ部分以下参照
			http://cosarin.com/js_easy_popup/#chapter2 -->
		
		<!--ポップアップ部分　追加-->
		<div id="popup1" class="popup">
			<div class="popup_inner">
				<h4>Create a new list</h4>
				<p>List name</p>
				<!--  form method="get" action="#" class="create" -->
				<div>
					<input type="text" name="example" class="textBox">
					
					<p>Description</p>
					<p>Privavy</p>
						Public
						Private
						<p></p>
						<p></p>
						<div>
							<a href="#close_btn" class="close_btn">Cancel</a>
							<a href="#save_btn" class="save_btn">Save</a>
						</div>
				</div>
			</div>
		</div>
	
		<div id="overlay"></div>
		
		<!--ポップアップ部分　編集-->
		

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

		<% if(t == null) {
			session.setAttribute("t_utils",new TwitterUtils(twitter));
			t = (TwitterUtils)session.getAttribute("t_utils");
		}%>
		
		<h3>Follow(<% out.print(t.followList.size());%>)</h3>
		<% for(int i = 0; i < t.followList.size(); i++){ %>
			<img src="<% out.print(t.followList.get(i).getProfileImageURL());%>" 
						width="64" 
						height="64" 
						title="<% out.print(t.followList.get(i).getName() +" / @" + t.followList.get(i).getScreenName());%>" 
			/>
		<% } %>
		
		<h3>Follower(<% out.print(t.followerList.size());%>)</h3>
		<% for(int i = 0; i < t.followerList.size(); i++){ %>
			<img src="<% out.print(t.followerList.get(i).getProfileImageURL());%>" 
						width="64" 
						height="64" 
						title="<% out.print(t.followerList.get(i).getName() +" / @" + t.followerList.get(i).getScreenName());%>" 
			/>
		<% } %>
		
		<h3>リスト情報</h3>
		<% for(int i = 0; i < t.list.size(); i++){%>
			 <% out.println(t.list.get(i).getName()); %><br>
		<% }%>
		
		<h3>アカウント情報</h3>
		<img src="<% out.print(t.getMyProfileImage());%>" width="64" height="64" /><br>
		<% out.println("アカウント名:" + t.getMyAccountName()); %><br>
	    <% out.println("アカウントID:" + t.getMyAccountID()); %><br>
	    <% out.println("プロフィール文:" + t.getMyDescription()); %><br>
	    
	<% }%>
</body>
</html>

