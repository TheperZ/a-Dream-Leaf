package com.DreamCoder.DreamLeaf.repository;

import com.DreamCoder.DreamLeaf.dto.ReviewCreateDto;
import com.DreamCoder.DreamLeaf.dto.ReviewDto;
import com.DreamCoder.DreamLeaf.dto.ReviewSearchDto;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.support.DataAccessUtils;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class ReviewRepositoryImpl implements ReviewRepository{

    private final JdbcTemplate jdbcTemplate;
    
//    반환 내용 중 UserName, StoreName를 구하기 위해서는 필요함
//    private final UserRepository userRepository;
//    private final StoreRepository storeRepository;

    private final RowMapper<ReviewDto> reviewRowMapper = new RowMapper<ReviewDto>() {
        @Override
        public ReviewDto mapRow(ResultSet rs, int rowNum) throws SQLException {
            return new ReviewDto(
                    rs.getInt("userId"),
                    rs.getInt("reviewId"),
                    rs.getInt("storeId"),
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
        ReviewDto reviewDto = jdbcTemplate.queryForObject("SELECT * FROM REVIEW WHERE body = '"+reviewCreateDto.getBody()+
                "' AND created_date = '"+reviewCreateDto.getDate()+
                "' AND storeId = "+reviewCreateDto.getStoreId()+
                " AND userId = "+reviewCreateDto.getUserId(), reviewRowMapper);

//        reviewDto.setNameData(userRepository.findById(reviewDto.getUserId()).getUserName(), storeRepository.findById(reviewDto.getStoreId()).getStoreName());

        return reviewDto;
    }

    @Override
    public Integer CountReview(int storeId) {
        Integer count =  jdbcTemplate.queryForObject("SELECT count(*) FROM REVIEW WHERE storeId="+storeId, Integer.class);
        return count;
    }

    @Override
    public List<ReviewDto> findReviewPage(ReviewSearchDto reviewSearchDto) {
        List<ReviewDto> reviewDtoList = jdbcTemplate.query("SELECT * FROM REVIEW WHERE storeId="+reviewSearchDto.getStoreId()
                        + " ORDER BY created_date DESC LIMIT " + reviewSearchDto.getDisplay()
                        + " OFFSET " + reviewSearchDto.getReviewPagination().getLimitStart()
                , reviewRowMapper);
        return reviewDtoList;
    }
}
