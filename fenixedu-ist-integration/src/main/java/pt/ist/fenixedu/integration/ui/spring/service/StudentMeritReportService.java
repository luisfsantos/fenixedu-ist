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

package pt.ist.fenixedu.integration.ui.spring.service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.fenixedu.academic.domain.Degree;
import org.fenixedu.academic.domain.DegreeCurricularPlan;
import org.fenixedu.academic.domain.Enrolment;
import org.fenixedu.academic.domain.ExecutionYear;
import org.fenixedu.academic.domain.Grade;
import org.fenixedu.academic.domain.IEnrolment;
import org.fenixedu.academic.domain.Person;
import org.fenixedu.academic.domain.StudentCurricularPlan;
import org.fenixedu.academic.domain.degree.DegreeType;
import org.fenixedu.academic.domain.student.Registration;
import org.fenixedu.academic.domain.student.Student;
import org.fenixedu.academic.domain.studentCurriculum.Credits;
import org.fenixedu.academic.domain.studentCurriculum.CurriculumGroup;
import org.fenixedu.academic.domain.studentCurriculum.CurriculumLine;
import org.fenixedu.academic.domain.studentCurriculum.CurriculumModule;
import org.fenixedu.academic.domain.studentCurriculum.Dismissal;
import org.fenixedu.academic.domain.studentCurriculum.EnrolmentWrapper;
import org.fenixedu.academic.domain.studentCurriculum.RootCurriculumGroup;
import org.fenixedu.academic.domain.studentCurriculum.Substitution;
import org.fenixedu.bennu.core.domain.Bennu;
import org.fenixedu.commons.spreadsheet.Spreadsheet;
import org.fenixedu.commons.spreadsheet.Spreadsheet.Row;
import org.springframework.stereotype.Service;

/**
 * Created by Luis Santos on 24-02-2017.
 */

@Service
public class StudentMeritReportService {

    private static final MathContext MATH_CONTEXT = new MathContext(3, RoundingMode.HALF_EVEN);

    public List<ExecutionYear> getExecutionYears() {
        return Bennu.getInstance().getExecutionYearsSet().stream().sorted(ExecutionYear.COMPARATOR_BY_YEAR.reversed())
                .collect(Collectors.toList());
    }

    public List<DegreeType> getRelevantDegreeTypes() {
        return DegreeType.all().filter(type -> !type.isEmpty()).sorted().collect(Collectors.toList());
    }

    private void process(final DegreeType degreeType, final ExecutionYear executionYearForReport) {
        final Spreadsheet spreadsheet = createHeader(executionYearForReport);
        for (final Degree degree : Bennu.getInstance().getDegreesSet()) {
            if (degreeType != degree.getDegreeType()) {
                continue;
            }
    
            for (final DegreeCurricularPlan degreeCurricularPlan : degree.getDegreeCurricularPlansSet()) {
                for (final StudentCurricularPlan studentCurricularPlan : degreeCurricularPlan.getStudentCurricularPlansSet()) {
                    final Registration registration = studentCurricularPlan.getRegistration();
                    final Student student = registration.getStudent();
                    if (registration.hasAnyActiveState(executionYearForReport)) {
                        final double approvedCredits =
                                getCredits(executionYearForReport, studentCurricularPlan.getRegistration().getStudent(), true);
                        final double enrolledCredits =
                                getCredits(executionYearForReport, studentCurricularPlan.getRegistration().getStudent(), false);
                        final Person person = student.getPerson();
                        final int curricularYear = registration.getCurricularYear(executionYearForReport);
    
                        final Row row = spreadsheet.addRow();
                        row.setCell(degree.getSigla());
                        row.setCell(student.getNumber());
                        row.setCell(person.getName());
                        row.setCell(enrolledCredits);
                        row.setCell(approvedCredits);
                        row.setCell(curricularYear);
    
                        final BigDecimal average = calculateAverage(registration, executionYearForReport);
                        row.setCell(average.toPlainString());
                    }
                }
            }
        }
        ByteArrayOutputStream reportFileOS = new ByteArrayOutputStream();
        try {
            spreadsheet.exportToXLSSheet(reportFileOS);
        } catch (final IOException e) {
            throw new Error(e);
        }
        //need to output TODO output(degreeType.getName() + "_", reportFileOS.toByteArray());
    }

    private Spreadsheet createHeader(ExecutionYear executionYear) {
        Spreadsheet spreadsheet = new Spreadsheet("MeritStudents");
        String year = executionYear.getYear();
        spreadsheet.setHeader("Degree");
        spreadsheet.setHeader("Number");
        spreadsheet.setHeader("Name");
        spreadsheet.setHeader("Credits Enroled in " + year);
        spreadsheet.setHeader("Credits Approved Durring Year " + year);
        spreadsheet.setHeader("Curricular Year During " + year);
        spreadsheet.setHeader("Average in " + year);
    
        return spreadsheet;
    }

