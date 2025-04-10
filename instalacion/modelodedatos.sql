-- -----------------------------------------------------
-- Base de datos: `gestion_restaurante`
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Tabla `restaurantes`
-- Almacena información básica de cada restaurante registrado en el sistema
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `restaurantes` (
  `id_restaurante` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL COMMENT 'Nombre comercial del restaurante',
  `direccion` VARCHAR(200) NOT NULL COMMENT 'Dirección física del establecimiento',
  `codigo_postal` VARCHAR(10) COMMENT 'Código postal de la ubicación',
  `ciudad` VARCHAR(100) NOT NULL COMMENT 'Ciudad donde se ubica el restaurante',
  `provincia` VARCHAR(100) COMMENT 'Provincia o estado',
  `pais` VARCHAR(50) DEFAULT 'España' COMMENT 'País donde se ubica el restaurante',
  `telefono` VARCHAR(20) NOT NULL COMMENT 'Teléfono principal de contacto',
  `email` VARCHAR(100) COMMENT 'Email de contacto',
  `sitio_web` VARCHAR(150) COMMENT 'URL del sitio web del restaurante',
  `latitud` DECIMAL(10,8) COMMENT 'Coordenada de latitud para Google Maps',
  `longitud` DECIMAL(11,8) COMMENT 'Coordenada de longitud para Google Maps',
  `horario_apertura` TIME COMMENT 'Hora de apertura estándar',
  `horario_cierre` TIME COMMENT 'Hora de cierre estándar',
  `descripcion` TEXT COMMENT 'Descripción breve del restaurante',
  `tipo_cocina` VARCHAR(100) COMMENT 'Tipo de cocina o especialidad',
  `imagen_portada` VARCHAR(255) COMMENT 'URL de la imagen principal',
  `logo` VARCHAR(255) COMMENT 'URL del logo del restaurante',
  `capacidad_total` INT UNSIGNED COMMENT 'Capacidad máxima de comensales',
  `tiempo_entre_reservas` INT UNSIGNED DEFAULT 30 COMMENT 'Tiempo en minutos entre reservas para gestionar aforo',
  `activo` TINYINT(1) DEFAULT 1 COMMENT 'Indica si el restaurante está activo en el sistema',
  `fecha_registro` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de registro en el sistema',
  `fecha_actualizacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha de última actualización',
  PRIMARY KEY (`id_restaurante`)
) ENGINE=InnoDB COMMENT='Almacena la información principal de los restaurantes';

-- -----------------------------------------------------
-- Tabla `restaurante_redes_sociales`
-- Almacena las redes sociales de cada restaurante
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `restaurante_redes_sociales` (
  `id_red_social` INT NOT NULL AUTO_INCREMENT,
  `id_restaurante` INT NOT NULL,
  `tipo_red` ENUM('Facebook', 'Instagram', 'Twitter', 'TikTok', 'LinkedIn', 'YouTube', 'Pinterest', 'Otra') NOT NULL COMMENT 'Tipo de red social',
  `url` VARCHAR(255) NOT NULL COMMENT 'URL de la página o perfil en la red social',
  `usuario` VARCHAR(100) COMMENT 'Nombre de usuario en la red social',
  `activo` TINYINT(1) DEFAULT 1 COMMENT 'Indica si esta red social está activa',
  `fecha_registro` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_red_social`),
  INDEX `fk_redes_restaurante_idx` (`id_restaurante`),
  CONSTRAINT `fk_redes_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurantes` (`id_restaurante`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Enlaces a redes sociales de cada restaurante';

-- -----------------------------------------------------
-- Tabla `horarios_especiales`
-- Permite configurar días con horarios diferentes (festivos, eventos, etc.)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `horarios_especiales` (
  `id_horario_especial` INT NOT NULL AUTO_INCREMENT,
  `id_restaurante` INT NOT NULL,
  `fecha` DATE NOT NULL COMMENT 'Fecha del horario especial',
  `horario_apertura` TIME COMMENT 'Hora de apertura especial (NULL si está cerrado)',
  `horario_cierre` TIME COMMENT 'Hora de cierre especial (NULL si está cerrado)',
  `motivo` VARCHAR(150) COMMENT 'Motivo del horario especial',
  `cerrado` TINYINT(1) DEFAULT 0 COMMENT 'Indica si el restaurante está cerrado en esta fecha',
  PRIMARY KEY (`id_horario_especial`),
  INDEX `fk_horarios_restaurante_idx` (`id_restaurante`),
  CONSTRAINT `fk_horarios_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurantes` (`id_restaurante`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Configura horarios especiales o días cerrados';

-- -----------------------------------------------------
-- Tabla `zonas`
-- Divide el restaurante en diferentes zonas (terraza, interior, salón privado, etc.)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `zonas` (
  `id_zona` INT NOT NULL AUTO_INCREMENT,
  `id_restaurante` INT NOT NULL,
  `nombre` VARCHAR(50) NOT NULL COMMENT 'Nombre identificativo de la zona',
  `descripcion` TEXT COMMENT 'Descripción de la zona',
  `capacidad` INT UNSIGNED COMMENT 'Capacidad máxima de la zona',
  `climatizada` TINYINT(1) DEFAULT 0 COMMENT '¿Zona con clima controlado?',
  `fumadores` TINYINT(1) DEFAULT 0 COMMENT '¿Permitido fumar?',
  `accesible` TINYINT(1) DEFAULT 1 COMMENT '¿Accesible para personas con movilidad reducida?',
  `activa` TINYINT(1) DEFAULT 1 COMMENT 'Indica si la zona está disponible',
  PRIMARY KEY (`id_zona`),
  INDEX `fk_zonas_restaurante_idx` (`id_restaurante`),
  CONSTRAINT `fk_zonas_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurantes` (`id_restaurante`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Áreas o zonas dentro del restaurante';

-- -----------------------------------------------------
-- Tabla `mesas`
-- Almacena información de las mesas disponibles
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mesas` (
  `id_mesa` INT NOT NULL AUTO_INCREMENT,
  `id_restaurante` INT NOT NULL,
  `id_zona` INT NOT NULL,
  `numero` VARCHAR(10) NOT NULL COMMENT 'Número o identificador visible de la mesa',
  `capacidad_minima` INT UNSIGNED DEFAULT 1 COMMENT 'Capacidad mínima de comensales',
  `capacidad_maxima` INT UNSIGNED NOT NULL COMMENT 'Capacidad máxima de comensales',
  `forma` ENUM('Redonda', 'Cuadrada', 'Rectangular', 'Ovalada', 'Otra') DEFAULT 'Rectangular' COMMENT 'Forma de la mesa',
  `posicion_x` DECIMAL(10,2) COMMENT 'Coordenada X en el plano del restaurante',
  `posicion_y` DECIMAL(10,2) COMMENT 'Coordenada Y en el plano del restaurante',
  `notas` TEXT COMMENT 'Notas especiales sobre la mesa',
  `activa` TINYINT(1) DEFAULT 1 COMMENT 'Indica si la mesa está disponible para reservas',
  PRIMARY KEY (`id_mesa`),
  INDEX `fk_mesas_restaurante_idx` (`id_restaurante`),
  INDEX `fk_mesas_zona_idx` (`id_zona`),
  CONSTRAINT `fk_mesas_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurantes` (`id_restaurante`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_mesas_zona`
    FOREIGN KEY (`id_zona`)
    REFERENCES `zonas` (`id_zona`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Registro de mesas disponibles en el restaurante';

-- -----------------------------------------------------
-- Tabla `mesas_combinadas`
-- Permite unir mesas para grupos grandes
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mesas_combinadas` (
  `id_combinacion` INT NOT NULL AUTO_INCREMENT,
  `id_restaurante` INT NOT NULL,
  `nombre` VARCHAR(50) NOT NULL COMMENT 'Nombre identificativo de la combinación',
  `capacidad_total` INT UNSIGNED NOT NULL COMMENT 'Capacidad total de la combinación',
  `activa` TINYINT(1) DEFAULT 1 COMMENT 'Indica si esta combinación está disponible',
  PRIMARY KEY (`id_combinacion`),
  INDEX `fk_combinacion_restaurante_idx` (`id_restaurante`),
  CONSTRAINT `fk_combinacion_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurantes` (`id_restaurante`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Combinaciones predefinidas de mesas';

-- -----------------------------------------------------
-- Tabla `mesas_combinadas_detalle`
-- Detalle de qué mesas componen cada combinación
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mesas_combinadas_detalle` (
  `id_combinacion` INT NOT NULL,
  `id_mesa` INT NOT NULL,
  PRIMARY KEY (`id_combinacion`, `id_mesa`),
  INDEX `fk_combinacion_mesa_idx` (`id_mesa`),
  CONSTRAINT `fk_detalle_combinacion`
    FOREIGN KEY (`id_combinacion`)
    REFERENCES `mesas_combinadas` (`id_combinacion`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_detalle_mesa`
    FOREIGN KEY (`id_mesa`)
    REFERENCES `mesas` (`id_mesa`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Mesas que forman parte de cada combinación';

-- -----------------------------------------------------
-- Tabla `clientes`
-- Almacena información de los clientes que realizan reservas
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clientes` (
  `id_cliente` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL COMMENT 'Nombre del cliente',
  `apellidos` VARCHAR(100) COMMENT 'Apellidos del cliente',
  `email` VARCHAR(100) COMMENT 'Email del cliente',
  `telefono` VARCHAR(20) NOT NULL COMMENT 'Teléfono del cliente',
  `direccion` VARCHAR(200) COMMENT 'Dirección del cliente',
  `codigo_postal` VARCHAR(10) COMMENT 'Código postal',
  `ciudad` VARCHAR(100) COMMENT 'Ciudad',
  `pais` VARCHAR(50) DEFAULT 'España' COMMENT 'País de residencia',
  `fecha_nacimiento` DATE COMMENT 'Fecha de nacimiento',
  `notas` TEXT COMMENT 'Notas generales sobre el cliente',
  `fecha_registro` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de registro en el sistema',
  `ultima_visita` TIMESTAMP NULL COMMENT 'Fecha de la última visita',
  `consentimiento_comunicaciones` TINYINT(1) DEFAULT 0 COMMENT 'Consentimiento para envío de comunicaciones',
  `activo` TINYINT(1) DEFAULT 1 COMMENT 'Indica si el cliente está activo',
  PRIMARY KEY (`id_cliente`),
  UNIQUE INDEX `idx_cliente_email` (`email`),
  INDEX `idx_cliente_telefono` (`telefono`)
) ENGINE=InnoDB COMMENT='Datos de los clientes que realizan reservas';

-- -----------------------------------------------------
-- Tabla `clientes_preferencias`
-- Almacena preferencias específicas de los clientes
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clientes_preferencias` (
  `id_preferencia` INT NOT NULL AUTO_INCREMENT,
  `id_cliente` INT NOT NULL,
  `tipo_preferencia` ENUM('Ubicación', 'Alergias', 'Intolerancias', 'Dieta', 'Ocasiones', 'Bebida', 'Otra') NOT NULL COMMENT 'Tipo de preferencia',
  `descripcion` TEXT NOT NULL COMMENT 'Descripción detallada de la preferencia',
  `fecha_registro` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_preferencia`),
  INDEX `fk_preferencias_cliente_idx` (`id_cliente`),
  CONSTRAINT `fk_preferencias_cliente`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `clientes` (`id_cliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Preferencias y necesidades específicas de clientes';

-- -----------------------------------------------------
-- Tabla `usuarios`
-- Gestiona las cuentas de acceso de clientes y personal
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(100) NOT NULL COMMENT 'Email del usuario (usado como login)',
  `password` VARCHAR(255) NOT NULL COMMENT 'Contraseña encriptada',
  `tipo_usuario` ENUM('Administrador', 'Gerente', 'Recepcionista', 'Camarero', 'Cliente') NOT NULL COMMENT 'Nivel de acceso',
  `id_cliente` INT NULL COMMENT 'ID del cliente asociado (solo para tipo Cliente)',
  `id_restaurante` INT NULL COMMENT 'ID del restaurante asociado (para personal)',
  `token_recuperacion` VARCHAR(100) COMMENT 'Token para recuperación de contraseña',
  `fecha_token` TIMESTAMP NULL COMMENT 'Fecha de creación del token',
  `ultimo_acceso` TIMESTAMP NULL COMMENT 'Última fecha de acceso',
  `activo` TINYINT(1) DEFAULT 1 COMMENT 'Indica si el usuario está activo',
  `fecha_registro` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`),
  UNIQUE INDEX `idx_usuario_email` (`email`),
  INDEX `fk_usuario_cliente_idx` (`id_cliente`),
  INDEX `fk_usuario_restaurante_idx` (`id_restaurante`),
  CONSTRAINT `fk_usuario_cliente`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `clientes` (`id_cliente`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_usuario_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurantes` (`id_restaurante`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Cuentas de usuarios del sistema';

-- -----------------------------------------------------
-- Tabla `turnos_servicio`
-- Define los turnos disponibles para reservas (comida, cena, etc.)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `turnos_servicio` (
  `id_turno` INT NOT NULL AUTO_INCREMENT,
  `id_restaurante` INT NOT NULL,
  `nombre` VARCHAR(50) NOT NULL COMMENT 'Nombre del turno (ej. Comida, Cena)',
  `hora_inicio` TIME NOT NULL COMMENT 'Hora de inicio del turno',
  `hora_fin` TIME NOT NULL COMMENT 'Hora de fin del turno',
  `duracion_estandar` INT UNSIGNED DEFAULT 90 COMMENT 'Duración estándar de cada servicio en minutos',
  `dias_semana` VARCHAR(20) DEFAULT '1,2,3,4,5,6,0' COMMENT 'Días de la semana aplicables (0=Domingo, 1=Lunes...)',
  `activo` TINYINT(1) DEFAULT 1 COMMENT 'Indica si este turno está activo',
  PRIMARY KEY (`id_turno`),
  INDEX `fk_turnos_restaurante_idx` (`id_restaurante`),
  CONSTRAINT `fk_turnos_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurantes` (`id_restaurante`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Definición de turnos de servicio disponibles';

-- -----------------------------------------------------
-- Tabla `estados_reserva`
-- Catálogo de posibles estados de una reserva
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estados_reserva` (
  `id_estado` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL COMMENT 'Nombre del estado (ej. Confirmada, Cancelada)',
  `descripcion` TEXT COMMENT 'Descripción detallada del estado',
  `color` VARCHAR(7) DEFAULT '#000000' COMMENT 'Color representativo en formato hexadecimal',
  `activo` TINYINT(1) DEFAULT 1 COMMENT 'Indica si este estado está disponible',
  PRIMARY KEY (`id_estado`)
) ENGINE=InnoDB COMMENT='Catálogo de estados posibles para las reservas';

-- Inserción de estados por defecto
INSERT INTO `estados_reserva` (`nombre`, `descripcion`, `color`) VALUES 
('Pendiente', 'Reserva creada y pendiente de confirmación', '#FFA500'),
('Confirmada', 'Reserva confirmada por el restaurante', '#008000'),
('Cancelada por cliente', 'Reserva cancelada por el cliente', '#FF0000'),
('Cancelada por restaurante', 'Reserva cancelada por el restaurante', '#8B0000'),
('Completada', 'Reserva completada (cliente asistió)', '#0000FF'),
('No-show', 'Cliente no se presentó', '#000000');

-- -----------------------------------------------------
-- Tabla `reservas`
-- Almacena las reservas realizadas
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `reservas` (
  `id_reserva` INT NOT NULL AUTO_INCREMENT,
  `id_restaurante` INT NOT NULL,
  `id_cliente` INT NOT NULL,
  `id_turno` INT NULL COMMENT 'Turno seleccionado, NULL si es horario personalizado',
  `id_estado` INT NOT NULL DEFAULT 1 COMMENT 'Estado actual de la reserva',
  `id_usuario_creador` INT NULL COMMENT 'Usuario que creó la reserva',
  `fecha_reserva` DATE NOT NULL COMMENT 'Fecha programada de la reserva',
  `hora_inicio` TIME NOT NULL COMMENT 'Hora de inicio de la reserva',
  `hora_fin` TIME COMMENT 'Hora estimada de fin de la reserva',
  `num_comensales` INT UNSIGNED NOT NULL COMMENT 'Número de comensales',
  `nombre_reserva` VARCHAR(100) COMMENT 'Nombre bajo el que está la reserva (si es distinto del cliente)',
  `observaciones` TEXT COMMENT 'Observaciones especiales para esta reserva',
  `codigo_reserva` VARCHAR(20) NOT NULL COMMENT 'Código único para identificación',
  `origen` ENUM('Web', 'App', 'Teléfono', 'Presencial', 'Otro') NOT NULL COMMENT 'Origen de la reserva',
  `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación de la reserva',
  `fecha_actualizacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha de última actualización',
  `recordatorio_enviado` TINYINT(1) DEFAULT 0 COMMENT 'Indica si se ha enviado recordatorio',
  `valoracion` INT UNSIGNED NULL COMMENT 'Valoración del cliente (1-5)',
  `comentario_valoracion` TEXT COMMENT 'Comentario dejado por el cliente',
  `hora_llegada` TIME NULL COMMENT 'Hora real de llegada del cliente',
  PRIMARY KEY (`id_reserva`),
  UNIQUE INDEX `idx_codigo_reserva` (`codigo_reserva`),
  INDEX `fk_reserva_restaurante_idx` (`id_restaurante`),
  INDEX `fk_reserva_cliente_idx` (`id_cliente`),
  INDEX `fk_reserva_turno_idx` (`id_turno`),
  INDEX `fk_reserva_estado_idx` (`id_estado`),
  INDEX `fk_reserva_usuario_idx` (`id_usuario_creador`),
  INDEX `idx_reserva_fecha` (`fecha_reserva`),
  CONSTRAINT `fk_reserva_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurantes` (`id_restaurante`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_reserva_cliente`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `clientes` (`id_cliente`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_reserva_turno`
    FOREIGN KEY (`id_turno`)
    REFERENCES `turnos_servicio` (`id_turno`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_reserva_estado`
    FOREIGN KEY (`id_estado`)
    REFERENCES `estados_reserva` (`id_estado`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_reserva_usuario`
    FOREIGN KEY (`id_usuario_creador`)
    REFERENCES `usuarios` (`id_usuario`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Registro de todas las reservas';

-- -----------------------------------------------------
-- Tabla `reservas_mesas`
-- Asignación de mesas a reservas (una reserva puede tener varias mesas)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `reservas_mesas` (
  `id_reserva` INT NOT NULL,
  `id_mesa` INT NOT NULL,
  PRIMARY KEY (`id_reserva`, `id_mesa`),
  INDEX `fk_reserva_mesa_idx` (`id_mesa`),
  CONSTRAINT `fk_reservas_mesas_reserva`
    FOREIGN KEY (`id_reserva`)
    REFERENCES `reservas` (`id_reserva`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_reservas_mesas_mesa`
    FOREIGN KEY (`id_mesa`)
    REFERENCES `mesas` (`id_mesa`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Mesas asignadas a cada reserva';

-- -----------------------------------------------------
-- Tabla `historial_estados_reserva`
-- Registro histórico de cambios en el estado de las reservas
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `historial_estados_reserva` (
  `id_historial` INT NOT NULL AUTO_INCREMENT,
  `id_reserva` INT NOT NULL,
  `id_estado` INT NOT NULL COMMENT 'Estado de la reserva en este momento',
  `id_usuario` INT NULL COMMENT 'Usuario que realizó el cambio',
  `fecha_cambio` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del cambio',
  `motivo` TEXT COMMENT 'Motivo del cambio de estado',
  PRIMARY KEY (`id_historial`),
  INDEX `fk_historial_reserva_idx` (`id_reserva`),
  INDEX `fk_historial_estado_idx` (`id_estado`),
  INDEX `fk_historial_usuario_idx` (`id_usuario`),
  CONSTRAINT `fk_historial_reserva`
    FOREIGN KEY (`id_reserva`)
    REFERENCES `reservas` (`id_reserva`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_historial_estado`
    FOREIGN KEY (`id_estado`)
    REFERENCES `estados_reserva` (`id_estado`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_historial_usuario`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `usuarios` (`id_usuario`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Historial de cambios de estado de las reservas';

-- -----------------------------------------------------
-- Tabla `tipos_bloqueo`
-- Catálogo de razones por las que se puede bloquear un horario o mesa
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tipos_bloqueo` (
  `id_tipo_bloqueo` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL COMMENT 'Nombre del tipo de bloqueo',
  `descripcion` TEXT COMMENT 'Descripción detallada',
  `color` VARCHAR(7) DEFAULT '#FF0000' COMMENT 'Color para representación visual',
  PRIMARY KEY (`id_tipo_bloqueo`)
) ENGINE=InnoDB COMMENT='Tipos de bloqueo para mesas o franjas horarias';

-- Inserción de tipos de bloqueo comunes
INSERT INTO `tipos_bloqueo` (`nombre`, `descripcion`, `color`) VALUES 
('Mantenimiento', 'Mesa o zona en mantenimiento', '#FFA500'),
('Evento privado', 'Espacio reservado para evento privado', '#800080'),
('Cierre temporal', 'Cierre temporal por causas internas', '#FF0000'),
('Reservado para personal', 'Espacio reservado para personal', '#008000');

-- -----------------------------------------------------
-- Tabla `bloqueos_disponibilidad`
-- Permite bloquear mesas o zonas en determinados horarios
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bloqueos_disponibilidad` (
  `id_bloqueo` INT NOT NULL AUTO_INCREMENT,
  `id_restaurante` INT NOT NULL,
  `id_tipo_bloqueo` INT NOT NULL,
  `id_zona` INT NULL COMMENT 'Zona bloqueada (NULL si es restaurant completo o mesa específica)',
  `id_mesa` INT NULL COMMENT 'Mesa bloqueada (NULL si es zona o restaurant completo)',
  `fecha_inicio` DATE NOT NULL COMMENT 'Fecha de inicio del bloqueo',
  `fecha_fin` DATE NOT NULL COMMENT 'Fecha de fin del bloqueo',
  `hora_inicio` TIME COMMENT 'Hora de inicio (NULL si es todo el día)',
  `hora_fin` TIME COMMENT 'Hora de fin (NULL si es todo el día)',
  `motivo_detallado` TEXT COMMENT 'Descripción detallada del motivo',
  `id_usuario` INT NULL COMMENT 'Usuario que creó el bloqueo',
  `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_bloqueo`),
  INDEX `fk_bloqueo_restaurante_idx` (`id_restaurante`),
  INDEX `fk_bloqueo_tipo_idx` (`id_tipo_bloqueo`),
  INDEX `fk_bloqueo_zona_idx` (`id_zona`),
  INDEX `fk_bloqueo_mesa_idx` (`id_mesa`),
  INDEX `fk_bloqueo_usuario_idx` (`id_usuario`),
  CONSTRAINT `fk_bloqueo_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurantes` (`id_restaurante`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_bloqueo_tipo`
    FOREIGN KEY (`id_tipo_bloqueo`)
    REFERENCES `tipos_bloqueo` (`id_tipo_bloqueo`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_bloqueo_zona`
    FOREIGN KEY (`id_zona`)
    REFERENCES `zonas` (`id_zona`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_bloqueo_mesa`
    FOREIGN KEY (`id_mesa`)
    REFERENCES `mesas` (`id_mesa`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_bloqueo_usuario`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `usuarios` (`id_usuario`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Bloqueos de disponibilidad de mesas o zonas';

-- -----------------------------------------------------
-- Tabla `configuracion_sistema`
-- Parámetros de configuración general del sistema
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `configuracion_sistema` (
  `id_configuracion` INT NOT NULL AUTO_INCREMENT,
  `clave` VARCHAR(100) NOT NULL COMMENT 'Clave de la configuración',
  `valor` TEXT COMMENT 'Valor de la configuración',
  `descripcion` TEXT COMMENT 'Descripción de la configuración',
  `fecha_actualizacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_configuracion`),
  UNIQUE INDEX `idx_configuracion_clave` (`clave`)
) ENGINE=InnoDB COMMENT='Parámetros de configuración del sistema';

-- -----------------------------------------------------
-- Tabla `configuracion_restaurante`
-- Parámetros de configuración específicos de cada restaurante
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `configuracion_restaurante` (
  `id_configuracion` INT NOT NULL AUTO_INCREMENT,
  `id_restaurante` INT NOT NULL,
  `clave` VARCHAR(100) NOT NULL COMMENT 'Clave de la configuración',
  `valor` TEXT COMMENT 'Valor de la configuración',
  `descripcion` TEXT COMMENT 'Descripción de la configuración',
  `fecha_actualizacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_configuracion`),
  UNIQUE INDEX `idx_config_restaurante_clave` (`id_restaurante`, `clave`),
  CONSTRAINT `fk_config_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurantes` (`id_restaurante`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Configuraciones específicas por restaurante';

-- -----------------------------------------------------
-- Tabla `log_notificaciones`
-- Registro de notificaciones enviadas a clientes
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `log_notificaciones` (
  `id_notificacion` INT NOT NULL AUTO_INCREMENT,
  `id_cliente` INT NOT NULL,
  `id_reserva` INT NULL COMMENT 'Reserva asociada (puede ser NULL)',
  `tipo` ENUM('SMS', 'Email', 'Push', 'WhatsApp') NOT NULL COMMENT 'Tipo de notificación',
  `asunto` VARCHAR(200) COMMENT 'Asunto de la notificación',
  `mensaje` TEXT NOT NULL COMMENT 'Contenido del mensaje',
  `estado` ENUM('Pendiente', 'Enviado', 'Fallido', 'Entregado', 'Leído') NOT NULL DEFAULT 'Pendiente' COMMENT 'Estado de envío',
  `error` TEXT COMMENT 'Mensaje de error en caso de fallo',
  `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `fecha_envio` TIMESTAMP NULL COMMENT 'Fecha y hora del envío',
  PRIMARY KEY (`id_notificacion`),
  INDEX `fk_notificacion_cliente_idx` (`id_cliente`),
  INDEX `fk_notificacion_reserva_idx` (`id_reserva`),
  CONSTRAINT `fk_notificacion_cliente`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `clientes` (`id_cliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_notificacion_reserva`
    FOREIGN KEY (`id_reserva`)
    REFERENCES `reservas` (`id_reserva`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Historial de notificaciones enviadas a clientes';

-- -----------------------------------------------------
-- Tabla `plantillas_notificacion`
-- Plantillas para notificaciones automáticas
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `plantillas_notificacion` (
  `id_plantilla` INT NOT NULL AUTO_INCREMENT,
  `id_restaurante` INT NULL COMMENT 'NULL si es plantilla global del sistema',
  `tipo` ENUM('SMS', 'Email', 'Push', 'WhatsApp') NOT NULL COMMENT 'Tipo de notificación',
  `nombre` VARCHAR(100) NOT NULL COMMENT 'Nombre descriptivo de la plantilla',
  `evento` ENUM('Confirmacion', 'Recordatorio', 'Cancelacion', 'Modificacion', 'Agradecimiento', 'Recuperacion', 'Promocion') NOT NULL COMMENT 'Evento que dispara esta plantilla',
  `asunto` VARCHAR(200) COMMENT 'Asunto para emails',
  `contenido` TEXT NOT NULL COMMENT 'Contenido con marcadores para reemplazo',
  `activa` TINYINT(1) DEFAULT 1 COMMENT 'Indica si la plantilla está activa',
  `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_plantilla`),
  INDEX `fk_plantilla_restaurante_idx` (`id_restaurante`),
  CONSTRAINT `fk_plantilla_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurantes` (`id_restaurante`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Plantillas para notificaciones automáticas';

-- -----------------------------------------------------
-- Tabla `programa_fidelizacion`
-- Configuración del programa de fidelización
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `programa_fidelizacion` (
  `id_programa` INT NOT NULL AUTO_INCREMENT,
  `id_restaurante` INT NOT NULL,
  `nombre` VARCHAR(100) NOT NULL COMMENT 'Nombre del programa de fidelización',
  `descripcion` TEXT COMMENT 'Descripción detallada del programa',
  `puntos_por_reserva` INT UNSIGNED DEFAULT 0 COMMENT 'Puntos base por cada reserva completada',
  `puntos_por_euro` DECIMAL(5,2) DEFAULT 0 COMMENT 'Puntos por cada euro gastado',
  `valor_punto` DECIMAL(10,2) DEFAULT 0 COMMENT 'Valor monetario de cada punto en euros',
  `minimo_canje` INT UNSIGNED DEFAULT 0 COMMENT 'Cantidad mínima de puntos para canjear',
  `dias_caducidad` INT UNSIGNED DEFAULT 365 COMMENT 'Días hasta que caducan los puntos',
  `activo` TINYINT(1) DEFAULT 1 COMMENT 'Indica si el programa está activo',
  `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_programa`),
  INDEX `fk_programa_restaurante_idx` (`id_restaurante`),
  CONSTRAINT `fk_programa_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurantes` (`id_restaurante`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Configuración del programa de fidelización por restaurante';

-- -----------------------------------------------------
-- Tabla `niveles_fidelizacion`
-- Niveles dentro del programa de fidelización
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `niveles_fidelizacion` (
  `id_nivel` INT NOT NULL AUTO_INCREMENT,
  `id_programa` INT NOT NULL,
  `nombre` VARCHAR(50) NOT NULL COMMENT 'Nombre del nivel (ej. Plata, Oro, Platino)',
  `descripcion` TEXT COMMENT 'Descripción de los beneficios del nivel',
  `puntos_necesarios` INT UNSIGNED NOT NULL COMMENT 'Puntos necesarios para alcanzar este nivel',
  `multiplicador_puntos` DECIMAL(3,2) DEFAULT 1.00 COMMENT 'Multiplicador de puntos para este nivel',
  `beneficios` TEXT COMMENT 'Detalles de ventajas para este nivel',
  `color` VARCHAR(7) DEFAULT '#000000' COMMENT 'Color representativo en formato hexadecimal',
  `activo` TINYINT(1) DEFAULT 1 COMMENT 'Indica si este nivel está activo',
  PRIMARY KEY (`id_nivel`),
  INDEX `fk_nivel_programa_idx` (`id_programa`),
  CONSTRAINT `fk_nivel_programa`
    FOREIGN KEY (`id_programa`)
    REFERENCES `programa_fidelizacion` (`id_programa`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Niveles del programa de fidelización';

-- -----------------------------------------------------
-- Tabla `clientes_fidelizacion`
-- Estado de cada cliente en el programa de fidelización
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clientes_fidelizacion` (
  `id_cliente` INT NOT NULL,
  `id_programa` INT NOT NULL,
  `id_nivel` INT NULL COMMENT 'Nivel actual del cliente',
  `puntos_actuales` INT UNSIGNED DEFAULT 0 COMMENT 'Puntos acumulados y disponibles',
  `puntos_totales` INT UNSIGNED DEFAULT 0 COMMENT 'Total histórico de puntos conseguidos',
  `fecha_ultima_actividad` TIMESTAMP NULL COMMENT 'Fecha de última actividad en el programa',
  `codigo_cliente` VARCHAR(20) COMMENT 'Código único de cliente en el programa',
  `fecha_registro` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cliente`, `id_programa`),
  INDEX `fk_fidelizacion_programa_idx` (`id_programa`),
  INDEX `fk_fidelizacion_nivel_idx` (`id_nivel`),
  CONSTRAINT `fk_fidelizacion_cliente`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `clientes` (`id_cliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_fidelizacion_programa`
    FOREIGN KEY (`id_programa`)
    REFERENCES `programa_fidelizacion` (`id_programa`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_fidelizacion_nivel`
    FOREIGN KEY (`id_nivel`)
    REFERENCES `niveles_fidelizacion` (`id_nivel`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Clientes inscritos en programas de fidelización';

-- -----------------------------------------------------
-- Tabla `movimientos_puntos`
-- Registro de todos los movimientos de puntos
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `movimientos_puntos` (
  `id_movimiento` INT NOT NULL AUTO_INCREMENT,
  `id_cliente` INT NOT NULL,
  `id_programa` INT NOT NULL,
  `id_reserva` INT NULL COMMENT 'Reserva asociada (si aplica)',
  `tipo` ENUM('Ganados', 'Canjeados', 'Ajuste', 'Caducados', 'Bonus') NOT NULL COMMENT 'Tipo de movimiento',
  `puntos` INT NOT NULL COMMENT 'Cantidad de puntos (positivo o negativo)',
  `concepto` VARCHAR(200) NOT NULL COMMENT 'Descripción del movimiento',
  `fecha_movimiento` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` INT NULL COMMENT 'Usuario que registró el movimiento',
  `fecha_caducidad` DATE NULL COMMENT 'Fecha de caducidad de estos puntos',
  PRIMARY KEY (`id_movimiento`),
  INDEX `fk_movimiento_cliente_idx` (`id_cliente`),
  INDEX `fk_movimiento_programa_idx` (`id_programa`),
  INDEX `fk_movimiento_reserva_idx` (`id_reserva`),
  INDEX `fk_movimiento_usuario_idx` (`id_usuario`),
  CONSTRAINT `fk_movimiento_cliente`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `clientes` (`id_cliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_movimiento_programa`
    FOREIGN KEY (`id_programa`)
    REFERENCES `programa_fidelizacion` (`id_programa`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_movimiento_reserva`
    FOREIGN KEY (`id_reserva`)
    REFERENCES `reservas` (`id_reserva`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_movimiento_usuario`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `usuarios` (`id_usuario`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Registro de movimientos de puntos de fidelización';

-- -----------------------------------------------------
-- Tabla `promociones`
-- Gestión de promociones y ofertas especiales
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `promociones` (
  `id_promocion` INT NOT NULL AUTO_INCREMENT,
  `id_restaurante` INT NOT NULL,
  `nombre` VARCHAR(100) NOT NULL COMMENT 'Nombre de la promoción',
  `descripcion` TEXT NOT NULL COMMENT 'Descripción detallada',
  `tipo` ENUM('Descuento', 'Regalo', 'Puntos Extra', 'Evento') NOT NULL COMMENT 'Tipo de promoción',
  `valor` DECIMAL(10,2) NULL COMMENT 'Valor del descuento o beneficio',
  `fecha_inicio` DATE NOT NULL COMMENT 'Fecha de inicio de la promoción',
  `fecha_fin` DATE NOT NULL COMMENT 'Fecha de fin de la promoción',
  `hora_inicio` TIME NULL COMMENT 'Hora de inicio (opcional)',
  `hora_fin` TIME NULL COMMENT 'Hora de fin (opcional)',
  `dias_semana` VARCHAR(20) DEFAULT '1,2,3,4,5,6,0' COMMENT 'Días de la semana aplicables',
  `solo_fidelizacion` TINYINT(1) DEFAULT 0 COMMENT 'Solo para clientes del programa',
  `id_nivel_minimo` INT NULL COMMENT 'Nivel mínimo requerido',
  `maximo_usos` INT UNSIGNED NULL COMMENT 'Número máximo de usos de la promoción',
  `codigo_promocional` VARCHAR(50) NULL COMMENT 'Código para aplicar promoción',
  `activa` TINYINT(1) DEFAULT 1 COMMENT 'Indica si la promoción está activa',
  `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_promocion`),
  INDEX `fk_promocion_restaurante_idx` (`id_restaurante`),
  INDEX `fk_promocion_nivel_idx` (`id_nivel_minimo`),
  CONSTRAINT `fk_promocion_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurantes` (`id_restaurante`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_promocion_nivel`
    FOREIGN KEY (`id_nivel_minimo`)
    REFERENCES `niveles_fidelizacion` (`id_nivel`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Promociones y ofertas especiales';

-- -----------------------------------------------------
-- Tabla `uso_promociones`
-- Registro de uso de promociones
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `uso_promociones` (
  `id_uso` INT NOT NULL AUTO_INCREMENT,
  `id_promocion` INT NOT NULL,
  `id_cliente` INT NOT NULL,
  `id_reserva` INT NULL COMMENT 'Reserva donde se aplicó la promoción',
  `valor_aplicado` DECIMAL(10,2) NULL COMMENT 'Valor del beneficio aplicado',
  `fecha_uso` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `notas` TEXT COMMENT 'Observaciones sobre la aplicación',
  PRIMARY KEY (`id_uso`),
  INDEX `fk_uso_promocion_idx` (`id_promocion`),
  INDEX `fk_uso_cliente_idx` (`id_cliente`),
  INDEX `fk_uso_reserva_idx` (`id_reserva`),
  CONSTRAINT `fk_uso_promocion`
    FOREIGN KEY (`id_promocion`)
    REFERENCES `promociones` (`id_promocion`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_uso_cliente`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `clientes` (`id_cliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_uso_reserva`
    FOREIGN KEY (`id_reserva`)
    REFERENCES `reservas` (`id_reserva`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Registro de usos de promociones';

-- -----------------------------------------------------
-- Tabla `encuestas_satisfaccion`
-- Plantillas de encuestas para clientes
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `encuestas_satisfaccion` (
  `id_encuesta` INT NOT NULL AUTO_INCREMENT,
  `id_restaurante` INT NOT NULL,
  `nombre` VARCHAR(100) NOT NULL COMMENT 'Nombre descriptivo de la encuesta',
  `descripcion` TEXT COMMENT 'Descripción o instrucciones',
  `activa` TINYINT(1) DEFAULT 1 COMMENT 'Indica si la encuesta está activa',
  `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_encuesta`),
  INDEX `fk_encuesta_restaurante_idx` (`id_restaurante`),
  CONSTRAINT `fk_encuesta_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurantes` (`id_restaurante`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Configuración de encuestas de satisfacción';

-- -----------------------------------------------------
-- Tabla `preguntas_encuesta`
-- Preguntas incluidas en las encuestas
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `preguntas_encuesta` (
  `id_pregunta` INT NOT NULL AUTO_INCREMENT,
  `id_encuesta` INT NOT NULL,
  `texto` TEXT NOT NULL COMMENT 'Texto de la pregunta',
  `tipo` ENUM('Valoración', 'Si/No', 'Selección Única', 'Selección Múltiple', 'Texto Libre') NOT NULL COMMENT 'Tipo de respuesta',
  `opciones` TEXT NULL COMMENT 'Opciones para selección, separadas por "|"',
  `obligatoria` TINYINT(1) DEFAULT 0 COMMENT 'Indica si es obligatorio responder',
  `orden` INT UNSIGNED DEFAULT 1 COMMENT 'Orden de la pregunta en la encuesta',
  PRIMARY KEY (`id_pregunta`),
  INDEX `fk_pregunta_encuesta_idx` (`id_encuesta`),
  CONSTRAINT `fk_pregunta_encuesta`
    FOREIGN KEY (`id_encuesta`)
    REFERENCES `encuestas_satisfaccion` (`id_encuesta`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Preguntas incluidas en las encuestas';

-- -----------------------------------------------------
-- Tabla `encuestas_enviadas`
-- Registro de encuestas enviadas a clientes
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `encuestas_enviadas` (
  `id_envio` INT NOT NULL AUTO_INCREMENT,
  `id_encuesta` INT NOT NULL,
  `id_cliente` INT NOT NULL,
  `id_reserva` INT NULL COMMENT 'Reserva asociada',
  `codigo_acceso` VARCHAR(64) NOT NULL COMMENT 'Código único para acceder a responder',
  `fecha_envio` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `fecha_respuesta` TIMESTAMP NULL COMMENT 'Fecha cuando fue respondida',
  `completada` TINYINT(1) DEFAULT 0 COMMENT 'Indica si fue completada',
  PRIMARY KEY (`id_envio`),
  UNIQUE INDEX `idx_codigo_acceso` (`codigo_acceso`),
  INDEX `fk_envio_encuesta_idx` (`id_encuesta`),
  INDEX `fk_envio_cliente_idx` (`id_cliente`),
  INDEX `fk_envio_reserva_idx` (`id_reserva`),
  CONSTRAINT `fk_envio_encuesta`
    FOREIGN KEY (`id_encuesta`)
    REFERENCES `encuestas_satisfaccion` (`id_encuesta`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_envio_cliente`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `clientes` (`id_cliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_envio_reserva`
    FOREIGN KEY (`id_reserva`)
    REFERENCES `reservas` (`id_reserva`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Registro de encuestas enviadas a clientes';

-- -----------------------------------------------------
-- Tabla `respuestas_encuesta`
-- Respuestas dadas por los clientes a las encuestas
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `respuestas_encuesta` (
  `id_respuesta` INT NOT NULL AUTO_INCREMENT,
  `id_envio` INT NOT NULL,
  `id_pregunta` INT NOT NULL,
  `respuesta` TEXT NOT NULL COMMENT 'Contenido de la respuesta',
  `fecha_respuesta` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_respuesta`),
  INDEX `fk_respuesta_envio_idx` (`id_envio`),
  INDEX `fk_respuesta_pregunta_idx` (`id_pregunta`),
  CONSTRAINT `fk_respuesta_envio`
    FOREIGN KEY (`id_envio`)
    REFERENCES `encuestas_enviadas` (`id_envio`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_respuesta_pregunta`
    FOREIGN KEY (`id_pregunta`)
    REFERENCES `preguntas_encuesta` (`id_pregunta`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Respuestas de los clientes a las encuestas';

-- -----------------------------------------------------
-- Tabla `integraciones`
-- Configuración de integraciones con servicios externos
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `integraciones` (
  `id_integracion` INT NOT NULL AUTO_INCREMENT,
  `id_restaurante` INT NOT NULL,
  `tipo` ENUM('Google Maps', 'Facebook', 'Instagram', 'TripAdvisor', 'Google Calendar', 'iCal', 'Pasarela Pago', 'SMS', 'WhatsApp', 'API Externa') NOT NULL COMMENT 'Tipo de integración',
  `nombre` VARCHAR(100) NOT NULL COMMENT 'Nombre descriptivo de la integración',
  `api_key` VARCHAR(255) NULL COMMENT 'Clave API o similar',
  `api_secret` VARCHAR(255) NULL COMMENT 'Secret para la API',
  `url_endpoint` VARCHAR(255) NULL COMMENT 'URL del endpoint si aplica',
  `token_acceso` TEXT NULL COMMENT 'Token de acceso',
  `fecha_renovacion` TIMESTAMP NULL COMMENT 'Fecha de renovación del token',
  `configuracion` TEXT NULL COMMENT 'Configuración en formato JSON',
  `activa` TINYINT(1) DEFAULT 1 COMMENT 'Indica si la integración está activa',
  `ultima_sincronizacion` TIMESTAMP NULL COMMENT 'Última fecha de sincronización',
  `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_integracion`),
  INDEX `fk_integracion_restaurante_idx` (`id_restaurante`),
  CONSTRAINT `fk_integracion_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurantes` (`id_restaurante`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Configuración de integraciones con servicios externos';

-- -----------------------------------------------------
-- Tabla `log_sistema`
-- Registro de actividades y eventos del sistema
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `log_sistema` (
  `id_log` INT NOT NULL AUTO_INCREMENT,
  `fecha` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `tipo` ENUM('Info', 'Advertencia', 'Error', 'Debug', 'Seguridad') NOT NULL DEFAULT 'Info',
  `origen` VARCHAR(100) COMMENT 'Módulo o función origen',
  `mensaje` TEXT NOT NULL COMMENT 'Mensaje descriptivo',
  `datos_adicionales` TEXT NULL COMMENT 'Datos adicionales en formato JSON',
  `id_usuario` INT NULL COMMENT 'Usuario relacionado con la actividad',
  `ip` VARCHAR(45) NULL COMMENT 'Dirección IP',
  PRIMARY KEY (`id_log`),
  INDEX `fk_log_usuario_idx` (`id_usuario`),
  CONSTRAINT `fk_log_usuario`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `usuarios` (`id_usuario`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Registro de actividades y eventos del sistema';

-- -----------------------------------------------------
-- Tabla `estadisticas`
-- Almacena estadísticas precalculadas para agilizar consultas
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estadisticas` (
  `id_estadistica` INT NOT NULL AUTO_INCREMENT,
  `id_restaurante` INT NOT NULL,
  `categoria` VARCHAR(50) NOT NULL COMMENT 'Categoría de la estadística',
  `subcategoria` VARCHAR(50) NULL COMMENT 'Subcategoría opcional',
  `fecha_inicio` DATE NOT NULL COMMENT 'Fecha de inicio del período',
  `fecha_fin` DATE NOT NULL COMMENT 'Fecha de fin del período',
  `metrica` VARCHAR(50) NOT NULL COMMENT 'Nombre de la métrica',
  `valor` DECIMAL(15,2) NOT NULL COMMENT 'Valor numérico',
  `unidad` VARCHAR(20) NULL COMMENT 'Unidad de medida si aplica',
  `fecha_calculo` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de cálculo',
  PRIMARY KEY (`id_estadistica`),
  INDEX `fk_estadistica_restaurante_idx` (`id_restaurante`),
  INDEX `idx_estadistica_periodo` (`fecha_inicio`, `fecha_fin`),
  CONSTRAINT `fk_estadistica_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurantes` (`id_restaurante`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Estadísticas precalculadas del sistema';

-- -----------------------------------------------------
-- Procedimiento: actualizarEstadoReserva
-- Actualiza el estado de una reserva y registra el cambio
-- -----------------------------------------------------
DELIMITER //
CREATE PROCEDURE  `actualizarEstadoReserva`(
  IN p_id_reserva INT,
  IN p_id_estado INT,
  IN p_id_usuario INT,
  IN p_motivo TEXT
)
BEGIN
  -- Actualizar estado en la tabla de reservas
  UPDATE `reservas` 
  SET `id_estado` = p_id_estado, 
      `fecha_actualizacion` = CURRENT_TIMESTAMP
  WHERE `id_reserva` = p_id_reserva;
  
  -- Registrar en el historial de estados
  INSERT INTO `historial_estados_reserva` 
    (`id_reserva`, `id_estado`, `id_usuario`, `motivo`)
  VALUES 
    (p_id_reserva, p_id_estado, p_id_usuario, p_motivo);
    
  -- Si el estado es "Completada", actualizar la última visita del cliente
  IF p_id_estado = 5 THEN
    UPDATE `clientes` c
    JOIN `reservas` r ON c.`id_cliente` = r.`id_cliente`
    SET c.`ultima_visita` = CURRENT_TIMESTAMP
    WHERE r.`id_reserva` = p_id_reserva;
  END IF;
END//
DELIMITER ;

-- -----------------------------------------------------
-- Vista: vw_disponibilidad_mesas
-- Muestra información de disponibilidad de mesas
-- -----------------------------------------------------
CREATE OR REPLACE VIEW `vw_disponibilidad_mesas` AS
SELECT 
  m.`id_mesa`,
  m.`id_restaurante`,
  m.`id_zona`,
  m.`numero`,
  m.`capacidad_minima`,
  m.`capacidad_maxima`,
  z.`nombre` AS `zona_nombre`,
  r.`nombre` AS `restaurante_nombre`,
  IF(m.`activa` = 0, 'Inactiva', 
    IF(EXISTS(SELECT 1 FROM `bloqueos_disponibilidad` b 
              WHERE (b.`id_mesa` = m.`id_mesa` OR b.`id_zona` = m.`id_zona`) 
              AND CURRENT_DATE BETWEEN b.`fecha_inicio` AND b.`fecha_fin`
              AND (b.`hora_inicio` IS NULL OR 
                  (CURRENT_TIME BETWEEN b.`hora_inicio` AND b.`hora_fin`))
             ), 'Bloqueada', 'Disponible')) AS `estado_actual`
FROM `mesas` m
JOIN `zonas` z ON m.`id_zona` = z.`id_zona`
JOIN `restaurantes` r ON m.`id_restaurante` = r.`id_restaurante`;

-- -----------------------------------------------------
-- Vista: vw_reservas_dia
-- Muestra las reservas para el día actual con información completa
-- -----------------------------------------------------
CREATE OR REPLACE VIEW `vw_reservas_dia` AS
SELECT 
  r.`id_reserva`,
  r.`id_restaurante`,
  re.`nombre` AS `restaurante_nombre`,
  r.`codigo_reserva`,
  r.`fecha_reserva`,
  r.`hora_inicio`,
  r.`hora_fin`,
  r.`num_comensales`,
  c.`nombre` AS `cliente_nombre`,
  c.`apellidos` AS `cliente_apellidos`,
  c.`telefono` AS `cliente_telefono`,
  c.`email` AS `cliente_email`,
  r.`nombre_reserva`,
  r.`observaciones`,
  e.`nombre` AS `estado_nombre`,
  e.`color` AS `estado_color`,
  GROUP_CONCAT(DISTINCT m.`numero` ORDER BY m.`numero` SEPARATOR ', ') AS `mesas_asignadas`,
  GROUP_CONCAT(DISTINCT z.`nombre` ORDER BY z.`nombre` SEPARATOR ', ') AS `zonas`
FROM `reservas` r
JOIN `clientes` c ON r.`id_cliente` = c.`id_cliente`
JOIN `restaurantes` re ON r.`id_restaurante` = re.`id_restaurante`
JOIN `estados_reserva` e ON r.`id_estado` = e.`id_estado`
LEFT JOIN `reservas_mesas` rm ON r.`id_reserva` = rm.`id_reserva`
LEFT JOIN `mesas` m ON rm.`id_mesa` = m.`id_mesa`
LEFT JOIN `zonas` z ON m.`id_zona` = z.`id_zona`
WHERE r.`fecha_reserva` = CURRENT_DATE
GROUP BY r.`id_reserva`;

-- -----------------------------------------------------
-- Vista: vw_clientes_fidelizados
-- Muestra información de clientes con su nivel y puntos de fidelización
-- -----------------------------------------------------
CREATE OR REPLACE VIEW `vw_clientes_fidelizados` AS
SELECT 
  c.`id_cliente`,
  c.`nombre`,
  c.`apellidos`,
  c.`email`,
  c.`telefono`,
  c.`ultima_visita`,
  cf.`id_programa`,
  p.`nombre` AS `programa_nombre`,
  cf.`puntos_actuales`,
  cf.`puntos_totales`,
  nf.`id_nivel`,
  nf.`nombre` AS `nivel_nombre`,
  nf.`color` AS `nivel_color`,
  r.`id_restaurante`,
  r.`nombre` AS `restaurante_nombre`,
  COUNT(DISTINCT re.`id_reserva`) AS `total_reservas`,
  MAX(re.`fecha_reserva`) AS `ultima_reserva`
FROM `clientes` c
JOIN `clientes_fidelizacion` cf ON c.`id_cliente` = cf.`id_cliente`
JOIN `programa_fidelizacion` p ON cf.`id_programa` = p.`id_programa`
LEFT JOIN `niveles_fidelizacion` nf ON cf.`id_nivel` = nf.`id_nivel`
JOIN `restaurantes` r ON p.`id_restaurante` = r.`id_restaurante`
LEFT JOIN `reservas` re ON c.`id_cliente` = re.`id_cliente` AND re.`id_restaurante` = r.`id_restaurante` AND re.`id_estado` = 5
GROUP BY c.`id_cliente`, cf.`id_programa`;

-- -----------------------------------------------------
-- Índices adicionales para optimizar rendimiento
-- -----------------------------------------------------
ALTER TABLE `reservas` ADD INDEX `idx_reservas_fecha_estado` (`fecha_reserva`, `id_estado`);
ALTER TABLE `clientes` ADD INDEX `idx_clientes_nombre_apellidos` (`nombre`, `apellidos`);
ALTER TABLE `mesas` ADD INDEX `idx_mesas_capacidad` (`capacidad_minima`, `capacidad_maxima`);
ALTER TABLE `usuarios` ADD INDEX `idx_usuarios_tipo_activo` (`tipo_usuario`, `activo`);

-- Trigger: actualizar_puntos_al_completar_reserva
DELIMITER //
CREATE TRIGGER IF NOT EXISTS `tgr_actualizar_puntos_al_completar_reserva`
AFTER UPDATE ON `reservas`
FOR EACH ROW
BEGIN
    DECLARE v_id_programa INT;
    DECLARE v_puntos INT;
    DECLARE v_multiplicador DECIMAL(3,2);
    DECLARE v_concepto VARCHAR(200);
    DECLARE v_dias_caducidad INT;

    -- Si la reserva cambió a estado "Completada" (id=5) y antes no lo estaba
    IF NEW.`id_estado` = 5 AND OLD.`id_estado` != 5 THEN
        SELECT pf.`id_programa`, pf.`puntos_por_reserva`,
               nf.`multiplicador_puntos`, pf.`dias_caducidad`
        INTO   v_id_programa, v_puntos, v_multiplicador, v_dias_caducidad
        FROM `programa_fidelizacion` pf
        LEFT JOIN `clientes_fidelizacion` cf
               ON pf.`id_programa` = cf.`id_programa`
              AND cf.`id_cliente`  = NEW.`id_cliente`
        LEFT JOIN `niveles_fidelizacion` nf
               ON cf.`id_nivel` = nf.`id_nivel`
        WHERE pf.`id_restaurante` = NEW.`id_restaurante`
          AND pf.`activo` = 1
        LIMIT 1;

        IF v_id_programa IS NOT NULL AND v_puntos > 0 THEN
            IF v_multiplicador IS NULL THEN
                SET v_multiplicador = 1.00;
            END IF;
            SET v_puntos = ROUND(v_puntos * v_multiplicador);
            SET v_concepto = CONCAT('Reserva completada #', NEW.`codigo_reserva`, ' - ',
                                    DATE_FORMAT(NEW.`fecha_reserva`, '%d/%m/%Y'));

            INSERT INTO `movimientos_puntos` (
                `id_cliente`, `id_programa`, `id_reserva`, `tipo`, `puntos`, `concepto`, `fecha_caducidad`
            ) VALUES (
                NEW.`id_cliente`, v_id_programa, NEW.`id_reserva`, 'Ganados', v_puntos,
                v_concepto, DATE_ADD(CURRENT_DATE, INTERVAL v_dias_caducidad DAY)
            );

            INSERT INTO `clientes_fidelizacion` (
                `id_cliente`, `id_programa`, `puntos_actuales`,
                `puntos_totales`, `fecha_ultima_actividad`
            ) VALUES (
                NEW.`id_cliente`, v_id_programa, v_puntos, v_puntos, CURRENT_TIMESTAMP
            )
            ON DUPLICATE KEY UPDATE
                `puntos_actuales`     = `puntos_actuales` + v_puntos,
                `puntos_totales`      = `puntos_totales` + v_puntos,
                `fecha_ultima_actividad` = CURRENT_TIMESTAMP;

            -- Comprobar si el cliente debe subir de nivel
            CALL actualizarNivelCliente(NEW.`id_cliente`, v_id_programa);
        END IF;
    END IF;
END//
DELIMITER ;


-- -----------------------------------------------------
-- Procedimiento: actualizarNivelCliente
-- Actualiza el nivel de un cliente en base a sus puntos totales
-- -----------------------------------------------------
DELIMITER //
CREATE PROCEDURE  `actualizarNivelCliente`(
  IN p_id_cliente INT,
  IN p_id_programa INT
)
BEGIN
  DECLARE v_puntos_totales INT;
  DECLARE v_id_nivel_actual INT;
  DECLARE v_id_nivel_nuevo INT;
  
  -- Obtener puntos actuales y nivel actual
  SELECT `puntos_totales`, `id_nivel`
  INTO v_puntos_totales, v_id_nivel_actual
  FROM `clientes_fidelizacion`
  WHERE `id_cliente` = p_id_cliente AND `id_programa` = p_id_programa;
  
  -- Buscar si corresponde un nuevo nivel
  SELECT `id_nivel` 
  INTO v_id_nivel_nuevo
  FROM `niveles_fidelizacion`
  WHERE `id_programa` = p_id_programa AND `puntos_necesarios` <= v_puntos_totales AND `activo` = 1
  ORDER BY `puntos_necesarios` DESC
  LIMIT 1;
  
  -- Si hay un nuevo nivel y es diferente al actual, actualizar
  IF v_id_nivel_nuevo IS NOT NULL AND (v_id_nivel_actual IS NULL OR v_id_nivel_nuevo != v_id_nivel_actual) THEN
    UPDATE `clientes_fidelizacion`
    SET `id_nivel` = v_id_nivel_nuevo
    WHERE `id_cliente` = p_id_cliente AND `id_programa` = p_id_programa;
    
    -- Registrar el cambio de nivel en el historial (opcional)
    INSERT INTO `log_sistema` (
      `tipo`, 
      `origen`, 
      `mensaje`, 
      `datos_adicionales`
    ) VALUES (
      'Info', 
      'Sistema Fidelización', 
      CONCAT('Cliente ID ', p_id_cliente, ' subió al nivel ID ', v_id_nivel_nuevo),
      JSON_OBJECT(
        'id_cliente', p_id_cliente,
        'id_programa', p_id_programa,
        'nivel_anterior', v_id_nivel_actual,
        'nivel_nuevo', v_id_nivel_nuevo,
        'puntos_totales', v_puntos_totales
      )
    );
  END IF;
END//
DELIMITER ;

-- -----------------------------------------------------
-- Trigger: verificar_disponibilidad_mesa
-- Verifica que una mesa no esté ya reservada en el mismo horario
-- -----------------------------------------------------
DELIMITER //
CREATE TRIGGER IF NOT EXISTS `tgr_verificar_disponibilidad_mesa`
BEFORE INSERT ON `reservas_mesas`
FOR EACH ROW
BEGIN
  DECLARE v_fecha_reserva DATE;
  DECLARE v_hora_inicio TIME;
  DECLARE v_hora_fin TIME;
  DECLARE v_conflicto_count INT;
  
  -- Obtener datos de la reserva
  SELECT `fecha_reserva`, `hora_inicio`, `hora_fin` 
  INTO v_fecha_reserva, v_hora_inicio, v_hora_fin
  FROM `reservas` WHERE `id_reserva` = NEW.`id_reserva`;
  
  -- Verificar si la mesa ya está asignada a otra reserva en el mismo horario
  SELECT COUNT(*)
  INTO v_conflicto_count
  FROM `reservas` r
  JOIN `reservas_mesas` rm ON r.`id_reserva` = rm.`id_reserva`
  WHERE rm.`id_mesa` = NEW.`id_mesa`
    AND r.`fecha_reserva` = v_fecha_reserva
    AND r.`id_estado` IN (1, 2) -- Solo reservas pendientes o confirmadas
    AND r.`id_reserva` != NEW.`id_reserva`
    AND (
      (v_hora_inicio BETWEEN r.`hora_inicio` AND r.`hora_fin`) OR
      (v_hora_fin BETWEEN r.`hora_inicio` AND r.`hora_fin`) OR
      (r.`hora_inicio` BETWEEN v_hora_inicio AND v_hora_fin)
    );
  
  -- Si hay conflicto, cancelar la inserción
  IF v_conflicto_count > 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'La mesa ya está reservada en ese horario';
  END IF;
  
  -- Verificar si la mesa está bloqueada
  SELECT COUNT(*)
  INTO v_conflicto_count
  FROM `bloqueos_disponibilidad` b
  JOIN `mesas` m ON b.`id_mesa` = m.`id_mesa` OR (b.`id_zona` = m.`id_zona` AND b.`id_mesa` IS NULL)
  WHERE m.`id_mesa` = NEW.`id_mesa`
    AND v_fecha_reserva BETWEEN b.`fecha_inicio` AND b.`fecha_fin`
    AND (b.`hora_inicio` IS NULL OR 
         (v_hora_inicio BETWEEN b.`hora_inicio` AND b.`hora_fin`) OR
         (v_hora_fin BETWEEN b.`hora_inicio` AND b.`hora_fin`));
  
  -- Si la mesa está bloqueada, cancelar la inserción
  IF v_conflicto_count > 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'La mesa está bloqueada en ese horario';
  END IF;
END//
DELIMITER ;

-- -----------------------------------------------------
-- Procedimiento: buscarMesasDisponibles
-- Busca mesas disponibles según criterios específicos
-- -----------------------------------------------------
DELIMITER //
CREATE PROCEDURE  `buscarMesasDisponibles`(
  IN p_id_restaurante INT,
  IN p_fecha DATE,
  IN p_hora_inicio TIME,
  IN p_hora_fin TIME,
  IN p_num_comensales INT,
  IN p_id_zona INT
)
BEGIN
  -- Mesas individuales disponibles
  SELECT m.`id_mesa`, m.`numero`, m.`capacidad_maxima`, z.`nombre` AS `zona_nombre`
  FROM `mesas` m
  JOIN `zonas` z ON m.`id_zona` = z.`id_zona`
  WHERE m.`id_restaurante` = p_id_restaurante
    AND m.`activa` = 1
    AND m.`capacidad_minima` <= p_num_comensales AND m.`capacidad_maxima` >= p_num_comensales
    AND (p_id_zona IS NULL OR m.`id_zona` = p_id_zona)
    AND NOT EXISTS (
      SELECT 1 FROM `bloqueos_disponibilidad` b
      WHERE (b.`id_mesa` = m.`id_mesa` OR (b.`id_zona` = m.`id_zona` AND b.`id_mesa` IS NULL))
        AND p_fecha BETWEEN b.`fecha_inicio` AND b.`fecha_fin`
        AND (b.`hora_inicio` IS NULL OR 
             (p_hora_inicio BETWEEN b.`hora_inicio` AND b.`hora_fin`) OR
             (p_hora_fin BETWEEN b.`hora_inicio` AND b.`hora_fin`) OR
             (b.`hora_inicio` BETWEEN p_hora_inicio AND p_hora_fin))
    )
    AND NOT EXISTS (
      SELECT 1 FROM `reservas` r
      JOIN `reservas_mesas` rm ON r.`id_reserva` = rm.`id_reserva`
      WHERE rm.`id_mesa` = m.`id_mesa`
        AND r.`fecha_reserva` = p_fecha
        AND r.`id_estado` IN (1, 2) -- Pendiente o confirmada
        AND (
          (p_hora_inicio BETWEEN r.`hora_inicio` AND r.`hora_fin`) OR
          (p_hora_fin BETWEEN r.`hora_inicio` AND r.`hora_fin`) OR
          (r.`hora_inicio` BETWEEN p_hora_inicio AND p_hora_fin)
        )
    )
  ORDER BY ABS(m.`capacidad_maxima` - p_num_comensales), m.`id_zona`;
  
  -- Combinaciones de mesas disponibles
  SELECT mc.`id_combinacion`, mc.`nombre`, mc.`capacidad_total`,
         GROUP_CONCAT(m.`numero` ORDER BY m.`numero` SEPARATOR ', ') AS `mesas_combinadas`
  FROM `mesas_combinadas` mc
  JOIN `mesas_combinadas_detalle` mcd ON mc.`id_combinacion` = mcd.`id_combinacion`
  JOIN `mesas` m ON mcd.`id_mesa` = m.`id_mesa`
  WHERE mc.`id_restaurante` = p_id_restaurante
    AND mc.`activa` = 1
    AND mc.`capacidad_total` >= p_num_comensales
    AND NOT EXISTS (
      SELECT 1 FROM `mesas_combinadas_detalle` mcd2
      JOIN `mesas` m2 ON mcd2.`id_mesa` = m2.`id_mesa`
      WHERE mcd2.`id_combinacion` = mc.`id_combinacion`
        AND (
          (p_id_zona IS NOT NULL AND m2.`id_zona` != p_id_zona) OR
          EXISTS (
            SELECT 1 FROM `bloqueos_disponibilidad` b
            WHERE (b.`id_mesa` = m2.`id_mesa` OR (b.`id_zona` = m2.`id_zona` AND b.`id_mesa` IS NULL))
              AND p_fecha BETWEEN b.`fecha_inicio` AND b.`fecha_fin`
              AND (b.`hora_inicio` IS NULL OR 
                  (p_hora_inicio BETWEEN b.`hora_inicio` AND b.`hora_fin`) OR
                  (p_hora_fin BETWEEN b.`hora_inicio` AND b.`hora_fin`) OR
                  (b.`hora_inicio` BETWEEN p_hora_inicio AND p_hora_fin))
          ) OR
          EXISTS (
            SELECT 1 FROM `reservas` r
            JOIN `reservas_mesas` rm ON r.`id_reserva` = rm.`id_reserva`
            WHERE rm.`id_mesa` = m2.`id_mesa`
              AND r.`fecha_reserva` = p_fecha
              AND r.`id_estado` IN (1, 2) -- Pendiente o confirmada
              AND (
                (p_hora_inicio BETWEEN r.`hora_inicio` AND r.`hora_fin`) OR
                (p_hora_fin BETWEEN r.`hora_inicio` AND r.`hora_fin`) OR
                (r.`hora_inicio` BETWEEN p_hora_inicio AND p_hora_fin)
              )
          )
        )
    )
  GROUP BY mc.`id_combinacion`
  ORDER BY ABS(mc.`capacidad_total` - p_num_comensales);
END//
DELIMITER ;

-- -----------------------------------------------------
-- Procedimiento: generarCodigoReserva
-- Genera un código único para una nueva reserva
-- -----------------------------------------------------
DELIMITER //
CREATE PROCEDURE  `generarCodigoReserva`(
  IN p_id_restaurante INT,
  OUT p_codigo VARCHAR(20)
)
BEGIN
  DECLARE v_existe INT DEFAULT 1;
  DECLARE v_prefix VARCHAR(3);
  DECLARE v_random VARCHAR(8);
  
  -- Obtener prefijo del restaurante (primeras 3 letras del nombre)
  SELECT UPPER(SUBSTRING(REPLACE(nombre, ' ', ''), 1, 3)) INTO v_prefix
  FROM `restaurantes` WHERE `id_restaurante` = p_id_restaurante;
  
  -- Si no hay prefijo, usar 'RSV'
  IF v_prefix IS NULL THEN
    SET v_prefix = 'RSV';
  END IF;
  
  -- Generar código único
  WHILE v_existe > 0 DO
    -- Combinar fecha actual (YYMMDD) con números aleatorios
    SET v_random = CONCAT(
      DATE_FORMAT(CURRENT_DATE, '%y%m%d'),
      LPAD(FLOOR(RAND() * 1000), 3, '0')
    );
    
    SET p_codigo = CONCAT(v_prefix, '-', v_random);
    
    -- Verificar que no exista
    SELECT COUNT(*) INTO v_existe 
    FROM `reservas` WHERE `codigo_reserva` = p_codigo;
  END WHILE;
END//
DELIMITER ;

-- -----------------------------------------------------
-- Procedimiento: crearReserva
-- Crea una nueva reserva completa con asignación de mesa
-- -----------------------------------------------------
DELIMITER //
CREATE PROCEDURE  `crearReserva`(
  IN p_id_restaurante INT,
  IN p_id_cliente INT,
  IN p_id_turno INT,
  IN p_fecha_reserva DATE,
  IN p_hora_inicio TIME,
  IN p_num_comensales INT,
  IN p_nombre_reserva VARCHAR(100),
  IN p_observaciones TEXT,
  IN p_origen ENUM('Web', 'App', 'Teléfono', 'Presencial', 'Otro'),
  IN p_id_usuario_creador INT,
  OUT p_id_reserva INT,
  OUT p_codigo_reserva VARCHAR(20)
)
BEGIN
  DECLARE v_hora_fin TIME;
  DECLARE v_duracion INT;
  DECLARE v_id_mesa INT;
  DECLARE v_error VARCHAR(255);
  
  -- Obtener la duración estándar del turno o usar valor predeterminado
  IF p_id_turno IS NULL THEN
    SELECT `tiempo_entre_reservas` * 3 INTO v_duracion
    FROM `restaurantes` WHERE `id_restaurante` = p_id_restaurante;
    
    IF v_duracion IS NULL THEN SET v_duracion = 90; END IF;
  ELSE
    SELECT `duracion_estandar` INTO v_duracion
    FROM `turnos_servicio` WHERE `id_turno` = p_id_turno;
  END IF;
  
  -- Calcular hora de fin
  SET v_hora_fin = ADDTIME(p_hora_inicio, SEC_TO_TIME(v_duracion * 60));
  
  -- Generar código de reserva
  CALL generarCodigoReserva(p_id_restaurante, p_codigo_reserva);
  
  -- Crear la reserva
  INSERT INTO `reservas` (
    `id_restaurante`,
    `id_cliente`,
    `id_turno`,
    `id_estado`,
    `id_usuario_creador`,
    `fecha_reserva`,
    `hora_inicio`,
    `hora_fin`,
    `num_comensales`,
    `nombre_reserva`,
    `observaciones`,
    `codigo_reserva`,
    `origen`
  ) VALUES (
    p_id_restaurante,
    p_id_cliente,
    p_id_turno,
    1, -- Estado: Pendiente
    p_id_usuario_creador,
    p_fecha_reserva,
    p_hora_inicio,
    v_hora_fin,
    p_num_comensales,
    p_nombre_reserva,
    p_observaciones,
    p_codigo_reserva,
    p_origen
  );
  
  SET p_id_reserva = LAST_INSERT_ID();
  
  -- Buscar mesa disponible (la más adecuada al número de comensales)
  SELECT m.`id_mesa` INTO v_id_mesa
  FROM `mesas` m
  JOIN `zonas` z ON m.`id_zona` = z.`id_zona`
  WHERE m.`id_restaurante` = p_id_restaurante
    AND m.`activa` = 1
    AND m.`capacidad_minima` <= p_num_comensales 
    AND m.`capacidad_maxima` >= p_num_comensales
    AND NOT EXISTS (
      SELECT 1 FROM `bloqueos_disponibilidad` b
      WHERE (b.`id_mesa` = m.`id_mesa` OR (b.`id_zona` = m.`id_zona` AND b.`id_mesa` IS NULL))
        AND p_fecha_reserva BETWEEN b.`fecha_inicio` AND b.`fecha_fin`
        AND (b.`hora_inicio` IS NULL OR 
             (p_hora_inicio BETWEEN b.`hora_inicio` AND b.`hora_fin`) OR
             (v_hora_fin BETWEEN b.`hora_inicio` AND b.`hora_fin`) OR
             (b.`hora_inicio` BETWEEN p_hora_inicio AND v_hora_fin))
    )
    AND NOT EXISTS (
      SELECT 1 FROM `reservas` r
      JOIN `reservas_mesas` rm ON r.`id_reserva` = rm.`id_reserva`
      WHERE rm.`id_mesa` = m.`id_mesa`
        AND r.`fecha_reserva` = p_fecha_reserva
        AND r.`id_estado` IN (1, 2) -- Pendiente o confirmada
        AND (
          (p_hora_inicio BETWEEN r.`hora_inicio` AND r.`hora_fin`) OR
          (v_hora_fin BETWEEN r.`hora_inicio` AND r.`hora_fin`) OR
          (r.`hora_inicio` BETWEEN p_hora_inicio AND v_hora_fin)
        )
    )
  ORDER BY ABS(m.`capacidad_maxima` - p_num_comensales)
  LIMIT 1;
  
  -- Si no se encuentra una mesa individual, buscar combinaciones disponibles
  IF v_id_mesa IS NULL THEN
    -- Intentar encontrar la mejor combinación de mesas
    SELECT m.`id_mesa` INTO v_id_mesa
    FROM `mesas_combinadas` mc
    JOIN `mesas_combinadas_detalle` mcd ON mc.`id_combinacion` = mcd.`id_combinacion`
    JOIN `mesas` m ON mcd.`id_mesa` = m.`id_mesa`
    WHERE mc.`id_restaurante` = p_id_restaurante
      AND mc.`activa` = 1
      AND mc.`capacidad_total` >= p_num_comensales
      AND NOT EXISTS (
        SELECT 1 FROM `mesas_combinadas_detalle` mcd2
        JOIN `mesas` m2 ON mcd2.`id_mesa` = m2.`id_mesa`
        WHERE mcd2.`id_combinacion` = mc.`id_combinacion`
          AND (
            EXISTS (
              SELECT 1 FROM `bloqueos_disponibilidad` b
              WHERE (b.`id_mesa` = m2.`id_mesa` OR (b.`id_zona` = m2.`id_zona` AND b.`id_mesa` IS NULL))
                AND p_fecha_reserva BETWEEN b.`fecha_inicio` AND b.`fecha_fin`
                AND (b.`hora_inicio` IS NULL OR 
                    (p_hora_inicio BETWEEN b.`hora_inicio` AND b.`hora_fin`) OR
                    (v_hora_fin BETWEEN b.`hora_inicio` AND b.`hora_fin`) OR
                    (b.`hora_inicio` BETWEEN p_hora_inicio AND v_hora_fin))
            ) OR
            EXISTS (
              SELECT 1 FROM `reservas` r
              JOIN `reservas_mesas` rm ON r.`id_reserva` = rm.`id_reserva`
              WHERE rm.`id_mesa` = m2.`id_mesa`
                AND r.`fecha_reserva` = p_fecha_reserva
                AND r.`id_estado` IN (1, 2) -- Pendiente o confirmada
                AND (
                  (p_hora_inicio BETWEEN r.`hora_inicio` AND r.`hora_fin`) OR
                  (v_hora_fin BETWEEN r.`hora_inicio` AND r.`hora_fin`) OR
                  (r.`hora_inicio` BETWEEN p_hora_inicio AND v_hora_fin)
                )
            )
          )
      )
    ORDER BY ABS(mc.`capacidad_total` - p_num_comensales)
    LIMIT 1;
    
    IF v_id_mesa IS NULL THEN
      -- Si no se encuentra ninguna mesa disponible, cancelar la reserva
      UPDATE `reservas` SET `id_estado` = 4 -- Cancelada por restaurante
      WHERE `id_reserva` = p_id_reserva;
      
      -- Registrar en el historial
      INSERT INTO `historial_estados_reserva` 
        (`id_reserva`, `id_estado`, `id_usuario`, `motivo`)
      VALUES 
        (p_id_reserva, 4, p_id_usuario_creador, 'No hay mesas disponibles para esta reserva');
        
      SET v_error = 'No hay mesas disponibles para esta reserva';
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error;
    ELSE
      -- Asignar todas las mesas de la combinación
      INSERT INTO `reservas_mesas` (`id_reserva`, `id_mesa`)
      SELECT p_id_reserva, mcd.`id_mesa`
      FROM `mesas_combinadas` mc
      JOIN `mesas_combinadas_detalle` mcd ON mc.`id_combinacion` = mcd.`id_combinacion`
      WHERE mc.`id_combinacion` = (
        SELECT mc2.`id_combinacion`
        FROM `mesas_combinadas` mc2
        JOIN `mesas_combinadas_detalle` mcd2 ON mc2.`id_combinacion` = mcd2.`id_combinacion`
        WHERE mcd2.`id_mesa` = v_id_mesa
        LIMIT 1
      );
    END IF;
  ELSE
    -- Asignar la mesa individual
    INSERT INTO `reservas_mesas` (`id_reserva`, `id_mesa`) VALUES (p_id_reserva, v_id_mesa);
  END IF;
  
  -- Registrar en el historial
  INSERT INTO `historial_estados_reserva` 
    (`id_reserva`, `id_estado`, `id_usuario`, `motivo`)
  VALUES 
    (p_id_reserva, 1, p_id_usuario_creador, 'Reserva creada');
    
  -- Actualizar fecha de última visita prevista del cliente
  UPDATE `clientes` 
  SET `ultima_visita` = p_fecha_reserva
  WHERE `id_cliente` = p_id_cliente;
END//
DELIMITER ;

-- -----------------------------------------------------
-- Tabla `app_dispositivos`
-- Almacena información de los dispositivos móviles para la app
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `app_dispositivos` (
  `id_dispositivo` INT NOT NULL AUTO_INCREMENT,
  `id_cliente` INT NULL COMMENT 'Cliente asociado al dispositivo (puede ser NULL para usuarios anónimos)',
  `token_dispositivo` VARCHAR(255) NOT NULL COMMENT 'Token único del dispositivo para notificaciones push',
  `plataforma` ENUM('iOS', 'Android', 'Web') NOT NULL COMMENT 'Plataforma del dispositivo',
  `version_app` VARCHAR(20) COMMENT 'Versión de la aplicación instalada',
  `idioma` VARCHAR(10) DEFAULT 'es' COMMENT 'Idioma preferido del usuario',
  `ultimo_acceso` TIMESTAMP NULL COMMENT 'Fecha y hora del último acceso',
  `fecha_registro` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `activo` TINYINT(1) DEFAULT 1 COMMENT 'Indica si el dispositivo está activo',
  PRIMARY KEY (`id_dispositivo`),
  UNIQUE INDEX `idx_token_dispositivo` (`token_dispositivo`),
  INDEX `fk_dispositivo_cliente_idx` (`id_cliente`),
  CONSTRAINT `fk_dispositivo_cliente`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `clientes` (`id_cliente`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Dispositivos móviles registrados para la app';

-- -----------------------------------------------------
-- Tabla `configuracion_app`
-- Configuración específica para la app móvil
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `configuracion_app` (
  `id_configuracion` INT NOT NULL AUTO_INCREMENT,
  `id_restaurante` INT NOT NULL,
  `clave` VARCHAR(100) NOT NULL COMMENT 'Clave de configuración',
  `valor` TEXT COMMENT 'Valor de la configuración',
  `descripcion` TEXT COMMENT 'Descripción de la configuración',
  `activo` TINYINT(1) DEFAULT 1 COMMENT 'Indica si la configuración está activa',
  `fecha_actualizacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_configuracion`),
  UNIQUE INDEX `idx_config_app_clave` (`id_restaurante`, `clave`),
  CONSTRAINT `fk_config_app_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurantes` (`id_restaurante`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Configuraciones específicas para la app móvil';

-- -----------------------------------------------------
-- Tabla `categorias_menu`
-- Categorías para los platos del restaurante
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `categorias_menu` (
  `id_categoria` INT NOT NULL AUTO_INCREMENT,
  `id_restaurante` INT NOT NULL,
  `nombre` VARCHAR(100) NOT NULL COMMENT 'Nombre de la categoría',
  `descripcion` TEXT COMMENT 'Descripción de la categoría',
  `imagen` VARCHAR(255) COMMENT 'Imagen representativa',
  `orden` INT UNSIGNED DEFAULT 1 COMMENT 'Orden de visualización',
  `activo` TINYINT(1) DEFAULT 1 COMMENT 'Indica si la categoría está activa',
  PRIMARY KEY (`id_categoria`),
  INDEX `fk_categoria_restaurante_idx` (`id_restaurante`),
  CONSTRAINT `fk_categoria_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurantes` (`id_restaurante`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Categorías de platos del restaurante';

-- -----------------------------------------------------
-- Tabla `platos`
-- Platos disponibles en el menú del restaurante
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `platos` (
  `id_plato` INT NOT NULL AUTO_INCREMENT,
  `id_restaurante` INT NOT NULL,
  `id_categoria` INT NOT NULL,
  `nombre` VARCHAR(150) NOT NULL COMMENT 'Nombre del plato',
  `descripcion` TEXT COMMENT 'Descripción detallada',
  `ingredientes` TEXT COMMENT 'Lista de ingredientes principales',
  `alergenos` TEXT COMMENT 'Información sobre alérgenos',
  `precio` DECIMAL(10,2) NOT NULL COMMENT 'Precio de venta',
  `imagen` VARCHAR(255) COMMENT 'URL de la imagen del plato',
  `tiempo_preparacion` INT UNSIGNED COMMENT 'Tiempo estimado de preparación en minutos',
  `es_vegano` TINYINT(1) DEFAULT 0 COMMENT '¿Es una opción vegana?',
  `es_vegetariano` TINYINT(1) DEFAULT 0 COMMENT '¿Es una opción vegetariana?',
  `es_sin_gluten` TINYINT(1) DEFAULT 0 COMMENT '¿Es sin gluten?',
  `es_picante` TINYINT(1) DEFAULT 0 COMMENT '¿Es picante?',
  `es_nuevo` TINYINT(1) DEFAULT 0 COMMENT '¿Es un plato nuevo en el menú?',
  `es_mas_vendido` TINYINT(1) DEFAULT 0 COMMENT '¿Es uno de los platos más vendidos?',
  `activo` TINYINT(1) DEFAULT 1 COMMENT '¿Está disponible actualmente?',
  `orden` INT UNSIGNED DEFAULT 1 COMMENT 'Orden de visualización en el menú',
  `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_plato`),
  INDEX `fk_plato_restaurante_idx` (`id_restaurante`),
  INDEX `fk_plato_categoria_idx` (`id_categoria`),
  CONSTRAINT `fk_plato_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurantes` (`id_restaurante`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_plato_categoria`
    FOREIGN KEY (`id_categoria`)
    REFERENCES `categorias_menu` (`id_categoria`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Platos disponibles en el menú del restaurante';

CREATE TABLE IF NOT EXISTS `menus` (
  `id_menu` INT NOT NULL AUTO_INCREMENT,
  `id_restaurante` INT NOT NULL,
  `nombre` VARCHAR(100) NOT NULL COMMENT 'Nombre del menú (ej. Menú del día, Carta principal)',
  `descripcion` TEXT COMMENT 'Descripción del menú',
  `tipo` ENUM('Carta', 'Menú del día', 'Degustación', 'Infantil', 'Especial', 'Otro') NOT NULL DEFAULT 'Carta',
  `hora_inicio` TIME NULL COMMENT 'Hora de inicio de disponibilidad',
  `hora_fin` TIME NULL COMMENT 'Hora de fin de disponibilidad',
  `dias_semana` VARCHAR(20) DEFAULT '1,2,3,4,5,6,0' COMMENT 'Días de la semana aplicables (0=Domingo, 1=Lunes...)',
  `precio_fijo` DECIMAL(10,2) NULL COMMENT 'Precio fijo si aplica',
  `activo` TINYINT(1) DEFAULT 1 COMMENT 'Indica si el menú está activo',
  `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_menu`),
  INDEX `fk_menu_restaurante_idx` (`id_restaurante`),
  CONSTRAINT `fk_menu_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurantes` (`id_restaurante`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Menús disponibles en el restaurante';

CREATE TABLE IF NOT EXISTS `menu_platos` (
  `id_menu` INT NOT NULL,
  `id_plato` INT NOT NULL,
  `id_categoria` INT NOT NULL COMMENT 'Categoría dentro de este menú (puede ser diferente a la categoría principal del plato)',
  `orden` INT UNSIGNED DEFAULT 1 COMMENT 'Orden de visualización dentro de la categoría',
  `precio_especial` DECIMAL(10,2) NULL COMMENT 'Precio especial en este menú (si es diferente al precio base)',
  `es_obligatorio` TINYINT(1) DEFAULT 0 COMMENT 'Para menús fijos: ¿es obligatorio elegir este plato?',
  PRIMARY KEY (`id_menu`, `id_plato`),
  INDEX `fk_menu_plato_idx` (`id_plato`),
  INDEX `fk_menu_categoria_idx` (`id_categoria`),
  CONSTRAINT `fk_menu_plato_menu`
    FOREIGN KEY (`id_menu`)
    REFERENCES `menus` (`id_menu`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_menu_plato_plato`
    FOREIGN KEY (`id_plato`)
    REFERENCES `platos` (`id_plato`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_menu_plato_categoria`
    FOREIGN KEY (`id_categoria`)
    REFERENCES `categorias_menu` (`id_categoria`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Relación entre menús y platos';

CREATE TABLE IF NOT EXISTS `reserva_platos` (
  `id_reserva_plato` INT NOT NULL AUTO_INCREMENT,
  `id_reserva` INT NOT NULL,
  `id_plato` INT NOT NULL,
  `cantidad` INT UNSIGNED DEFAULT 1 COMMENT 'Cantidad de este plato',
  `precio_unitario` DECIMAL(10,2) NOT NULL COMMENT 'Precio en el momento de la reserva',
  `notas` TEXT COMMENT 'Notas especiales para este plato (ej. sin gluten, bien cocido)',
  `servido` TINYINT(1) DEFAULT 0 COMMENT '¿Ya fue servido al cliente?',
  `fecha_registro` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_reserva_plato`),
  INDEX `fk_reserva_plato_reserva_idx` (`id_reserva`),
  INDEX `fk_reserva_plato_plato_idx` (`id_plato`),
  CONSTRAINT `fk_reserva_plato_reserva`
    FOREIGN KEY (`id_reserva`)
    REFERENCES `reservas` (`id_reserva`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_reserva_plato_plato`
    FOREIGN KEY (`id_plato`)
    REFERENCES `platos` (`id_plato`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Platos reservados/preordenados por los clientes';

CREATE TABLE IF NOT EXISTS `pedidos` (
  `id_pedido` INT NOT NULL AUTO_INCREMENT,
  `id_reserva` INT NULL COMMENT 'NULL si es pedido sin reserva',
  `id_restaurante` INT NOT NULL,
  `id_mesa` INT NULL COMMENT 'Mesa asociada al pedido',
  `id_cliente` INT NULL COMMENT 'Cliente asociado al pedido',
  `codigo_pedido` VARCHAR(20) NOT NULL COMMENT 'Código único del pedido',
  `estado` ENUM('Pendiente', 'En preparación', 'Listo para servir', 'Servido', 'Cancelado', 'Pagado') NOT NULL DEFAULT 'Pendiente',
  `tipo` ENUM('Comer aquí', 'Para llevar', 'Delivery') NOT NULL DEFAULT 'Comer aquí',
  `total` DECIMAL(10,2) DEFAULT 0 COMMENT 'Total del pedido',
  `notas` TEXT COMMENT 'Notas generales del pedido',
  `fecha_pedido` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pedido`),
  UNIQUE INDEX `idx_codigo_pedido` (`codigo_pedido`),
  INDEX `fk_pedido_reserva_idx` (`id_reserva`),
  INDEX `fk_pedido_restaurante_idx` (`id_restaurante`),
  INDEX `fk_pedido_mesa_idx` (`id_mesa`),
  INDEX `fk_pedido_cliente_idx` (`id_cliente`),
  CONSTRAINT `fk_pedido_reserva`
    FOREIGN KEY (`id_reserva`)
    REFERENCES `reservas` (`id_reserva`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pedido_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurantes` (`id_restaurante`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pedido_mesa`
    FOREIGN KEY (`id_mesa`)
    REFERENCES `mesas` (`id_mesa`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pedido_cliente`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `clientes` (`id_cliente`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Pedidos realizados por los clientes';

CREATE TABLE IF NOT EXISTS `pedido_platos` (
  `id_pedido_plato` INT NOT NULL AUTO_INCREMENT,
  `id_pedido` INT NOT NULL,
  `id_plato` INT NOT NULL,
  `cantidad` INT UNSIGNED DEFAULT 1,
  `precio_unitario` DECIMAL(10,2) NOT NULL COMMENT 'Precio en el momento del pedido',
  `estado` ENUM('Pendiente', 'En preparación', 'Listo', 'Servido', 'Cancelado') NOT NULL DEFAULT 'Pendiente',
  `notas` TEXT COMMENT 'Instrucciones especiales para este plato',
  `fecha_registro` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pedido_plato`),
  INDEX `fk_pedido_plato_pedido_idx` (`id_pedido`),
  INDEX `fk_pedido_plato_plato_idx` (`id_plato`),
  CONSTRAINT `fk_pedido_plato_pedido`
    FOREIGN KEY (`id_pedido`)
    REFERENCES `pedidos` (`id_pedido`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pedido_plato_plato`
    FOREIGN KEY (`id_plato`)
    REFERENCES `platos` (`id_plato`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Platos incluidos en cada pedido';

CREATE TABLE IF NOT EXISTS `pagos` (
  `id_pago` INT NOT NULL AUTO_INCREMENT,
  `id_pedido` INT NULL COMMENT 'NULL si es pago sin pedido (ej. reserva con anticipo)',
  `id_reserva` INT NULL COMMENT 'NULL si es pago sin reserva',
  `id_cliente` INT NULL COMMENT 'Cliente asociado al pago',
  `id_restaurante` INT NOT NULL,
  `metodo` ENUM('Efectivo', 'Tarjeta', 'Transferencia', 'Bizum', 'App', 'Otro') NOT NULL,
  `monto` DECIMAL(10,2) NOT NULL,
  `estado` ENUM('Pendiente', 'Completado', 'Fallido', 'Reembolsado', 'Parcial') NOT NULL DEFAULT 'Pendiente',
  `codigo_transaccion` VARCHAR(100) COMMENT 'Código de transacción del pago',
  `notas` TEXT COMMENT 'Notas adicionales sobre el pago',
  `fecha_pago` TIMESTAMP NULL COMMENT 'Fecha y hora del pago',
  `fecha_registro` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pago`),
  INDEX `fk_pago_pedido_idx` (`id_pedido`),
  INDEX `fk_pago_reserva_idx` (`id_reserva`),
  INDEX `fk_pago_cliente_idx` (`id_cliente`),
  INDEX `fk_pago_restaurante_idx` (`id_restaurante`),
  CONSTRAINT `fk_pago_pedido`
    FOREIGN KEY (`id_pedido`)
    REFERENCES `pedidos` (`id_pedido`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pago_reserva`
    FOREIGN KEY (`id_reserva`)
    REFERENCES `reservas` (`id_reserva`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pago_cliente`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `clientes` (`id_cliente`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pago_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurantes` (`id_restaurante`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Registro de pagos realizados';

CREATE TABLE IF NOT EXISTS `eventos` (
  `id_evento` INT NOT NULL AUTO_INCREMENT,
  `id_restaurante` INT NOT NULL,
  `nombre` VARCHAR(100) NOT NULL,
  `descripcion` TEXT NOT NULL,
  `fecha_inicio` DATE NOT NULL,
  `fecha_fin` DATE NOT NULL,
  `hora_inicio` TIME NOT NULL,
  `hora_fin` TIME NOT NULL,
  `imagen` VARCHAR(255) COMMENT 'Imagen promocional del evento',
  `precio_entrada` DECIMAL(10,2) NULL COMMENT 'Precio de entrada si aplica',
  `capacidad_maxima` INT UNSIGNED NULL COMMENT 'Aforo máximo del evento',
  `reservas_requeridas` TINYINT(1) DEFAULT 1 COMMENT '¿Se requieren reservas para asistir?',
  `activo` TINYINT(1) DEFAULT 1 COMMENT '¿El evento está activo?',
  `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evento`),
  INDEX `fk_evento_restaurante_idx` (`id_restaurante`),
  CONSTRAINT `fk_evento_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurantes` (`id_restaurante`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Eventos especiales organizados por el restaurante';

CREATE TABLE IF NOT EXISTS `reservas_eventos` (
  `id_reserva_evento` INT NOT NULL AUTO_INCREMENT,
  `id_evento` INT NOT NULL,
  `id_cliente` INT NOT NULL,
  `num_personas` INT UNSIGNED NOT NULL DEFAULT 1,
  `codigo_reserva` VARCHAR(20) NOT NULL COMMENT 'Código único de la reserva',
  `estado` ENUM('Pendiente', 'Confirmada', 'Cancelada', 'Asistió', 'No asistió') NOT NULL DEFAULT 'Pendiente',
  `notas` TEXT COMMENT 'Notas adicionales',
  `fecha_reserva` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_reserva_evento`),
  UNIQUE INDEX `idx_codigo_reserva_evento` (`codigo_reserva`),
  INDEX `fk_reserva_evento_evento_idx` (`id_evento`),
  INDEX `fk_reserva_evento_cliente_idx` (`id_cliente`),
  CONSTRAINT `fk_reserva_evento_evento`
    FOREIGN KEY (`id_evento`)
    REFERENCES `eventos` (`id_evento`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_reserva_evento_cliente`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `clientes` (`id_cliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Reservas para eventos especiales';

DELIMITER //
CREATE PROCEDURE  `calcularEstadisticasOcupacion`(
  IN p_id_restaurante INT,
  IN p_fecha_inicio DATE,
  IN p_fecha_fin DATE
)
BEGIN
  -- Eliminar estadísticas previas para este período
  DELETE FROM `estadisticas` 
  WHERE `id_restaurante` = p_id_restaurante 
    AND `categoria` = 'Ocupación'
    AND `fecha_inicio` = p_fecha_inicio
    AND `fecha_fin` = p_fecha_fin;
  
  -- Ocupación por día
  INSERT INTO `estadisticas` (
    `id_restaurante`, `categoria`, `subcategoria`, 
    `fecha_inicio`, `fecha_fin`, `metrica`, `valor`, `unidad`
  )
  SELECT 
    r.`id_restaurante`, 
    'Ocupación', 
    'Diaria',
    p_fecha_inicio,
    p_fecha_fin,
    'Porcentaje ocupación',
    (SUM(r.`num_comensales`) / re.`capacidad_total`) * 100,
    '%'
  FROM `reservas` r
  JOIN `restaurantes` re ON r.`id_restaurante` = re.`id_restaurante`
  WHERE r.`id_restaurante` = p_id_restaurante
    AND r.`fecha_reserva` BETWEEN p_fecha_inicio AND p_fecha_fin
    AND r.`id_estado` = 5 -- Completadas
  GROUP BY r.`fecha_reserva`;
  
  -- Ocupación por turno
  INSERT INTO `estadisticas` (
    `id_restaurante`, `categoria`, `subcategoria`, 
    `fecha_inicio`, `fecha_fin`, `metrica`, `valor`, `unidad`
  )
  SELECT 
    r.`id_restaurante`, 
    'Ocupación', 
    'Por turno',
    p_fecha_inicio,
    p_fecha_fin,
    CONCAT('Turno ', t.`nombre`),
    (SUM(r.`num_comensales`) / re.`capacidad_total`) * 100,
    '%'
  FROM `reservas` r
  JOIN `turnos_servicio` t ON r.`id_turno` = t.`id_turno`
  JOIN `restaurantes` re ON r.`id_restaurante` = re.`id_restaurante`
  WHERE r.`id_restaurante` = p_id_restaurante
    AND r.`fecha_reserva` BETWEEN p_fecha_inicio AND p_fecha_fin
    AND r.`id_estado` = 5 -- Completadas
  GROUP BY t.`id_turno`;
  
  -- Ocupación por zona
  INSERT INTO `estadisticas` (
    `id_restaurante`, `categoria`, `subcategoria`, 
    `fecha_inicio`, `fecha_fin`, `metrica`, `valor`, `unidad`
  )
  SELECT 
    r.`id_restaurante`, 
    'Ocupación', 
    'Por zona',
    p_fecha_inicio,
    p_fecha_fin,
    CONCAT('Zona ', z.`nombre`),
    (COUNT(DISTINCT r.`id_reserva`) / z.`capacidad`) * 100,
    '%'
  FROM `reservas` r
  JOIN `reservas_mesas` rm ON r.`id_reserva` = rm.`id_reserva`
  JOIN `mesas` m ON rm.`id_mesa` = m.`id_mesa`
  JOIN `zonas` z ON m.`id_zona` = z.`id_zona`
  WHERE r.`id_restaurante` = p_id_restaurante
    AND r.`fecha_reserva` BETWEEN p_fecha_inicio AND p_fecha_fin
    AND r.`id_estado` = 5 -- Completadas
  GROUP BY z.`id_zona`;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE  `enviarRecordatoriosReservas`(
  IN p_horas_antes INT
)
BEGIN
  DECLARE v_id_reserva INT;
  DECLARE v_id_cliente INT;
  DECLARE v_nombre_cliente VARCHAR(150);
  DECLARE v_email_cliente VARCHAR(100);
  DECLARE v_telefono_cliente VARCHAR(20);
  DECLARE v_fecha_reserva DATE;
  DECLARE v_hora_reserva TIME;
  DECLARE v_nombre_restaurante VARCHAR(100);
  DECLARE v_direccion_restaurante VARCHAR(200);
  DECLARE v_codigo_reserva VARCHAR(20);
  DECLARE v_num_comensales INT;
  DECLARE v_done INT DEFAULT FALSE;
  
  -- Cursor para reservas que necesitan recordatorio
  DECLARE cur_reservas CURSOR FOR
    SELECT 
      r.`id_reserva`,
      r.`id_cliente`,
      CONCAT(c.`nombre`, ' ', c.`apellidos`) AS nombre_cliente,
      c.`email`,
      c.`telefono`,
      r.`fecha_reserva`,
      r.`hora_inicio`,
      res.`nombre` AS nombre_restaurante,
      res.`direccion`,
      r.`codigo_reserva`,
      r.`num_comensales`
    FROM `reservas` r
    JOIN `clientes` c ON r.`id_cliente` = c.`id_cliente`
    JOIN `restaurantes` res ON r.`id_restaurante` = res.`id_restaurante`
    WHERE r.`fecha_reserva` = CURRENT_DATE
      AND r.`hora_inicio` BETWEEN CURRENT_TIME AND ADDTIME(CURRENT_TIME, SEC_TO_TIME(p_horas_antes * 3600))
      AND r.`id_estado` IN (1, 2) -- Pendiente o confirmada
      AND r.`recordatorio_enviado` = 0;
  
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
  
  OPEN cur_reservas;
  
  read_loop: LOOP
    FETCH cur_reservas INTO 
      v_id_reserva, v_id_cliente, v_nombre_cliente, v_email_cliente, 
      v_telefono_cliente, v_fecha_reserva, v_hora_reserva, 
      v_nombre_restaurante, v_direccion_restaurante, v_codigo_reserva, v_num_comensales;
    
    IF v_done THEN
      LEAVE read_loop;
    END IF;
    
    -- Registrar envío de email
    IF v_email_cliente IS NOT NULL THEN
      INSERT INTO `log_notificaciones` (
        `id_cliente`, `id_reserva`, `tipo`, 
        `asunto`, `mensaje`, `estado`
      ) VALUES (
        v_id_cliente, v_id_reserva, 'Email',
        CONCAT('Recordatorio de tu reserva en ', v_nombre_restaurante),
        CONCAT(
          'Hola ', v_nombre_cliente, ',\n\n',
          'Te recordamos que tienes una reserva para ', v_num_comensales, ' personas en ', v_nombre_restaurante, '.\n',
          'Fecha: ', DATE_FORMAT(v_fecha_reserva, '%d/%m/%Y'), '\n',
          'Hora: ', TIME_FORMAT(v_hora_reserva, '%H:%i'), '\n',
          'Dirección: ', v_direccion_restaurante, '\n',
          'Código de reserva: ', v_codigo_reserva, '\n\n',
          '¡Te esperamos!'
        ),
        'Pendiente'
      );
    END IF;
    
    -- Registrar envío de SMS (si hay teléfono)
    IF v_telefono_cliente IS NOT NULL THEN
      INSERT INTO `log_notificaciones` (
        `id_cliente`, `id_reserva`, `tipo`, 
        `mensaje`, `estado`
      ) VALUES (
        v_id_cliente, v_id_reserva, 'SMS',
        CONCAT(
          'Recordatorio reserva ', v_codigo_reserva, ': ', 
          v_nombre_restaurante, ' hoy a las ', TIME_FORMAT(v_hora_reserva, '%H:%i'), 
          ' para ', v_num_comensales, ' pers.'
        ),
        'Pendiente'
      );
    END IF;
    
    -- Marcar reserva como recordatorio enviado
    UPDATE `reservas` 
    SET `recordatorio_enviado` = 1
    WHERE `id_reserva` = v_id_reserva;
  END LOOP;
  
  CLOSE cur_reservas;
END//
DELIMITER ;


CREATE OR REPLACE VIEW `vw_platos_populares` AS
SELECT 
  p.`id_plato`,
  p.`nombre` AS `nombre_plato`,
  p.`precio`,
  cm.`nombre` AS `categoria`,
  r.`id_restaurante`,
  r.`nombre` AS `nombre_restaurante`,
  COUNT(DISTINCT pp.`id_reserva_plato`) AS `veces_pedido`,
  SUM(pp.`cantidad`) AS `cantidad_total`,
  SUM(pp.`cantidad` * pp.`precio_unitario`) AS `ingresos_totales`,
  AVG(pp.`cantidad` * pp.`precio_unitario`) AS `ingreso_promedio`
FROM `platos` p
JOIN `categorias_menu` cm ON p.`id_categoria` = cm.`id_categoria`
JOIN `restaurantes` r ON p.`id_restaurante` = r.`id_restaurante`
LEFT JOIN `reserva_platos` pp ON p.`id_plato` = pp.`id_plato`
GROUP BY p.`id_plato`
ORDER BY `veces_pedido` DESC;

CREATE OR REPLACE VIEW `vw_clientes_frecuentes` AS
SELECT 
  c.`id_cliente`,
  CONCAT(c.`nombre`, ' ', c.`apellidos`) AS `nombre_completo`,
  c.`email`,
  c.`telefono`,
  COUNT(r.`id_reserva`) AS `total_reservas`,
  MAX(r.`fecha_reserva`) AS `ultima_reserva`,
  SUM(r.`num_comensales`) AS `total_comensales`,
  GROUP_CONCAT(DISTINCT res.`nombre` ORDER BY res.`nombre` SEPARATOR ', ') AS `restaurantes_visitados`
FROM `clientes` c
JOIN `reservas` r ON c.`id_cliente` = r.`id_cliente`
JOIN `restaurantes` res ON r.`id_restaurante` = res.`id_restaurante`
WHERE r.`id_estado` = 5 -- Completadas
GROUP BY c.`id_cliente`
ORDER BY `total_reservas` DESC;

-- Create table for users (usuarios)
CREATE TABLE IF NOT EXISTS `admin` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `full_name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `username` VARCHAR(50) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
-- Agregar comentarios a las tablas y columnas (en español)

-- Insert initial user record in the usuarios table
INSERT INTO `admin` (`full_name`, `email`, `username`, `password`)
VALUES ('Jose Vicente Carratala', 'info@josevicentecarratala.com', 'jocarsa', 'jocarsa');
