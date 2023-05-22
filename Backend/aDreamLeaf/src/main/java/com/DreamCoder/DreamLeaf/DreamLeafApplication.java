package com.DreamCoder.DreamLeaf;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableScheduling
@SpringBootApplication
public class DreamLeafApplication {

	public static void main(String[] args) {
		SpringApplication.run(DreamLeafApplication.class, args);
	}

}
