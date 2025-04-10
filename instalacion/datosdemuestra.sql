-- Restaurante 1
INSERT INTO restaurantes (
    nombre, direccion, codigo_postal, ciudad, provincia, pais, 
    telefono, email, sitio_web, latitud, longitud, 
    horario_apertura, horario_cierre, descripcion, tipo_cocina, 
    capacidad_total, tiempo_entre_reservas
) VALUES (
    'La Taberna del Puerto', 'Calle del Mar 45', '08003', 'Barcelona', 'Barcelona', 'España',
    '932123456', 'info@latabernadelpuerto.com', 'https://www.latabernadelpuerto.com',
    41.378737, 2.178642, '12:00:00', '23:30:00', 
    'Restaurante especializado en pescados y mariscos frescos del Mediterráneo', 'Marisquería', 
    120, 30
);

-- Restaurante 2
INSERT INTO restaurantes (
    nombre, direccion, codigo_postal, ciudad, provincia, pais, 
    telefono, email, sitio_web, latitud, longitud, 
    horario_apertura, horario_cierre, descripcion, tipo_cocina, 
    capacidad_total, tiempo_entre_reservas
) VALUES (
    'Asador Don Carnal', 'Avenida de la Carne 12', '28013', 'Madrid', 'Madrid', 'España',
    '915555678', 'reservas@asadordoncarnal.com', 'https://www.asadordoncarnal.com',
    40.416775, -3.703790, '13:00:00', '00:00:00', 
    'Asador tradicional especializado en carnes a la parrilla y cocina castellana', 'Asador', 
    80, 45
);

-- Restaurante 3
INSERT INTO restaurantes (
    nombre, direccion, codigo_postal, ciudad, provincia, pais, 
    telefono, email, sitio_web, latitud, longitud, 
    horario_apertura, horario_cierre, descripcion, tipo_cocina, 
    capacidad_total, tiempo_entre_reservas
) VALUES (
    'La Huerta de Valencia', 'Plaza del Mercado 8', '46001', 'Valencia', 'Valencia', 'España',
    '963456789', 'contacto@lahuertadevalencia.com', 'https://www.lahuertadevalencia.com',
    39.469907, -0.376288, '11:00:00', '23:00:00', 
    'Cocina tradicional valenciana con productos frescos de la huerta', 'Mediterránea', 
    90, 30
);


-- Redes sociales para La Taberna del Puerto
INSERT INTO restaurante_redes_sociales (id_restaurante, tipo_red, url, usuario) VALUES
(1, 'Facebook', 'https://www.facebook.com/latabernadelpuerto', 'latabernadelpuerto'),
(1, 'Instagram', 'https://www.instagram.com/latabernadelpuerto', 'latabernadelpuerto'),
(1, 'Twitter', 'https://twitter.com/latabernapueblo', 'latabernapueblo');

-- Redes sociales para Asador Don Carnal
INSERT INTO restaurante_redes_sociales (id_restaurante, tipo_red, url, usuario) VALUES
(2, 'Facebook', 'https://www.facebook.com/asadordoncarnal', 'asadordoncarnal'),
(2, 'Instagram', 'https://www.instagram.com/asadordoncarnal', 'asadordoncarnal'),
(2, 'TikTok', 'https://www.tiktok.com/@asadordoncarnal', 'asadordoncarnal');

-- Redes sociales para La Huerta de Valencia
INSERT INTO restaurante_redes_sociales (id_restaurante, tipo_red, url, usuario) VALUES
(3, 'Facebook', 'https://www.facebook.com/lahuertadevalencia', 'lahuertadevalencia'),
(3, 'Instagram', 'https://www.instagram.com/lahuertadevalencia', 'lahuertadevalencia'),
(3, 'YouTube', 'https://www.youtube.com/lahuertadevalencia', 'La Huerta de Valencia');


