package com.DreamCoder.DreamLeaf.config;


import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;

@Configuration
public class JdbcConfig {

    @Value("${spring.datasource.username}")
    private String username;
    @Value("${spring.datasource.url}")
    private String url;
    @Value("${spring.datasource.password}")
    private String pw;
    @Value("${spring.datasource.driver-class-name}")
    private String cname;

    @Bean
    public DataSource dataSource(){
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setUsername(username);
        dataSource.setPassword(pw);
        dataSource.setDriverClassName(cname);
        dataSource.setUrl(url);
        return dataSource;
    }

    @Bean
    public JdbcTemplate jdbcTemplate(){
        return new JdbcTemplate(dataSource());
    }
}
