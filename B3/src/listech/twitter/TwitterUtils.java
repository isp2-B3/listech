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
		updateList();
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
            users = twitter.getFriendsList(getMyAccountID(), cursor,GET_COUNT_PER_REQUEST);
            
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
            users = twitter.getFollowersList(getMyAccountID(), cursor,GET_COUNT_PER_REQUEST);
            
            
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
	public String getMyAccountName(){
		return me.getName();
	}
	
	public String getMyAccountID(){
		return me.getScreenName();
	}
	
	public int getMyFollowCount(){
		return me.getFriendsCount();
	}
	
	public int getMyFollowersCount(){
		return me.getFollowersCount();
	}
	
	public String getMyProfileImage(){
		return me.getOriginalProfileImageURL();
	}
	
	public String getMyDescription(){
		return me.getDescription();
	}
	
	//新しい空のリストを作成(引数:リスト名, 公開かどうか？, リストの説明文)
	public void createList(String name, boolean isPublic, String description) throws TwitterException{
		twitter.createUserList(name, isPublic, description);
	}
	
	//リストにユーザーを追加(引数:listのID, 追加するユーザーのアカウントIDのString配列)
	public void addListMember(long listID, String[] accountIDs) throws TwitterException{
		twitter.createUserListMembers(listID, accountIDs);
	}
	
	//リストからユーザーを取り除く(引数:listのID, 取り除くユーザーのアカウントIDのString配列)
	public void removeListMember(long listID, String[] accountIDs) throws TwitterException{
		twitter.destroyUserListMembers(listID, accountIDs);
	}
	
	//リストの削除(引数:削除するリストのID)
	public void deleteList(long listID) throws TwitterException{
		twitter.destroyUserList(listID);
		
	}
	
	//リスト情報の更新
	public void updateList() throws TwitterException{
		list = twitter.getUserLists(getMyAccountID());
	}
	
	
}
