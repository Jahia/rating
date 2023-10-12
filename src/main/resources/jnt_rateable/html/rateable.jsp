<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="uiComponents" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<%--@elvariable id="acl" type="java.lang.String"--%>
<c:set var="bindedComponent"
       value="${uiComponents:getBindedComponent(currentNode, renderContext, 'j:bindedComponent')}"/>

<c:if test="${not empty bindedComponent}">
    <c:set var="cookieName" value="rated${bindedComponent.identifier}"/>
<c:choose>
    <c:when test="${renderContext.liveMode and renderContext.loggedIn and (empty cookie[cookieName]) and renderContext.readOnlyStatus == 'OFF'}">
    <jcr:nodeProperty node="${bindedComponent}" name="j:nbOfVotes" var="nbVotes"/>
    <jcr:nodeProperty node="${bindedComponent}" name="j:sumOfVotes" var="sumVotes"/>
    <c:set var="id" value="${bindedComponent.identifier}"/>
    <c:if test="${nbVotes.long > 0}">
        <c:set var="avg" value="${sumVotes.long / nbVotes.long}"/>
    </c:if>
    <c:if test="${nbVotes.long == 0}">
        <c:set var="avg" value="0.0"/>
    </c:if>
    <template:addResources type="css" resources="uni-form.css,ui.stars.css"/>
    <template:addResources type="javascript" resources="apps/rating.bundle.js"/>
    <script type="text/javascript">
        <fmt:message key="label.saving" var="i18nSaving"/>
        <fmt:message key="label.ratingSaved" var="ratingSaved"/>
        <fmt:message key="label.thanks" var="thanks"/>
        var params = {
            i18nSaving: "${functions:escapeJavaScript(i18nSaving)}",
            url: "<c:url value='${url.base}${bindedComponent.path}'/>.rate.do",
            id: "${id}",
            ratingSaved: "${ratingSaved}",
            thanks: "${thanks}"
        }
        RatingLibrary.initRateable(params);
    </script>

    <div class="ratings">

        <div class="rating-L"><strong><fmt:message key="label.AverageRating"/></strong>
        <span>(<span id="all_votes${id}">${nbVotes.long}</span> <fmt:message key="label.votes"/>; <span
                id="all_avg${id}">${fn:substring(avg,0,3)}</span>)</span>

            <form id="avg${id}" style="width: 200px">
                <input type="radio" name="rate_avg" value="1" title="Poor"
                           disabled="disabled" ${avg >= 1.0 ? 'checked="checked"' : ''}/>
                <input type="radio" name="rate_avg" value="2" title="Fair"
                           disabled="disabled" ${avg >= 2.0 ? 'checked="checked"' : ''}/>
                <input type="radio" name="rate_avg" value="3" title="Average"
                           disabled="disabled" ${avg >= 3.0 ? 'checked="checked"' : ''}/>
                <input type="radio" name="rate_avg" value="4" title="Good"
                           disabled="disabled" ${avg >= 4.0 ? 'checked="checked"' : ''}/>
                <input type="radio" name="rate_avg" value="5" title="Excellent"
                           disabled="disabled" ${avg >= 5.0 ? 'checked="checked"' : ''}/>
            </form>
        </div>

		<div class="rating-R"><strong><fmt:message key="label.rateThis"/>:</strong> <span id="caption${id}"></span>
            <form id="rat${id}" action="<c:url value='${url.base}${bindedComponent.path}'/>" method="post">
                <select name="j:lastVote">
                    <option value="1"><fmt:message key="label.rateThis.poor"/></option>
                    <option value="2"><fmt:message key="label.rateThis.fair"/></option>
                    <option value="3"><fmt:message key="label.rateThis.average"/></option>
                    <option value="4"><fmt:message key="label.rateThis.good"/></option>
                    <option value="5"><fmt:message key="label.rateThis.excellent"/></option>
                </select>
                <input type="submit" value="<fmt:message key="label.rateThis.rateIt"/>"/>
            </form>
        </div>

    </div>
    </c:when>
    <c:otherwise>
        <jcr:nodeProperty node="${bindedComponent}" name="j:nbOfVotes" var="nbVotes"/>
        <jcr:nodeProperty node="${bindedComponent}" name="j:sumOfVotes" var="sumVotes"/>
        <c:set var="id" value="${bindedComponent.identifier}"/>
        <c:if test="${nbVotes.long > 0}">
            <c:set var="avg" value="${sumVotes.long / nbVotes.long}"/>
        </c:if>
        <c:if test="${nbVotes.long == 0}">
            <c:set var="avg" value="0.0"/>
        </c:if>
        <div class="ratings">

            <div class="rating-L"><strong><fmt:message key="label.AverageRating"/></strong>
        <span>(<span id="all_votes${id}">${nbVotes.long}</span> <fmt:message key="label.votes"/>; <span
                id="all_avg${id}">${fn:substring(avg,0,3)}</span>)</span>

                <form id="avg${id}" style="width: 200px">
                    <input type="radio" name="rate_avg" value="1" title="Poor"
                           disabled="disabled" ${avg >= 1.0 ? 'checked="checked"' : ''}/>
                    <input type="radio" name="rate_avg" value="2" title="Fair"
                           disabled="disabled" ${avg >= 2.0 ? 'checked="checked"' : ''}/>
                    <input type="radio" name="rate_avg" value="3" title="Average"
                           disabled="disabled" ${avg >= 3.0 ? 'checked="checked"' : ''}/>
                    <input type="radio" name="rate_avg" value="4" title="Good"
                           disabled="disabled" ${avg >= 4.0 ? 'checked="checked"' : ''}/>
                    <input type="radio" name="rate_avg" value="5" title="Excellent"
                           disabled="disabled" ${avg >= 5.0 ? 'checked="checked"' : ''}/>
                </form>
            </div>
        </div>

    </c:otherwise>
    </c:choose>
</c:if>

