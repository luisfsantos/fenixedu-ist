<%--

    Copyright © ${project.inceptionYear} Instituto Superior Técnico

    This file is part of Fenix IST.

    Fenix IST is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Fenix IST is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with Fenix IST.  If not, see <http://www.gnu.org/licenses/>.

--%>
<%@ page language="java" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<html:xhtml/>

<h1><bean:message key="link.Publications" bundle="RESEARCHER_RESOURCES"/></h1>

<bean:define id="sotisURL">
    <%= pt.ist.fenixedu.cmscomponents.FenixEduIstCmsComponentsConfiguration.getConfiguration().sotisURL() %>
</bean:define>

<bean:define id="lang">
    <%= org.fenixedu.commons.i18n.I18N.getLocale().toLanguageTag() %>
</bean:define>

<bean:define id="researchers" name="researchers" />

<script src="<%= sotisURL %>/js/sotis-embedded.js" data-sotis-use="publications" data-sotis-users="<%= researchers %>" data-sotis-links="yes" data-sotis-lang="<%= lang %>"></script>