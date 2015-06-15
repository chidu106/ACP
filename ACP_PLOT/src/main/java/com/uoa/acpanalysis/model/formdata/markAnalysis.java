package com.uoa.acpanalysis.model.formdata;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
@SuppressWarnings({ "rawtypes" })
public class markAnalysis {
	
	private String title;
	
	private String xAxisText;

	private String yAxisText;
	
	private String test1NameForComparision;
	
	private String test2NameForComparision;
	

	private HashMap<String, ArrayList> categoryColorCodes = new HashMap<String, ArrayList>();

	public HashMap<String, ArrayList> getCategoryColorCodes() {
		return categoryColorCodes;
	}

	public void setCategoryColorCodes(HashMap<String, ArrayList> categoryColorCodes) {
		this.categoryColorCodes = categoryColorCodes;
	}

	/*
	 * Categorization start time
	 */
	private List<GroupingCategory> categories = new ArrayList<GroupingCategory>();
	
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getxAxisText() {
		return xAxisText;
	}

	public void setxAxisText(String xAxisText) {
		this.xAxisText = xAxisText;
	}

	public String getyAxisText() {
		return yAxisText;
	}

	public void setyAxisText(String yAxisText) {
		this.yAxisText = yAxisText;
	}

	public List<GroupingCategory> getCategories() {
		return categories;
	}

	public void setCategories(List<GroupingCategory> categories) {
		this.categories = categories;
	}

	public String getTest1NameForComparision() {
		return test1NameForComparision;
	}

	public void setTest1NameForComparision(String test1NameForComparision) {
		this.test1NameForComparision = test1NameForComparision;
	}

	public String getTest2NameForComparision() {
		return test2NameForComparision;
	}

	public void setTest2NameForComparision(String test2NameForComparision) {
		this.test2NameForComparision = test2NameForComparision;
	}
	
	
}