-- Horarios especiales para La Taberna del Puerto
INSERT INTO horarios_especiales (id_restaurante, fecha, horario_apertura, horario_cierre, motivo, cerrado) VALUES
(1, '2023-12-25', NULL, NULL, 'Navidad', 1),
(1, '2023-12-31', '20:00:00', '01:00:00', 'Nochevieja', 0),
(1, '2024-01-06', '13:00:00', '17:00:00', 'Reyes Magos', 0);

-- Horarios especiales para Asador Don Carnal
INSERT INTO horarios_especiales (id_restaurante, fecha, horario_apertura, horario_cierre, motivo, cerrado) VALUES
(2, '2023-12-25', NULL, NULL, 'Navidad', 1),
(2, '2023-12-31', '21:00:00', '02:00:00', 'Cena de Nochevieja', 0),
(2, '2024-08-15', '13:00:00', '17:00:00', 'Festivo local', 0);

-- Horarios especiales para La Huerta de Valencia
INSERT INTO horarios_especiales (id_restaurante, fecha, horario_apertura, horario_cierre, motivo, cerrado) VALUES
(3, '2023-12-25', NULL, NULL, 'Navidad', 1),
(3, '2024-03-19', '12:00:00', '00:00:00', 'Fallas de Valencia', 0),
(3, '2024-04-19', '12:00:00', '18:00:00', 'Viernes Santo', 0);

-- Zonas para La Taberna del Puerto
INSERT INTO zonas (id_restaurante, nombre, descripcion, capacidad, climatizada, fumadores, accesible) VALUES
(1, 'Terraza', 'Terraza exterior con vistas al puerto', 40, 0, 1, 1),
(1, 'Comedor Principal', 'Comedor interior con decoración marinera', 60, 1, 0, 1),
(1, 'Salón Privado', 'Salón privado para eventos', 20, 1, 0, 1);

-- Zonas para Asador Don Carnal
INSERT INTO zonas (id_restaurante, nombre, descripcion, capacidad, climatizada, fumadores, accesible) VALUES
(2, 'Sala Principal', 'Amplio comedor con chimenea', 50, 1, 0, 1),
(2, 'Barra', 'Zona de barra para comidas informales', 15, 1, 1, 0),
(2, 'Terraza Cubierta', 'Terraza cubierta climatizada', 15, 1, 1, 1);

-- Zonas para La Huerta de Valencia
INSERT INTO zonas (id_restaurante, nombre, descripcion, capacidad, climatizada, fumadores, accesible) VALUES
(3, 'Jardín', 'Comedor en jardín interior', 40, 0, 0, 1),
(3, 'Comedor Principal', 'Comedor principal con decoración tradicional', 40, 1, 0, 1),
(3, 'Barra de Tapas', 'Zona de barra para tapeo', 10, 1, 0, 0);

-- Mesas para La Taberna del Puerto (Terraza)
INSERT INTO mesas (id_restaurante, id_zona, numero, capacidad_minima, capacidad_maxima, forma, posicion_x, posicion_y) VALUES
(1, 1, 'T1', 2, 4, 'Redonda', 10.5, 15.2),
(1, 1, 'T2', 2, 4, 'Redonda', 12.5, 15.2),
(1, 1, 'T3', 4, 6, 'Rectangular', 8.0, 12.0),
(1, 1, 'T4', 4, 6, 'Rectangular', 8.0, 18.0);

-- Mesas para La Taberna del Puerto (Comedor Principal)
INSERT INTO mesas (id_restaurante, id_zona, numero, capacidad_minima, capacidad_maxima, forma, posicion_x, posicion_y) VALUES
(1, 2, 'M1', 2, 4, 'Cuadrada', 5.0, 5.0),
(1, 2, 'M2', 2, 4, 'Cuadrada', 5.0, 10.0),
(1, 2, 'M3', 4, 6, 'Rectangular', 10.0, 5.0),
(1, 2, 'M4', 6, 8, 'Rectangular', 15.0, 5.0),
(1, 2, 'M5', 8, 12, 'Rectangular', 20.0, 5.0);

