package pe.edu.upeu.bomerp.catalogo.categoria.service;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.bean.override.mockito.MockitoSpyBean;
import pe.edu.upeu.bomerp.catalogo.categoria.repository.CategoriaRepository;

import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;

@SpringBootTest
@ActiveProfiles("dev")
class CategoriaCacheVerificationTest {

    @Autowired
    private CategoriaService categoriaService;

    @MockitoSpyBean
    private CategoriaRepository categoriaRepository;

    @Test
    void listar_segundaLlamada_noRepiteLaConsultaRealPorqueSirveDesdeRedis() throws InterruptedException {
        categoriaService.listar();
        Thread.sleep(300); // Lettuce escribe en Redis de forma asíncrona; una llamada inmediata vería un falso miss.
        categoriaService.listar();

        verify(categoriaRepository, times(1)).findAll();
    }
}
