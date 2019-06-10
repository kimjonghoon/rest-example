package net.java_school.controller;

import java.util.List;

import net.java_school.board.Comment;
import net.java_school.board.CommentService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/comments")
public class CommentController {

	@Autowired
	private CommentService service;
	
	@RequestMapping(method=RequestMethod.POST)
	public void addComment(Comment comment) {
		service.addComment(comment);
	}
	
	@RequestMapping(method=RequestMethod.GET)
	public List<Comment> getComments() {
		return service.getComments();
	}
	
	@RequestMapping(value="/{no}",method=RequestMethod.DELETE)
	public void removeComment(@PathVariable Integer no) {
		service.removeComment(no);
	}
	
	@RequestMapping(value="/{no}",method=RequestMethod.PUT)
	public void modifyComment(String content, @PathVariable Integer no) {
		Comment comment = this.getComment(no);
		comment.setContent(content);
		service.modifyComment(comment);
	}
	
	@RequestMapping(value="/{no}", method=RequestMethod.GET)
	public Comment getComment(@PathVariable Integer no) {
		return service.getComment(no);
	}
	
}