-- Mesas para Asador Don Carnal (Sala Principal)
INSERT INTO mesas (id_restaurante, id_zona, numero, capacidad_minima, capacidad_maxima, forma, posicion_x, posicion_y) VALUES
(2, 4, 'P1', 2, 4, 'Redonda', 8.0, 8.0),
(2, 4, 'P2', 2, 4, 'Redonda', 12.0, 8.0),
(2, 4, 'P3', 4, 6, 'Rectangular', 6.0, 15.0),
(2, 4, 'P4', 6, 8, 'Rectangular', 14.0, 15.0);

-- Mesas para La Huerta de Valencia (Jardín)
INSERT INTO mesas (id_restaurante, id_zona, numero, capacidad_minima, capacidad_maxima, forma, posicion_x, posicion_y) VALUES
(3, 7, 'J1', 2, 4, 'Redonda', 5.0, 5.0),
(3, 7, 'J2', 2, 4, 'Redonda', 10.0, 5.0),
(3, 7, 'J3', 4, 6, 'Rectangular', 5.0, 12.0),
(3, 7, 'J4', 6, 8, 'Rectangular', 12.0, 12.0);

-- Combinaciones para La Taberna del Puerto
INSERT INTO mesas_combinadas (id_restaurante, nombre, capacidad_total) VALUES
(1, 'Combinación Terraza 1', 10),
(1, 'Combinación Comedor 1', 16);

-- Detalle de combinaciones
INSERT INTO mesas_combinadas_detalle (id_combinacion, id_mesa) VALUES
(1, 1), (1, 2), (1, 3),  -- T1, T2, T3 (Terraza)
(2, 6), (2, 7);          -- M3, M4 (Comedor)

-- Combinaciones para Asador Don Carnal
INSERT INTO mesas_combinadas (id_restaurante, nombre, capacidad_total) VALUES
(2, 'Combinación Principal 1', 12);

INSERT INTO mesas_combinadas_detalle (id_combinacion, id_mesa) VALUES
(3, 11), (3, 12);  -- P3, P4 (Sala Principal)

INSERT INTO clientes (
    nombre, apellidos, email, telefono, direccion, codigo_postal, ciudad, pais, 
    fecha_nacimiento, notas, ultima_visita, consentimiento_comunicaciones
) VALUES
('Juan', 'García Pérez', 'juan.garcia@email.com', '611223344', 'Calle Mayor 12', '28013', 'Madrid', 'España', 
 '1985-06-15', 'Cliente frecuente, prefiere mesa cerca de la ventana', '2023-10-15 14:30:00', 1),

('María', 'López Fernández', 'maria.lopez@email.com', '622334455', 'Avenida Diagonal 45', '08028', 'Barcelona', 'España', 
 '1990-03-22', 'Alergia a los frutos secos', '2023-11-02 21:15:00', 1),

('Carlos', 'Martínez Ruiz', 'carlos.martinez@email.com', '633445566', 'Calle Colón 8', '46004', 'Valencia', 'España', 
 '1978-11-30', 'Prefiere menú degustación', '2023-09-28 13:45:00', 0),

('Ana', 'Sánchez Gómez', 'ana.sanchez@email.com', '644556677', 'Paseo de la Castellana 120', '28046', 'Madrid', 'España', 
 '1982-07-10', 'Celebración de cumpleaños en noviembre', NULL, 1),

('Pedro', 'Jiménez Torres', 'pedro.jimenez@email.com', '655667788', 'Calle Bailén 25', '08010', 'Barcelona', 'España', 
 '1995-02-18', 'Vegetariano', '2023-10-30 20:00:00', 1);
 
 INSERT INTO clientes_preferencias (id_cliente, tipo_preferencia, descripcion) VALUES
