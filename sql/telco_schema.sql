-- ============================================================
--  Telco Customer Churn — Schema PostgreSQL
--  Base: telco_db | Usuario: telco_user
-- ============================================================

-- ------------------------------------------------------------
-- Tablas dimensionales (lookup)
-- ------------------------------------------------------------

-- Binario + sin servicio: No(0), Sí(1), Sin servicio(2)
CREATE TABLE IF NOT EXISTS dim_estado (
    id          SMALLINT    PRIMARY KEY,
    descripcion VARCHAR(20) NOT NULL
);

-- Género: Femenino(0), Masculino(1)
CREATE TABLE IF NOT EXISTS dim_genero (
    id          SMALLINT    PRIMARY KEY,
    descripcion VARCHAR(20) NOT NULL
);

-- Líneas múltiples: No(0), Sí(1), Sin servicio telefónico(2)
CREATE TABLE IF NOT EXISTS dim_multiple_lines (
    id          SMALLINT    PRIMARY KEY,
    descripcion VARCHAR(30) NOT NULL
);

-- Servicio de internet: No(0), DSL(1), Fiber optic(2)
CREATE TABLE IF NOT EXISTS dim_internet (
    id          SMALLINT    PRIMARY KEY,
    descripcion VARCHAR(20) NOT NULL
);

-- Tipo de contrato: Month-to-month(0), One year(1), Two year(2)
CREATE TABLE IF NOT EXISTS dim_contrato (
    id          SMALLINT    PRIMARY KEY,
    descripcion VARCHAR(30) NOT NULL
);

-- Método de pago: Electronic check(0), Mailed check(1), Bank transfer(2), Credit card(3)
CREATE TABLE IF NOT EXISTS dim_metodo_pago (
    id          SMALLINT    PRIMARY KEY,
    descripcion VARCHAR(40) NOT NULL
);

-- ------------------------------------------------------------
-- Datos de catálogos
-- ------------------------------------------------------------

INSERT INTO dim_estado VALUES
    (0, 'No'), (1, 'Sí'), (2, 'Sin servicio')
ON CONFLICT DO NOTHING;

INSERT INTO dim_genero VALUES
    (0, 'Femenino'), (1, 'Masculino')
ON CONFLICT DO NOTHING;

INSERT INTO dim_multiple_lines VALUES
    (0, 'No'), (1, 'Sí'), (2, 'Sin servicio telefónico')
ON CONFLICT DO NOTHING;

INSERT INTO dim_internet VALUES
    (0, 'No'), (1, 'DSL'), (2, 'Fiber optic')
ON CONFLICT DO NOTHING;

INSERT INTO dim_contrato VALUES
    (0, 'Month-to-month'), (1, 'One year'), (2, 'Two year')
ON CONFLICT DO NOTHING;

INSERT INTO dim_metodo_pago VALUES
    (0, 'Electronic check'), (1, 'Mailed check'),
    (2, 'Bank transfer (automatic)'), (3, 'Credit card (automatic)')
ON CONFLICT DO NOTHING;

-- ------------------------------------------------------------
-- Tabla principal de clientes
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS cliente (
    customer_id             VARCHAR(20)  PRIMARY KEY,
    genero_id               SMALLINT     NOT NULL REFERENCES dim_genero(id),
    senior_citizen          BOOLEAN      NOT NULL,
    partner                 BOOLEAN      NOT NULL,
    dependents              BOOLEAN      NOT NULL,
    tenure                  SMALLINT     NOT NULL,
    phone_service           BOOLEAN      NOT NULL,
    multiple_lines_id       SMALLINT     NOT NULL REFERENCES dim_multiple_lines(id),
    internet_id             SMALLINT     NOT NULL REFERENCES dim_internet(id),
    online_security_id      SMALLINT     NOT NULL REFERENCES dim_estado(id),
    online_backup_id        SMALLINT     NOT NULL REFERENCES dim_estado(id),
    device_protection_id    SMALLINT     NOT NULL REFERENCES dim_estado(id),
    tech_support_id         SMALLINT     NOT NULL REFERENCES dim_estado(id),
    streaming_tv_id         SMALLINT     NOT NULL REFERENCES dim_estado(id),
    streaming_movies_id     SMALLINT     NOT NULL REFERENCES dim_estado(id),
    contrato_id             SMALLINT     NOT NULL REFERENCES dim_contrato(id),
    paperless_billing       BOOLEAN      NOT NULL,
    metodo_pago_id          SMALLINT     NOT NULL REFERENCES dim_metodo_pago(id),
    monthly_charges         NUMERIC(8,2) NOT NULL,
    total_charges           NUMERIC(10,2),
    churn                   BOOLEAN      NOT NULL
);

-- ------------------------------------------------------------
-- Índices
-- ------------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_cliente_churn         ON cliente(churn);
CREATE INDEX IF NOT EXISTS idx_cliente_contrato       ON cliente(contrato_id);
CREATE INDEX IF NOT EXISTS idx_cliente_internet       ON cliente(internet_id);
CREATE INDEX IF NOT EXISTS idx_cliente_metodo_pago    ON cliente(metodo_pago_id);
CREATE INDEX IF NOT EXISTS idx_cliente_genero         ON cliente(genero_id);

-- ------------------------------------------------------------
-- Vista enriquecida
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW v_clientes AS
SELECT
    c.customer_id,
    g.descripcion                               AS genero,
    c.senior_citizen,
    c.partner,
    c.dependents,
    c.tenure,
    c.phone_service,
    ml.descripcion                              AS multiple_lines,
    i.descripcion                               AS internet_service,
    os.descripcion                              AS online_security,
    ob.descripcion                              AS online_backup,
    dp.descripcion                              AS device_protection,
    ts.descripcion                              AS tech_support,
    stv.descripcion                             AS streaming_tv,
    sm.descripcion                              AS streaming_movies,
    ct.descripcion                              AS contrato,
    c.paperless_billing,
    mp.descripcion                              AS metodo_pago,
    c.monthly_charges,
    c.total_charges,
    c.churn
FROM cliente c
JOIN dim_genero        g   ON c.genero_id            = g.id
JOIN dim_multiple_lines ml ON c.multiple_lines_id    = ml.id
JOIN dim_internet       i  ON c.internet_id          = i.id
JOIN dim_estado        os  ON c.online_security_id   = os.id
JOIN dim_estado        ob  ON c.online_backup_id     = ob.id
JOIN dim_estado        dp  ON c.device_protection_id = dp.id
JOIN dim_estado        ts  ON c.tech_support_id      = ts.id
JOIN dim_estado        stv ON c.streaming_tv_id      = stv.id
JOIN dim_estado        sm  ON c.streaming_movies_id  = sm.id
JOIN dim_contrato      ct  ON c.contrato_id          = ct.id
JOIN dim_metodo_pago   mp  ON c.metodo_pago_id       = mp.id;