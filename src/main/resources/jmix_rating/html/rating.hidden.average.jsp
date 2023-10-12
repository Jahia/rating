<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<c:set var="cookieName" value="rated${currentNode.identifier}"/>
<c:choose>
    <c:when test="${renderContext.loggedIn and (empty cookie[cookieName]) and renderContext.readOnlyStatus == 'OFF'}">
        <jcr:nodeProperty node="${currentNode}" name="j:nbOfVotes" var="nbVotes"/>
        <jcr:nodeProperty node="${currentNode}" name="j:sumOfVotes" var="sumVotes"/>
        <c:set var="id" value="${currentNode.identifier}"/>
        <c:if test="${nbVotes.long > 0}">
            <c:set var="avg" value="${sumVotes.long / nbVotes.long}"/>
        </c:if>
        <c:if test="${nbVotes.long == 0}">
            <c:set var="avg" value="0.0"/>
        </c:if>
        <template:addResources type="css" resources="uni-form.css,ui.stars.css"/>
        <template:addResources type="javascript" resources="apps/rating.bundle.js"/>
        <script type="text/javascript">
            RatingLibrary.initRating('<c:url value='${url.base}${currentNode.path}'/>.rate.do','${currentNode.identifier}', '${currentNode.path}');
        </script>

        <div class="ratings">

            <div class="rating-L"><strong><fmt:message key="label.AverageRating"/></strong>
        <span>(<span id="all_votes${id}">${nbVotes.long}</span> votes; <span
                id="all_avg${id}">${fn:substring(avg,0,3)}</span>)</span>

                <form id="avg${id}" style="width: 200px">


                    <input type="radio" name="rate_avg" value="1" title="Poor"
                           disabled="disabled"
                           <c:if test="${avg > 1.0}">checked="checked"</c:if> />
                    <input type="radio" name="rate_avg" value="2" title="Fair"
                           disabled="disabled"
                           <c:if test="${avg > 2.0}">checked="checked"</c:if> />
                    <input type="radio" name="rate_avg" value="3" title="Average"
                           disabled="disabled"
                           <c:if test="${avg > 3.0}">checked="checked"</c:if> />
                    <input type="radio" name="rate_avg" value="4" title="Good"
                           disabled="disabled"
                           <c:if test="${avg > 4.0}">checked="checked"</c:if> />
                    <input type="radio" name="rate_avg" value="5" title="Excellent"
                           disabled="disabled"
                           <c:if test="${avg > 5.0}">checked="checked"</c:if> />

                </form>
            </div>


            <div class="rating-R"><strong><fmt:message key="label.rateThis"/>:</strong> <span id="caption${id}"></span>

                <form id="rat${id}" action="<c:url value='${url.base}${currentNode.path}'/>" method="post">
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
        <%@include file="rating.hidden.average.readonly.jsp" %>
    </c:otherwise>
</c:choose>