(1, 'Ubicación', 'Prefiere mesa cerca de la ventana'),
(2, 'Alergias', 'Alergia grave a frutos secos'),
(3, 'Dieta', 'Prefiere menús degustación'),
(5, 'Dieta', 'Dieta vegetariana estricta'),
(4, 'Ocasiones', 'Celebración de cumpleaños');

-- Usuarios de clientes
INSERT INTO usuarios (email, password, tipo_usuario, id_cliente, id_restaurante, activo) VALUES
('juan.garcia@email.com', '$2a$10$xJwL5v5Jz5U5Z5z5U5Z5zO5Z5z5U5Z5z5U5Z5z5U5Z5z5U5Z5z5', 'Cliente', 1, NULL, 1),
('maria.lopez@email.com', '$2a$10$xJwL5v5Jz5U5Z5z5U5Z5zO5Z5z5U5Z5z5U5Z5z5U5Z5z5U5Z5z5', 'Cliente', 2, NULL, 1),
('carlos.martinez@email.com', '$2a$10$xJwL5v5Jz5U5Z5z5U5Z5zO5Z5z5U5Z5z5U5Z5z5U5Z5z5U5Z5z5', 'Cliente', 3, NULL, 1);

-- Usuarios de personal
INSERT INTO usuarios (email, password, tipo_usuario, id_cliente, id_restaurante, activo) VALUES
('admin@latabernadelpuerto.com', '$2a$10$xJwL5v5Jz5U5Z5z5U5Z5zO5Z5z5U5Z5z5U5Z5z5U5Z5z5U5Z5z5', 'Administrador', NULL, 1, 1),
('recepcion@latabernadelpuerto.com', '$2a$10$xJwL5v5Jz5U5Z5z5U5Z5zO5Z5z5U5Z5z5U5Z5z5U5Z5z5U5Z5z5', 'Recepcionista', NULL, 1, 1),
('gerente@asadordoncarnal.com', '$2a$10$xJwL5v5Jz5U5Z5z5U5Z5zO5Z5z5U5Z5z5U5Z5z5U5Z5z5U5Z5z5', 'Gerente', NULL, 2, 1),
('camarero@lahuertadevalencia.com', '$2a$10$xJwL5v5Jz5U5Z5z5U5Z5zO5Z5z5U5Z5z5U5Z5z5U5Z5z5U5Z5z5', 'Camarero', NULL, 3, 1);

-- Turnos para La Taberna del Puerto
INSERT INTO turnos_servicio (id_restaurante, nombre, hora_inicio, hora_fin, duracion_estandar, dias_semana) VALUES
(1, 'Comida', '13:00:00', '16:00:00', 90, '1,2,3,4,5,6,0'),
(1, 'Cena', '20:00:00', '23:30:00', 90, '1,2,3,4,5,6,0');

-- Turnos para Asador Don Carnal
INSERT INTO turnos_servicio (id_restaurante, nombre, hora_inicio, hora_fin, duracion_estandar, dias_semana) VALUES
(2, 'Comida', '13:30:00', '16:30:00', 120, '1,2,3,4,5,6,0'),
(2, 'Cena', '21:00:00', '00:00:00', 120, '4,5,6,0'),
(2, 'Cena', '20:30:00', '23:30:00', 120, '1,2,3');

-- Turnos para La Huerta de Valencia
INSERT INTO turnos_servicio (id_restaurante, nombre, hora_inicio, hora_fin, duracion_estandar, dias_semana) VALUES
(3, 'Almuerzo', '12:00:00', '16:00:00', 90, '1,2,3,4,5,6,0'),
(3, 'Cena', '20:00:00', '23:00:00', 90, '1,2,3,4,5,6,0');

-- Reservas para La Taberna del Puerto
INSERT INTO reservas (
    id_restaurante, id_cliente, id_turno, id_estado, id_usuario_creador, 
    fecha_reserva, hora_inicio, hora_fin, num_comensales, nombre_reserva, 
    observaciones, codigo_reserva, origen, recordatorio_enviado
) VALUES
(1, 1, 1, 5, 4, '2023-10-15', '14:00:00', '15:30:00', 4, 'Reserva Juan García', 
 'Cliente frecuente, mesa cerca de la ventana', 'TAB-23101501', 'Web', 1),

