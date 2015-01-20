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

//ユーザをリストに追加。
public class DeleteListServlet extends HttpServlet {

	  private static final long serialVersionUID = 1657390011452788111L;
  public void doPost (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
	  //セッション管理しているTwitterUtilsクラスを取得
	  TwitterUtils t_utils = (TwitterUtils) request.getSession().getAttribute("t_utils");

	  int listindex = Integer.valueOf(request.getParameter("listindex"));

	  //管理クラスからリスト追加のメソッドを呼び出す。
	  try {
		t_utils.deleteList(t_utils.list.get(listindex).getId());
	  } catch (TwitterException e) {
		e.printStackTrace();
  }

	  System.out.println("Create list by ");


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
