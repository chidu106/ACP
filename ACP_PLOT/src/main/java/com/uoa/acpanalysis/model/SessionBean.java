package com.uoa.acpanalysis.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import org.springframework.context.annotation.ScopedProxyMode;

@Component
@Scope(value = "session",  proxyMode = ScopedProxyMode.TARGET_CLASS)
public class SessionBean implements Serializable {

	private static final long serialVersionUID = 6224827856340712333L;
	
	/*
	 * Set of all records from the log file
	 */
	private List<Record> records = new ArrayList<Record>();
	
	/*
	 * Records filtered in configuration page
	 */
	private List<Record> filteredRecords = new ArrayList<Record>();
	
	/*
	 * Lecture Start times for the course
	 */
	private List<Date> lectureStartTime = new ArrayList<Date>();
	
	/*
	 * Lecture End times for the course
	 */
	private List<Date> lectureEndTime = new ArrayList<Date>();
	
	/*
	 * Map of users objects which contains marks and UPIDS
	 */
	private Map<String, User> users = new HashMap<String, User>();
	
	/*
	 * List of test/Assignment names
	 */
	private List<String> namesOfTest;
	
	public List<Record> getRecords() {
		return records;
	}

	public void setRecords(List<Record> records) {
		this.records = records;
	}
	
	public List<Date> getLectureStartTime() {
		return lectureStartTime;
	}

	public void setLectureStartTime(List<Date> lectureStartTime) {
		this.lectureStartTime = lectureStartTime;
	}

	public List<Date> getLectureEndTime() {
		return lectureEndTime;
	}

	public void setLectureEndTime(List<Date> lectureEndTime) {
		this.lectureEndTime = lectureEndTime;
	}

	public Map<String, User> getUsers() {
		return users;
	}

	public void setUsers(Map<String, User> users) {
		this.users = users;
	}

	public List<Record> getFilteredRecords() {
		return filteredRecords;
	}

	public void setFilteredRecords(List<Record> filteredRecords) {
		this.filteredRecords = filteredRecords;
	}

	public List<String> getNamesOfTest() {
		return namesOfTest;
	}

	public void setNamesOfTest(List<String> namesOfTest) {
		this.namesOfTest = namesOfTest;
	}

}
