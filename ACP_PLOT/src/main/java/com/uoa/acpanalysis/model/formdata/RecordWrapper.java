package com.uoa.acpanalysis.model.formdata;

import java.util.ArrayList;
import java.util.List;
import com.uoa.acpanalysis.model.Record;

public class RecordWrapper {	
	
	private List<Record> filteredList = new ArrayList<Record>();

	public List<Record> getFilteredList() {
		return filteredList;
	}

	public void setFilteredList(List<Record> filteredList) {
		this.filteredList = filteredList;
	}
	
	private String item;

	public String getItem() {
		return item;
	}

	public void setItem(String item) {
		this.item = item;
	}
	

}
