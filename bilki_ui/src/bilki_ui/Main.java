package bilki_ui;

import java.sql.SQLException;

public class Main {
	
	private static DBManager dbManager;
	private static VidDao vidDao;

	public static DBManager getDbManager() {
		return dbManager;
	}
	
	public static VidDao getVidDao() {
		return vidDao;
	}

	public static void main(String[] args) {
		try {
			dbManager = new DBManager();
			dbManager.estabilishConnection();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		vidDao = new VidDao();
		FrameVidovi.main(args);
		//dbManager.getConnection().commit();
		//dbManager.close();
		

	}

	private static void testVidDao() {
		Vid v1 = getVidDao().getVid(1);
		Vid v2 = getVidDao().getVid(2);
		Vid v3 = getVidDao().getVid(12345);
		System.out.println(v1);
		System.out.println(v2);
		System.out.println(v3);
		Vid vnew = new Vid(0, "Kaktus", "Opuntia ficus-indica", 0, new java.util.Date());
		if (getVidDao().insertVid(vnew)) {
			System.out.println("eden red vnesen" + vnew.toString());
			
		} else {
			System.out.println("neuspesen vnes, duplikat");
		}
		vnew = getVidDao().getVid("Opuntia ficus-indica");
		System.out.print("selektirano: ");
		System.out.println(vnew);
		vnew.setIme("Kaktus 2");
		if (getVidDao().updateVid(vnew)) {
			System.out.println("eden update");
		}
		if (getVidDao().deleteVid(vnew)) {
			System.out.println("1 red izbirsan");
		}
	}

}
