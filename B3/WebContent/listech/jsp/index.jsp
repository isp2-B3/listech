<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<%@ page import="listech.twitter.*" %>
<%@ page import="twitter4j.*" %>

<!-- twitterインスタンスのセッションの収得 -->
<% twitter4j.Twitter twitter = (twitter4j.Twitter) session.getAttribute("twitter"); %> 


<html>
<head>
    <meta content="text/html; charset=utf-8" http-equiv="Content-Type"/>
    <title>Sign in with Twitter example</title>
</head>
<body>
	
	<% if(twitter == null){ %>
    	<a href="signin"><img src="./images/Sign-in-with-Twitter-darker.png"/></a>
    	
	<% } %>
	
	<% if(null != twitter){ %>
		<% TwitterUtils t = new TwitterUtils(twitter);%>
		
		<% out.println("アカウント名:" + t.getAccountName()); %><br>
	    <% out.println("アカウントID:" + t.getAccountID()); %><br>
	    <% out.println("フォロー:" + t.getFollowCount()); %><br>
	    <% out.println("フォロワー:" + t.getFollowersCount()); %><br>
	    <% out.println(t.followList.size());%><br>
	    <% out.println(t.followerList.size());%><br>
	    
	    <form action="post" method="post">
	        <textarea cols="80" rows="2" name="text"></textarea>
	        <input type="submit" name="post" value="update"/>
	    </form>
	    
	    <a href="logout">logout</a>
    <% } %>
</body>
</html>

