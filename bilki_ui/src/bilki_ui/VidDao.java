package bilki_ui;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Date;
import java.util.List;

public class VidDao {
	
	
	
	public List<Vid> getSiteVidovi() {
		return null;
	}
	public Vid getVid(int idvid) {
		Connection con = Main.getDbManager().getConnection();
	    String query =
	        "select * "
	        + "from vidovi v "
	        + "where v.idvid = ?";
	    try (PreparedStatement stmt = con.prepareStatement(query)) {	        
	        stmt.setInt(1, idvid);
	        try (ResultSet rs = stmt.executeQuery()) {
		        while (rs.next()) {
		        	idvid = rs.getInt("IDVID");
		            String ime = rs.getString("IME");
		            String latIme = rs.getString("LATINSKO_IME");
		            int nadvidId = rs.getInt("VIDOVI_IDVID");
		            Date datumOtkrivanje = rs.getDate("DATUMOTKRIVANJE");
		            return new Vid(idvid, ime, latIme, nadvidId, datumOtkrivanje);
		        }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return null;
	}
	public boolean insertVid(Vid vid) {
		Connection con = Main.getDbManager().getConnection();
	    String query =
	        "insert into VIDOVI(IDVID, LATINSKO_IME, IME, VIDOVI_IDVID, DATUMOTKRIVANJE) "
	        + "VALUES (?,?,?,?,?)";
	    try (PreparedStatement stmt = con.prepareStatement(query,new String[]{"IDVID"})) {	        
	        stmt.setInt(1, vid.getIdvid());
	        stmt.setString(2, vid.getLatinskoIme());
	        stmt.setString(3, vid.getIme());
	        if (vid.getId_nadvid() <= 0) {
	        	stmt.setNull(4, Types.INTEGER);
	        } else {
	        	stmt.setInt(4, vid.getId_nadvid());
	        }
	        stmt.setDate(5, new java.sql.Date(vid.getDatumOtkruvanje().getTime()));
	        stmt.executeUpdate();
	        try (ResultSet rsKey = stmt.getGeneratedKeys()) {
		        if (rsKey.next()) {
		        	vid.setIdvid(rsKey.getInt(1));
		        }
	        }
	        return true;
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return false;
	}
	
	public void updateVid(Vid vid) {
		
	}
	public void deleteVid(Vid vid) {
		
	}	
}
