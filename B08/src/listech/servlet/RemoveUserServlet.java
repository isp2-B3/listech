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

//ユーザをリストから除外。
public class RemoveUserServlet extends HttpServlet {


	  private static final long serialVersionUID = 1657390011452788111L;
  public void doPost (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
	  //セッション管理しているTwitterUtilsクラスを取得
	  TwitterUtils t_utils = (TwitterUtils) request.getSession().getAttribute("t_utils");
	  String listID = (String)request.getParameter("listID");
	  String currentList = (String)request.getParameter("currentlist");

	  //formでチェックされたユーザーIDをString[]で取得
	  String[] accountIDs = request.getParameterValues(currentList);
	  long id = Long.parseLong(listID);


	  System.out.println(currentList);


	  System.out.println("Remove user by " + currentList);
	  for(int i = 0; i < accountIDs.length; i++){
		  System.out.println(accountIDs[i]);
	  }

	  //管理クラスからリスト追加のメソッドを呼び出す。
	  try {
		t_utils.removeListMember(id, accountIDs);
	  } catch (TwitterException e) {
		e.printStackTrace();
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
