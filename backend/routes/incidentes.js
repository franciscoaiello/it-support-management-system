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

module.exports = router;