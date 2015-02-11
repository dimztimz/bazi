package bilki_ui;

import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.UIManager;
import javax.swing.JButton;
import javax.swing.JTable;
import javax.swing.JScrollBar;
import javax.swing.JScrollPane;

import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.List;
import javax.swing.table.DefaultTableModel;
import java.awt.BorderLayout;
import javax.swing.JPanel;
import javax.swing.BoxLayout;
import java.awt.FlowLayout;

public class FrameVidovi extends JFrame {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8043703367648877792L;
	private JTable table;
	private JButton btnPrev;
	private JScrollPane scrollPane;
	
	List<Vid> data;
	private JPanel panel;
	private JButton btnNext;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		try {
			UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
		} catch (Throwable e) {
			e.printStackTrace();
		}
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					FrameVidovi frame = new FrameVidovi();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the frame.
	 */
	public FrameVidovi() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 546, 408);
		getContentPane().setLayout(new BorderLayout(0, 0));
		
		scrollPane = new JScrollPane();
		getContentPane().add(scrollPane);
		
		data = Main.getVidDao().getVidoviPodredeni(1, 100);
		Object[][] tabledata = new Object[data.size()][5];
		for (int i = 0; i < data.size(); i++) {
			tabledata[i][0] = data.get(i).getIdvid();
			tabledata[i][1] = data.get(i).getLatinskoIme();
			tabledata[i][2] = data.get(i).getIme();
			tabledata[i][3] = data.get(i).getId_nadvid();
			tabledata[i][4] = data.get(i).getDatumOtkruvanje();
		}
		Object[] koloni = new Object[] {"ID", "LATINSKO IME", "IME", "NADVID_ID", "DATUM NA OTKRIVANJE"};
		
		table = new JTable();
		/*table.setModel(new DefaultTableModel(
			new Object[][] {
				{null, null, null, null, null},
				{null, null, null, null, null},
			},
			new String[] {
				"\u041A\u043E\u0434", "\u041B\u0430\u0442\u0438\u043D\u0441\u043A\u043E \u0438\u043C\u0435", "\u0418\u043C\u0435", "\u041A\u043E\u0434 \u043D\u0430 \u043D\u0430\u0434\u0432\u0438\u0434", "\u0414\u0430\u0442\u0443\u043C \u043D\u0430 \u043E\u0442\u043A\u0440\u0438\u0432\u0430\u045A\u0435"
			}
		));*/
		table.setModel(new DefaultTableModel(tabledata, koloni));
		table.getColumnModel().getColumn(0).setPreferredWidth(65);
		table.getColumnModel().getColumn(1).setPreferredWidth(111);
		scrollPane.setViewportView(table);
		
		panel = new JPanel();
		getContentPane().add(panel, BorderLayout.SOUTH);
		panel.setLayout(new FlowLayout(FlowLayout.CENTER, 5, 5));
		
		btnPrev = new JButton("<<");
		panel.add(btnPrev);
		
		btnNext = new JButton(">>");
		panel.add(btnNext);
	}
}
