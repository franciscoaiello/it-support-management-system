const express = require('express');
const router = express.Router();
const connection = require('../connection');

router.get(`/`, (req, res) => {
    connection.query(
      'SELECT * FROM incidentes',
      (error, resultados) => {
        if(error){
            res.status(500).json({mensaje: 'Error al cargar registros.'});
        }else if(resultados.length === 0){
            res.status(200).json({mensaje: 'Registros no encontrados.'});
        }else{
            res.status(200).json(resultados);
        }
      }  
    );
});

router.get(`/:id`, (req, res) => {
    const id = req.params.id;

    connection.query(
        'SELECT * FROM incidentes WHERE id = ?',
        [id],
        (error, resultados) => {
            if(error){
                res.status(500).json({mensaje: 'Error al obtener registro.'});
            }else if(resultados.length === 0){
                res.status(404).json({mensaje: 'No se encontraron registros.'});
            }else{
                res.status(200).json(resultados);
            }
        }
    );
});

router.delete(`/:id`, (req,res) => {
    const id = req.params.id;

    connection.query(
        'DELETE FROM incidentes WHERE id = ?',
        [id],
        (error, resultados) => {
            if(error){
                res.status(500).json({mensaje: 'Error al eliminar registros.'});
            }else if(resultados.affectedRows === 0){
                res.status(404).json({mensaje: 'No existen registros.'})
            }else{
                res.status(200).json({mensaje: 'Registro eliminado con exito.', resultados});
            }
        }
    )
});

router.patch(`/:id`, (req, res) => {
    const id = req.params.id;
    const titulo = req.body.titulo;
    const categoria = req.body.categoria;
    const prioridad = req.body.prioridad;
    const estado = req.body.estado;
    const sucursalId = req.body.sucursal_id;

    const campos = [];
    const valores = [];

    if(titulo !== undefined){
        campos.push('titulo = ?');
        valores.push(titulo);
    };if(categoria !== undefined){
        campos.push('categoria = ?');
        valores.push(categoria);
    };if(prioridad !== undefined){
        campos.push('prioridad = ?');
        valores.push(prioridad);
    };if(estado !== undefined){
        campos.push('estado = ?');
        valores.push(estado);
    };if(sucursalId !== undefined){
        campos.push('sucursal_id = ?');
        valores.push(sucursalId)
    };if(campos.length === 0){
        res.status(400).json({mensaje: 'Sin datos para modificar.'});
        return;
    };

    const setCampos = campos.join(', ');
    valores.push(id);

    connection.query(
        `UPDATE incidentes SET ${setCampos} WHERE id = ?`,
        valores,
        (error, resultados) => {
            if(error){
                res.status(500).json({mensaje: 'Error al modificar registros.'});
            }else if(resultados.affectedRows === 0){
                res.status(404).json({mensaje: 'Registros no encontrados'})
            }else{
                res.status(200).json({mensaje: 'Registros modificados correctamente', resultados})
            }
        }
    );
});

router.post(`/`, (req, res) => {
    const titulo = req.body.titulo;
    const categoria = req.body.categoria;
    const prioridad = req.body.prioridad;
    const estado = req.body.estado;
    const sucursal_id = req.body.sucursal_id;

    if(titulo === undefined){
        res.status(400).json({mensaje: 'El campo TITULO debe ser completado.'})
        return;
    };if(categoria === undefined){
        res.status(400).json({mensaje: 'El campo CATEGORIA debe ser completado.'})
        return;
    };if(prioridad === undefined){
        res.status(400).json({mensaje: 'El campo PRIORIDAD debe ser completado.'})
        return;
    };if(estado === undefined){
        res.status(400).json({mensaje: 'El campo ESTADO debe ser completado.'})
        return;
    };if(sucursal_id === undefined){
        res.status(400).json({mensaje: 'El campo SUCURSAL_ID debe ser completado.'})
        return;
    };

    connection.query(
        'INSERT INTO incidentes (titulo, categoria, prioridad, estado, sucursal_id) VALUES (?, ?, ?, ?, ?)',
        [titulo, categoria, prioridad, estado, sucursal_id],
        (error, resultados) => {
            if(error){
                res.status(500).json({mensaje: 'Error al crear incidnete.'});
            }else{
                res.status(201).json({mensaje: 'Incidente generado con exito.', resultados})
            }
        }
    );
});

module.exports = router;