<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="tag" tagdir="/WEB-INF/tags" %>
<%@ page import="listech.twitter.*" %>
<%@ page import="twitter4j.*" %>

<% twitter4j.Twitter twitter = (twitter4j.Twitter) session.getAttribute("twitter"); %>
<% TwitterUtils t = (TwitterUtils)session.getAttribute("t_utils");%>
<% int clicklistid = 0;%>
<html>
<head>
    <meta content="text/html; charset=utf-8" http-equiv="Content-Type"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign in with Twitter example</title>

	<!-- CSSのリンク -->





	<!-- Javascript -->
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
	<script src="https://code.jquery.com/jquery.js"></script>
   	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>

	<!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.2/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>

<body>

	<!-- サインイン画面 -->
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

	<!-- メイン画面 -->
	<% if(null != twitter){ %>
		<!-- 管理クラスのセッション開始 -->
		<% if(t == null) {
			session.setAttribute("t_utils",new TwitterUtils(twitter));
			t = (TwitterUtils)session.getAttribute("t_utils");
		}%>
		<link rel="stylesheet" type="text/css" href="./listech/css/main_style.css"/>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">

		<!-- リストの作成 -->
		<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
		  <div class="modal-dialog">
		    <div class="modal-content" style="width:740px; margin-left: -70px;">
		      <div class="modal-header">
		        <h4 class="modal-title" id="myModalLabel">Create a new list</h4>
		      </div>
		      <form method= "POST" action="createlist">
		      <div class="modal-body">

	        		<p>List Name</p>
	      			<input type="text" name="listname" class="textBox" size="30">
	      			<p>Description</p>
	      			<textarea name="description" cols="50" rows="2"></textarea>
					<p>Privacy</p>
					<input type="radio" name="privacy" value="1">Public
					<input type="radio" name="privacy" value="0">Private
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
		        <button type="submit" class="btn btn-primary%>">Create</button>
		      </div>
		      </form>

		    </div><!-- /.modal-content -->
		  </div><!-- /.modal-dialog -->
		</div><!-- /.modal -->

		<!-- リストの編集 -->
		<div class="modal fade" id="myModal2" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
		  <div class="modal-dialog">
		    <div class="modal-content" style="width:740px; margin-left: -70px;">
		      <div class="modal-header">
		        <h4 class="modal-title" id="myModalLabel">Edit a list</h4>
		      </div>
		      <form method= "POST" action="updatelist">
		      <div class="modal-body">

	        		<p>List Name</p>
	      			<input type="text" name="listname" class="textBox" size="30"
	      			value = <%=t.list.get(t.getClickListID()).getName()%>
	      			>
	      			<p>Description</p>
	      			<textarea name="description" cols="50" rows="2"><%=t.list.get(t.getClickListID()).getDescription()%></textarea>
					<p>Privacy</p>
					<input type="radio" name="privacy" value="1" <%if(t.list.get(t.getClickListID()).isPublic()){ %>checked<%} %>>Public
					<input type="radio" name="privacy" value="0" <%if(!t.list.get(t.getClickListID()).isPublic()){ %>checked <%} %>>Private
					<input type= "hidden" name=listindex value = <%=t.getClickListID()%>>

					<!--  input type="submit">リストを削除-->
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
		        <button type="submit" class="btn btn-primary%>">update</button>
		      </div>
		      </form>

		    </div><!-- /.modal-content -->
		  </div><!-- /.modal-dialog -->
		</div><!-- /.modal -->

		<!-- リスト数の取得 -->
		<script type="text/javascript">
			setListSize(<%=t.list.size() %>);
		</script>

		<!-- ヘッダー -->
		<div id="header_frame">
			<!-- 左 -->
			<div id="header_left" align="left">
				<img src="./listech/images/tech.png" alt="ListTech" height="50">
			</div>

			<!-- 右 -->
			<div id="header_right" align="right">
				<!-- タブメニュー -->
				<ul class="nav nav-tabs">
				  <li class="dropdown">

					<!-- タブメニュー閉時の自分のアカウント名とアイコン -->
				    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
				    	<img src="<% out.print(t.getMyProfileImage());%>" width="30" height="30"/>
				    	<% out.print(t.getMyAccountID());%>
				    	<span class="caret"></span>
				    </a>

					<!-- ドロップダウンメニュー -->
				    <ul class="dropdown-menu">
				      <li><a href="logout" data-toggle="tab">Logout</a></li>
				      <li><a href="#message2" data-toggle="tab">Cash Clear</a></li>
				    </ul>

				  </li>
				</ul>
			</div>
		</div>

		<!-- フッダー -->
		<div id="under_frame"class="item">

			<!-- 左側ナビゲーションメニュー -->
			<div id="left_frame"class="item">

				<!-- search -->
				<div id = "search" >
					<form method="get" action="#" class="search">
							<input type="text" name="example" class="textBox">
							<a id="search" href=""><img src="./listech/images/search.png" alt="検索" height="15"></a>
					</form>
				</div>
				<br>

				<!-- Friendship -->
				<div id = "friendship" >
					<font size=5 color="#6D72B2">Friendship</font>

					<!-- フォローしているユーザー -->
					<div id = "fs_follow" >
						<a id="followings" href="#follow" onclick="ChangeTab('follow'); return false;">
							<img src="./listech/images/yazi_migi.png" alt="following" height="15">
							<font color="#3E478F">Followings(<% out.print(t.followList.size());%>)</font>
						</a>
					</div>

					<!-- フォローされているユーザー -->
					<div id = "fs_follower" >
						<a id="followers" href="#follower" onclick="ChangeTab('follower'); return false;">
							<img src="./listech/images/yazi_hidari.png" alt="followers" height="15">
							<font color="#3E478F">Followers(<% out.print(t.followerList.size());%>)</font>
						</a>
					</div>

					<!-- 相互フォローのユーザー -->
					<div id = "fs_relationships" >
						<a id="relationships" href="#relationships" onclick="ChangeTab('relationship'); return false;">
							<img src="./listech/images/each.png" alt="relationships" height="15">
							<font color="#3E478F">Relationships(<% out.print(t.relationshipList.size());%>)</font>
						</a>
					</div>
				</div>
				<br>

				<!--リスト-->
				<div id = "lists">
					<font size=5 color="#6D72B2">Lists(<% out.print(t.list.size());%>)</font>

					<!-- 新規リストの作成(モーダルボタンの設定) -->
					<a data-toggle="modal" href="#myModal" class="btn btn-primary">
						<img src="./listech/images/plus.png" alt="追加" height="15">
					</a>
					<br>

					<!-- リスト一覧の表示（ボタンを押したらそのリストに登録されているユーザー一覧が表示されるよう変更しやした） -->
					<%for(int i = 0 ; i < t.list.size(); i++ ){ %>
						<a id="list" href="#list<%=i%>" onclick="ChangeTab('list<%= i%>'); return false;">
						<% out.print(t.list.get(i).getName());%>
						</a>
						<!-- 新規リストの作成(モーダルボタンの設定) -->
						<a data-toggle="modal" href="#myModal2" class="btn btn-primary" onclick = "<%t.setClickListID(i); %>">
						<img src="./listech/images/pen.png" alt="追加" height="15">
						</a>
						<br>
					<% }%>
				</div>
			</div>

			<!-- アイコンを表示する場所 -->
			<div id="center_frame"class="item">

				<!-- フォロー、フォロワー、相互共に選択出来るようまとめてくくる -->
				<form method = "POST" action="adduser">

<script type="text/javascript">
 function chkdisp( obj,id ) {
  if( obj.checked ){
   document.getElementById(id).style.display = "block";
  }
  else {
   document.getElementById(id).style.display = "none";
  }
 }</script>
					<!-- フォローしている -->
					<div id = "follow">
							<section>
							<% for(int i = 0; i < t.followList.size(); i++){ %>
								<input type = "checkbox" id = "following_<%out.print(i);%>" name = "test" value = "<%= t.followList.get(i).getScreenName()%>"
								onclick="chkdisp(this,'f_<%= i%>')" >

								  <label id = "contents"for = "following_<%out.print(i);%>">

								<img src = "<% out.print(t.followList.get(i).getProfileImageURL());%> " width="48" height="48"
									title = "<% out.print(t.followList.get(i).getName() +" / @" + t.followList.get(i).getScreenName());%>">
								<img id="f_<%= i%>" class="star" style="display:none;" src="./listech/images/check_2.png" width="48" height="48">

								</label>


							<% } %>
							</section>
						<input type="submit" value="リストに追加" -->

					</div>

					<!-- フォローされている -->
					<div id = "follower">

							<section>
							<% for(int i = 0; i < t.followerList.size(); i++){ %>

								<input type = "checkbox" id = "follower_<%out.print(i);%>" name = "test" value = "<%= t.followerList.get(i).getScreenName()%>">
								<label for = "follower_<%out.print(i);%>">
								<img src = "<% out.print(t.followerList.get(i).getProfileImageURL());%>" width="48" height="48"
									title = "<% out.print(t.followerList.get(i).getName() +" / @" + t.followerList.get(i).getScreenName());%>" >
								</label>

							<% } %>
							</section>
						<input type="submit" value="リストに追加">
					</div>

					<!-- 相互フォロー -->
					<div id = "relationship">
						<section>
						<% for(int i = 0; i < t.relationshipList.size(); i++){ %>
							<input type = "checkbox" id = "relationship_<%out.print(i);%>" name = "test" value = "<%= t.relationshipList.get(i).getScreenName()%>">
							<label for = "relationship_<%out.print(i);%>">
							<img src = "<% out.print(t.relationshipList.get(i).getProfileImageURL());%>" width="48" height="48"
								title = "<% out.print(t.relationshipList.get(i).getName() +" / @" + t.relationshipList.get(i).getScreenName());%>" >
							</label>
						<% } %>
						</section>
						<input type="submit" value="リストに追加">
					</div>

				</form>

				<!-- リストに登録されているユーザー -->
				<% for(int a = 0; a < t.allListMember.size(); a++){ %>
					<div id = "list<%= a %>">
					<form method = "POST" action="removeuser">
						<section>
						<% for(int i = 0; i < t.allListMember.get(a).size(); i++){ %>

							<input type = "checkbox" id = "list<%out.print(a + "_"+ i );%>" name = "list<%=a %>"
									value = <% out.print(t.allListMember.get(a).get(i).getScreenName());%>>

							<label for = "list<%out.print(a + "_"+ i );%>">
							<img src = "<% out.print(t.allListMember.get(a).get(i).getProfileImageURL()); %>" width="48" height="48"
								title = "<% out.print(t.allListMember.get(a).get(i).getName() +" / @" + t.allListMember.get(a).get(i).getScreenName());%>" >
							</label>
						<% } %>
						</section>

						<input type="hidden" name = "currentlist" value="list<%=a %>">
						<input type="hidden" name = "listID" value="<%=t.list.get(a).getId() %>">
						<input type="submit" value="リストから削除">
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
	<%}%>
</body>
</html>

