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
public class CreateListServlet extends HttpServlet {
  public void doPost (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

	  //セッション管理しているTwitterUtilsクラスを取得
	  TwitterUtils t_utils = (TwitterUtils) request.getSession().getAttribute("t_utils");

	  //formでチェックされたユーザーIDをString[]で取得
	  String listname = request.getParameter("listname");
	  String description = request.getParameter("description");
	  String ispublic = request.getParameter("privacy");

	  boolean ispub = false;
	  if(Integer.valueOf(ispublic) == 1){
		  ispub = true;
	  }

	  //管理クラスからリスト追加のメソッドを呼び出す。
	  try {
		t_utils.createList(listname, ispub, description);
	  } catch (TwitterException e) {
		e.printStackTrace();
	  }

	  System.out.println("Create list by ");
	  System.out.println("ListName:" + listname);
	  System.out.println("Description:" + description);
	  System.out.println("isPublic:" + ispublic);

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
