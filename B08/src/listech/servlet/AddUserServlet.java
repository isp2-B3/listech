package listech.servlet;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import listech.twitter.TwitterUtils;
import twitter4j.TwitterException;

@SuppressWarnings("serial")
//ユーザをリストに追加。
public class AddUserServlet extends HttpServlet {
  public void doPost (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

	  //セッション管理しているTwitterUtilsクラスを取得
	  TwitterUtils t_utils = (TwitterUtils) request.getSession().getAttribute("t_utils");

	  //formでチェックされたユーザーIDをString[]で取得
	  String[] accountIDs = request.getParameterValues("test");

	  //管理クラスからリスト追加のメソッドを呼び出す。
	  try {
		t_utils.addListMember(t_utils.list.get(0).getId(), accountIDs);
	  } catch (TwitterException e) {
		e.printStackTrace();
	  }

	  System.out.println("Add user by " + t_utils.list.get(0).getName());

	  for(int i = 0; i < accountIDs.length; i++){
		  System.out.println(accountIDs[i]);
	  }

	  //リストの更新
	  try {
		t_utils.updateList();
	  } catch (TwitterException e) {
		e.printStackTrace();
	  }

	  //リストに登録されているユーザを更新
	  try {
		t_utils.getAllListMember();
	  } catch (TwitterException e) {
		e.printStackTrace();
	  }

	  try {
		  response.sendRedirect(new URI(request.getHeader("referer")).getPath());
	  } catch (URISyntaxException e) {
		  e.printStackTrace();
	  }
  }
}
