-- Schema para el taller de pipelines y contenerización
-- Archivo: schema.sql

-- Crear tabla de estudiantes
CREATE TABLE IF NOT EXISTS estudiantes (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    nota NUMERIC(3,1) CHECK (nota >= 0 AND nota <= 5),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE
);

-- Crear tabla de cursos
CREATE TABLE IF NOT EXISTS cursos (
    id SERIAL PRIMARY KEY,
    nombre_curso VARCHAR(100) NOT NULL,
    codigo_curso VARCHAR(10) UNIQUE NOT NULL,
    creditos INTEGER CHECK (creditos > 0),
    descripcion TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla de inscripciones (relación muchos a muchos)
CREATE TABLE IF NOT EXISTS inscripciones (
    id SERIAL PRIMARY KEY,
    estudiante_id INTEGER REFERENCES estudiantes(id) ON DELETE CASCADE,
    curso_id INTEGER REFERENCES cursos(id) ON DELETE CASCADE,
    fecha_inscripcion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nota_final NUMERIC(3,1) CHECK (nota_final >= 0 AND nota_final <= 5),
    estado VARCHAR(20) DEFAULT 'inscrito' CHECK (estado IN ('inscrito', 'aprobado', 'reprobado', 'retirado')),
    UNIQUE(estudiante_id, curso_id)
);

-- Crear índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_estudiantes_nombre ON estudiantes(nombre);
CREATE INDEX IF NOT EXISTS idx_cursos_codigo ON cursos(codigo_curso);
CREATE INDEX IF NOT EXISTS idx_inscripciones_estudiante ON inscripciones(estudiante_id);
CREATE INDEX IF NOT EXISTS idx_inscripciones_curso ON inscripciones(curso_id);

-- Crear vista para consultas frecuentes
CREATE OR REPLACE VIEW vista_estudiantes_activos AS
SELECT 
    e.id,
    e.nombre,
    e.nota,
    e.fecha_registro,
    COUNT(i.id) as cursos_inscritos
FROM estudiantes e
LEFT JOIN inscripciones i ON e.id = i.estudiante_id
WHERE e.activo = TRUE
GROUP BY e.id, e.nombre, e.nota, e.fecha_registro
ORDER BY e.nombre;

-- Comentarios informativos
COMMENT ON TABLE estudiantes IS 'Tabla que almacena información de los estudiantes';
COMMENT ON TABLE cursos IS 'Tabla que almacena información de los cursos disponibles';
COMMENT ON TABLE inscripciones IS 'Tabla que relaciona estudiantes con cursos';
COMMENT ON COLUMN estudiantes.nota IS 'Nota promedio del estudiante (0.0 - 5.0)';
COMMENT ON COLUMN cursos.creditos IS 'Número de créditos académicos del curso';

-- Mensaje de confirmación
SELECT 'Schema creado exitosamente' AS mensaje; 