-- Datos de ejemplo para el taller de pipelines y contenerización
-- Archivo: data.sql

-- Insertar estudiantes de ejemplo
INSERT INTO estudiantes (nombre, nota) VALUES 
    ('Ana García', 4.5),
    ('Luis Rodríguez', 3.8),
    ('María López', 4.2),
    ('Carlos Martínez', 3.5),
    ('Sofia Hernández', 4.8),
    ('Diego Pérez', 3.9),
    ('Valentina Castro', 4.1),
    ('Andrés Morales', 3.7),
    ('Camila Vargas', 4.6),
    ('Santiago Ruiz', 4.0)
ON CONFLICT DO NOTHING;

-- Insertar cursos de ejemplo
INSERT INTO cursos (nombre_curso, codigo_curso, creditos, descripcion) VALUES 
    ('Programación I', 'PROG101', 4, 'Introducción a la programación con Python'),
    ('Base de Datos', 'BD201', 3, 'Fundamentos de bases de datos relacionales'),
    ('Algoritmos', 'ALG301', 4, 'Estructuras de datos y algoritmos'),
    ('Desarrollo Web', 'WEB401', 3, 'Desarrollo de aplicaciones web modernas'),
    ('DevOps', 'DEVOPS501', 2, 'Prácticas de DevOps y CI/CD'),
    ('Machine Learning', 'ML601', 4, 'Introducción al aprendizaje automático'),
    ('Seguridad Informática', 'SEC701', 3, 'Fundamentos de ciberseguridad'),
    ('Arquitectura de Software', 'ARCH801', 4, 'Diseño de sistemas de software')
ON CONFLICT (codigo_curso) DO NOTHING;

-- Insertar inscripciones de ejemplo
INSERT INTO inscripciones (estudiante_id, curso_id, nota_final, estado) VALUES 
    -- Ana García (id: 1)
    (1, 1, 4.5, 'aprobado'),
    (1, 2, 4.3, 'aprobado'),
    (1, 3, 4.7, 'aprobado'),
    
    -- Luis Rodríguez (id: 2)
    (2, 1, 3.8, 'aprobado'),
    (2, 2, 3.5, 'aprobado'),
    (2, 4, NULL, 'inscrito'),
    
    -- María López (id: 3)
    (3, 1, 4.2, 'aprobado'),
    (3, 3, 4.0, 'aprobado'),
    (3, 5, 4.4, 'aprobado'),
    
    -- Carlos Martínez (id: 4)
    (4, 1, 3.5, 'aprobado'),
    (4, 2, 3.2, 'aprobado'),
    (4, 4, 3.8, 'aprobado'),
    
    -- Sofia Hernández (id: 5)
    (5, 1, 4.8, 'aprobado'),
    (5, 2, 4.6, 'aprobado'),
    (5, 3, 4.9, 'aprobado'),
    (5, 6, NULL, 'inscrito'),
    
    -- Diego Pérez (id: 6)
    (6, 1, 3.9, 'aprobado'),
    (6, 4, 4.1, 'aprobado'),
    (6, 5, NULL, 'inscrito'),
    
    -- Valentina Castro (id: 7)
    (7, 2, 4.1, 'aprobado'),
    (7, 3, 4.0, 'aprobado'),
    (7, 7, NULL, 'inscrito'),
    
    -- Andrés Morales (id: 8)
    (8, 1, 3.7, 'aprobado'),
    (8, 4, 3.9, 'aprobado'),
    
    -- Camila Vargas (id: 9)
    (9, 1, 4.6, 'aprobado'),
    (9, 2, 4.4, 'aprobado'),
    (9, 6, 4.8, 'aprobado'),
    
    -- Santiago Ruiz (id: 10)
    (10, 1, 4.0, 'aprobado'),
    (10, 3, 3.8, 'aprobado'),
    (10, 8, NULL, 'inscrito')
ON CONFLICT (estudiante_id, curso_id) DO NOTHING;

-- Verificar la inserción de datos
SELECT 'Datos insertados exitosamente' AS mensaje;

-- Mostrar estadísticas básicas
SELECT 
    'Estudiantes registrados: ' || COUNT(*) AS estadistica
FROM estudiantes
UNION ALL
SELECT 
    'Cursos disponibles: ' || COUNT(*) AS estadistica
FROM cursos
UNION ALL
SELECT 
    'Inscripciones totales: ' || COUNT(*) AS estadistica
FROM inscripciones;

-- Mostrar algunos datos de ejemplo
SELECT 
    e.nombre AS estudiante,
    c.nombre_curso AS curso,
    i.nota_final,
    i.estado
FROM inscripciones i
JOIN estudiantes e ON i.estudiante_id = e.id
JOIN cursos c ON i.curso_id = c.id
ORDER BY e.nombre, c.nombre_curso
LIMIT 10; 