    private double getCredits(final ExecutionYear executionYear, final Student student, final boolean approvedCredits) {
        double creditsCount = 0.0;
        for (final Registration registration : student.getRegistrationsSet()) {
            for (final StudentCurricularPlan studentCurricularPlan : registration.getStudentCurricularPlansSet()) {
                final RootCurriculumGroup root = studentCurricularPlan.getRoot();
                final Set<CurriculumModule> modules =
                        root == null ? (Set) studentCurricularPlan.getEnrolmentsSet() : root.getCurriculumModulesSet();
                creditsCount += countCredits(executionYear, modules, approvedCredits);
            }
        }
        return creditsCount;
    }

    private double countCredits(final ExecutionYear executionYear, final Set<CurriculumModule> modules,
            final boolean approvedCredits) {
        double creditsCount = 0.0;
        for (final CurriculumModule module : modules) {
            if (module instanceof CurriculumGroup) {
                final CurriculumGroup courseGroup = (CurriculumGroup) module;
                creditsCount += countCredits(executionYear, courseGroup.getCurriculumModulesSet(), approvedCredits);
            } else if (module instanceof CurriculumLine) {
                final CurriculumLine curriculumLine = (CurriculumLine) module;
                if (curriculumLine.getExecutionYear() == executionYear) {
                    if (approvedCredits) {
                        creditsCount += curriculumLine.getAprovedEctsCredits().doubleValue();
                    } else {
                        creditsCount += curriculumLine.getEctsCredits().doubleValue();
                    }
                }
            }
        }
        return creditsCount;
    }

    private BigDecimal calculateAverage(final Registration registration, final ExecutionYear executionYear) {
        BigDecimal[] result = new BigDecimal[] { new BigDecimal(0.000, MATH_CONTEXT), new BigDecimal(0.000, MATH_CONTEXT) };
        for (final StudentCurricularPlan studentCurricularPlan : registration.getStudentCurricularPlansSet()) {
            final RootCurriculumGroup root = studentCurricularPlan.getRoot();
            final Set<CurriculumModule> modules =
                    root == null ? (Set) studentCurricularPlan.getEnrolmentsSet() : root.getCurriculumModulesSet();
            calculateAverage(result, modules, executionYear);
        }
        return result[1].equals(BigDecimal.ZERO) ? result[1] : result[0].divide(result[1], MATH_CONTEXT);
    }

    private void calculateAverage(final BigDecimal[] result, final Set<CurriculumModule> modules,
            final ExecutionYear executionYear) {
        for (final CurriculumModule module : modules) {
            if (module instanceof CurriculumGroup) {
                final CurriculumGroup courseGroup = (CurriculumGroup) module;
                calculateAverage(result, courseGroup.getCurriculumModulesSet(), executionYear);
            } else if (module instanceof Enrolment) {
                final Enrolment enrolment = (Enrolment) module;
                if (enrolment.isApproved()) {
                    if (enrolment.getExecutionYear() == executionYear) {
                        final Grade grade = enrolment.getGrade();
                        if (grade.isNumeric()) {
                            final BigDecimal ectsCredits = new BigDecimal(enrolment.getEctsCredits());
                            final BigDecimal value = grade.getNumericValue().multiply(ectsCredits);
                            result[0] = result[0].add(value);
                            result[1] = result[1].add(ectsCredits);
                        }
                    }
                }
            } else if (module instanceof Dismissal) {
                final Dismissal dismissal = (Dismissal) module;
                if (dismissal.getExecutionYear() == executionYear && dismissal.getCurricularCourse() != null
                        && !dismissal.getCurricularCourse().isOptionalCurricularCourse()) {
    
                    final Credits credits = dismissal.getCredits();
                    if (credits instanceof Substitution) {
                        final Substitution substitution = (Substitution) credits;
                        for (final EnrolmentWrapper enrolmentWrapper : substitution.getEnrolmentsSet()) {
                            final IEnrolment iEnrolment = enrolmentWrapper.getIEnrolment();
    
                            final Grade grade = iEnrolment.getGrade();
                            if (grade.isNumeric()) {
                                final BigDecimal ectsCredits = new BigDecimal(iEnrolment.getEctsCredits());
                                final BigDecimal value = grade.getNumericValue().multiply(ectsCredits);
                                result[0] = result[0].add(value);
                                result[1] = result[1].add(ectsCredits);
                            }
                        }
                    } else {
                        final Grade grade = dismissal.getGrade();
                        if (grade.isNumeric()) {
                            final BigDecimal ectsCredits = new BigDecimal(dismissal.getEctsCredits());
                            final BigDecimal value = grade.getNumericValue().multiply(ectsCredits);
                            result[0] = result[0].add(value);
                            result[1] = result[1].add(ectsCredits);
                        }
                    }
                }
            }
        }
    }

}
