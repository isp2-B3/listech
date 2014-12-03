package listech.twitter;

import java.util.ArrayList;

import twitter4j.*;


/**
 * 管理用クラス
 * ここでユーザーの取得やリスト管理を行う
 */
public class TwitterUtils {

	/*APIリクエスト時の最大取得数*/
    private static int GET_COUNT_PER_REQUEST = 200;
    
	public Twitter twitter;	/*処理の根幹を担うフィールド*/
	public User me;			/*認証したユーザ、つまり自分のユーザ情報*/
	public ResponseList<UserList> list;		/*自分が作成したリスト*/
	public ArrayList<User> followList;	/*フォローしているユーザのリスト*/
	public  ArrayList<User> followerList;	/*フォローされているユーザのリスト*/
	
	
	/**
	 * @category Constructor
	 * @param Twitter
	 * @throws TwitterException
	 * 
	 * セッションから取得したtwitterオブジェクトをセットし、
	 * 自分のユーザ情報、リスト、フォロー、フォロワーのデータを取得しセットする
	 */
	public TwitterUtils(Twitter twitter) throws TwitterException{
		this.twitter = twitter;					//セッションで得られたTwitterオブジェクトを代入
		me = twitter.verifyCredentials();		//自分の詳細なユーザ情報の取得
		followList = getFollowUsersList();		//フォローしているユーザ情報をリストで取得しフィールドにセット
		followerList = getFollowerUsersList();	//フォローされているユーザ情報をリストで取得しフィールドにセット
		list = twitter.getUserLists(null);
		
		

		
	}
	/**
	 * @category Getter
	 * @return ArrayList<User>
	 * @throws TwitterException
	 * 
	 * フォローしているユーザを取得しリストで返す
	 */
	public ArrayList<User> getFollowUsersList() throws TwitterException{
		long cursor = -1L; 					// カーソル初期値。
        PagableResponseList<User> users; 	// 一時的にuserを格納するオブジェクト
        
        // フォローしているユーザを全てストックするオブジェクト
        ArrayList<User> followUserList = new ArrayList<User>();
       
        long page = 1L;
        
        do {
            // フォローが多いユーザだと無反応で寂しい＆不安なので状況表示
            System.out.println(String.format("Follow:%dページ目取得中。。(%d <= %d)", page, GET_COUNT_PER_REQUEST * (page - 1),
                    GET_COUNT_PER_REQUEST * page++));
            users = twitter.getFriendsList(getAccountID(), cursor,GET_COUNT_PER_REQUEST);
            
            // 取得したユーザをストックする
            for (User user : users) {
                followUserList.add(user);
            }

            // 次のページへのカーソル取得。ない場合は0のようだが、念のためループ条件はhasNextで見る
            cursor = users.getNextCursor();
        } while (users.hasNext());
        
        return followUserList;
        
	}
	
	/**
	 * @category Getter
	 * @return ArrayList<User>
	 * @throws TwitterException
	 * 
	 * フォローされているユーザを取得しリストで返す
	 */
	public ArrayList<User> getFollowerUsersList() throws TwitterException{
		long cursor = -1L; 					// カーソル初期値。
        PagableResponseList<User> users; 	// 一時的にuserを格納するオブジェクト
        
        // フォローしているユーザを全てストックするオブジェクト
        ArrayList<User> followerUserList = new ArrayList<User>();
       
        long page = 1L;
        do {
            // フォローが多いユーザだと無反応で寂しい＆不安なので状況表示
            System.out.println(String.format("Follower:%dページ目取得中。。(%d <= %d)", page, GET_COUNT_PER_REQUEST * (page - 1),
                    GET_COUNT_PER_REQUEST * page++));
            users = twitter.getFollowersList(getAccountID(), cursor,GET_COUNT_PER_REQUEST);
            
            
            // 取得したユーザをストックする
            for (User user : users) {
                followerUserList.add(user);
            }

            // 次のページへのカーソル取得。ない場合は0のようだが、念のためループ条件はhasNextで見る
            cursor = users.getNextCursor();
        } while (users.hasNext());
        
        return followerUserList;
        
	}
	
	
	/*自分のアカウント情報のゲッター(ユーザ名、IDなどなど)*/
	public String getAccountName(){
		return me.getName();
	}
	
	public String getAccountID(){
		return me.getScreenName();
	}
	
	public int getFollowCount(){
		return me.getFriendsCount();
	}
	
	public int getFollowersCount(){
		return me.getFollowersCount();
	}
	
	public String getProfileImage(){
		return me.getOriginalProfileImageURL();
	}
	
	public String getDescription(){
		return me.getDescription();
	}
	
}
