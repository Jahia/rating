<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<%--@elvariable id="acl" type="java.lang.String"--%>
<jcr:nodeProperty node="${currentNode}" name="j:nbOfVotes" var="nbVotes"/>
<jcr:nodeProperty node="${currentNode}" name="j:sumOfVotes" var="sumVotes"/>
<c:set var="positiveVote" value="0"/>
<c:set var="negativeVote" value="0"/>
<c:if test="${nbVotes.long > 0}">
    <c:if test="${sumVotes.long > 0}">
        <c:set var="positiveVote" value="${((sumVotes.long)+(nbVotes.long - sumVotes.long)/2)}"/>
        <c:set var="negativeVote" value="${(nbVotes.long - sumVotes.long)/2}"/>
    </c:if>
    <c:if test="${sumVotes.long == 0}">
        <c:set var="positiveVote" value="${nbVotes.long/2}"/>
        <c:set var="negativeVote" value="${nbVotes.long/2}"/>
    </c:if>
    <c:if test="${sumVotes.long < 0}">
        <c:set var="positiveVote" value="${(nbVotes.long + sumVotes.long)/2}"/>
        <c:set var="negativeVote" value="${((-sumVotes.long)+(nbVotes.long + sumVotes.long)/2)}"/>
    </c:if>
</c:if>
<c:set var="cookieName" value="rated${currentNode.identifier}"/>
<c:choose>

    <c:when test="${renderContext.loggedIn and (empty cookie[cookieName]) and renderContext.readOnlyStatus == 'OFF'}">
    <div class="voteblock">
        <a class="positiveVote" title="Vote +1" href="#" id="positiveVote_${currentNode.identifier}"><span><fmt:formatNumber
                value="${positiveVote}" pattern="##"/><span class="voteText"> (<fmt:formatNumber
                value="${positiveVote}" pattern="##"/> Good)</span></span></a>
        <a class="negativeVote" title="Vote -1" href="#" id="negativeVote_${currentNode.identifier}"><span><fmt:formatNumber
                value="${negativeVote}" pattern="##"/><span class="voteText"> (<fmt:formatNumber
                value="${negativeVote}" pattern="##"/>  Bad)</span></span></a>
    </div>

        <script src="<c:url value='/modules/rating/javascript/apps/rating.bundle.js'/>"></script>
        <script type="text/javascript">
            RatingLibrary.initPlusOne('${currentNode.identifier}');
        </script>
    </c:when>
    <c:when test="${renderContext.loggedIn and (not empty cookie[cookieName]) and renderContext.readOnlyStatus == 'OFF'}">
    <div class="voteblock">
        <div class="positiveVote" title="You have already vote"><span><fmt:formatNumber value="${positiveVote}" pattern="##"/><span class="voteText"> (<fmt:formatNumber value="${positiveVote}" pattern="##"/> Good)</span></span></div>
        <div class="negativeVote" title="You have already vote"><span><fmt:formatNumber value="${negativeVote}" pattern="##"/><span class="voteText"> (<fmt:formatNumber value="${negativeVote}" pattern="##"/>  Bad)</span></span></div>
     </div>
    </c:when>
    <c:otherwise>
     <div class="voteblock">
        <div class="positiveVote" title="Thank you to log in to vote"><span><fmt:formatNumber value="${positiveVote}" pattern="##"/><span class="voteText"> (<fmt:formatNumber value="${positiveVote}" pattern="##"/> Good)</span></span></div>
        <div class="negativeVote" title="Thank you to log in to vote"><span><fmt:formatNumber value="${negativeVote}" pattern="##"/><span class="voteText"> (<fmt:formatNumber value="${negativeVote}" pattern="##"/>  Bad)</span></span></div>
     </div>
    </c:otherwise>

</c:choose>
