package pe.edu.upeu.bomerp.ventas.venta.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import java.math.BigDecimal;

@Getter
@AllArgsConstructor
public class VentaAgregado {
    private final long totalVentas;
    private final BigDecimal montoTotal;
    private final BigDecimal ticketPromedio;
}