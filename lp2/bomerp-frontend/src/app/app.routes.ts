import { Routes } from '@angular/router';
import { authGuard } from './core/guards/auth-guard';
import { rolGuard } from './core/guards/rol-guard';

export const routes: Routes = [
  {
    path: 'auth/callback',
    loadComponent: () => import('./core/auth/auth-callback').then((m) => m.AuthCallback),
  },
  {
    path: '',
    loadComponent: () => import('./core/layout/layout').then((m) => m.Layout),
    children: [
      {
        path: '',
        loadComponent: () => import('./core/inicio/inicio').then((m) => m.Inicio),
      },
      {
        path: 'catalogo/categorias',
        canActivate: [authGuard],
        loadComponent: () =>
          import('./features/catalogo/categoria/categoria-list').then((m) => m.CategoriaList),
      },
      {
        path: 'catalogo/categorias/nueva',
        canActivate: [authGuard, rolGuard('ADMIN')],
        loadComponent: () =>
          import('./features/catalogo/categoria/categoria-form').then((m) => m.CategoriaForm),
      },
      {
        path: 'catalogo/categorias/:id/editar',
        canActivate: [authGuard, rolGuard('ADMIN')],
        loadComponent: () =>
          import('./features/catalogo/categoria/categoria-form').then((m) => m.CategoriaForm),
      },
      {
        path: 'catalogo/productos',
        canActivate: [authGuard],
        loadComponent: () =>
          import('./features/catalogo/producto/producto-list').then((m) => m.ProductoList),
      },
      {
        path: 'catalogo/productos/nuevo',
        canActivate: [authGuard, rolGuard('ADMIN')],
        loadComponent: () =>
          import('./features/catalogo/producto/producto-form').then((m) => m.ProductoForm),
      },
      {
        path: 'catalogo/productos/:id/editar',
        canActivate: [authGuard, rolGuard('ADMIN')],
        loadComponent: () =>
          import('./features/catalogo/producto/producto-form').then((m) => m.ProductoForm),
      },
      {
        path: 'ventas/nueva',
        canActivate: [authGuard, rolGuard('VENDEDOR', 'SUPERVISOR')],
        loadComponent: () =>
          import('./features/ventas/venta/venta-form').then((m) => m.VentaForm),
      },
      {
        path: 'ventas/reporte',
        canActivate: [authGuard],
        loadComponent: () =>
          import('./features/ventas/venta/venta-reporte').then((m) => m.VentaReporteComponent),
      },
      {
        path: 'sin-permiso',
        loadComponent: () => import('./core/sin-permiso/sin-permiso').then((m) => m.SinPermiso),
      },
    ],
  },
];