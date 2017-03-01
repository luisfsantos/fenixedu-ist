<%--

    Copyright © 2013 Instituto Superior Técnico

    This file is part of FenixEdu IST Integration.

    FenixEdu IST Integration is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    FenixEdu IST Integration is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with FenixEdu IST Integration.  If not, see <http://www.gnu.org/licenses/>.

--%>
<%@ page language="java" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://fenix-ashes.ist.utl.pt/fenix-renderers" prefix="fr" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html:xhtml/>

<h2><bean:message key="link.reports" bundle="GEP_RESOURCES" /></h2>

<logic:notEmpty name="queueJobList">

	<h3 class="mtop15 mbottom05"><bean:message key="label.gep.latest.requests" bundle="GEP_RESOURCES" /></h3>
	
	<fr:view name="queueJobList">
		<fr:schema type="org.fenixedu.academic.domain.QueueJob" bundle="GEP_RESOURCES">
			<fr:slot name="executionYear.name" key="label.gep.courseYear"/>
			<fr:slot name="degreeType" key="label.gep.degree" layout="null-as-label">		       
		        <fr:property name="subSchema" value="degreeType.view"/>
		        <fr:property name="subLayout" value="values"/>
		    </fr:slot>
			<fr:slot name="jobName" key="label.gep.listing"/>
			<fr:slot name="upperCaseType" key="label.gep.format"/>
			<fr:slot name="requestDate" key="label.gep.date"/>
			<fr:slot name="person.name" key="label.get.person"/>
		</fr:schema>
    	<fr:layout name="tabular">
    		<fr:property name="classes" value="tstyle1 mtop05" />
    		<fr:property name="columnClasses" value=",,,acenter,,,,,," />
			<fr:property name="link(Download)" value="/downloadQueuedJob.do?method=downloadFile"/>
			<fr:property name="param(Download)" value="externalId/id"/>
			<fr:property name="bundle(Download)" value="GEP_RESOURCES"/>
			<fr:property name="visibleIf(Download)" value="done"/>
			<fr:property name="module(Download)" value=""/>
			
			<fr:property name="link(sendJob)" value="/gep/reportsByDegreeType.do?method=resendJob"/>
			<fr:property name="param(sendJob)" value="externalId/id"/>
			<fr:property name="key(sendJob)" value="label.sendJob"/>
			<fr:property name="bundle(sendJob)" value="GEP_RESOURCES"/>
			<fr:property name="visibleIf(sendJob)" value="isNotDoneAndCancelled"/>
			<fr:property name="module(sendJob)" value=""/>
			
			<fr:property name="link(Cancel)" value="/gep/reportsByDegreeType.do?method=cancelQueuedJob"/>
			<fr:property name="param(Cancel)" value="externalId/id"/>
			<fr:property name="key(Cancel)" value="label.cancel"/>
			<fr:property name="bundle(Cancel)" value="GEP_RESOURCES"/>
			<fr:property name="visibleIf(Cancel)" value="isNotDoneAndNotCancelled"/>
			<fr:property name="module(Cancel)" value=""/>
		</fr:layout>
	</fr:view>
</logic:notEmpty>

<logic:present name="reportBean">
	
	<h3 class="mtop15 mbottom05"><bean:message key="label.gep.new.request" bundle="GEP_RESOURCES" /></h3>
	
	<fr:form action="/reportsByDegreeType.do?method=selectDegreeType">
		<fr:edit name="reportBean" id="reportBean" type="pt.ist.fenixedu.integration.ui.struts.action.gep.ReportsByDegreeTypeDA$ReportBean" 
				schema="select.degree.type">
			<fr:layout>
				<fr:property name="classes" value="tstyle5 thlight thmiddle mtop05"/>
				<fr:property name="columnClasses" value=",,tdclear"/>
			</fr:layout>
		</fr:edit>
	</fr:form>

<logic:present name="job">
	<bean:define id="job" name="job" type="org.fenixedu.academic.domain.reports.GepReportFile"/>
		<div class="success0 mtop0" style="width:600px;">
			<logic:present name="reportBean" property="executionYear">
			<logic:present name="reportBean" property="degreeType">
				<p class="mvert05"><bean:message key="label.gep.listing.confirmation" bundle="GEP_RESOURCES" arg0="<%= job.getJobName().toString() %>" arg1="<%= job.getExecutionYear().getYear().toString() %>" arg2="<%= job.getDegreeType().getName().getContent().toString() %>"/></p>
				<p class="mvert05"><bean:message key="label.gep.email.notice" bundle="GEP_RESOURCES" /></p>
			</logic:present>
			</logic:present>
	
			<logic:notPresent name="reportBean" property="executionYear">
				<p class="mvert05"><bean:message key="label.gep.listing.confirmation.graduation" bundle="GEP_RESOURCES" arg0="<%= job.getJobName().toString() %>"/></p>
				<p class="mvert05"><bean:message key="label.gep.email.notice" bundle="GEP_RESOURCES" /></p>
			</logic:notPresent>
			
			<logic:present name="reportBean" property="executionYear">
			<logic:notPresent name="reportBean" property="degreeType">
				<p class="mvert05"><bean:message key="label.gep.listing.confirmation.graduation" bundle="GEP_RESOURCES" arg0="<%= job.getJobName().toString() %>"/></p>
				<p class="mvert05"><bean:message key="label.gep.email.notice" bundle="GEP_RESOURCES" /></p>
			</logic:notPresent>
			</logic:present>
		</div>
</logic:present>

<bean:define id="args" type="java.lang.String">degreeType=<bean:write name="reportBean" property="degreeTypeOID"/>&amp;executionYearID=<bean:write name="reportBean" property="executionYearOID"/></bean:define>

<logic:present name="reportBean" property="executionYear">
<logic:present name="reportBean" property="degreeType">

<bean:define id="executionYearID" name="reportBean" property="executionYear.externalId"/>
<bean:define id="degreeType" name="reportBean" property="degreeType"/>


