const Meme = require('../models/Meme');
const { getPool } = require('../db');

class MemeController {
  static async getAllMemes(req, res) {
    try {
      const { rows } = await getPool().query('SELECT id, name, description, category, rating::float AS rating, views::int AS views, max_shares AS "maxShares", created_at AS "createdAt", updated_at AS "updatedAt" FROM memes ORDER BY id');
      res.json(rows);
    } catch (error) {
      console.error('Error getting memes:', error);
      res.status(500).json({
        error: 'Internal server error',
        message: 'Failed to retrieve memes'
      });
    }
  }

  static async getMemeById(req, res) {
    try {
      const id = parseInt(req.params.id, 10);
      const { rows } = await getPool().query('SELECT id, name, description, category, rating::float AS rating, views::int AS views, max_shares AS "maxShares", created_at AS "createdAt", updated_at AS "updatedAt" FROM memes WHERE id = $1', [id]);
      if (rows.length === 0) {
        return res.status(404).json({
          error: 'Not found',
          message: `Meme with id ${id} not found`
        });
      }
      res.json(rows[0]);
    } catch (error) {
      console.error('Error getting meme by id:', error);
      res.status(500).json({
        error: 'Internal server error',
        message: 'Failed to retrieve meme'
      });
    }
  }

  static async createMeme(req, res) {
    try {
      const validationErrors = Meme.validateCreateRequest(req.body);
      if (validationErrors.length > 0) {
        return res.status(400).json({
          error: 'Validation failed',
          message: 'Request validation failed',
          details: validationErrors
        });
      }
      const newMeme = Meme.fromRequest(req.body);
      const { rows } = await getPool().query(
        'INSERT INTO memes (name, description, category, rating, views, max_shares) VALUES ($1,$2,$3,$4,$5,$6) RETURNING id, name, description, category, rating::float AS rating, views::int AS views, max_shares AS "maxShares", created_at AS "createdAt", updated_at AS "updatedAt"',
        [
          newMeme.name,
          newMeme.description,
          newMeme.category,
          newMeme.rating,
          newMeme.views,
          newMeme.maxShares
        ]
      );
      res.status(201).json(rows[0]);
    } catch (error) {
      console.error('Error creating meme:', error);
      res.status(500).json({
        error: 'Internal server error',
        message: 'Failed to create meme'
      });
    }
  }

  static async updateMeme(req, res) {
    try {
      const id = parseInt(req.params.id, 10);
      const validationErrors = Meme.validateCreateRequest(req.body);
      if (validationErrors.length > 0) {
        return res.status(400).json({
          error: 'Validation failed',
          message: 'Request validation failed',
          details: validationErrors
        });
      }
      const { rows } = await getPool().query(
        'UPDATE memes SET name=$1, description=$2, category=$3, rating=$4, views=$5, max_shares=$6, updated_at=now() WHERE id=$7 RETURNING id, name, description, category, rating::float AS rating, views::int AS views, max_shares AS "maxShares", created_at AS "createdAt", updated_at AS "updatedAt"',
        [
          req.body.name,
          req.body.description,
          req.body.category,
          req.body.rating,
          req.body.views,
          req.body.maxShares,
          id
        ]
      );
      if (rows.length === 0) {
        return res.status(404).json({
          error: 'Not found',
          message: `Meme with id ${id} not found`
        });
      }
      res.json(rows[0]);
    } catch (error) {
      console.error('Error updating meme:', error);
      res.status(500).json({
        error: 'Internal server error',
        message: 'Failed to update meme'
      });
    }
  }

  static async deleteMeme(req, res) {
    try {
      const id = parseInt(req.params.id, 10);
      const { rowCount } = await getPool().query('DELETE FROM memes WHERE id=$1', [id]);
      if (rowCount === 0) {
        return res.status(404).json({
          error: 'Not found',
          message: `Meme with id ${id} not found`
        });
      }
      res.status(204).send();
    } catch (error) {
      console.error('Error deleting meme:', error);
      res.status(500).json({
        error: 'Internal server error',
        message: 'Failed to delete meme'
      });
    }
  }
}

module.exports = MemeController;