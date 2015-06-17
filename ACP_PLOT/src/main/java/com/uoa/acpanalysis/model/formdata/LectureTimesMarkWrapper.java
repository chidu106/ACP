package com.uoa.acpanalysis.model.formdata;

import java.util.ArrayList;
import java.util.HashMap;

import com.uoa.acpanalysis.model.User;

public class LectureTimesMarkWrapper {
	
	private   ArrayList lectureStartTimes = new ArrayList();
	
	private   ArrayList lectureEndTimes = new ArrayList();
	
	private HashMap<String, User> users = new HashMap<String, User>();
	
	public ArrayList getLectureStartTimes() {
		return lectureStartTimes;
	}

	public void setLectureStartTimes(ArrayList lectureStartTimes) {
		this.lectureStartTimes = lectureStartTimes;
	}

	public ArrayList getLectureEndTimes() {
		return lectureEndTimes;
	}

	public void setLectureEndTimes(ArrayList lectureEndTimes) {
		this.lectureEndTimes = lectureEndTimes;
	}

	public HashMap<String, User> getUsers() {
		return users;
	}

	public void setUsers(HashMap<String, User> users) {
		this.users = users;
	}

}
