package pe.edu.upeu.bomerp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@EnableCaching
@SpringBootApplication
public class BomerpBackendApplication {

	public static void main(String[] args) {
		SpringApplication.run(BomerpBackendApplication.class, args);
	}

}
