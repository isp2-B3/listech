<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<%@ page import="listech.twitter.*" %>
<%@ page import="twitter4j.*" %>

<% twitter4j.Twitter twitter = (twitter4j.Twitter) session.getAttribute("twitter"); %> 

<html>
<head>
    <meta content="text/html; charset=utf-8" http-equiv="Content-Type"/>
    <title>Sign in with Twitter example</title>
</head>
<body>
	<% if(twitter == null){ %>
    	<a href="signin"><img src="./listech/images/Sign-in-with-Twitter-darker.png"/></a>
	<% } %>
	
	<% if(null != twitter){ %>
		<% TwitterUtils t = (TwitterUtils)session.getAttribute("t_utils");%>

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
		
		<h3>アカウント情報</h3>
		<img src="<% out.print(t.getProfileImage());%>" width="64" height="64" /><br>
		<% out.println("アカウント名:" + t.getAccountName()); %><br>
	    <% out.println("アカウントID:" + t.getAccountID()); %><br>
	    <% out.println("プロフィール文:" + t.getDescription()); %><br>
	    <a href="logout">logout</a>
	<% }%>
</body>
</html>