(1, 2, 2, 5, 5, '2023-11-02', '21:00:00', '22:30:00', 2, 'Reserva María López', 
 'Alergia a frutos secos', 'TAB-23110201', 'Teléfono', 1),

(1, 3, 1, 2, 5, '2023-12-10', '13:30:00', '15:00:00', 6, 'Reserva Carlos Martínez', 
 'Celebración de aniversario', 'TAB-23121001', 'App', 0);

-- Asignación de mesas a reservas
INSERT INTO reservas_mesas (id_reserva, id_mesa) VALUES
(1, 6),  -- Reserva 1 asignada a mesa M1
(2, 1),  -- Reserva 2 asignada a mesa T1
(3, 9);  -- Reserva 3 asignada a mesa M4

-- Historial de estados de reservas
INSERT INTO historial_estados_reserva (id_reserva, id_estado, id_usuario, motivo) VALUES
(1, 1, 4, 'Reserva creada por el cliente'),
(1, 2, 5, 'Reserva confirmada por el restaurante'),
(1, 5, 5, 'Reserva completada'),

(2, 1, 5, 'Reserva creada por teléfono'),
(2, 2, 5, 'Reserva confirmada'),
(2, 5, 5, 'Reserva completada'),

(3, 1, 5, 'Reserva creada desde la app'),
(3, 2, 5, 'Reserva confirmada');

-- Configuración general del sistema
INSERT INTO configuracion_sistema (clave, valor, descripcion) VALUES
('tiempo_maximo_reserva', '30', 'Tiempo máximo en días para hacer una reserva futura'),
('hora_recordatorio', '24', 'Horas antes para enviar recordatorio de reserva'),
('politica_cancelacion', '24', 'Horas mínimas para cancelar sin penalización');

-- Configuración específica por restaurante
INSERT INTO configuracion_restaurante (id_restaurante, clave, valor, descripcion) VALUES
(1, 'deposito_grupos', '10', 'Porcentaje de depósito requerido para grupos de más de 8 personas'),
(1, 'max_comensales_mesa', '8', 'Máximo de comensales por mesa sin combinar'),
(2, 'minimo_cena_finde', '25', 'Consumo mínimo por persona en cenas de fin de semana'),
(3, 'menu_infantil', '1', 'Ofrece menú infantil');

-- Programas de fidelización
INSERT INTO programa_fidelizacion (
    id_restaurante, nombre, descripcion, puntos_por_reserva, 
    puntos_por_euro, valor_punto, minimo_canje, dias_caducidad, activo
) VALUES
(1, 'Club del Puerto', 'Programa de fidelización para clientes habituales', 10, 0.5, 0.02, 100, 365, 1),
(2, 'Amigos del Asador', 'Programa de puntos para clientes frecuentes', 15, 0.75, 0.03, 150, 180, 1);

-- Niveles de fidelización
INSERT INTO niveles_fidelizacion (
    id_programa, nombre, descripcion, puntos_necesarios, 
    multiplicador_puntos, beneficios, color
) VALUES
(1, 'Plateado', 'Nivel inicial', 0, 1.0, 'Descuento del 5% en cumpleaños', '#C0C0C0'),
(1, 'Dorado', 'Nivel intermedio', 500, 1.2, 'Descuento del 10% en cumpleaños y prioridad en reservas', '#FFD700'),
(1, 'Platino', 'Nivel avanzado', 1000, 1.5, 'Descuento del 15%, prioridad en reservas y degustación gratuita anual', '#E5E4E2'),

