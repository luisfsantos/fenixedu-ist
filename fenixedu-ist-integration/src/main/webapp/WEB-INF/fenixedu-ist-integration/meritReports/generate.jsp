<%--

    Copyright Â© 2017 Instituto Superior TÃ©cnico

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
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="page-header">
  <h1>
      <spring:message code="student.merit.report.title"/>
  </h1>
</div>

<spring:url var="formUrl" value="/student-merit-reports" />
<form role="form" action="${formUrl}/generate" method="POST">
    <div class="form-group">
      <label for="executionYear">Select execution year:</label>
      <select class="form-control" id="executionYear">
        <c:forEach var="executionYear" items="${executionYears}">
            <option value="${executionYear.externalId}"><c:out value="${executionYear.year.}"/></option>
      </select>
    </div>
    <button type="submit" class="btn btn-default">Submit</button>
</form>