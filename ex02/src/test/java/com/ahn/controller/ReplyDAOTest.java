package com.ahn.controller;

import javax.inject.Inject;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.ahn.domain.ReplyVO;
import com.ahn.persistence.ReplyDAO;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations= {"file:src/main/webapp/WEB-INF/spring/**/root-context.xml"})
public class ReplyDAOTest {
	
	@Inject
	private ReplyDAO dao;
	
	private Logger logger= LoggerFactory.getLogger(ReplyDAOTest.class);

	
	@Test
	public void testCreate()throws Exception{
		ReplyVO vo = new ReplyVO();
		vo.setReplyer("김개똥");
		vo.setReplytext("에잇 더러워!");
		vo.setBno(15);
		dao.create(vo);
		
	}
	
	@Test
	public void testRead()throws Exception{
		logger.info(dao.list(12).toString());
	}
	
	@Test
	public void testUpdate() throws Exception{
		ReplyVO vo = new ReplyVO();
		vo.setRno(1);
		vo.setReplyer("홍길동");
		vo.setReplytext("수정된 댓글입니다.");
		dao.update(vo);
	}
	
	@Test
	public void testDelete() throws Exception{
		dao.delete(1);
	}
	
	
}
