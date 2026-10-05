import { Component, computed, inject, signal } from '@angular/core';
import { HttpErrorResponse } from '@angular/common/http';
import { Router, RouterLink } from '@angular/router';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { ProductoService } from '../../catalogo/producto/producto-service';
import { Producto } from '../../catalogo/producto/producto.model';
import { VentaService } from './venta-service';
import { toSignal } from '@angular/core/rxjs-interop';
import { CurrencyPipe } from '@angular/common';

@Component({
  selector: 'app-venta-form',
  imports: [ReactiveFormsModule, RouterLink, CurrencyPipe],
  templateUrl: './venta-form.html',
})
export class VentaForm {
  private readonly fb = inject(FormBuilder);
  private readonly productoService = inject(ProductoService);
  private readonly ventaService = inject(VentaService);
  private readonly router = inject(Router);

  protected readonly productos = signal<Producto[]>([]);
  protected readonly error = signal<string | null>(null);
  protected readonly loading = signal(false);

  protected readonly form = this.fb.nonNullable.group({
    detalles: this.fb.array([this.crearLinea()], [Validators.minLength(1)]),
  });

    protected readonly valoresDetalles = toSignal(
    this.form.controls.detalles.valueChanges,
    { initialValue: this.form.controls.detalles.getRawValue() },
  );

  protected readonly subtotales = computed(() =>
    this.valoresDetalles().map((linea) => {
      const producto = this.productos().find((p) => p.id === linea.productoId);
      return (producto?.precio ?? 0) * (linea.cantidad ?? 0);
    }),
  );

  protected readonly total = computed(() => this.subtotales().reduce((suma, s) => suma + s, 0));

  constructor() {
    this.productoService.listar().subscribe({
      next: (data) => this.productos.set(data),
      error: () => this.error.set('No se pudieron cargar los productos.'),
    });
  }

  protected get lineasForm() {
    return this.form.controls.detalles;
  }

  private crearLinea() {
    return this.fb.nonNullable.group({
      productoId: [0, [Validators.min(1)]],
      cantidad: [1, [Validators.required, Validators.min(1)]],
    });
  }

    protected agregarLinea(): void {
    this.lineasForm.push(this.crearLinea());
  }

  protected quitarLinea(indice: number): void {
    if (this.lineasForm.length > 1) {
      this.lineasForm.removeAt(indice);
    }
  }

}