<bean:define id="args" type="java.lang.String">degreeType=<bean:write name="reportBean" property="degreeTypeOID"/>&amp;executionYearID=<bean:write name="executionYearID"/></bean:define>
 
	<p class="mbottom05">
		<bean:message key="label.available.reports" bundle="GEP_RESOURCES" />
	</p>
	<bean:define id="urlEurAce" type="java.lang.String">/reportsByDegreeType.do?method=downloadEurAce&amp;<bean:write name="args" filter="false"/></bean:define>
	<bean:define id="urlEctsLabelForDegrees" type="java.lang.String">/reportsByDegreeType.do?method=downloadEctsLabelForDegrees&amp;<bean:write name="args" filter="false"/></bean:define>
	<bean:define id="urlEctsLabelForCurricularCourses" type="java.lang.String">/reportsByDegreeType.do?method=downloadEctsLabelForCurricularCourses&amp;<bean:write name="args" filter="false"/></bean:define>
	<bean:define id="urlStatusAndAproval" type="java.lang.String">/reportsByDegreeType.do?method=downloadStatusAndAproval&amp;<bean:write name="args" filter="false"/></bean:define>
	<bean:define id="urlEti" type="java.lang.String">/reportsByDegreeType.do?method=downloadEti&amp;<bean:write name="args" filter="false"/></bean:define>
	<bean:define id="urlCourseLoadAndResponsibles" type="java.lang.String">/reportsByDegreeType.do?method=downloadCourseLoadAndResponsibles&amp;<bean:write name="args" filter="false"/></bean:define>
	<bean:define id="urlRegistrations" type="java.lang.String">/reportsByDegreeType.do?method=downloadRegistrations&amp;<bean:write name="args" filter="false"/></bean:define>
	<bean:define id="urlFlunked" type="java.lang.String">/reportsByDegreeType.do?method=downloadFlunked&amp;<bean:write name="args" filter="false"/></bean:define>
	<bean:define id="urlTeachersByShift" type="java.lang.String">/reportsByDegreeType.do?method=downloadTeachersByShift&amp;<bean:write name="args" filter="false"/></bean:define>
	<bean:define id="urlCourseLoads" type="java.lang.String">/reportsByDegreeType.do?method=downloadCourseLoads&amp;<bean:write name="args" filter="false"/></bean:define>
	<bean:define id="urlTutorshipProgram" type="java.lang.String">/reportsByDegreeType.do?method=downloadTutorshipProgram&amp;<bean:write name="args" filter="false"/></bean:define>
	<bean:define id="urlTimetables" type="java.lang.String">/reportsByDegreeType.do?method=downloadTimetables&amp;<bean:write name="args" filter="false"/></bean:define>
    <bean:define id="urlRaidesGraduation" type="java.lang.String">/reportsByDegreeType.do?method=downloadRaidesGraduation&amp;<bean:write name="args" filter="false"/></bean:define>
    <bean:define id="urlRaidesDfa" type="java.lang.String">/reportsByDegreeType.do?method=downloadRaidesDfa&amp;<bean:write name="args" filter="false"/></bean:define>
    <bean:define id="urlRaidesPhd" type="java.lang.String">/reportsByDegreeType.do?method=downloadRaidesPhd&amp;<bean:write name="args" filter="false"/></bean:define>
    <bean:define id="urlRaidesSpecialization" type="java.lang.String">/reportsByDegreeType.do?method=downloadRaidesSpecialization&amp;<bean:write name="args" filter="false"/></bean:define>
	<bean:define id="viewReports" type="java.lang.String">/reportsByDegreeType.do?method=viewReports&amp;<bean:write name="args" filter="false"/></bean:define>
	
			<table class="tstyle1 thleft thlight mtop05">
				<tr>
					<td style="width: 350px;">
						<bean:message key="label.report.eur.ace" bundle="GEP_RESOURCES" />
					</td>
					<td>
						<bean:define id="urlEurAceCsv" type="java.lang.String"><bean:write name="urlEurAce" filter="false"/>&amp;format=csv&amp;type=1</bean:define>
						<html:link page="<%= urlEurAceCsv %>">
							<bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
						</html:link>
						|
						<bean:define id="urlEurAceXls" type="java.lang.String"><bean:write name="urlEurAce" filter="false"/>&amp;format=xls&amp;type=1</bean:define>
						<html:link page="<%= urlEurAceXls %>">
							<bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
						</html:link>
					</td>
					<td>
						<html:link page="<%= viewReports + "&type=1" %>">
							<bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType1"/>)
						</html:link>
					</td>
				</tr>
				<tr>
					<td>
						<bean:message key="label.report.ects.label.degrees" bundle="GEP_RESOURCES" />
					</td>
					<td>
						<bean:define id="urlEctsLabelDegreesCsv" type="java.lang.String"><bean:write name="urlEctsLabelForDegrees" filter="false"/>&amp;format=csv&amp;type=2</bean:define>
						<html:link page="<%= urlEctsLabelDegreesCsv %>">
							<bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
						</html:link>
						|
						<bean:define id="urlEctsLabelDegreesXls" type="java.lang.String"><bean:write name="urlEctsLabelForDegrees" filter="false"/>&amp;format=xls&amp;type=2</bean:define>
						<html:link page="<%= urlEctsLabelDegreesXls %>">
							<bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
						</html:link>
					</td>
					<td>
						<html:link page="<%= viewReports + "&type=2" %>">
							<bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType2"/>)
						</html:link>
					</td>
				</tr>
				<tr>
					<td>
						<bean:message key="label.report.ects.label.curricularCourses" bundle="GEP_RESOURCES" />
					</td>
					<td>
						<bean:define id="urlEctsLabelCurricularCoursesCsv" type="java.lang.String"><bean:write name="urlEctsLabelForCurricularCourses" filter="false"/>&amp;format=csv&amp;type=3</bean:define>
						<html:link page="<%= urlEctsLabelCurricularCoursesCsv %>">
							<bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
						</html:link>
						|
						<bean:define id="urlEctsLabelCurricularCoursesXls" type="java.lang.String"><bean:write name="urlEctsLabelForCurricularCourses" filter="false"/>&amp;format=xls&amp;type=3</bean:define>
						<html:link page="<%= urlEctsLabelCurricularCoursesXls %>">
							<bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
						</html:link>
					</td>
					<td>
						<html:link page="<%= viewReports + "&type=3" %>">
							<bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType3"/>)
						</html:link>
					</td>
				</tr>
				<tr>
					<td>
						<bean:message key="label.report.status.and.aprovals" bundle="GEP_RESOURCES" arg0="2003/2004"/>
					</td>
					<td>
						<bean:define id="urlStatusAndAprovalCsv" type="java.lang.String"><bean:write name="urlStatusAndAproval" filter="false"/>&amp;format=csv&amp;type=4</bean:define>
						<html:link page="<%= urlStatusAndAprovalCsv %>">
							<bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
						</html:link>
						|
						<bean:define id="urlStatusAndAprovalXls" type="java.lang.String"><bean:write name="urlStatusAndAproval" filter="false"/>&amp;format=xls&amp;type=4</bean:define>
						<html:link page="<%= urlStatusAndAprovalXls %>">
							<bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
						</html:link>
					</td>
					<td>
						<html:link page="<%= viewReports + "&type=4" %>">
							<bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType4"/>)
						</html:link>
					</td>
				</tr>
				<tr>
					<td>
						<bean:message key="label.report.eti" bundle="GEP_RESOURCES"/>
					</td>
					<td>
						<bean:define id="urlEtiCsv" type="java.lang.String"><bean:write name="urlEti" filter="false"/>&amp;format=csv&amp;type=5</bean:define>
						<html:link page="<%= urlEtiCsv %>">
							<bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
						</html:link>
						|
						<bean:define id="urlEtiXls" type="java.lang.String"><bean:write name="urlEti" filter="false"/>&amp;format=xls&amp;type=5</bean:define>
						<html:link page="<%= urlEtiXls %>">
							<bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
						</html:link>
					</td>
					<td>
						<html:link page="<%= viewReports + "&type=5" %>">
							<bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType5"/>)
						</html:link>
					</td>
				</tr>
			    <tr>
			       <td style="width: 350px;">
			           <bean:message key="label.report.course.load.and.responsibles" bundle="GEP_RESOURCES"/>
			       </td>
			       <td>
			           <bean:define id="urlCourseLoadAndResponsiblesCsv" type="java.lang.String"><bean:write name="urlCourseLoadAndResponsibles" filter="false"/>&amp;format=csv&amp;type=18</bean:define>
			           <html:link page="<%= urlCourseLoadAndResponsiblesCsv %>">
			               <bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
			           </html:link>
			           |
			           <bean:define id="urlCourseLoadAndResponsiblesXls" type="java.lang.String"><bean:write name="urlCourseLoadAndResponsibles" filter="false"/>&amp;format=xls&amp;type=18</bean:define>
			           <html:link page="<%= urlCourseLoadAndResponsiblesXls %>">
			               <bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
			           </html:link>
			       </td>
			       <td>
			           <html:link page="<%= viewReports + "&type=18" %>">
			               <bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType18"/>)
			           </html:link>
			       </td>
			    </tr>
		<!-- 		<tr>
					<td>
						<bean:message key="label.report.registrations" bundle="GEP_RESOURCES"/>
					</td>
					<td>
						<bean:define id="urlRegistrationsCsv" type="java.lang.String"><bean:write name="urlRegistrations" filter="false"/>&amp;format=csv&amp;type=6</bean:define>
						<html:link page="<%= urlRegistrationsCsv %>">
							<bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
						</html:link>
						|
						<bean:define id="urlRegistrationsXls" type="java.lang.String"><bean:write name="urlRegistrations" filter="false"/>&amp;format=xls&amp;type=6</bean:define>
						<html:link page="<%= urlRegistrationsXls %>">
							<bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
						</html:link>
					</td>
					<td>
						<html:link page="<%= viewReports + "&type=6" %>">
							<bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType6"/>)
						</html:link>
					</td>
				</tr>
                 -->
				<tr>
					<td>
						<bean:message key="label.report.flunked" bundle="GEP_RESOURCES"/>
					</td>
					<td>
						<bean:define id="urlFlunkedCsv" type="java.lang.String"><bean:write name="urlFlunked" filter="false"/>&amp;format=csv&amp;type=7</bean:define>
						<html:link page="<%= urlFlunkedCsv %>">
							<bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
						</html:link>
						|
						<bean:define id="urlFlunkedXls" type="java.lang.String"><bean:write name="urlFlunked" filter="false"/>&amp;format=xls&amp;type=7</bean:define>
						<html:link page="<%= urlFlunkedXls %>">
							<bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
						</html:link>
					</td>
					<td>
						<html:link page="<%= viewReports + "&type=7" %>">
							<bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType7"/>)
						</html:link>
					</td>
				</tr>
				<tr>
					<td>
						<bean:message key="label.report.teachersByShift" bundle="GEP_RESOURCES"/>
					</td>
					<td>
						<bean:define id="urlTeachersByShiftCsv" type="java.lang.String"><bean:write name="urlTeachersByShift" filter="false"/>&amp;format=csv&amp;type=8</bean:define>
						<html:link page="<%= urlTeachersByShiftCsv %>">
							<bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
						</html:link>
						|
						<bean:define id="urlTeachersByShiftXls" type="java.lang.String"><bean:write name="urlTeachersByShift" filter="false"/>&amp;format=xls&amp;type=8</bean:define>
						<html:link page="<%= urlTeachersByShiftXls %>">
							<bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
						</html:link>
					</td>
					<td>
						<html:link page="<%= viewReports + "&type=8" %>">
							<bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType8"/>)
						</html:link>
					</td>
				</tr>
				<tr>
					<td>
						<bean:message key="label.report.courseLoads" bundle="GEP_RESOURCES"/>
					</td>
					<td>
						<bean:define id="urlCourseLoadsCsv" type="java.lang.String"><bean:write name="urlCourseLoads" filter="false"/>&amp;format=csv&amp;type=9</bean:define>
						<html:link page="<%= urlCourseLoadsCsv %>">
							<bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
						</html:link>
						|
						<bean:define id="urlCourseLoadsXls" type="java.lang.String"><bean:write name="urlCourseLoads" filter="false"/>&amp;format=xls&amp;type=9</bean:define>
						<html:link page="<%= urlCourseLoadsXls %>">
							<bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
						</html:link>
					</td>
					<td>
						<html:link page="<%= viewReports + "&type=9" %>">
							<bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType9"/>)
						</html:link>
					</td>
				</tr>

				<tr>
					<td>
						<bean:message key="label.report.tutorship.program" bundle="GEP_RESOURCES"/>
					</td>
					<td>
						<bean:define id="urlTutorshipProgramCsv" type="java.lang.String"><bean:write name="urlTutorshipProgram" filter="false"/>&amp;format=csv&amp;type=16</bean:define>
						<html:link page="<%= urlTutorshipProgramCsv %>">
							<bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
						</html:link>
						|
						<bean:define id="urlTutorshipProgramXls" type="java.lang.String"><bean:write name="urlTutorshipProgram" filter="false"/>&amp;format=xls&amp;type=16</bean:define>
						<html:link page="<%= urlTutorshipProgramXls %>">
							<bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
						</html:link>
					</td>
					<td>
						<html:link page="<%= viewReports + "&type=16" %>">
							<bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType16"/>)
						</html:link>
					</td>
				</tr>
				
				<tr>
					<td>
						<bean:message key="label.report.teachers.and.lessons" bundle="GEP_RESOURCES"/>
					</td>
					<td>
						<bean:define id="urlTimetablesCsv" type="java.lang.String"><bean:write name="urlTimetables" filter="false"/>&amp;format=csv&amp;type=19</bean:define>
						<html:link page="<%= urlTimetablesCsv %>">
							<bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
						</html:link>
						|
						<bean:define id="urlTimetablesXls" type="java.lang.String"><bean:write name="urlTimetables" filter="false"/>&amp;format=xls&amp;type=19</bean:define>
						<html:link page="<%= urlTimetablesXls %>">
							<bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
						</html:link>
					</td>
					<td>
						<html:link page="<%= viewReports + "&type=19" %>">
							<bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType19"/>)
						</html:link>
					</td>
				</tr>

                <c:if test="${degreeType.bolonhaDegree || degreeType.integratedMasterDegree || degreeType.bolonhaMasterDegree }">
                    <tr>
                        <td>
                            <bean:message key="label.report.raides.graduation" bundle="GEP_RESOURCES"/>
                        </td>
                        <td>
                            <bean:define id="urlRaidesGraduationCsv" type="java.lang.String"><bean:write name="urlRaidesGraduation" filter="false"/>&amp;format=csv&amp;type=13</bean:define>
                            <html:link page="<%= urlRaidesGraduationCsv %>">
                                <bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
                            </html:link>
                            |
                            <bean:define id="urlRaidesGraduationXls" type="java.lang.String"><bean:write name="urlRaidesGraduation" filter="false"/>&amp;format=xls&amp;type=13</bean:define>
                            <html:link page="<%= urlRaidesGraduationXls %>">
                                <bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
                            </html:link>
                        </td>
                        <td>
                            <html:link page="<%= viewReports + "&type=13" %>">
                                <bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType13"/>)
                            </html:link>
                        </td>
                    </tr>
                </c:if>

				<c:if test="${degreeType.advancedFormationDiploma}">
                    <tr>
                        <td>
                            <bean:message key="label.report.raides.dfa" bundle="GEP_RESOURCES"/>
                        </td>
                        <td>
                            <bean:define id="urlRaidesDfaCsv" type="java.lang.String"><bean:write name="urlRaidesDfa" filter="false"/>&amp;format=csv&amp;type=14</bean:define>
                            <html:link page="<%= urlRaidesDfaCsv %>">
                                <bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
                            </html:link>
                            |
                            <bean:define id="urlRaidesDfaXls" type="java.lang.String"><bean:write name="urlRaidesDfa" filter="false"/>&amp;format=xls&amp;type=14</bean:define>
                            <html:link page="<%= urlRaidesDfaXls %>">
                                <bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
                            </html:link>
                        </td>
                        <td>
                            <html:link page="<%= viewReports + "&type=14" %>">
                                <bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType14"/>)
                            </html:link>
                        </td>
                    </tr>
                </c:if>
                
                <c:if test="${degreeType.advancedSpecializationDiploma}" >
                    <tr>
                        <td>
                            <bean:message key="label.report.raides.phd" bundle="GEP_RESOURCES"/>
                        </td>
                        <td>
                            <bean:define id="urlRaidesPhdCsv" type="java.lang.String"><bean:write name="urlRaidesPhd" filter="false"/>&amp;format=csv&amp;type=15</bean:define>
                            <html:link page="<%= urlRaidesPhdCsv %>">
                                <bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
                            </html:link>
                            |
                            <bean:define id="urlRaidesPhdXls" type="java.lang.String"><bean:write name="urlRaidesPhd" filter="false"/>&amp;format=xls&amp;type=15</bean:define>
                            <html:link page="<%= urlRaidesPhdXls %>">
                                <bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
                            </html:link>
                        </td>
                        <td>
                            <html:link page="<%= viewReports + "&type=15" %>">
                                <bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType15"/>)
                            </html:link>
                        </td>
                    </tr>
                </c:if>
                <c:if test="${degreeType.specializationCycle}" >
                    <tr>
                        <td>
                            <bean:message key="label.report.raides.specialization" bundle="GEP_RESOURCES"/>
                        </td>
                        <td>
                            <bean:define id="urlRaidesSpecializationCsv" type="java.lang.String"><bean:write name="urlRaidesSpecialization" filter="false"/>&amp;format=csv&amp;type=20</bean:define>
                            <html:link page="<%= urlRaidesSpecializationCsv %>">
                                <bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
                            </html:link>
                            |
                            <bean:define id="urlRaidesSpecializationXls" type="java.lang.String"><bean:write name="urlRaidesSpecialization" filter="false"/>&amp;format=xls&amp;type=20</bean:define>
                            <html:link page="<%= urlRaidesSpecializationXls %>">
                                <bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
                            </html:link>
                        </td>
                        <td>
                            <html:link page="<%= viewReports + "&type=20" %>">
                                <bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType20"/>)
                            </html:link>
                        </td>
                    </tr>
                </c:if>
                
			</table>
