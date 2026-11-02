package pe.edu.upeu.bomerp.catalogo.categoria.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.io.Serializable;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CategoriaResponse implements Serializable {
    private Long id;
    private String nombre;
    private String descripcion;
}