(2, 'Bronce', 'Nivel inicial', 0, 1.0, 'Descuento del 5% en vinos', '#CD7F32'),
(2, 'Plata', 'Nivel intermedio', 750, 1.25, 'Descuento del 10% en vinos y tapas gratuitas', '#C0C0C0'),
(2, 'Oro', 'Nivel avanzado', 1500, 1.5, 'Descuento del 15%, tapas gratuitas y acceso a eventos exclusivos', '#FFD700');

-- Clientes en programas de fidelización
INSERT INTO clientes_fidelizacion (
    id_cliente, id_programa, id_nivel, puntos_actuales, puntos_totales, fecha_ultima_actividad, codigo_cliente
) VALUES
(1, 1, 2, 650, 850, '2023-10-15 14:30:00', 'TAB-CL001'),
(2, 1, 1, 120, 320, '2023-11-02 21:15:00', 'TAB-CL002'),
(3, 2, 3, 1800, 2300, '2023-09-28 13:45:00', 'ASA-CL001');

-- Movimientos de puntos
INSERT INTO movimientos_puntos (
    id_cliente, id_programa, id_reserva, tipo, puntos, concepto, fecha_caducidad
) VALUES
(1, 1, 1, 'Ganados', 10, 'Reserva completada #TAB-23101501', '2024-10-15'),
(1, 1, NULL, 'Bonus', 50, 'Bonus por aniversario', '2024-12-31'),
(2, 1, 2, 'Ganados', 10, 'Reserva completada #TAB-23110201', '2024-11-02'),
(3, 2, NULL, 'Ganados', 15, 'Reserva completada #ASA-23092801', '2024-03-28');

-- Categorías para La Taberna del Puerto
INSERT INTO categorias_menu (id_restaurante, nombre, descripcion, orden) VALUES
(1, 'Entrantes', 'Deliciosos entrantes para compartir', 1),
(1, 'Pescados', 'Pescados frescos del día', 2),
(1, 'Mariscos', 'Selección de los mejores mariscos', 3),
(1, 'Postres', 'Dulces finales para tu comida', 4);

-- Platos para La Taberna del Puerto
INSERT INTO platos (
    id_restaurante, id_categoria, nombre, descripcion, ingredientes, alergenos, 
    precio, tiempo_preparacion, es_vegano, es_vegetariano, es_sin_gluten, es_picante, es_mas_vendido
) VALUES
(1, 1, 'Pan con tomate', 'Pan tostado con tomate fresco y aceite de oliva', 'Pan, tomate, ajo, aceite de oliva', 'Gluten', 
 3.50, 5, 0, 1, 0, 0, 1),

(1, 1, 'Anchoas del Cantábrico', 'Anchoas marinadas en aceite de oliva virgen extra', 'Anchoas, aceite de oliva', 'Pescado', 
 12.50, 10, 0, 0, 1, 0, 1),

(1, 2, 'Dorada a la sal', 'Dorada cocinada al horno con costra de sal', 'Dorada, sal', 'Pescado', 
 22.00, 30, 0, 0, 1, 0, 1),

(1, 3, 'Arroz negro', 'Arroz con tinta de calamar y alioli', 'Arroz, calamar, tinta, ajo', 'Pescado, moluscos', 
 18.50, 25, 0, 0, 0, 0, 1),

(1, 4, 'Crema catalana', 'Postre tradicional con caramelo crujiente', 'Leche, huevo, azúcar, canela', 'Huevo, lactosa', 
 5.50, 15, 0, 1, 1, 0, 1);
 
 -- Menús para La Taberna del Puerto
INSERT INTO menus (
    id_restaurante, nombre, descripcion, tipo, precio_fijo, activo
) VALUES
(1, 'Menú del día', 'Menú económico de mediodía', 'Menú del día', 15.90, 1),
(1, 'Carta principal', 'Nuestra selección completa de platos', 'Carta', NULL, 1);