</logic:present>
</logic:present>

</logic:present>

<logic:present name="reportBean" property="executionYear">

<bean:define id="urlSummaries" type="java.lang.String">/reportsByDegreeType.do?method=downloadSummaries&amp;<bean:write name="args" filter="false"/></bean:define>
<bean:define id="urlWrittenEvaluations" type="java.lang.String">/reportsByDegreeType.do?method=downloadWrittenEvaluations&amp;<bean:write name="args" filter="false"/></bean:define>
<bean:define id="urlDissertations" type="java.lang.String">/reportsByDegreeType.do?method=downloadDissertationsWithExternalAffiliations&amp;<bean:write name="args" filter="false"/></bean:define>
<bean:define id="urlDissertationsProposals" type="java.lang.String">/reportsByDegreeType.do?method=downloadDissertationsProposals&amp;<bean:write name="args" filter="false"/></bean:define>
<bean:define id="urlTeachersFromAplica" type="java.lang.String">/reportsByDegreeType.do?method=downloadTeachersListFromAplica&amp;<bean:write name="args" filter="false"/></bean:define>
<bean:define id="urlTeachersFromGiaf" type="java.lang.String">/reportsByDegreeType.do?method=downloadTeachersListFromGiaf&amp;<bean:write name="args" filter="false"/></bean:define>
<bean:define id="urlTeacherCreditsReportFile" type="java.lang.String">/reportsByDegreeType.do?method=downloadTeacherCreditsReportFile&amp;<bean:write name="args" filter="false"/></bean:define>
<bean:define id="urlEffectiveTeachingLoadReportFile" type="java.lang.String">/reportsByDegreeType.do?method=downloadEffectiveTeachingLoadReportFile&amp;<bean:write name="args" filter="false"/>
</bean:define>
<bean:define id="viewReports" type="java.lang.String">/reportsByDegreeType.do?method=viewReports&amp;<bean:write name="args" filter="false"/></bean:define>
<bean:define id="urlAvailableCoursesForInquiry" type="java.lang.String">/reportsByDegreeType.do?method=downloadAvailableCoursesForQUCReportFile&amp;<bean:write name="args" filter="false"/></bean:define>
<bean:define id="urlInquiryWorkloadSummaryBoard" type="java.lang.String">/reportsByDegreeType.do?method=downloadWorkloadSummaryBoardReportFile&amp;<bean:write name="args" filter="false"/></bean:define>
<bean:define id="urlInquiryInitialAnswersReportFile" type="java.lang.String">/reportsByDegreeType.do?method=downloadInitialAnswersReportFile&amp;<bean:write name="args" filter="false"/></bean:define>
<bean:define id="urlInquiryCoursesAnswersReportFile" type="java.lang.String">/reportsByDegreeType.do?method=downloadCoursesAnswersReportFile&amp;<bean:write name="args" filter="false"/></bean:define>
<bean:define id="urlQUCQuestionsReportFile" type="java.lang.String">/reportsByDegreeType.do?method=downloadQUCQuestionsReportFile&amp;<bean:write name="args" filter="false"/></bean:define>

