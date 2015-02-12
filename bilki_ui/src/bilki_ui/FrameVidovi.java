package bilki_ui;

import javax.swing.JFrame;
import javax.swing.JButton;
import javax.swing.JTable;
import javax.swing.JScrollPane;

import java.awt.event.WindowEvent;
import java.util.List;
import javax.swing.table.DefaultTableModel;
import java.awt.BorderLayout;
import javax.swing.JPanel;
import java.awt.FlowLayout;
import java.awt.event.WindowAdapter;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.JLabel;
import javax.swing.JSpinner;

public class FrameVidovi extends JFrame {

	int startRowNum;
	List<Vid> data;
	Object[] koloni;
	DefaultTableModel tableModel;
	private static final long serialVersionUID = 8043703367648877792L;
	private JTable table;
	private JButton btnPrev;
	private JScrollPane scrollPane;
	private JPanel panel;
	private JButton btnNext;
	private JPanel panel_1;
	private JLabel lblPage;
	private JSpinner spinner;
	private JButton btnGoto;

	/**
	 * Create the frame.
	 */
	public FrameVidovi() {
		setTitle("Bilki > Vidovi");
		addWindowListener(new WindowAdapter() {
			@Override
			public void windowOpened(WindowEvent arg0) {
				refreshTable();
			}
			@Override
			public void windowClosed(WindowEvent arg0) {
				Main.getDbManager().close();
			}
		});
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 546, 408);
		getContentPane().setLayout(new BorderLayout(0, 0));
		
		scrollPane = new JScrollPane();
		getContentPane().add(scrollPane);
		
		koloni = new Object[] {"ID", "LATINSKO IME", "IME", "NADVID_ID", "DATUM NA OTKRIVANJE"};
		
		table = new JTable();
		table.setFillsViewportHeight(true);
		table.setModel(new DefaultTableModel(null, koloni));
		table.getColumnModel().getColumn(0).setPreferredWidth(65);
		table.getColumnModel().getColumn(1).setPreferredWidth(111);
		scrollPane.setViewportView(table);
		
		panel = new JPanel();
		getContentPane().add(panel, BorderLayout.SOUTH);
		panel.setLayout(new FlowLayout(FlowLayout.CENTER, 5, 5));
		
		btnPrev = new JButton("<<");
		btnPrev.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				startRowNum -= 100;
				if (startRowNum < 1) {
					startRowNum = 1;
				}
				refreshTable();
			}
		});
		panel.add(btnPrev);
		
		btnNext = new JButton(">>");
		btnNext.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				startRowNum += 100;
				refreshTable();
			}
		});
		panel.add(btnNext);
		
		panel_1 = new JPanel();
		getContentPane().add(panel_1, BorderLayout.NORTH);
		
		lblPage = new JLabel("\u0421\u0442\u0440\u0430\u043D\u0438\u0446\u0430:");
		panel_1.add(lblPage);
		
		spinner = new JSpinner();
		panel_1.add(spinner);
		
		btnGoto = new JButton("\u041E\u0434\u0438 \u0434\u043E \u0441\u0442\u0440\u0430\u043D\u0438\u0446\u0430");
		btnGoto.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					int a = Integer.parseInt(spinner.getValue().toString());
					startRowNum = a*100-99;
					refreshTable();
				} catch (Exception e) {}
			}
		});
		panel_1.add(btnGoto);
		
		tableModel = (DefaultTableModel)table.getModel();
		startRowNum = 1;
	}
	
	private void refreshTable() {
		spinner.getModel().setValue((startRowNum+99)/100);
		data = Main.getVidDao().getVidoviPodredeni(startRowNum, startRowNum+99);
		Object[][] tabledata = new Object[data.size()][5];
		for (int i = 0; i < data.size(); i++) {
			tabledata[i][0] = data.get(i).getIdvid();
			tabledata[i][1] = data.get(i).getLatinskoIme();
			tabledata[i][2] = data.get(i).getIme();
			tabledata[i][3] = data.get(i).getId_nadvid();
			tabledata[i][4] = data.get(i).getDatumOtkruvanje();
		}
		tableModel.setDataVector(tabledata, koloni);
	}
}
