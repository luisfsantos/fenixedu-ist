package pt.ist.fenixedu.integration.domain.reports;

import org.fenixedu.academic.domain.ExecutionYear;
import org.fenixedu.academic.domain.degree.DegreeType;
import org.fenixedu.bennu.core.i18n.BundleUtil;
import org.fenixedu.commons.spreadsheet.Spreadsheet;

public class StudentMeritReportFile extends StudentMeritReportFile_Base {

    public StudentMeritReportFile() {
        super();
    }

    @Override
    public String getJobName() {
        return BundleUtil.getString("resources.FenixeduIntegrationResources", "title.student.merit.report");
    }

    @Override
    protected String getPrefix() {
        return BundleUtil.getString("resources.FenixeduIntegrationResources", "label.student.merit.report.prefix");
    }

    @Override
    public void renderReport(Spreadsheet spreadsheet) throws Exception {

    }

    private void listStudents(Spreadsheet spreadsheet, ExecutionYear executionYear, DegreeType degreeType) {
        generateHeaders(spreadsheet, executionYear);
    }

    private void generateHeaders(Spreadsheet spreadsheet, ExecutionYear executionYear) {

    }

    private void renderRow() {

    }

}
