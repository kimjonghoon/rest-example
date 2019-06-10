<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="sf" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"/>
<title>REST Example</title>
<style type="text/css">
#wrap {
	margin: 0 auto;
	padding: 0;
	width: 856px;
}
.comments span.writer {
	display: block;
	float: left;
	margin: 3px;
	padding: 0;
	font-size: 12px;
	font-weight: bold;
	color: #555;
}
.comments span.date {
	display: block;
	float: left;
	margin: 3px;
	padding: 0;
	font-size: 12px;
	color: #555;
}
.comments span.modify-del {
	display: block;
	float: right;
	margin: 3px;
	padding: 0;
	font-size: 12px;
	color: #555;
}
.comments a {
	color: #555;
	text-decoration: none;
	font-size: 11px;
}
.comments a:hover {
	color: #555;
	text-decoration: underline;
}
.comments p {
	clear: both;
	margin: 0;
	padding: 0 3px 3px 3px;
	color: #555;
	font-size: 12px;
}
.comment-form {
	clear: both; 
	padding: 0.22em 2.22em 0.22em 3.22em; 
}
.comment-textarea {
	border: 1px solid silver;
	padding: 3px;
	width: 99%;
	color:#555;
	background-color: #eee;
	font-size: 11px; 
}
#addComment {
    margin-bottom: 5px;
    padding: 0.22em;
    border: 1px solid #eee;
    background-color: #fafbf7;
}
#addComment textarea {
    width: 99%;
    padding: 3px;
    border: 0;
    color: #555;    
}
</style>
<script src="/resources/js/jquery-3.2.1.min.js"></script>
<script>
function displayComments() {
	var url = '/comments/';
	$.getJSON(url, function(data) {
		$('#all-comments').empty();
		$.each(data, function(i, item) {
			var creation = new Date(item.creation);
			var comments = '<div class="comments">'
								+ '<span class="writer">' + item.username + '</span>'
								+ '<span class="date">' + creation.toLocaleString() + '</span>';
			if (item.editable == true) {
				comments = comments   
								+ '<span class="modify-del">'
									+ '<a href="#" class="comment-modify-link">Modify</a> |' 
									+ '<a href="#" class="comment-delete-link" title="' + item.commentNo + '">Del</a>'
								+ '</span>';
			}					
				comments = comments  
								+ '<p class="comment-p">' + item.content + '</p>'
								+ '<form class="comment-form" action="/comments/' + item.commentNo + '" method="put" style="display: none;">'
									+ '<div style="text-align: right;">'
										+ '<a href="#" class="comment-modify-submit-link">Submit</a> | <a href="#" class="comment-modify-cancel-link">Cancel</a>'
									+ '</div>'
									+ '<div>'
										+ '<textarea class="comment-textarea" name="content" rows="7" cols="50">' + item.content + '</textarea>'
									+ '</div>'
								+ '</form>'
							+ '</div>';
			$('#all-comments').append(comments);
			console.log(item);
		});
	});
}

$(document).ready(function() {
	displayComments();
	//new comment
	$("#addCommentForm").submit(function(event) {
		event.preventDefault();
		var $form = $(this);
		var content = $('#addComment-ta').val();
		content = $.trim(content);
		if (content.length == 0) {
			$('#addComment-ta').val('');
			return false;
		}
		var dataToBeSent = $form.serialize();
		var url = $form.attr("action");
		var posting = $.post(url, dataToBeSent);
		posting.done(function() {
			displayComments();
			$('#addComment-ta').val('');
		});
	});
	
	$('article > iframe').attr('allowFullScreen', '');

});

$(document).on('click', '#all-comments', function(e) {
	if ($(e.target).is('.comment-modify-link')) {
		e.preventDefault();
		var $form = $(e.target).parent().parent().find('.comment-form');
		var $p = $(e.target).parent().parent().find('.comment-p');

		if ($form.is(':hidden') == true) {
			$form.show();
			$p.hide();
		} else {
			$form.hide();
			$p.show();
		}
	} else if ($(e.target).is('.comment-modify-cancel-link')) {
		e.preventDefault();
		var $form = $(e.target).parent().parent().parent().find('.comment-form');
		var $p = $(e.target).parent().parent().parent().find('.comment-p');

		if ($form.is(':hidden') == true) {
			$form.show();
			$p.hide();
		} else {
			$form.hide();
			$p.show();
		}
	} else if ($(e.target).is('.comment-modify-submit-link')) {
		e.preventDefault();
		var $form = $(e.target).parent().parent().parent().find('.comment-form');
		var $textarea = $(e.target).parent().parent().find('.comment-textarea');
		var content = $textarea.val();
		$('#modifyCommentForm input[name*=content]').val(content);
		var dataToBeSent = $('#modifyCommentForm').serialize();
		var url = $form.attr("action");
		$.ajax({
			url: url,
			type: 'POST',
			data: dataToBeSent,
			success: function() {
				displayComments();
			},
			error: function() {
				alert('error!');
			}
		});
	} else if ($(e.target).is('.comment-delete-link')) {
		e.preventDefault();
		var msg = 'Are you sure you want to delete this item?';
		var chk = confirm(msg);
		if (chk == false) {
			return;
		}
		var $commentNo = $(e.target).attr('title');
		var url = $('#deleteCommentForm').attr('action');
		url += $commentNo;
		var dataToBeSent = $('#deleteCommentForm').serialize();
		$.ajax({
			url: url,
			type: 'POST',
			data: dataToBeSent,
			success: function() {
				displayComments();
			},
			error: function() {
				alert('error!');
			}
		});
	}
});
</script>
</head>

<body>

<div id="wrap">

	<article>
		<iframe width="854" height="480" src="https://www.youtube.com/embed/Ph5NOf-di18"></iframe>
	</article>
	
	<sf:form id="addCommentForm" action="/comments" method="post">
		<div id="addComment">
			<textarea id="addComment-ta" name="content" rows="2" cols="50"></textarea>
		</div>
		<div style="text-align: right;">
			<input type="submit" value="Submit" />
		</div>
	</sf:form>
	
	<div id="all-comments">
	</div>

</div>

<div id="form-group" style="display: none">
	<sf:form id="deleteCommentForm" action="/comments/" method="delete">
		<input type="hidden" name="_method" value="DELETE" />
	</sf:form>
	<sf:form id="modifyCommentForm" method="put">
		<input type="hidden" name="_method" value="PUT" />
		<input type="hidden" name="content" />
	</sf:form>
</div>

</body>
</html>