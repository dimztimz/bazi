package bilki_ui;

import javax.swing.JComponent;
import javax.swing.JFormattedTextField;
import javax.swing.JFrame;
import javax.swing.JButton;
import javax.swing.JTable;
import javax.swing.JScrollPane;

import java.awt.event.WindowEvent;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.swing.table.AbstractTableModel;
import java.awt.BorderLayout;

import javax.swing.JPanel;

import java.awt.FlowLayout;
import java.awt.event.WindowAdapter;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

import javax.swing.JLabel;
import javax.swing.JSpinner;
import javax.swing.BoxLayout;
import javax.swing.JTextArea;

class VidoviTableModel extends AbstractTableModel {
	
	private static final long serialVersionUID = 6619862435796258183L;
	public final static int VID_ID = 0;
	public final static int LATINSKO_IME = 1;
	public final static int IME = 2;
	public final static int NADVID_ID = 3;
	public final static int DATUM_OTKRIVANJE = 4;
	
	private final List<String> koloni = Arrays.asList("ID", "LATINSKO IME", "IME", "NADVID_ID", "DATUM NA OTKRIVANJE"); 
	private List<Vid> data;
	private int rowsPerPage;
	private int currentPage;
	private int size;

	public VidoviTableModel() {
		this(100);
	}
	
	public VidoviTableModel(int rowsPerPage) {
		data = new ArrayList<>();
		size = Main.getVidDao().getBrojNaVidovi();
		this.rowsPerPage = rowsPerPage;
	}
	
	public int getTotalPages() {
		return (size + rowsPerPage - 1)/rowsPerPage;
	}
	
	public int getRowsPerPage() {
		return rowsPerPage;
	}

	public int getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(int currentPage) {
		if (currentPage < 1) {
			return;
		}
		this.currentPage = currentPage;
		data = Main.getVidDao().getVidoviPodredeni((currentPage-1)*rowsPerPage+1, currentPage*rowsPerPage);
		fireTableDataChanged();
	}
	
	public void loadPreviousPage() {
		setCurrentPage(currentPage-1);
	}
	
	public void loadNextPage() {
		setCurrentPage(currentPage+1);
	}
	
	public void loadFirstPage() {
		setCurrentPage(1);
	}
	
	public void loadLastPage() {
		setCurrentPage(getTotalPages());
	}

	@Override
	public int getColumnCount() {
		return koloni.size();
	}

	@Override
	public int getRowCount() {
		return data.size();
	}

	@Override
	public Object getValueAt(int rowIndex, int columnIndex) {
		Vid ret = data.get(rowIndex);
		switch (columnIndex) {
		case VID_ID:
			return ret.getIdvid();
		case LATINSKO_IME:
			return ret.getLatinskoIme();
		case IME:
			return ret.getIme();
		case NADVID_ID:
			return ret.getId_nadvid();
		case DATUM_OTKRIVANJE:
			return ret.getDatumOtkruvanje();
		}
		return null;
	}
	@Override
	public String getColumnName(int column) {
		return koloni.get(column);
	}
	
	@Override
	public int findColumn(String columnName){
		return koloni.indexOf(columnName);
	}
}

public class FrameVidovi extends JFrame {

	VidoviTableModel tableModel;
	private static final long serialVersionUID = 8043703367648877792L;
	private JTable table;
	private JButton btnPrev;
	private JScrollPane scrollPane;
	private JPanel pnlNavigacija;
	private JButton btnNext;
	private JPanel pnlStranici;
	private JLabel lblPage;
	private JSpinner spinner;
	private JButton btnGoto;
	private JLabel label;
	private JLabel lblNumPages;
	private JButton btnFirstPage;
	private JButton btlLastPage;
	private JPanel pnlDolu;
	private JPanel pnlDetali;
	private JButton btnNewButton;
	private JTextArea txtrFsdfsdfsdf;