<bean:define id="urlDelegatesAnswersReportFile" type="java.lang.String">/reportsByDegreeType.do?method=downloadDelegatesAnswersReportFile&amp;<bean:write name="args" filter="false"/></bean:define>
<bean:define id="urlTeachersAnswersReportFile" type="java.lang.String">/reportsByDegreeType.do?method=downloadTeachersAnswersReportFile&amp;<bean:write name="args" filter="false"/></bean:define>
<bean:define id="urlRegentsAnswersReportFile" type="java.lang.String">/reportsByDegreeType.do?method=downloadRegentsAnswersReportFile&amp;<bean:write name="args" filter="false"/></bean:define>
<bean:define id="urlCoordinatorsAnswersReportFile" type="java.lang.String">/reportsByDegreeType.do?method=downloadCoordinatorsAnswersReportFile&amp;<bean:write name="args" filter="false"/></bean:define>
<bean:define id="urlFirstTimeCycleAnswersReportFile" type="java.lang.String">/reportsByDegreeType.do?method=downloadFirstTimeCycleAnswersReportFile&amp;<bean:write name="args" filter="false"/></bean:define>

<table class="tstyle1 thleft thlight mtop05">
	<logic:notPresent name="reportBean" property="degreeType">
		<tr>
			<td style="width: 350px;">
				<bean:message key="label.report.summaries" bundle="GEP_RESOURCES"/>
			</td>
			<td>
				<bean:define id="urlSummariesCsv" type="java.lang.String"><bean:write name="urlSummaries" filter="false"/>&amp;format=csv&amp;type=21</bean:define>
				<html:link page="<%= urlSummariesCsv %>">
					<bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
				</html:link>
				|
				<bean:define id="urlSummariesXls" type="java.lang.String"><bean:write name="urlSummaries" filter="false"/>&amp;format=xls&amp;type=21</bean:define>
				<html:link page="<%= urlSummariesXls %>">
					<bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
				</html:link>
			</td>
			<td>
				<html:link page="<%= viewReports + "&type=21" %>">
					<bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType21"/>)
				</html:link>
			</td>
		</tr>
		<tr>
			<td style="width: 350px;">
				<bean:message key="label.report.writtenEvaluations" bundle="GEP_RESOURCES"/>
			</td>
			<td>
				<bean:define id="urlWrittenEvaluationsCsv" type="java.lang.String"><bean:write name="urlWrittenEvaluations" filter="false"/>&amp;format=csv&amp;type=22</bean:define>
				<html:link page="<%= urlWrittenEvaluationsCsv %>">
					<bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
				</html:link>
				|
				<bean:define id="urlWrittenEvaluationsXls" type="java.lang.String"><bean:write name="urlWrittenEvaluations" filter="false"/>&amp;format=xls&amp;type=22</bean:define>
				<html:link page="<%= urlWrittenEvaluationsXls %>">
					<bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
				</html:link>
			</td>
			<td>
				<html:link page="<%= viewReports + "&type=22" %>">
					<bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType22"/>)
				</html:link>
			</td>
		</tr>
	</logic:notPresent>
	<tr>
		<td style="width: 350px;">
			<bean:message key="label.report.dissertations" bundle="GEP_RESOURCES"/>
		</td>
		<td>
			<bean:define id="urlDissertationsCsv" type="java.lang.String"><bean:write name="urlDissertations" filter="false"/>&amp;format=csv&amp;type=11</bean:define>
			<html:link page="<%= urlDissertationsCsv %>">
				<bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
			</html:link>
			|
			<bean:define id="urlDissertationsXls" type="java.lang.String"><bean:write name="urlDissertations" filter="false"/>&amp;format=xls&amp;type=11</bean:define>
			<html:link page="<%= urlDissertationsXls %>">
				<bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
			</html:link>
		</td>
		<td>
			<html:link page="<%= viewReports + "&type=11" %>">
				<bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType11"/>)
			</html:link>
		</td>
	</tr>
	<tr>
		<td style="width: 350px;">
			<bean:message key="label.report.dissertations.proposals" bundle="GEP_RESOURCES"/>
		</td>
		<td>
			<bean:define id="urlDissertationsCsv" type="java.lang.String"><bean:write name="urlDissertationsProposals" filter="false"/>&amp;format=csv&amp;type=12</bean:define>
			<html:link page="<%= urlDissertationsCsv %>">
				<bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
			</html:link>
			|
			<bean:define id="urlDissertationsXls" type="java.lang.String"><bean:write name="urlDissertationsProposals" filter="false"/>&amp;format=xls&amp;type=12</bean:define>
			<html:link page="<%= urlDissertationsXls %>">
				<bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
			</html:link>
		</td>
		<td>
			<html:link page="<%= viewReports + "&type=12" %>">
				<bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType12"/>)
			</html:link>
		</td>
	</tr>
	<%-- tr>
		<td style="width: 350px;">
			<bean:message key="label.report.teachersList.from.aplica" arg0="<%=org.fenixedu.academic.domain.organizationalStructure.Unit.getInstitutionAcronym()%>" bundle="GEP_RESOURCES"/>
		</td>
		<td>
			<bean:define id="urlTeachersCsv" type="java.lang.String"><bean:write name="urlTeachersFromAplica" filter="false"/>&amp;format=csv&amp;type=17</bean:define>
			<html:link page="<%= urlTeachersCsv %>">
				<bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
			</html:link>
			|
			<bean:define id="urlTeachersXls" type="java.lang.String"><bean:write name="urlTeachersFromAplica" filter="false"/>&amp;format=xls&amp;type=17</bean:define>
			<html:link page="<%= urlTeachersXls %>">
				<bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
			</html:link>
		</td>
		<td>
			<html:link page="<%= viewReports + "&type=17" %>">
				<bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType17"/>)
			</html:link>
		</td>
	</tr--%>
	<tr>
		<td style="width: 350px;">
			<bean:message key="label.report.teachersList.from.giaf" arg0="<%=org.fenixedu.academic.domain.organizationalStructure.Unit.getInstitutionAcronym()%>" bundle="GEP_RESOURCES"/>
		</td>
		<td>
			<bean:define id="urlTeachersCsv" type="java.lang.String"><bean:write name="urlTeachersFromGiaf" filter="false"/>&amp;format=csv&amp;type=17</bean:define>
			<html:link page="<%= urlTeachersCsv %>">
				<bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
			</html:link>
			|
			<bean:define id="urlTeachersXls" type="java.lang.String"><bean:write name="urlTeachersFromGiaf" filter="false"/>&amp;format=xls&amp;type=17</bean:define>
			<html:link page="<%= urlTeachersXls %>">
				<bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
			</html:link>
		</td>
		<td>
			<html:link page="<%= viewReports + "&type=17" %>">
				<bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType17"/>)
			</html:link>
		</td>
	</tr>
	<tr>
		<td style="width: 350px;">
			<bean:message key="label.report.teacherCredits" arg0="<%=org.fenixedu.academic.domain.organizationalStructure.Unit.getInstitutionAcronym()%>" bundle="GEP_RESOURCES"/>
		</td>
		<td>
			<bean:define id="urlTeachersCsv" type="java.lang.String"><bean:write name="urlTeacherCreditsReportFile" filter="false"/>&amp;format=csv&amp;type=23</bean:define>
			<html:link page="<%= urlTeachersCsv %>">
				<bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
			</html:link>
			|
			<bean:define id="urlTeachersXls" type="java.lang.String"><bean:write name="urlTeacherCreditsReportFile" filter="false"/>&amp;format=xls&amp;type=23</bean:define>
			<html:link page="<%= urlTeachersXls %>">
				<bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
			</html:link>
		</td>
		<td>
			<html:link page="<%= viewReports + "&type=23" %>">
				<bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType23"/>)
			</html:link>
		</td>
	</tr>
	<tr>
		<td style="width: 350px;">
			<bean:message key="label.report.effectiveTeachingLoad" bundle="GEP_RESOURCES"/>
		</td>
		<td>
			<bean:define id="urlTeachersCsv" type="java.lang.String"><bean:write name="urlEffectiveTeachingLoadReportFile" filter="false"/>&amp;format=csv&amp;type=24</bean:define>
			<html:link page="<%= urlTeachersCsv %>">
				<bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
			</html:link>
			|
			<bean:define id="urlTeachersXls" type="java.lang.String"><bean:write name="urlEffectiveTeachingLoadReportFile" filter="false"/>&amp;format=xls&amp;type=24</bean:define>
			<html:link page="<%= urlTeachersXls %>">
				<bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
			</html:link>
		</td>
		<td>
			<html:link page="<%= viewReports + "&type=24" %>">
				<bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType24"/>)
			</html:link>
		</td>
	</tr>
	<tr>
        <td>
        	${fr:message('resources.FenixEduQucResources', 'label.report.available.quc')}                        
        </td>
        <td>
            <bean:define id="urlAvailableForInquiryCsv" type="java.lang.String"><bean:write name="urlAvailableCoursesForInquiry" filter="false"/>&amp;format=csv&amp;type=25</bean:define>
            <html:link page="<%= urlAvailableForInquiryCsv %>">
                <bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
            </html:link>
            |
            <bean:define id="urlAvailableForInquiryXls" type="java.lang.String"><bean:write name="urlAvailableCoursesForInquiry" filter="false"/>&amp;format=xls&amp;type=25</bean:define>
            <html:link page="<%= urlAvailableForInquiryXls %>">
                <bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
            </html:link>
        </td>
        <td>
            <html:link page="<%= viewReports + "&type=25" %>">
                <bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType25"/>)
            </html:link>
        </td>
    </tr>
    <tr>
        <td>
        	${fr:message('resources.FenixEduQucResources', 'label.report.workload.summary')}                        
        </td>
        <td>
            <bean:define id="urlInquiryWorkloadSummaryBoardCsv" type="java.lang.String"><bean:write name="urlInquiryWorkloadSummaryBoard" filter="false"/>&amp;format=csv&amp;type=26</bean:define>
            <html:link page="<%= urlInquiryWorkloadSummaryBoardCsv %>">
                <bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
            </html:link>
            |
            <bean:define id="urlInquiryWorkloadSummaryBoardXls" type="java.lang.String"><bean:write name="urlInquiryWorkloadSummaryBoard" filter="false"/>&amp;format=xls&amp;type=26</bean:define>
            <html:link page="<%= urlInquiryWorkloadSummaryBoardXls %>">
                <bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
            </html:link>
        </td>
        <td>
            <html:link page="<%= viewReports + "&type=26" %>">
                <bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType26"/>)
            </html:link>
        </td>
    </tr>
    <tr>
        <td>
        	${fr:message('resources.FenixEduQucResources', 'label.report.initial.answers')}                        
        </td>
        <td>
            <bean:define id="urlInquiryInitialAnswersReportFileCsv" type="java.lang.String"><bean:write name="urlInquiryInitialAnswersReportFile" filter="false"/>&amp;format=csv&amp;type=27</bean:define>
            <html:link page="<%= urlInquiryInitialAnswersReportFileCsv %>">
                <bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
            </html:link>
            |
            <bean:define id="urlInquiryInitialAnswersReportFileXls" type="java.lang.String"><bean:write name="urlInquiryInitialAnswersReportFile" filter="false"/>&amp;format=xls&amp;type=27</bean:define>
            <html:link page="<%= urlInquiryInitialAnswersReportFileXls %>">
                <bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
            </html:link>
        </td>
        <td>
            <html:link page="<%= viewReports + "&type=27" %>">
                <bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType27"/>)
            </html:link>
        </td>
    </tr>
    <tr>
        <td>
        	${fr:message('resources.FenixEduQucResources', 'label.report.inquiry.answers')}                        
        </td>
        <td>
            <bean:define id="urlInquiryCoursesAnswersReportFileCsv" type="java.lang.String"><bean:write name="urlInquiryCoursesAnswersReportFile" filter="false"/>&amp;format=csv&amp;type=28</bean:define>
            <html:link page="<%= urlInquiryCoursesAnswersReportFileCsv %>">
                <bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
            </html:link>
            |
            <bean:define id="urlInquiryCoursesAnswersReportFileXls" type="java.lang.String"><bean:write name="urlInquiryCoursesAnswersReportFile" filter="false"/>&amp;format=xls&amp;type=28</bean:define>
            <html:link page="<%= urlInquiryCoursesAnswersReportFileXls %>">
                <bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
            </html:link>
        </td>
        <td>
            <html:link page="<%= viewReports + "&type=28" %>">
                <bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType28"/>)
            </html:link>
        </td>
    </tr>



