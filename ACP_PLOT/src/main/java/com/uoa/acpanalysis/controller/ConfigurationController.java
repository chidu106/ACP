package com.uoa.acpanalysis.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.uoa.acpanalysis.Utilities.Utilities;
import com.uoa.acpanalysis.model.DailyUsagePlot;
import com.uoa.acpanalysis.model.Marks;
import com.uoa.acpanalysis.model.Plot1;
import com.uoa.acpanalysis.model.SessionBean;
import com.uoa.acpanalysis.model.User;
import com.uoa.acpanalysis.model.formdata.GroupingCategory;
import com.uoa.acpanalysis.model.formdata.LectureTimesMarkWrapper;
import com.uoa.acpanalysis.model.formdata.RecordWrapper;
import com.uoa.acpanalysis.model.formdata.markAnalysis;
import com.uoa.acpanalysis.reader.ACPReader;
import com.uoa.acpanalysis.wrapper.Label;
import com.uoa.acpanalysis.wrapper.ParentWrapper;
import com.uoa.acpanalysis.wrapper.Series;

@Controller
/*@RequestMapping("/firstplot")*/
public class ConfigurationController {
	
	@Autowired
	SessionBean sessionBean;
	
    @SuppressWarnings("unchecked")
	@RequestMapping(value="/configuration",method=RequestMethod.POST,produces = "application/json")
    public @ResponseBody HashMap  addRecordsToSession() throws ParseException{
        @SuppressWarnings("rawtypes") 
		HashMap model = new HashMap();       
        model.put("records", sessionBean.getRecords());       
        return model;
    }
    
    @SuppressWarnings("unchecked")
	@RequestMapping(value="/configuration/filteredRecords",method=RequestMethod.POST,produces = "application/json")
    public @ResponseBody HashMap addFilterdRecords(@RequestBody RecordWrapper recordWrapper) throws ParseException{
    	sessionBean.setFilteredRecords(recordWrapper.getFilteredList()); 
    	
    	//Not required!!
    	HashMap model = new HashMap(); 
        return model;
    }
    
    //TODO Remove. Not needed
	@RequestMapping(value="/tempConfig",method = RequestMethod.GET)
	public String getUploadPage(ModelMap model) {
		return "configuration";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/configuration/marksLectureTimes",method=RequestMethod.POST)
    public String addMarksLectureTimes(@RequestBody LectureTimesMarkWrapper lectureTimesMarkWrapper) throws ParseException{
    	// Setting the values to session beans
		sessionBean.setLectureStartTime(Utilities.getDate(lectureTimesMarkWrapper.getLectureStartTimes()));
		sessionBean.setLectureEndTime(Utilities.getDate(lectureTimesMarkWrapper.getLectureEndTimes()));
		sessionBean.setUsers(lectureTimesMarkWrapper.getUsers());
		
		//Retreiving the names of tests/Assignments
		List<String> testNames = new ArrayList<String>();
		
		//Get the first element from a Map
		Entry<String, User> entry = lectureTimesMarkWrapper.getUsers().entrySet().iterator().next();
		User temp = (User)entry.getValue();
		for(int i=0 ;i < temp.getMarks().size();i++){
			testNames.add(temp.getMarks().get(i).getName());
		}
		
		//Add names of the tests to session
		sessionBean.setNamesOfTest(testNames);
		
		return "dailyUsage";
    }
    
   
	
}