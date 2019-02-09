package com.ahn.persistence;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

@Repository
public class PointDAOImpl implements PointDAO {

	@Inject
	private SqlSession session;
	
	private static String namespace = "com.ahn.mapper.PointMapper";
	
	private Logger logger = LoggerFactory.getLogger(PointDAOImpl.class);
	
	@Override
	public void updatePoint(String uid, int point) throws Exception {
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("uid", uid);
		paramMap.put("point", point);
		
		logger.info("uid : " + uid + "point : " + point);
		
		session.update(namespace + ".updatePoint", paramMap);
	}

}
