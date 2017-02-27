/**
 * Copyright © 2017 Instituto Superior Técnico
 * <p>
 * This file is part of FenixEdu IST Integration.
 * <p>
 * FenixEdu IST Integration is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * <p>
 * FenixEdu IST Integration is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * <p>
 * You should have received a copy of the GNU Lesser General Public License
 * along with FenixEdu IST Integration.  If not, see <http://www.gnu.org/licenses/>.
 */

package pt.ist.fenixedu.integration.ui.spring.controller;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;

import javax.servlet.http.HttpServletResponse;

import org.fenixedu.academic.domain.ExecutionYear;
import org.fenixedu.academic.domain.degree.DegreeType;
import org.fenixedu.bennu.spring.portal.SpringApplication;
import org.fenixedu.bennu.spring.portal.SpringFunctionality;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import pt.ist.fenixedu.integration.ui.spring.service.StudentMeritReportService;

/**
 * Created by Luis Santos on 23-02-2017.
 */
@SpringApplication(group = "logged", hint = "", path = "student-merit-reports", title = "student.merit.report.title")
@SpringFunctionality(app = StudentMeritReportsController.class, title = "student.merit.report.title")
@RequestMapping("/student-merit-reports") public class StudentMeritReportsController {

    @Autowired
    StudentMeritReportService service;

    @RequestMapping(method = RequestMethod.GET)
    public String chooseMeritReport(Model model) {
        model.addAttribute("executionYears", service.getExecutionYears());
        model.addAttribute("degreeTypes", service.getRelevantDegreeTypes());
        return "fenixedu-ist-integration/meritReports/generate";
    }

    @RequestMapping(value = "/generate", method = RequestMethod.POST)
    public String generateMeritReport(HttpServletResponse response,
            @RequestParam(value = "executionYear") ExecutionYear executionYear,
            @RequestParam(value = "degreeType") DegreeType degreeType) {

        ByteArrayOutputStream report = service.generateReport(degreeType, executionYear);
        String fileName = "Merit_Report" + "_" + degreeType.getName().getContent().replace(" ", "_") + "_"
                + executionYear.getYear().replace("/", "_");

        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-Disposition", String.format("attachment; filename=\"" + fileName + "\""));

        try {
            FileCopyUtils.copy(new ByteArrayInputStream(report.toByteArray()), response.getOutputStream());
        } catch (IOException e) {
            e.printStackTrace();
        }
        return "redirect:/student-merit-reports";
    }
}
