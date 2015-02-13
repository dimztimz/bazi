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

import java.awt.GridBagLayout;
import java.awt.GridBagConstraints;
import java.awt.Insets;
import java.awt.Component;

import javax.swing.JTextField;

import com.toedter.calendar.JDateChooser;
import java.awt.Font;
import javax.swing.UIManager;
import javax.swing.ListSelectionModel;

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
	
	public boolean addEntry(Vid vid) {
		if (Main.getVidDao().insertVid(vid)) {
			data.add(vid);
			fireTableRowsInserted(data.size()-1, data.size()-1);
			return true;
		}
		return false;
	}

	public void reload() {
		size = Main.getVidDao().getBrojNaVidovi();
		if (currentPage > getTotalPages()) {
			loadLastPage();
		} else {
			setCurrentPage(currentPage);
		}
	}

	public boolean removeEntry(int rowNumber) {
		if (Main.getVidDao().deleteVid(data.get(rowNumber))) {
			data.remove(rowNumber);
			fireTableRowsDeleted(rowNumber, rowNumber);
			return true;
		}
		return false;
	}

	public Vid getData(int rowNumber) {
		return data.get(rowNumber);
	}

	public boolean update(int rowNumber, Vid v) {
		if (Main.getVidDao().updateVid(v)) {
			data.set(rowNumber, v);
			fireTableRowsUpdated(rowNumber, rowNumber);
			return true;
		}
		return false;
	}
	
}

public class FrameVidovi extends JFrame {
	
	enum Detali {
		SKRIENI_DETALI,
		REZIM_DODAVANJE,
		REZIM_UREDUVANJE,
		REZIM_GLEDAJ_DETALI;
	}
	Detali rezimDetali;
	int selektiranaRedicaDetali;
	VidoviTableModel tableModel;
	private static final long serialVersionUID = 8043703367648877792L;
	private JDateChooser dateChooser;
	private JTable table;
	private JButton btnPrev;
	private JScrollPane scrollPane;
	private JPanel pnlNavigacija;
	private JButton btnNext;
	private JPanel pnlStranici;
	private JLabel lblPage;
	private JSpinner spinner;
	private JButton btnGoto;
	private JLabel lblStraniciKosaCrta;
	private JLabel lblNumPages;
	private JButton btnFirstPage;
	private JButton btlLastPage;
	private JPanel pnlDolu;
	private JPanel pnlDetali;
	private JButton btnCloseDetails;
	private JLabel lblStatusBar;
	private JPanel pnlUreduvanje;
	private JButton btnDodadiVid;
	private JButton btnIzmeniVid;
	private JButton btnIzbrisiVid;
	private JLabel lvlVidId;
	private JTextField txtVidId;
	private JLabel lblVidLatinskoIme;
	private JTextField txtVidLatinskoIme;
	private JLabel lblVidIme;
	private JTextField txtVidIme;
	private JLabel label;
	private JLabel lblVidNadvidId;
	private JTextField txtVidNadvidId;
	private JButton btnDetailsAccept;
	private JButton btnRefresh;

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
			    
			    rezimDetali = Detali.SKRIENI_DETALI;
			    pnlDetali.setVisible(false);
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
		table.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
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
		
		pnlUreduvanje = new JPanel();
		pnlDolu.add(pnlUreduvanje);
		
