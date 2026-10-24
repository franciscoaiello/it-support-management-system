const express = require('express');
const sucRouter = require('./routes/sucursales');
const incRouter = require('./routes/incidentes');

const app = express();
const PORT = 3000;
const mysql = require('mysql2');

app.use(express.json());
app.use(`/sucursales`, sucRouter);
app.use(`/incidentes`, incRouter);

app.listen(PORT, () => {
    console.log(`Servidor ejecutándose en http://localhost:${PORT}`);
});
















