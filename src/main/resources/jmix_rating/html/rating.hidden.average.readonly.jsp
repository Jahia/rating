<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<jcr:nodeProperty node="${currentNode}" name="j:nbOfVotes" var="nbVotes"/>
<jcr:nodeProperty node="${currentNode}" name="j:sumOfVotes" var="sumVotes"/>
<c:set var="id" value="${currentNode.identifier}"/>
<c:if test="${nbVotes.long > 0}">
    <c:set var="avg" value="${sumVotes.long / nbVotes.long}"/>
</c:if>
<c:if test="${nbVotes.long == 0}">
    <c:set var="avg" value="0.0"/>
</c:if>
<div style="display:none;">${fn:substring(avg,0,3)}</div>
<form class="avg${id}">
    <input type="radio" name="rate_avg" value="1" title="Poor"
           disabled="disabled"
           <c:if test="${avg >= 1.0}">checked="checked"</c:if> />
    <input type="radio" name="rate_avg" value="2" title="Fair"
           disabled="disabled"
           <c:if test="${avg >= 2.0}">checked="checked"</c:if> />
    <input type="radio" name="rate_avg" value="3" title="Average"
           disabled="disabled"
           <c:if test="${avg >= 3.0}">checked="checked"</c:if> />
    <input type="radio" name="rate_avg" value="4" title="Good"
           disabled="disabled"
           <c:if test="${avg >= 4.0}">checked="checked"</c:if> />
    <input type="radio" name="rate_avg" value="5" title="Excellent"
           disabled="disabled"
           <c:if test="${avg >= 5.0}">checked="checked"</c:if> />
</form>

<script src="<c:url value='/modules/rating/javascript/apps/rating.bundle.js'/>"></script>
<script type="text/javascript">
    RatingLibrary.init('${id}');
</script>
