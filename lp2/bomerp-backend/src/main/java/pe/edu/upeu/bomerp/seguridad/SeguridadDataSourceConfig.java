package pe.edu.upeu.bomerp.seguridad;

import org.springframework.boot.jdbc.autoconfigure.DataSourceProperties;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.transaction.PlatformTransactionManager;

import javax.sql.DataSource;
import java.util.Map;

@Configuration
@EnableJpaRepositories(
        basePackages = "pe.edu.upeu.bomerp.seguridad",
        entityManagerFactoryRef = "seguridadEntityManagerFactory",
        transactionManagerRef = "seguridadTransactionManager")
public class SeguridadDataSourceConfig {

    @Bean
    @ConfigurationProperties("bomerp.datasource.seguridad")
    public DataSourceProperties seguridadDataSourceProperties() {
        return new DataSourceProperties();
    }

    @Bean
    public DataSource seguridadDataSource(DataSourceProperties seguridadDataSourceProperties) {
        return seguridadDataSourceProperties.initializeDataSourceBuilder().build();
    }

    @Bean
    public LocalContainerEntityManagerFactoryBean seguridadEntityManagerFactory(DataSource seguridadDataSource) {
        LocalContainerEntityManagerFactoryBean factory = new LocalContainerEntityManagerFactoryBean();
        factory.setDataSource(seguridadDataSource);
        factory.setPackagesToScan("pe.edu.upeu.bomerp.seguridad");
        factory.setJpaVendorAdapter(new HibernateJpaVendorAdapter());
        factory.setJpaPropertyMap(Map.of("hibernate.hbm2ddl.auto", "validate"));
        return factory;
    }

    @Bean
    public PlatformTransactionManager seguridadTransactionManager(
            LocalContainerEntityManagerFactoryBean seguridadEntityManagerFactory) {
        return new JpaTransactionManager(seguridadEntityManagerFactory.getObject());
    }
}