-- Relación menú-platos
INSERT INTO menu_platos (id_menu, id_plato, id_categoria, orden, precio_especial) VALUES
(1, 1, 1, 1, NULL),  -- Pan con tomate en Menú del día
(1, 3, 2, 2, NULL),  -- Dorada a la sal en Menú del día
(1, 5, 4, 3, 4.50),  -- Crema catalana en Menú del día con precio especial

(2, 1, 1, 1, NULL),  -- Pan con tomate en Carta
(2, 2, 1, 2, NULL),  -- Anchoas en Carta
(2, 3, 2, 1, NULL),  -- Dorada en Carta
(2, 4, 3, 1, NULL),  -- Arroz negro en Carta
(2, 5, 4, 1, NULL);  -- Crema catalana en Carta

-- Pedidos asociados a reservas
INSERT INTO pedidos (
    id_reserva, id_restaurante, id_mesa, id_cliente, codigo_pedido, estado, tipo, total
) VALUES
(1, 1, 6, 1, 'TAB-PED001', 'Pagado', 'Comer aquí', 78.50),
(2, 1, 1, 2, 'TAB-PED002', 'Pagado', 'Comer aquí', 45.00);

-- Platos reservados
INSERT INTO reserva_platos (
    id_reserva, id_plato, cantidad, precio_unitario, notas, servido
) VALUES
(1, 1, 1, 3.50, 'Sin ajo', 1),
(1, 3, 2, 22.00, 'Uno bien cocido', 1),
(1, 5, 1, 5.50, NULL, 1),

(2, 2, 1, 12.50, NULL, 1),
(2, 4, 1, 18.50, 'Sin picante', 1),
(2, 5, 1, 5.50, NULL, 1);

-- Actualizar totales de pedidos
UPDATE pedidos SET total = 78.50 WHERE id_pedido = 1;
UPDATE pedidos SET total = 45.00 WHERE id_pedido = 2;

INSERT INTO pagos (
    id_pedido, id_reserva, id_cliente, id_restaurante, metodo, monto, estado, codigo_transaccion, fecha_pago
) VALUES
(1, 1, 1, 1, 'Tarjeta', 78.50, 'Completado', 'TAB-PAY001', '2023-10-15 15:25:00'),
(2, 2, 2, 1, 'Efectivo', 45.00, 'Completado', 'TAB-PAY002', '2023-11-02 22:15:00');

-- Eventos para La Taberna del Puerto
INSERT INTO eventos (
    id_restaurante, nombre, descripcion, fecha_inicio, fecha_fin, hora_inicio, hora_fin, 
    precio_entrada, capacidad_maxima, reservas_requeridas
) VALUES
(1, 'Noche de Jazz', 'Cena con música en vivo de jazz', '2023-12-15', '2023-12-15', '21:00:00', '00:00:00', 
 35.00, 50, 1),

(1, 'Degustación de Vinos', 'Maridaje de vinos con tapas selectas', '2024-01-20', '2024-01-20', '20:00:00', '22:30:00', 
 25.00, 30, 1);

-- Reservas para eventos
INSERT INTO reservas_eventos (
    id_evento, id_cliente, num_personas, codigo_reserva, estado
) VALUES
(1, 1, 2, 'TAB-EV001', 'Confirmada'),
(1, 3, 4, 'TAB-EV002', 'Confirmada');

INSERT INTO log_notificaciones (
    id_cliente, id_reserva, tipo, asunto, mensaje, estado, fecha_envio
) VALUES
(1, 1, 'Email', 'Confirmación de reserva en La Taberna del Puerto', 
 'Estimado Juan García,\n\nSu reserva para 4 personas el 15/10/2023 a las 14:00 ha sido confirmada.\n\nCódigo de reserva: TAB-23101501\n\n¡Gracias por elegirnos!', 
 'Entregado', '2023-10-14 10:30:00'),

(2, 2, 'SMS', NULL, 
 'Recordatorio reserva TAB-23110201: La Taberna del Puerto hoy a las 21:00 para 2 pers.', 
 'Entregado', '2023-11-02 12:00:00');
 
 