<bean:define id="urlDelegatesAnswersReportFile" type="java.lang.String">/reportsByDegreeType.do?method=downloadDelegatesAnswersReportFile&amp;<bean:write name="args" filter="false"/></bean:define>
<bean:define id="urlTeachersAnswersReportFile" type="java.lang.String">/reportsByDegreeType.do?method=downloadTeachersAnswersReportFile&amp;<bean:write name="args" filter="false"/></bean:define>
<bean:define id="urlRegentsAnswersReportFile" type="java.lang.String">/reportsByDegreeType.do?method=downloadRegentsAnswersReportFile&amp;<bean:write name="args" filter="false"/></bean:define>
<bean:define id="urlCoordinatorsAnswersReportFile" type="java.lang.String">/reportsByDegreeType.do?method=downloadCoordinatorsAnswersReportFile&amp;<bean:write name="args" filter="false"/></bean:define>
<bean:define id="urlFirstTimeCycleAnswersReportFile"  type="java.lang.String">/reportsByDegreeType.do?method=downloadFirstTimeCycleAnswersReportFile&amp;<bean:write name="args" filter="false"/></bean:define>
    <tr>
        <td>
        	${fr:message('resources.FenixEduQucResources', 'label.report.quc.answers.delegates')}                        
        </td>
        <td>
            <bean:define id="urlDelegatesAnswersReportFileCsv" type="java.lang.String"><bean:write name="urlDelegatesAnswersReportFile" filter="false"/>&amp;format=csv&amp;type=30</bean:define>
            <html:link page="<%= urlDelegatesAnswersReportFileCsv %>">
                <bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
            </html:link>
            |
            <bean:define id="urlDelegatesAnswersReportFileXls" type="java.lang.String"><bean:write name="urlDelegatesAnswersReportFile" filter="false"/>&amp;format=xls&amp;type=30</bean:define>
            <html:link page="<%= urlDelegatesAnswersReportFileXls %>">
                <bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
            </html:link>
        </td>
        <td>
            <html:link page="<%= viewReports + "&type=30" %>">
                <bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType30"/>)
            </html:link>
        </td>
    </tr> 
    <tr>
        <td>
        	${fr:message('resources.FenixEduQucResources', 'label.report.quc.answers.teachers')}                        
        </td>
        <td>
            <bean:define id="urlTeachersAnswersReportFileCsv" type="java.lang.String"><bean:write name="urlTeachersAnswersReportFile" filter="false"/>&amp;format=csv&amp;type=31</bean:define>
            <html:link page="<%= urlTeachersAnswersReportFileCsv %>">
                <bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
            </html:link>
            |
            <bean:define id="urlTeachersAnswersReportFileXls" type="java.lang.String"><bean:write name="urlTeachersAnswersReportFile" filter="false"/>&amp;format=xls&amp;type=31</bean:define>
            <html:link page="<%= urlTeachersAnswersReportFileXls %>">
                <bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
            </html:link>
        </td>
        <td>
            <html:link page="<%= viewReports + "&type=31" %>">
                <bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType31"/>)
            </html:link>
        </td>
    </tr> 
    <tr>
        <td>
        	${fr:message('resources.FenixEduQucResources', 'label.report.quc.answers.regents')}                        
        </td>
        <td>
            <bean:define id="urlRegentsAnswersReportFileCsv" type="java.lang.String"><bean:write name="urlRegentsAnswersReportFile" filter="false"/>&amp;format=csv&amp;type=32</bean:define>
            <html:link page="<%= urlRegentsAnswersReportFileCsv %>">
                <bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
            </html:link>
            |
            <bean:define id="urlRegentsAnswersReportFileXls" type="java.lang.String"><bean:write name="urlRegentsAnswersReportFile" filter="false"/>&amp;format=xls&amp;type=32</bean:define>
            <html:link page="<%= urlRegentsAnswersReportFileXls %>">
                <bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
            </html:link>
        </td>
        <td>
            <html:link page="<%= viewReports + "&type=32" %>">
                <bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType32"/>)
            </html:link>
        </td>
    </tr> 
    <tr>
        <td>
        	${fr:message('resources.FenixEduQucResources', 'label.report.quc.answers.coordinator')}                        
        </td>
        <td>
            <bean:define id="urlCoordinatorsAnswersReportFileCsv" type="java.lang.String"><bean:write name="urlCoordinatorsAnswersReportFile" filter="false"/>&amp;format=csv&amp;type=33</bean:define>
            <html:link page="<%= urlCoordinatorsAnswersReportFileCsv %>">
                <bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
            </html:link>
            |
            <bean:define id="urlCoordinatorsAnswersReportFileXls" type="java.lang.String"><bean:write name="urlCoordinatorsAnswersReportFile" filter="false"/>&amp;format=xls&amp;type=33</bean:define>
            <html:link page="<%= urlCoordinatorsAnswersReportFileXls %>">
                <bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
            </html:link>
        </td>
        <td>
            <html:link page="<%= viewReports + "&type=33" %>">
                <bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType33"/>)
            </html:link>
        </td>
    </tr> 
    <tr>
        <td>
        	${fr:message('resources.FenixEduQucResources', 'label.report.quc.answers.firstTimeCycle')}                        
        </td>
        <td>
            <bean:define id="urlFirstTimeCycleAnswersReportFileCsv" type="java.lang.String"><bean:write name="urlFirstTimeCycleAnswersReportFile" filter="false"/>&amp;format=csv&amp;type=34</bean:define>
            <html:link page="<%= urlFirstTimeCycleAnswersReportFileCsv %>">
                <bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
            </html:link>
            |
            <bean:define id="urlFirstTimeCycleAnswersReportFileXls" type="java.lang.String"><bean:write name="urlFirstTimeCycleAnswersReportFile" filter="false"/>&amp;format=xls&amp;type=34</bean:define>
            <html:link page="<%= urlFirstTimeCycleAnswersReportFileXls %>">
                <bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
            </html:link>
        </td>
        <td>
            <html:link page="<%= viewReports + "&type=34" %>">
                <bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType34"/>)
            </html:link>
        </td>
    </tr> 




    <tr>
        <td>
        	${fr:message('resources.FenixEduQucResources', 'label.report.quc.questions')}                        
        </td>
        <td>
            <bean:define id="urlQUCQuestionsReportFileCsv" type="java.lang.String"><bean:write name="urlQUCQuestionsReportFile" filter="false"/>&amp;format=csv&amp;type=29</bean:define>
            <html:link page="<%= urlQUCQuestionsReportFileCsv %>">
                <bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
            </html:link>
            |
            <bean:define id="urlQUCQuestionsReportFileXls" type="java.lang.String"><bean:write name="urlQUCQuestionsReportFile" filter="false"/>&amp;format=xls&amp;type=29</bean:define>
            <html:link page="<%= urlQUCQuestionsReportFileXls %>">
                <bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
            </html:link>
        </td>
        <td>
            <html:link page="<%= viewReports + "&type=29" %>">
                <bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType29"/>)
            </html:link>
        </td>
    </tr>    
