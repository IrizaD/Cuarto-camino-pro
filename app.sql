
-- Tabla de perfiles de usuario extendidos
CREATE TABLE user_profiles (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    nickname VARCHAR(100),
    avatar_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Crear perfil por defecto para el admin
INSERT INTO user_profiles (user_id) VALUES (1);

-- Tabla de sesiones de chat/análisis
CREATE TABLE chat_sessions (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    session_name VARCHAR(200),
    current_step INTEGER DEFAULT 0,
    status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'completed', 'abandoned')),
    started_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de mensajes del chat
CREATE TABLE chat_messages (
    id BIGSERIAL PRIMARY KEY,
    session_id BIGINT NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('user', 'assistant', 'system')),
    content TEXT NOT NULL,
    step_number INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de respuestas del análisis
CREATE TABLE analysis_responses (
    id BIGSERIAL PRIMARY KEY,
    session_id BIGINT NOT NULL,
    user_name VARCHAR(100),
    battlefield_choice VARCHAR(50),
    scenario_1_response TEXT,
    scenario_2_response TEXT,
    scenario_3_response TEXT,
    body_response TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de reportes finales generados
CREATE TABLE analysis_reports (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    session_id BIGINT NOT NULL,
    user_name VARCHAR(100),
    diagnosed_type VARCHAR(100),
    full_report TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de configuración del prompt del sistema
CREATE TABLE system_prompts (
    id BIGSERIAL PRIMARY KEY,
    prompt_name VARCHAR(100) NOT NULL,
    prompt_content TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true,
    version INTEGER DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Habilitar RLS en todas las tablas de usuario
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE analysis_responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE analysis_reports ENABLE ROW LEVEL SECURITY;

-- Políticas RLS para user_profiles
CREATE POLICY user_profiles_select_policy ON user_profiles
    FOR SELECT USING (user_id = uid());

CREATE POLICY user_profiles_insert_policy ON user_profiles
    FOR INSERT WITH CHECK (user_id = uid());

CREATE POLICY user_profiles_update_policy ON user_profiles
    FOR UPDATE USING (user_id = uid()) WITH CHECK (user_id = uid());

CREATE POLICY user_profiles_delete_policy ON user_profiles
    FOR DELETE USING (user_id = uid());

-- Políticas RLS para chat_sessions
CREATE POLICY chat_sessions_select_policy ON chat_sessions
    FOR SELECT USING (user_id = uid());

CREATE POLICY chat_sessions_insert_policy ON chat_sessions
    FOR INSERT WITH CHECK (user_id = uid());

CREATE POLICY chat_sessions_update_policy ON chat_sessions
    FOR UPDATE USING (user_id = uid()) WITH CHECK (user_id = uid());

CREATE POLICY chat_sessions_delete_policy ON chat_sessions
    FOR DELETE USING (user_id = uid());

-- Políticas RLS para chat_messages (a través de session_id)
CREATE POLICY chat_messages_select_policy ON chat_messages
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM chat_sessions 
            WHERE chat_sessions.id = chat_messages.session_id 
            AND chat_sessions.user_id = uid()
        )
    );

CREATE POLICY chat_messages_insert_policy ON chat_messages
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM chat_sessions 
            WHERE chat_sessions.id = chat_messages.session_id 
            AND chat_sessions.user_id = uid()
        )
    );

CREATE POLICY chat_messages_delete_policy ON chat_messages
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM chat_sessions 
            WHERE chat_sessions.id = chat_messages.session_id 
            AND chat_sessions.user_id = uid()
        )
    );

-- Políticas RLS para analysis_responses (a través de session_id)
CREATE POLICY analysis_responses_select_policy ON analysis_responses
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM chat_sessions 
            WHERE chat_sessions.id = analysis_responses.session_id 
            AND chat_sessions.user_id = uid()
        )
    );

CREATE POLICY analysis_responses_insert_policy ON analysis_responses
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM chat_sessions 
            WHERE chat_sessions.id = analysis_responses.session_id 
            AND chat_sessions.user_id = uid()
        )
    );

CREATE POLICY analysis_responses_update_policy ON analysis_responses
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM chat_sessions 
            WHERE chat_sessions.id = analysis_responses.session_id 
            AND chat_sessions.user_id = uid()
        )
    ) WITH CHECK (
        EXISTS (
            SELECT 1 FROM chat_sessions 
            WHERE chat_sessions.id = analysis_responses.session_id 
            AND chat_sessions.user_id = uid()
        )
    );

-- Políticas RLS para analysis_reports
CREATE POLICY analysis_reports_select_policy ON analysis_reports
    FOR SELECT USING (user_id = uid());

CREATE POLICY analysis_reports_insert_policy ON analysis_reports
    FOR INSERT WITH CHECK (user_id = uid());

CREATE POLICY analysis_reports_delete_policy ON analysis_reports
    FOR DELETE USING (user_id = uid());

-- Índices para mejorar el rendimiento
CREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id);
CREATE INDEX idx_chat_sessions_user_id ON chat_sessions(user_id);
CREATE INDEX idx_chat_sessions_status ON chat_sessions(status);
CREATE INDEX idx_chat_messages_session_id ON chat_messages(session_id);
CREATE INDEX idx_chat_messages_created_at ON chat_messages(created_at);
CREATE INDEX idx_analysis_responses_session_id ON analysis_responses(session_id);
CREATE INDEX idx_analysis_reports_user_id ON analysis_reports(user_id);
CREATE INDEX idx_analysis_reports_session_id ON analysis_reports(session_id);
CREATE INDEX idx_system_prompts_active ON system_prompts(is_active);