	/**
	 * Create the frame.
	 */
	public FrameVidovi() {
		setTitle("Bilki > Vidovi");
		addWindowListener(new WindowAdapter() {
			@Override
			public void windowOpened(WindowEvent arg0) {
				tableModel = new VidoviTableModel();
				tableModel.loadFirstPage(); 
				table.setModel(tableModel);
				
				spinner.setValue(tableModel.getCurrentPage());
				lblNumPages.setText(Integer.toString(tableModel.getTotalPages()));
				
				JComponent editor = (JSpinner.DefaultEditor) spinner.getEditor();
			    JFormattedTextField ftf = ((JSpinner.DefaultEditor) editor).getTextField();
			    ftf.setColumns(5);
			    
			}
			@Override
			public void windowClosing(WindowEvent arg0) {
				Main.getDbManager().close();
			}
		});
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 546, 408);
		getContentPane().setLayout(new BorderLayout(0, 0));
		
		scrollPane = new JScrollPane();
		getContentPane().add(scrollPane);
		
		table = new JTable();
		table.setFillsViewportHeight(true);
		scrollPane.setViewportView(table);
		
		pnlDolu = new JPanel();
		getContentPane().add(pnlDolu, BorderLayout.SOUTH);
		pnlDolu.setLayout(new BoxLayout(pnlDolu, BoxLayout.Y_AXIS));
		
		pnlNavigacija = new JPanel();
		pnlDolu.add(pnlNavigacija);
		pnlNavigacija.setLayout(new FlowLayout(FlowLayout.CENTER, 5, 5));
		
		btnPrev = new JButton("<<");
		btnPrev.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				tableModel.loadPreviousPage();
				spinner.setValue(tableModel.getCurrentPage());
			}
		});
		
		btnFirstPage = new JButton("|<<<");
		btnFirstPage.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				tableModel.loadFirstPage();
				spinner.setValue(tableModel.getCurrentPage());
			}
		});
		pnlNavigacija.add(btnFirstPage);
		pnlNavigacija.add(btnPrev);
		
		btnNext = new JButton(">>");
		btnNext.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				tableModel.loadNextPage();
				spinner.setValue(tableModel.getCurrentPage());
			}
		});
		pnlNavigacija.add(btnNext);
		
		btlLastPage = new JButton(">>>|");
		btlLastPage.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				tableModel.loadLastPage();
				spinner.setValue(tableModel.getCurrentPage());
			}
		});
		pnlNavigacija.add(btlLastPage);
		
		pnlDetali = new JPanel();
		FlowLayout flowLayout = (FlowLayout) pnlDetali.getLayout();
		pnlDolu.add(pnlDetali);
		
		btnNewButton = new JButton("New button");
		pnlDetali.add(btnNewButton);
		
		txtrFsdfsdfsdf = new JTextArea();
		txtrFsdfsdfsdf.setText("fsdfsdfsdf");
		pnlDetali.add(txtrFsdfsdfsdf);
		
		pnlStranici = new JPanel();
		getContentPane().add(pnlStranici, BorderLayout.NORTH);
		pnlStranici.setLayout(new FlowLayout(FlowLayout.CENTER, 5, 5));
		
		lblPage = new JLabel("\u0421\u0442\u0440\u0430\u043D\u0438\u0446\u0430:");
		pnlStranici.add(lblPage);
		
		spinner = new JSpinner();
		pnlStranici.add(spinner);
		
		btnGoto = new JButton("\u041E\u0434\u0438 \u0434\u043E \u0441\u0442\u0440\u0430\u043D\u0438\u0446\u0430");
		btnGoto.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					int a = Integer.parseInt(spinner.getValue().toString());
					tableModel.setCurrentPage(a);
				} catch (Exception e) {}
			}
		});
		
		label = new JLabel("/");
		pnlStranici.add(label);
		
		lblNumPages = new JLabel("0");
		pnlStranici.add(lblNumPages);
		pnlStranici.add(btnGoto);
	}
}
