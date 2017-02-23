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

import org.fenixedu.bennu.core.domain.Bennu;
import org.fenixedu.bennu.spring.portal.SpringApplication;
import org.fenixedu.bennu.spring.portal.SpringFunctionality;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Created by Luis Santos on 23-02-2017.
 */
@SpringApplication(group = "logged", hint = "", path = "student-merit-reports", title = "student.merit.report.title")
@SpringFunctionality(app = StudentMeritReportsController.class, title = "student.merit.report.title")
@RequestMapping("/student-merit-reports") public class StudentMeritReportsController {

    @RequestMapping(method = RequestMethod.GET) public String generateMeritReport(Model model) {
        model.addAttribute("executionYears", Bennu.getInstance().getExecutionYearsSet());
        return "fenixedu-ist-integration/meritReports/generate";
    }
}
