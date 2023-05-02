package com.DreamCoder.DreamLeaf.Util;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
public class AuthUtil {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public int findUserId(String token) throws FirebaseAuthException {
        FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(token);
        String uid = decodedToken.getUid();
        int id = -1;
        try{
            id = jdbcTemplate.queryForObject("SELECT userId FROM USER WHERE uid = '"+uid+"'",Integer.class);
        } catch(EmptyResultDataAccessException error){
            id = -1;
        }
        return id;
    }
}