</table>

</logic:present>

<bean:define id="urlGraduations" type="java.lang.String">/reportsByDegreeType.do?method=downloadGraduations&amp;<bean:write name="args" filter="false"/></bean:define>
<bean:define id="viewReports" type="java.lang.String">/reportsByDegreeType.do?method=viewReports&amp;<bean:write name="args" filter="false"/></bean:define>
<table class="tstyle1 thleft thlight mtop05">
	<tr>
		<td style="width: 350px;">
			<bean:message key="label.report.graduations" bundle="GEP_RESOURCES"/>
		</td>
		<td>
			<bean:define id="urlGraduationsCsv" type="java.lang.String"><bean:write name="urlGraduations" filter="false"/>&amp;format=csv&amp;type=10</bean:define>
			<html:link page="<%= urlGraduationsCsv %>">
				<bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
			</html:link>
			|
			<bean:define id="urlGraduationsXls" type="java.lang.String"><bean:write name="urlGraduations" filter="false"/>&amp;format=xls&amp;type=10</bean:define>
			<html:link page="<%= urlGraduationsXls %>">
				<bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
			</html:link>
		</td>
		<td>
			<html:link page="<%= viewReports + "&type=10" %>">
				<bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType10"/>)
			</html:link>
		</td>
	</tr>
