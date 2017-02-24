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

import java.util.List;
import java.util.stream.Collectors;

import org.fenixedu.academic.domain.ExecutionYear;
import org.fenixedu.academic.domain.degree.DegreeType;
import org.fenixedu.bennu.core.domain.Bennu;
import org.springframework.stereotype.Service;

/**
 * Created by Luis Santos on 24-02-2017.
 */

@Service
public class StudentMeritReportService {

    public List<ExecutionYear> getExecutionYears() {
        return Bennu.getInstance().getExecutionYearsSet().stream().sorted(ExecutionYear.COMPARATOR_BY_YEAR.reversed())
                .collect(Collectors.toList());
    }

    public List<DegreeType> getRelevantDegreeTypes() {
        return DegreeType.all().filter(dt -> dt.isBolonhaDegree() || dt.isBolonhaMasterDegree() || dt.isIntegratedMasterDegree())
                .collect(Collectors.toList());
    }
    /*
    private void process(final DegreeType degreeType, final ExecutionYear executionYearForReport) {
        final Spreadsheet spreadsheet = createHeader();
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
    */
    /*
    private Spreadsheet createHeader() {
        Spreadsheet spreadsheet = new Spreadsheet("MeritStudents");
    
        spreadsheet.setHeader("Degree");
        spreadsheet.setHeader("Number");
        spreadsheet.setHeader("Name");
        spreadsheet.setHeader("Credits Enroled in " + EXECUTION_YEAR_STRING);
        spreadsheet.setHeader("Credits Approved Durring Year " + EXECUTION_YEAR_STRING);
        spreadsheet.setHeader("Curricular Year During " + EXECUTION_YEAR_STRING);
        spreadsheet.setHeader("Average in " + EXECUTION_YEAR_STRING);
    
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
    */
}