-- Insertar el prompt del sistema inicial
INSERT INTO system_prompts (prompt_name, prompt_content, is_active, version) VALUES (
    'Analista del Cuarto Camino',
    'ROL:
Eres un "Analista del Cuarto Camino", operando estrictamente bajo la METODOLOGÍA DE G.I. GURDJIEFF. Tu objetivo no es juzgar moralmente, sino diagnosticar la estructura mecánica de la "Máquina Humana" del usuario.
REGLA DE RITMO: Sé conciso y ágil durante las preguntas (tipo test), pero sé EXHAUSTIVO, DETALLADO y PROFUNDO en el Reporte Final.

CONOCIMIENTO BASE (Gurdjieff & Ouspensky):
- La base del análisis es la teoría de los Tres Cerebros o Centros.
- H1 (Centro Motor/Instintivo): Inteligencia del cuerpo. Prioridad: Acción, movimiento, sensaciones. Se estresa por inmovilidad o incomodidad física.
- H2 (Centro Emocional): Inteligencia del corazón. Prioridad: Gustos, disgustos, personas, atmósfera. Se estresa por conflicto o rechazo.
- H3 (Centro Intelectual): Inteligencia de la mente. Prioridad: Lógica, datos, reglas. Se estresa por el caos o la falta de sentido.
- Variante Implosiva (Clave en Gurdjieff): El H2 que no explota, sino que retiene la emoción ("olla a presión") y sufre parálisis física porque la emoción le roba la energía al centro motor.

PROTOCOLO DE INTERACCIÓN (Sigue este orden estrictamente):

PASO 0: SALUDO Y NOMBRE.
   - Saluda brevemente y pide el nombre.
   - Mensaje oculto esperado: "Hola. Salúdame y pídeme mi nombre para comenzar."

PASO 1: EL CAMPO DE BATALLA (Contexto Inicial).
   - Una vez tengas el nombre, úsalo.
   - Dale un MENÚ DE 3 ENFOQUES para elegir dónde siente fricción hoy:
     A) El trato con las PERSONAS.
     B) El manejo de COSAS/TAREAS.
     C) La sensación del CUERPO.
   - Pregunta: "¿En cuál pierdes más energía?".

PASO 2: PRIMER ESCENARIO (Reacción Instintiva).
   - Basado en su elección anterior, plantea una situación tensa específica.
   - Da 3 opciones de reacción (Motor, Emocional, Intelectual).
   - Ejemplo: "Te critican en público. ¿Reacción? 1. Dolor/Vergüenza. 2. Análisis lógico del error. 3. Ganas de irte."

PASO 3: SEGUNDO ESCENARIO (Contraste/Validación).
   - Plantea una situación de un contexto DIFERENTE al del Paso 2 (para triangular).
   - Ejemplo: "Ahora imagina que se rompe algo caro en tu casa. ¿Qué haces? 1. Gritas/Lloras. 2. Buscas cómo repararlo o comprar otro. 3. Te mueves rápido a limpiar."

PASO 4: TERCER ESCENARIO (Presión Inesperada).
   - Plantea una situación de shock rápido (ej: un frenazo en el auto o un susto).
   - Pregunta por la reacción inmediata (¿Parálisis, Grito, Cálculo?).

PASO 5: LA PREGUNTA DEL CUERPO (Confirmación de Variante).
   - Esta es la última pregunta antes del reporte.
   - Pregunta cómo queda su cuerpo después de esos estrés:
   - "¿Sientes ganas de descargar energía hacia afuera (gritar/correr) o sientes una pesadez física que te paraliza hacia adentro (como una ''olla a presión'' cerrada)?"

PASO 6: REPORTE FINAL EXTENSO (ESTILO MANUAL EDUCATIVO).
   - AQUÍ DETENTE Y ESCRIBE UN DOCUMENTO LARGO Y DETALLADO.
   - IMPORTANTE: Asume que el usuario NO sabe nada de Gurdjieff. Explica los conceptos.
   - ESTRUCTURA OBLIGATORIA DEL REPORTE:
     1. INTRODUCCIÓN TEÓRICA (Contexto): Explica brevemente qué son los 3 Centros (Motor, Emocional, Intelectual) según Gurdjieff de forma sencilla para que entienda el marco teórico.
     2. DIAGNÓSTICO: Define claramente su Tipo y Variante basándote en sus respuestas.
     3. TU MECÁNICA INTERNA: Explica cómo funcionan SUS centros específicos. Quién es el "Jefe" (Dominante), quién es el "Secretario" (Auxiliar) y quién es la "Víctima" (quién roba energía a quién). Usa analogías claras (como la del Carruaje o la Fábrica).
     4. TU TRAMPA PRINCIPAL: Explica su hábito más costoso (ej: Consideración Interna) con ejemplos cotidianos.
     5. PLAN DE ACCIÓN (3 Herramientas): Detalla 3 ejercicios específicos. Para cada uno explica: "Qué hacer" y "Por qué funciona para TU tipo específico".
     6. MANTRA PERSONAL: Una frase técnica para recordarse a sí mismo.',
    true,
    1
);
