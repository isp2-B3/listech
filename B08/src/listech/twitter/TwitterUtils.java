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
	public  ArrayList<User> relationshipList;	/*相互フォローのユーザのリスト*/
	public ArrayList<ArrayList<User>> allListMember;	/*全リストのメンバーリスト(2次元配列)*/


	/**
	 * @category Constructor
	 * @param Twitter
	 * @throws TwitterException
	 *
	 * セッションから取得したtwitterオブジェクトをセットし、
	 * 自分のユーザ情報、リスト、フォロー、フォロワーのデータを取得しセットする
	 */
	public TwitterUtils(Twitter twitter) throws TwitterException{
		this.twitter = twitter;							//セッションで得られたTwitterオブジェクトを代入
		me = twitter.verifyCredentials();				//自分の詳細なユーザ情報の取得
		getFollowUsersList();				//フォローしているユーザ情報をリストで取得しフィールドにセット
		getFollowerUsersList();			//フォローされているユーザ情報をリストで取得しフィールドにセット
		getRelationshipUserList();	//相互フォローのユーザ情報をリストで取得しフィールドにセット
		updateList();									//リスト情報の更新
		getAllListMember();				//全リストに対して登録されているユーザ情報を二次元配列にセット。
	}

	/**
	 * ユーザ情報取得関連
	 */

	/**
	 * @category Getter
	 * @return ArrayList<User>
	 *
	 *
	 * 相互フォローのユーザを取得しリストで返す
	 */
	public void getRelationshipUserList() {
		String i_screenName = null;
		String j_screenName = null;

		ArrayList<User> relationshipList = new ArrayList<User>();

		for(int i = 0; i< followList.size(); i++){
			i_screenName = followList.get(i).getScreenName();
			for(int j = 0; j< followerList.size(); j++){
				j_screenName = followerList.get(j).getScreenName();

				if(i_screenName.equalsIgnoreCase(j_screenName)){
					relationshipList.add(followList.get(i));
					break;
				}
			}
		}

		this.relationshipList = relationshipList ;
	}

	/**
	 * @category Getter
	 * @return ArrayList<User>
	 * @throws TwitterException
	 *
	 * フォローしているユーザを取得しリストで返す
	 */
	public void getFollowUsersList() throws TwitterException{
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

        this.followList = followUserList;

	}

	/**
	 * @category Getter
	 * @return ArrayList<User>
	 * @throws TwitterException
	 *
	 * フォローされているユーザを取得しリストで返す
	 */
	public void getFollowerUsersList() throws TwitterException{
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

        this.followerList =  followerUserList;

	}

	//全リストのメンバーを取得し二次元配列で返す
	public void getAllListMember() throws TwitterException{


	        ArrayList<ArrayList<User>> allListMember = new ArrayList<ArrayList<User>>();

	        for(int i = 0; i < list.size(); i++){
	        	long cursor = -1L; 					// カーソル初期値。
	            PagableResponseList<User> users; 	// 一時的にuserを格納するオブジェクト

	            // フォローしているユーザを全てストックするオブジェクト
		        ArrayList<User> listMember = new ArrayList<User>();
		        do {
		            users = twitter.getUserListMembers(list.get(i).getId(), cursor);


		            // 取得したユーザをストックする
		            for (User user : users) {
		            	listMember.add(user);
		            }

		            // 次のページへのカーソル取得。ない場合は0のようだが、念のためループ条件はhasNextで見る
		            cursor = users.getNextCursor();
		        } while (users.hasNext());
		        allListMember.add(listMember);
	        }
	        this.allListMember = allListMember;

		}



	/**
	 * 自分のアカウント情報関連のゲッター(ユーザ名、IDなどなど)
	 */

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



	/**
	  リスト管理関連
	 */

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

	//リストの編集
	public void editList(long listID, String name, boolean isPublic, String description) throws TwitterException{
		twitter.updateUserList(listID,name,isPublic, description);
	}

	//リストの削除(引数:削除するリストのID)
	public void deleteList(long listID) throws TwitterException{
		twitter.destroyUserList(listID);
	}

	//リスト情報の更新
	public void updateList() throws TwitterException{
		list = twitter.getUserLists(getMyAccountID());

		//自分が作成したリストのみ表示
		for(int i = 0; i < list.size(); i++){
			if(!(list.get(i).getUser().getScreenName().equalsIgnoreCase(getMyAccountID()))){
				list.remove(i);
			}

		}
	}


}
