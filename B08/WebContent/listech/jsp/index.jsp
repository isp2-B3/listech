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

    <!--画面を切り替えずに要素を表示するためのjavascript -->
    <script type="text/javascript">
    	var listsize = 0;
    	function setListSize(s){
    		listsize = s;
    	}

		function ChangeTab(tabname) {
		   // 全部消す
		   document.getElementById('follow').style.display = 'none';
		   document.getElementById('follower').style.display = 'none';
		   document.getElementById('relationship').style.display = 'none';

		   for(var i=0; i< listsize; i++){
			   document.getElementById("list" + i).style.display = 'none';
		   }

		   // 指定箇所のみ表示
		   document.getElementById(tabname).style.display = 'block';
		}
	</script>
</head>




<body>

	<!-- ログイン画面 -->
	<% if(twitter == null){ %>
		<link rel="stylesheet" type="text/css" href="./listech/css/input_style.css"/>
		<img src="./listech/images/ListTech.png" alt="ListTech" height="100">

		<!-- サインイン画面 -->
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

	<!-- メイン画面 -->

	<% if(null != twitter){ %>

		<% if(t == null) {
			session.setAttribute("t_utils",new TwitterUtils(twitter));
			t = (TwitterUtils)session.getAttribute("t_utils");
		}%>

		<!-- リスト数の取得 -->
		<script type="text/javascript">
			setListSize(<%=t.list.size() %>);
		</script>

		<link rel="stylesheet" type="text/css" href="./listech/css/main_style.css"/>

		<div id="header_frame" class="item">
			<div id="image_frame"class="item">
				<img src="./listech/images/tech.png" alt="ListTech" height="50">
			</div>


			<!-- 自分のアカウント情報 -->
			<!--
			<div align="right">
				<ul id="menu">

					<li>
					<ul>
						<li><a href="#"><img src="<% out.print(t.getMyProfileImage());%>" width="64" height="64" /></a></li>
						<li><a href="#"><a href= "logout">logout</a></a></li>
					</ul>
					</li>
				</ul>
			</div>


			<div id="myprof_frame"class="item">
				<img src="<% out.print(t.getMyProfileImage());%>" width="64" height="64" /><br>
				<div align="right">
					<a href= "logout">logout</a>
				</div>
			</div>

			-->
		</div>

		<div id="under_frame"class="item">

			<!-- 左側ナビゲーションメニュー -->
			<div id="left_frame"class="item">

				<!-- search -->
				<form method="get" action="#" class="search">
					<div>
						<!-- search部分 -->
						<input type="text" name="example" class="textBox">
						<a id="search" href=""><img src="./listech/images/search.png" alt="検索" height="15"></a>
					</div>
				</form>
				<br>

				<!-- Friendship -->
				<font size=5 color="#6D72B2">Friendship</font>

				<!-- フォローしているユーザー -->
				<div>
					<a id="followings" href="#follow" onclick="ChangeTab('follow'); return false;">
						<img src="./listech/images/yazi_migi.png" alt="following" height="15">
						<font color="#3E478F">Followings(<% out.print(t.followList.size());%>)</font>
					</a>
				</div>

				<!-- フォローされているユーザー -->
				<div>
					<a id="followers" href="#follower" onclick="ChangeTab('follower'); return false;">
						<img src="./listech/images/yazi_hidari.png" alt="followers" height="15">
						<font color="#3E478F">Followers(<% out.print(t.followerList.size());%>)</font>
					</a>
				</div>

				<!-- 相互フォローのユーザー -->
				<div>
					<a id="friends" href="#relationships" onclick="ChangeTab('relationship'); return false;">
						<img src="./listech/images/each.png" alt="friends" height="15">
						<font color="#3E478F">Relationships(<% out.print(t.relationshipList.size());%>)</font>
					</a>
				</div>
				<br>

				<!--リスト-->
				<font size=5 color="#6D72B2">Lists(<% out.print(t.list.size());%>)</font>
				<!-- 新規リストの作成 -->
				<a href="#popup1" class="popup_btn1">
					<img src="./listech/images/plus.png" alt="追加" height="15">
				</a>
				<br>
				<!-- リスト一覧の表示（ボタンを押したらそのリストに登録されているユーザー一覧が表示されるよう変更しやした） -->
				<%for(int i = 0 ; i < t.list.size(); i++ ){ %>
					<a id="list" href="#list<%=i%>" onclick="ChangeTab('list<%= i%>'); return false;">
					<% out.print(t.list.get(i).getName());%>
					</a>
					<!-- 編集ボタン -->
					<a href="#popup2" class="popup_btn2">
					<img src="./listech/images/pen.png" alt="編集" height="15">
				</a>
					<br>
				<% }%>
			</div>


			<!-- アイコンを表示する場所 -->
			<div id="center_frame"class="item">
				<!-- フォローしている -->
				<div id = "follow">
					<form>
						<section>
						<% for(int i = 0; i < t.followList.size(); i++){ %>
							<input type = "checkbox"　id = "following_<%out.print(i);%>" name = "test">
							<label for = "following_<%out.print(i);%>">
							<img src = "<% out.print(t.followList.get(i).getProfileImageURL());%>"
								title = "<% out.print(t.followList.get(i).getName() +" / @" + t.followList.get(i).getScreenName());%>" >
							</label>
						<% } %>
						</section>
					</form>
				</div>
				<!-- フォローされている -->
				<div id = "follower">
					<form>
						<section>
						<% for(int i = 0; i < t.followerList.size(); i++){ %>

							<input type = "checkbox"　id = "follower_<%out.print(i);%>" name = "test">
							<label for = "follower_<%out.print(i);%>">
							<img src = "<% out.print(t.followerList.get(i).getProfileImageURL());%>"
								title = "<% out.print(t.followerList.get(i).getName() +" / @" + t.followerList.get(i).getScreenName());%>" >
							</label>
						<% } %>
						</section>
					</form>
				</div>

				<!-- 相互フォロー -->
				<div id = "relationship">
					<form>
						<section>
						<% for(int i = 0; i < t.relationshipList.size(); i++){ %>
							<input type = "checkbox" id = "relationship_<%out.print(i);%>" name = "test">
							<label for = "relationship_<%out.print(i);%>">
							<img src = "<% out.print(t.relationshipList.get(i).getProfileImageURL());%>"
								title = "<% out.print(t.relationshipList.get(i).getName() +" / @" + t.relationshipList.get(i).getScreenName());%>" >
							</label>
						<% } %>
						</section>
					</form>
				</div>

				<!-- リストに登録されているユーザー -->
				<% for(int a = 0; a < t.allListMember.size(); a++){ %>
					<div id = "list<%= a %>">
						<form>
							<section>
							<% for(int i = 0; i < t.allListMember.get(a).size(); i++){ %>

								<input type = "checkbox" id = "list<%out.print(a + "_"+ i );%>" name = "test">
								<label for = "list<%out.print(a + "_"+ i );%>">
								<img src = "<% out.print(t.allListMember.get(a).get(i).getProfileImageURL()); %>"
									title = "<% out.print(t.allListMember.get(a).get(i).getName() +" / @" + t.allListMember.get(a).get(i).getScreenName());%>" >
								</label>
							<% } %>
							</section>
						</form>
					</div>
				<% } %>

				<!-- ログイン時に最初に表示される要素の選択(フォローしているユーザー) -->
				<script type="text/javascript">
				  // デフォルトのタブを選択
				  ChangeTab('follow');
				</script>

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
					<p>Privacy</p>
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

	<%}%>
</body>
</html>

