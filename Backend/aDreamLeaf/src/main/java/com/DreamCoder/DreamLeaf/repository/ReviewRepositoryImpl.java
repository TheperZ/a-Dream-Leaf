package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.ReviewCreateDto;
import com.DreamCoder.DreamLeaf.dto.ReviewDto;
import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;

@Repository
@RequiredArgsConstructor
public class ReviewRepositoryImpl implements ReviewRepository{

    private final JdbcTemplate jdbcTemplate;

    private final RowMapper<ReviewDto> reviewRowMapper = new RowMapper<ReviewDto>() {
        @Override
        public ReviewDto mapRow(ResultSet rs, int rowNum) throws SQLException {
            return new ReviewDto(rs.getInt("reviewId"),
                    rs.getInt("storeId"),
                    rs.getInt("userId"),
                    rs.getString("created_date"),
                    rs.getString("body"),
                    rs.getInt("rating"));
        }
    };

    @Override
    public ReviewDto save(ReviewCreateDto reviewCreateDto) {
        jdbcTemplate.execute("INSERT INTO REVIEW(storeId,created_date,body,rating, userId) VALUES(" +
                reviewCreateDto.getStoreId()+
                ",'" + reviewCreateDto.getDate()+
                "','" + reviewCreateDto.getBody()+
                "'," + reviewCreateDto.getRating()+
                "," + reviewCreateDto.getUserId()+
                ")");
        return jdbcTemplate.queryForObject("SELECT * FROM REVIEW WHERE body = '"+reviewCreateDto.getBody()+
                "' AND created_date = '"+reviewCreateDto.getDate()+
                "' AND storeId = "+reviewCreateDto.getStoreId()+
                " AND userId = "+reviewCreateDto.getUserId(), reviewRowMapper);
    }
}
