package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.AddAlarmDto;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
@Slf4j
@AllArgsConstructor
public class AlarmRepositoryImpl implements AlarmRepository{

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void save(AddAlarmDto addAlarmDto) {
        String sql = "INSERT INTO alarm(fcmToken,userId) VALUES(%s,%s)";
        sql = String.format(sql,addAlarmDto.getFCMToken(),addAlarmDto.getUserId());
        if(isExist(addAlarmDto.getUserId())){
            sql = "UPDATE alarm SET fcmToken = ? WHERE userId = ?";
            jdbcTemplate.update(sql,addAlarmDto.getFCMToken(),addAlarmDto.getUserId());
        } else{
            jdbcTemplate.execute(sql);
        }
    }

    @Override
    public void delete(int id) {
        String sql = "DELETE FROM alarm WHERE userId = ?";
        jdbcTemplate.update(sql,id);
    }

    @Override
    public boolean isExist(int id) {
        String sql = "SELECT userId FROM alarm WHERE userId = ?";
        try{
            int temp = jdbcTemplate.queryForObject(sql,Integer.class,id);
            return true;
        } catch(Exception e){
            return false;
        }
    }

    @Override
    public String findById(int id){
        String sql = "SELECT fcmToken FROM alarm WHERE userId = ?";
        String result = jdbcTemplate.queryForObject(sql,String.class,id);
        return result;
    }
}