		btnDodadiVid = new JButton("\u0414\u043E\u0434\u0430\u0434\u0438 +");
		btnDodadiVid.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				rezimDetali = Detali.REZIM_DODAVANJE;
				txtVidId.setEditable(false);
				txtVidId.setText(null);
				txtVidLatinskoIme.setText(null);
				txtVidIme.setText(null);
				txtVidNadvidId.setText("0");
				pnlDetali.setVisible(true);
			}
		});
		pnlUreduvanje.add(btnDodadiVid);
		
		btnIzmeniVid = new JButton("\u0418\u0437\u043C\u0435\u043D\u0438 \u25CC");
		btnIzmeniVid.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				int a = table.getSelectedRow();
				if (a < 0) {
					lblStatusBar.setText("Изберете редица за уредување");
				} else {
					Vid v = tableModel.getData(a);
					selektiranaRedicaDetali = a;
					rezimDetali = Detali.REZIM_UREDUVANJE;
					txtVidId.setEditable(false);
					txtVidId.setText(Integer.toString(v.getIdvid()));
					txtVidLatinskoIme.setText(v.getLatinskoIme());
					txtVidIme.setText(v.getIme());
					txtVidNadvidId.setText(Integer.toString(v.getId_nadvid()));
					if (v.getDatumOtkruvanje() != null) {
						dateChooser.setDate(v.getDatumOtkruvanje());
					}
					pnlDetali.setVisible(true);
				}
			}
		});
		pnlUreduvanje.add(btnIzmeniVid);
		
		btnIzbrisiVid = new JButton("\u0418\u0437\u0431\u0440\u0448\u0438 \u00D7");
		btnIzbrisiVid.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				int a = table.getSelectedRow();
				if (a < 0) {
					lblStatusBar.setText("Ништо не е избрано");
				}
				else if (tableModel.removeEntry(a)) {
					lblStatusBar.setText("Успешно бришење");
				} else {
					lblStatusBar.setText("Неуспешно бришење");
				}
			}
		});
		pnlUreduvanje.add(btnIzbrisiVid);
		
		pnlDetali = new JPanel();
		pnlDolu.add(pnlDetali);
		GridBagLayout gbl_pnlDetali = new GridBagLayout();
		gbl_pnlDetali.columnWidths = new int[]{129, 85, 0, 0, 54, 0};
		gbl_pnlDetali.rowHeights = new int[]{0, 23, 0, 0, 0, 0};
		gbl_pnlDetali.columnWeights = new double[]{0.0, 0.0, 0.0, 0.0, 0.0, Double.MIN_VALUE};
		gbl_pnlDetali.rowWeights = new double[]{0.0, 0.0, 0.0, 0.0, 0.0, Double.MIN_VALUE};
		pnlDetali.setLayout(gbl_pnlDetali);
		
		lvlVidId = new JLabel("\u0418\u0414");
		GridBagConstraints gbc_lvlVidId = new GridBagConstraints();
		gbc_lvlVidId.anchor = GridBagConstraints.EAST;
		gbc_lvlVidId.insets = new Insets(0, 0, 5, 5);
		gbc_lvlVidId.gridx = 0;
		gbc_lvlVidId.gridy = 1;
		pnlDetali.add(lvlVidId, gbc_lvlVidId);
		
		txtVidId = new JTextField();
		GridBagConstraints gbc_txtVidId = new GridBagConstraints();
		gbc_txtVidId.insets = new Insets(0, 0, 5, 5);
		gbc_txtVidId.fill = GridBagConstraints.HORIZONTAL;
		gbc_txtVidId.gridx = 1;
		gbc_txtVidId.gridy = 1;
		pnlDetali.add(txtVidId, gbc_txtVidId);
		txtVidId.setColumns(10);
		
		lblVidNadvidId = new JLabel("\u0418\u0414 \u041D\u0430\u0434\u0432\u0438\u0434");
		GridBagConstraints gbc_lblVidNadvidId = new GridBagConstraints();
		gbc_lblVidNadvidId.anchor = GridBagConstraints.EAST;
		gbc_lblVidNadvidId.insets = new Insets(0, 0, 5, 5);
		gbc_lblVidNadvidId.gridx = 3;
		gbc_lblVidNadvidId.gridy = 1;
		pnlDetali.add(lblVidNadvidId, gbc_lblVidNadvidId);
		
		txtVidNadvidId = new JTextField();
		GridBagConstraints gbc_txtVidNadvidId = new GridBagConstraints();
		gbc_txtVidNadvidId.fill = GridBagConstraints.HORIZONTAL;
		gbc_txtVidNadvidId.insets = new Insets(0, 0, 5, 0);
		gbc_txtVidNadvidId.gridx = 4;
		gbc_txtVidNadvidId.gridy = 1;
		pnlDetali.add(txtVidNadvidId, gbc_txtVidNadvidId);
		txtVidNadvidId.setColumns(10);
		
		lblVidLatinskoIme = new JLabel("\u041B\u0430\u0442\u0438\u043D\u0441\u043A\u043E \u0438\u043C\u0435");
		GridBagConstraints gbc_lblVidLatinskoIme = new GridBagConstraints();
		gbc_lblVidLatinskoIme.anchor = GridBagConstraints.EAST;
		gbc_lblVidLatinskoIme.insets = new Insets(0, 0, 5, 5);
		gbc_lblVidLatinskoIme.gridx = 0;
		gbc_lblVidLatinskoIme.gridy = 2;
		pnlDetali.add(lblVidLatinskoIme, gbc_lblVidLatinskoIme);
		
		txtVidLatinskoIme = new JTextField();
		GridBagConstraints gbc_txtVidLatinskoIme = new GridBagConstraints();
		gbc_txtVidLatinskoIme.insets = new Insets(0, 0, 5, 5);
		gbc_txtVidLatinskoIme.fill = GridBagConstraints.HORIZONTAL;
		gbc_txtVidLatinskoIme.gridx = 1;
		gbc_txtVidLatinskoIme.gridy = 2;
		pnlDetali.add(txtVidLatinskoIme, gbc_txtVidLatinskoIme);
		txtVidLatinskoIme.setColumns(10);
		
		lblVidIme = new JLabel("\u0418\u043C\u0435");
		GridBagConstraints gbc_lblVidIme = new GridBagConstraints();
		gbc_lblVidIme.anchor = GridBagConstraints.EAST;
		gbc_lblVidIme.insets = new Insets(0, 0, 5, 5);
		gbc_lblVidIme.gridx = 0;
		gbc_lblVidIme.gridy = 3;
		pnlDetali.add(lblVidIme, gbc_lblVidIme);
		
		txtVidIme = new JTextField();
		GridBagConstraints gbc_txtVidIme = new GridBagConstraints();
		gbc_txtVidIme.insets = new Insets(0, 0, 5, 5);
		gbc_txtVidIme.fill = GridBagConstraints.HORIZONTAL;
		gbc_txtVidIme.gridx = 1;
		gbc_txtVidIme.gridy = 3;
		pnlDetali.add(txtVidIme, gbc_txtVidIme);
		txtVidIme.setColumns(10);
		
		label = new JLabel("\u0414\u0430\u0442\u0443\u043C \u043D\u0430 \u043E\u0442\u043A\u0440\u0438\u0432\u0430\u045A\u0435");
		GridBagConstraints gbc_label = new GridBagConstraints();
		gbc_label.anchor = GridBagConstraints.EAST;
		gbc_label.insets = new Insets(0, 0, 0, 5);
		gbc_label.gridx = 0;
		gbc_label.gridy = 4;
		pnlDetali.add(label, gbc_label);
		
		dateChooser = new JDateChooser();
		GridBagConstraints gbc_dateChooser = new GridBagConstraints();
		gbc_dateChooser.insets = new Insets(0, 0, 0, 5);
		gbc_dateChooser.fill = GridBagConstraints.HORIZONTAL;
		gbc_dateChooser.gridx = 1;
		gbc_dateChooser.gridy = 4;
		pnlDetali.add(dateChooser, gbc_dateChooser);
		
		btnCloseDetails = new JButton("^ \u0417\u0430\u0442\u0432\u043E\u0440\u0438");
		btnCloseDetails.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				rezimDetali = Detali.SKRIENI_DETALI;
				pnlDetali.setVisible(false);
			}
		});
		
		btnDetailsAccept = new JButton("\u041F\u0440\u0438\u0444\u0430\u0442\u0438 \u25CF");
		btnDetailsAccept.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				if (rezimDetali == Detali.REZIM_DODAVANJE) {
					int nadvidId = 0;
					try {
						if (txtVidNadvidId.getText().length() > 0) {
							nadvidId = Integer.parseInt(txtVidNadvidId.getText());
						}
					} catch (NumberFormatException ex) {
						lblStatusBar.setText("Грешка: За надвид ид внесете број или 0 односно празно ако нема надвид");
					}
					Vid v = new Vid(0, txtVidIme.getText(), txtVidLatinskoIme.getText(), nadvidId, dateChooser.getDate());
					if (tableModel.addEntry(v)) {
						txtVidId.setText(Integer.toString(v.getIdvid()));
						txtVidNadvidId.setText(Integer.toString(v.getId_nadvid()));
						lblStatusBar.setText("Успешен внес");
					} else {
						lblStatusBar.setText("Грешка: Дупликат или непостоечки надвид");
					}
					
				} else if (rezimDetali == Detali.REZIM_UREDUVANJE) {
					int id = tableModel.getData(selektiranaRedicaDetali).getIdvid();
					int nadvidId = 0;
					try {
						if (txtVidNadvidId.getText().length() > 0) {
							nadvidId = Integer.parseInt(txtVidNadvidId.getText());
						}
					} catch (NumberFormatException ex) {
						lblStatusBar.setText("Грешка: За надвид ид внесете број или 0 односно празно ако нема надвид");
					}
					Vid v = new Vid(id, txtVidIme.getText(), txtVidLatinskoIme.getText(), nadvidId, dateChooser.getDate());
					if (tableModel.update(selektiranaRedicaDetali, v)) {
						lblStatusBar.setText("Успешно ажурирање");
					} else {
						lblStatusBar.setText("Грешка: Дупликат или непостоечки надвид");
					}
				}
				
			}
		});
		GridBagConstraints gbc_btnDetailsAccept = new GridBagConstraints();
		gbc_btnDetailsAccept.insets = new Insets(0, 0, 0, 5);
		gbc_btnDetailsAccept.gridx = 3;
		gbc_btnDetailsAccept.gridy = 4;
		pnlDetali.add(btnDetailsAccept, gbc_btnDetailsAccept);
		
		GridBagConstraints gbc_btnCloseDetails = new GridBagConstraints();
		gbc_btnCloseDetails.anchor = GridBagConstraints.NORTH;
		gbc_btnCloseDetails.gridx = 4;
		gbc_btnCloseDetails.gridy = 4;
		pnlDetali.add(btnCloseDetails, gbc_btnCloseDetails);
		
		lblStatusBar = new JLabel("Status Bar");
		lblStatusBar.setAlignmentX(Component.CENTER_ALIGNMENT);
		pnlDolu.add(lblStatusBar);
		
		pnlStranici = new JPanel();
		getContentPane().add(pnlStranici, BorderLayout.NORTH);
		pnlStranici.setLayout(new FlowLayout(FlowLayout.CENTER, 5, 5));
		
		lblPage = new JLabel("\u0421\u0442\u0440\u0430\u043D\u0438\u0446\u0430:");
		pnlStranici.add(lblPage);
		
		spinner = new JSpinner();
		pnlStranici.add(spinner);
		
		btnGoto = new JButton("\u2190 \u041E\u0434\u0438 \u0434\u043E \u0441\u0442\u0440\u0430\u043D\u0438\u0446\u0430");
		btnGoto.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					int a = Integer.parseInt(spinner.getValue().toString());
					tableModel.setCurrentPage(a);
				} catch (Exception e) {}
			}
		});
		
		lblStraniciKosaCrta = new JLabel("/");
		pnlStranici.add(lblStraniciKosaCrta);
		
		lblNumPages = new JLabel("0");
		pnlStranici.add(lblNumPages);
		pnlStranici.add(btnGoto);
		
		btnRefresh = new JButton("\u041E\u0441\u0432\u0435\u0436\u0438 \u047A");
		btnRefresh.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				tableModel.reload();
				lblNumPages.setText(Integer.toString(tableModel.getTotalPages()));
				spinner.setValue(tableModel.getCurrentPage());
			}
		});
		pnlStranici.add(btnRefresh);
	}
}
