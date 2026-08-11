package pe.edu.upeu.bomerp.catalogo.producto.dto;

import java.math.BigDecimal;

public record ProductoResponse(Long id, String nombre, BigDecimal precio, Integer stock) {
}