</table>

<bean:define id="urlMeritReportFile" type="java.lang.String">/reportsByDegreeType.do?method=downloadMeritReportFile&amp;<bean:write name="args" filter="false"/></bean:define>
<logic:present name="reportBean" property="executionYear">
<logic:present name="reportBean" property="degreeType">
<table class="tstyle1 thleft thlight mtop05">
	<tr>
		<td style="width: 350px;">
			${fr:message('resources.FenixeduIstIntegrationResources', 'label.student.merit.reports')} 
		</td>
		<td>
			<bean:define id="urlMeritReportFileCsv" type="java.lang.String"><bean:write name="urlMeritReportFile" filter="false"/>&amp;format=csv&amp;type=35</bean:define>
			<html:link page="<%= urlMeritReportFileCsv %>">
				<bean:message key="label.request.csv" bundle="GEP_RESOURCES" />
			</html:link>
			|
			<bean:define id="urlMeritReportFileXls" type="java.lang.String"><bean:write name="urlMeritReportFile" filter="false"/>&amp;format=xls&amp;type=35</bean:define>
			<html:link page="<%= urlMeritReportFileXls %>">
				<bean:message key="label.request.xls" bundle="GEP_RESOURCES" />
			</html:link>
		</td>
		<td>
			<html:link page="<%= viewReports + "&type=35" %>">
				<bean:message key="label.view.requests.done" bundle="GEP_RESOURCES" /> (<bean:write name="numberOfReportsType35"/>)
			</html:link>
		</td>
	</tr>
</table>
</logic:present>
</logic:present>