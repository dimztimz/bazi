package bilki_ui;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBManager {
	
	Connection connection;
	
	public DBManager() throws SQLException {
		DriverManager.registerDriver(new oracle.jdbc.OracleDriver());
	}
	
	private Connection getNewConnection() throws SQLException {
	    Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@WIN-WRXX17Q2IR4:1521:edudb", "bilki", "stobilo");
	    System.out.println("Connected to database");
	    return conn;
	}
	
	public Connection estabilishConnection() throws SQLException {
		if (connection != null && !connection.isClosed()) {
			connection.close();
		}
		this.connection = getNewConnection();
		return connection;
	}
	
	public Connection getConnection() {
		return connection;
	}
	
	public void close() {
		if (connection == null) {
			return;
		}
		try {
			connection.close();
			System.out.println("Databese connection closed");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
