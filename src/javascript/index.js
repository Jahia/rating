import $ from 'jquery';
import 'jquery-ui';
import {stars} from './lib/ui.stars';

stars($);

export function init(currentNodeId) {
    $(document).ready(function() {
        // Create stars for: Average rating
        $(`.avg${currentNodeId}`).stars();
    });
}
export function initRating(url, currentNodeId) {
    $(document).ready(function() {
        $(`#avg${currentNodeId}`).children().not(":input").hide();
        $(`#rat${currentNodeId}`).children().not("select").hide();

        // Create stars for: Average rating
        $(`#avg${currentNodeId}`).stars();

        // Create stars for: Rate this
        $(`#rat${currentNodeId}`).stars({
            inputType: "select",
            cancelShow: false,
            captionEl: $(`#caption${currentNodeId}`),
            callback: function(ui, type, value) {
                // Disable Stars while AJAX connection is active
                ui.disable();

                // Display message to the user at the begining of request
                $(`#messages${currentNodeId}`).text("Saving...").stop().css("opacity", 1).fadeIn(30);

                // Send request to the server using POST method
                $.post(url,
                    {'j:lastVote': value,'jcrMethodToCall':"post",'jcrCookieName':`rated${currentNodeId}`,'jcrCookieValue':`${currentNodeId}`},
                    function(result) {
                        // Select stars from "Average rating" control to match the returned average rating value
                        $(`#avg${currentNodeId}`).stars("select",
                            Math.round(result.j_sumOfVotes / result.j_nbOfVotes));
                        // Update other text controls...
                        $(`#all_votes${currentNodeId}`).text(result.j_nbOfVotes);
                        $(`#all_avg${currentNodeId}`).text(('' + result.j_sumOfVotes / result.j_nbOfVotes).substring(0,
                            3));
                        // Display confirmation message to the user
                        $(`#messages${currentNodeId}`).html("<br/>Rating saved (" + value +
                            "). Thanks!").stop().css("opacity", 1).fadeIn(30);
                        // Hide confirmation message and enable stars for "Rate this" control, after 2 sec...
                        setTimeout(function() {
                            $(`#messages${currentNodeId}`).fadeOut(1000, function() {
                                ui.enable();
                            });
                        }, 2000);
                    }, "json");
            }
        });

        // Since the <option value="3"> was selected by default, we must remove selection from Stars.
        $(`#rat${currentNodeId}`).stars("selectID", -1);

        // Create element to use for confirmation messages
        $(`<div id="messages${currentNodeId}"/>`).appendTo(`#rat${currentNodeId}`);
    });
}
export function initRateable(params) {
    $(document).ready(function() {
        jQuery.ajaxSettings.traditional = true;

        $(`#avg${params.id}`).children().not(":input").hide();
        $(`#rat${params.id}`).children().not("select").hide();

        $(`#avg${params.id}`).stars();

        $(`#rat${params.id}`).stars({
            inputType: "select",
            cancelShow: false,
            captionEl: $(`#caption${params.id}`),
            callback: function(ui, type, value) {
                ui.disable();

                $(`#messages${params.id}`).text(params.i18nSaving).stop().css("opacity", 1).fadeIn(30);

                $.post(params.url, {'j:lastVote': value,'jcrMethodToCall':"post",
                    'jcrCookieName':`rated${params.id}`,
                    'jcrCookieValue':`${params.id}`}, function(
                    result) {
                    $(`#avg${params.id}`).stars("select", Math.round(result.j_sumOfVotes / result.j_nbOfVotes));
                    $(`#all_votes${params.id}`).text(result.j_nbOfVotes);
                    $(`#all_avg${params.id}`).text(('' + result.j_sumOfVotes / result.j_nbOfVotes).substring(0, 3));
                    $(`#messages${params.id}`).html(`<br/>${params.ratingSaved} (${value}). ${params.thanks}!`).stop().css("opacity", 1).fadeIn(30);
                    var exdate=new Date();
                    exdate.setDate(exdate.getDate() + 365);
                    document.cookie = `rated${params.id}=${params.id}; expires="${exdate.toUTCString()}"; path=/;`;
                    setTimeout(function() {
                        $(`#messages${params.id}`).fadeOut(1000, function() {
//                                ui.enable();
                        });
                    }, 2000);
                }, "json");
            }
        });

        $(`#rat${params.id}`).stars("selectID", -1);

        $(`<div id="messages${params.id}"/>`).appendTo(`#rat${params.id}`);
    });
}

export function initPlusOne(currentNodeId) {
    $(document).ready(function() {
        document.getElementById(`positiveVote_${currentNodeId}`).addEventListener("click", function(e) {
            document.getElementById("jahia-forum-post-vote-" + e.currentTarget.id.replace("positiveVote_", "")).submit();
        });
        document.getElementById(`negativeVote_${currentNodeId}`).addEventListener("click", function(e) {
            var voteForm = document.getElementById("jahia-forum-post-vote-" + e.currentTarget.id.replace("negativeVote_", ""));
            voteForm.elements['j:lastVote'].value='-1';
            voteForm.submit();
        })
    });
}

