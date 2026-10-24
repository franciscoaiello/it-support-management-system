const express = require('express');
const router = express.Router();
const connection = require('../connection');

router.get(`/`, (req, res) => {
    connection.query(
        'SELECT * FROM sucursales;',
        (error, resultados) => {
            if(error){
                res.status(500).json({mensaje: 'Error al obtener registros.'});
            }else{
                res.json(resultados);
            }
        }
    );

});

router.get('/:id', (req, res, next) => {
    const id = req.params.id;
    
    connection.query(
        `SELECT * FROM sucursales WHERE id = ?`,
        [id],
        (error, resultados) => {
            if(error){
                res.status(500).json({mensaje: 'Error al cargar registros.'});
            }else if(resultados.length === 0){
                res.status(404).json({mensaje: 'Registros no encontrados.'});
            }else{
                res.status(200).json(resultados);
            }
        }  
    );
});

router.post('/', (req, res) => {
    const nombre = req.body.nombre;
    const localidad = req.body.localidad;
    const provincia = req.body.provincia;
    const activa = req.body.activa;

    connection.query(
        'SELECT * FROM sucursales WHERE nombre = ?',
        [nombre],
        (error, respuesta) => {
            if(error){
                res.status(500).json({mensaje: 'Error al generar registros.'});
            }else if(respuesta.length > 0){
                res.status(409).json({mensaje: 'Sucursal existente en base de datos.'});
            }else{
                connection.query(
                    'INSERT INTO sucursales (nombre, localidad, provincia, activa) VALUES (?, ?, ?, ?)',
                    [nombre, localidad, provincia, activa],
                    (error, resultados) => {
                        if(error){
                            res.status(500).json({mensaje: 'Error al generar registros.'});
                        }else{
                            res.status(201).json({mensaje: 'Registros generados con exito.'}, resultados);
                        }
                    }
                );
            }
        }
    );
});

router.patch(`/:id`, (req, res) => {
    const id = req.params.id;
    const nombre = req.body.nombre;
    const localidad = req.body.localidad;
    const provincia = req.body.provincia;
    const activa = req.body.activa;

    const valores = [];
    const campos = [];

    if(nombre!==undefined){
        campos.push('nombre = ?');
        valores.push(nombre);
    };
    if(localidad !== undefined){
        campos.push('localidad = ?');
        valores.push(localidad);
    };
    if(provincia !== undefined){
        campos.push('provincia = ?');
        valores.push(provincia);
    };
    if(activa !== undefined){
        campos.push('activa = ?');
        valores.push(activa);
    };
    if(campos.length === 0){
        res.status(400).json({mensaje: 'Sin datos para modificar.'})
        return;
    };

    const setCampos = campos.join(', ');
    valores.push(id);

    connection.query(
        `UPDATE sucursales SET ${setCampos} WHERE id = ?`,
        valores,
        (error, resultados) => {
            if(error){
                res.status(500).json({mensaje: 'Error al modificar registros.'});
            }else if(resultados.affectedRows === 0){
                res.status(404).json({mensaje: 'Registro no encontrado.'});
                return;
            }else{
                res.status(200).json({mensaje: 'Registros guardados con éxito.'});
            }
        }
    );

});


module.exports = router;